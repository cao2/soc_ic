library ieee;
use ieee.std_logic_1164.ALL;
--use iEEE.std_logic_unsigned.all ;
use ieee.numeric_std.ALL;
use work.defs.all;
use work.util.all;

entity l1_cache is
	port(
		Clock        : in  std_logic;
		reset        : in  std_logic;
		id_i         : in  IP_T;
		cpu_req_i    : in  MSG_T;
		snp_req_i    : in  MSG_T;
		bus_res_i    : in  BMSG_T;
		cpu_res_o    : out MSG_T     := ZERO_MSG;
		snp_hit_o    : out std_logic;
		snp_res_o    : out MSG_T     := ZERO_MSG;
		-- goes to cache controller ask for data
		snp_req_o    : out MSG_T;
		snp_res_i    : in  MSG_T;
		snp_hit_i    : in  std_logic;
		up_snp_req_i : in  MSG_T;
		up_snp_res_o : out MSG_T;
		up_snp_hit_o : out std_logic;
		wb_req_o     : out BMSG_T;
		full_snpres_i:in std_logic;
		-- FIFO flags
		crf_full_o   : out std_logic := '0'; -- Full flag from cpu_req FIFO
		srf_full_o   : out std_logic := '0'; -- Full flag from snp_req FIFO
		bsf_full_o   : out std_logic := '0'; -- Full flag from bus_req FIFO

		full_crq_i   : in  std_logic;   -- TODO what is this? not implemented?
		full_wb_i    : in  std_logic;
		full_srs_i   : in  std_logic;   -- TODO where is this coming from? not implemented?
		bus_req_o    : out MSG_T     := ZERO_MSG -- a req going to the other cache
	);

end l1_cache;

architecture rtl of l1_cache is
	-- IMB cache 1
	-- 3 lsb: dirty bit, valid bit, exclusive bit
	-- cache hold valid bit ,dirty bit, exclusive bit, 6 bits tag, 32 bits data,
	-- 41 bits in total
	type rom_type is array (natural(2 ** 14 - 1) downto 0) of std_logic_vector(52 downto 0);
	signal ROM_array : rom_type := (others => (others => '0'));

	-- Naming conventions:
	-- [c|s|b]rf is [cpu|snoop|bus]_req fifo
	-- [us|s]sf is [upstream-snoop|snoop]_resp fifo

	-- FIFO queues inputs
	-- write_enable signals for FIFO queues
	signal crf_we, srf_we, bsf_we, brf_we, ssf_we : std_logic := '0';
	-- read_enable signals for FIFO queues
	signal crf_re, srf_re, bsf_re, brf_re, ssf_re : std_logic;
	-- data_in signals
	signal crf_in, srf_in, ssf_in : MSG_T := ZERO_MSG;

	-- Outputs from FIFO queues
	-- data_out signals
	signal out1, out3,                  -- TODO not used?
	 srf_out, ssf_out ,crf_out: MSG_T := ZERO_MSG;
	signal brf_out, brf_in                                 : MSG_T := ZERO_MSG;
	-- empty signals
	signal crf_emp, srf_emp, bsf_emp, brf_emp, ssf_emp : std_logic;
	-- full signals
	signal brf_full, ssf_full : std_logic := '0'; -- TODO not implemented yet?

	-- MCU (Memory Control Unit)

	-- Memory requests (data_out signals from FIFO queues)
	-- Naming conventions:
	-- [cpu|snp|usnp]_mem_[req|res|ack] memory (write) request, response, or ack for
	-- cpu, snoop (from cache), or upstream snoop (from bus on behalf of a device)
	signal bus_req_s, snp_mem_req, mcu_write_req : MSG_T;
	signal usnp_mem_req, usnp_mem_res            : MSG_T := ZERO_MSG; -- usnp reqs are longer
	signal usnp_mem_ack                          : std_logic;
	signal snp_mem_req_1, snp_mem_req_2          : MSG_T := ZERO_MSG;

	signal snp_mem_ack1, snp_mem_ack2      : std_logic;
	signal bus_res, bsf_in                 : BMSG_T := ZERO_BMSG;
	signal cpu_mem_res, write_res, upd_res : MSG_T  := ZERO_MSG;
	signal snp_mem_res                     : MSG_T  := ZERO_MSG;
	-- hit signals
	signal cpu_mem_hit, snp_mem_hit, usnp_mem_hit : std_logic;
	-- "done" signals
	signal upd_ack, write_ack, cpu_mem_ack, snp_mem_ack : std_logic;

	signal cpu_res1, cpu_res2     : MSG_T := ZERO_MSG;
	signal ack1, ack2             : std_logic;
	signal snp_c_req1, snp_c_req2 : MSG_T := ZERO_MSG;
	signal snp_c_ack1, snp_c_ack2 : std_logic;

	signal prc          : std_logic_vector(1 downto 0);
	signal tmp_cpu_res1 : MSG_T                         := ZERO_MSG;
	signal tmp_snp_res  : MSG_T                         := ZERO_MSG;
	signal tmp_hit      : std_logic;
	signal tmp_mem      : std_logic_vector(40 downto 0) := (others => '0');
	-- -this one is important!!!!

	signal tidx                 : integer  := 0;
	signal content              : std_logic_vector(52 downto 0);
	signal upreq                : MSG_T; -- used only by up_snp_req_handler
	signal snpreq               : MSG_T; -- used only by cpu_req_handler
	signal fidx                 : integer  := 0;
	signal tcontent             : std_logic_vector(52 downto 0);
	constant DEFAULT_FIFO_DEPTH : positive := 256;

	signal snp_wt     : MSG_T;
	signal snp_wt_ack : std_logic;
 
begin
	
	snp_res_fifo : entity work.fifo(rtl)
		generic map(
			FIFO_DEPTH => DEFAULT_FIFO_DEPTH
		)
		port map(
			CLK     => Clock,
			RST     => reset,
			DataIn  => ssf_in,
			WriteEn => ssf_we,
			ReadEn  => ssf_re,
			DataOut => ssf_out,
			Full    => ssf_full,
			Empty   => ssf_emp
		);
	ureq_fifo : entity work.fifo(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => DEFAULT_FIFO_DEPTH
		)
		port map(
			CLK     => Clock,
			RST     => reset,
			DataIn  => brf_in,
			WriteEn => brf_we,
			ReadEn  => brf_re,
			DataOut => usnp_mem_req,
			Full    => brf_full,
			Empty   => brf_emp
		);

	-- * Stores up snoop requests into fifo
	-- * up_snp_req_i;; -> ;brf_in, brf_we;
	ureq_fifo_p : process(clock, reset)
	begin
		if reset = '1' then
			brf_we <= '0';
		elsif rising_edge(Clock) then
			if up_snp_req_i.val = '1' then
				brf_in <= up_snp_req_i;
				brf_we <= '1';
			else
				brf_we <= '0';
			end if;
		end if;
	end process;

	snp_req_fifo : entity work.fifo(rtl)
		generic map(
			FIFO_DEPTH => DEFAULT_FIFO_DEPTH
		)
		port map(
			CLK     => Clock,
			RST     => reset,
			DataIn  => srf_in,
			WriteEn => srf_we,
			ReadEn  => srf_re,
			DataOut => srf_out,
			Full    => srf_full_o,
			Empty   => srf_emp
		);
	bus_res_fifo : entity work.b_fifo(rtl)
		generic map(
			FIFO_DEPTH => DEFAULT_FIFO_DEPTH
		)
		port map(
			CLK     => Clock,
			RST     => reset,
			DataIn  => bsf_in,
			WriteEn => bsf_we,
			ReadEn  => bsf_re,
			DataOut => bus_res,
			Full    => bsf_full_o,
			Empty   => bsf_emp
		);
	cpu_res_arbiter : entity work.arbiter2(rtl)
		port map(
			clock => Clock,
			reset => reset,
			din1  => cpu_res1,
			ack1  => ack1,
			din2  => cpu_res2,
			ack2  => ack2,              -- o
			dout  => cpu_res_o
		);
	snp_c_req_arbiter : entity work.arbiter2(rtl)
		port map(
			clock => Clock,
			reset => reset,
			din1  => snp_c_req1,
			ack1  => snp_c_ack1,
			din2  => snp_c_req2,
			ack2  => snp_c_ack2,
			dout  => snp_req_o
		);

	snp_mem_req_arbiter : entity work.arbiter2(rtl)
		port map(
			clock => Clock,
			reset => reset,
			din1  => snp_mem_req_1,
			ack1  => snp_mem_ack1,
			din2  => snp_mem_req_2,
			ack2  => snp_mem_ack2,
			dout  => snp_mem_req
		);
	cpu_req_fifo : entity work.fifo(rtl)
		generic map(
			FIFO_DEPTH => DEFAULT_FIFO_DEPTH
		)
		port map(
			CLK     => Clock,
			RST     => reset,
			DataIn  => crf_in,
			WriteEn => crf_we,
			ReadEn  => crf_re,
			DataOut => bus_req_s,
			Full    => crf_full_o,
			Empty   => crf_emp
		);

	-- * Stores cpu requests into fifo
	-- * cpu_req_i;; -> ;crf_in, crf_we;
	cpu_req_fifo_p : process(clock, reset)
	begin
		if reset = '1' then
			crf_we <= '0';
		elsif rising_edge(clock) then
			if cpu_req_i.val = '1' then -- if req is valid
				crf_in <= cpu_req_i;
				----report "cpu 's input data " & std_logic_vector'image(cpu_req_i.dat);
        crf_we <= '1';
			else
				crf_we <= '0';
			end if;
		end if;
	end process;

	-- * Stores snoop requests into fifo
	-- * snp_req_i;; -> ;srf_in, srf_we;
	snp_req_fifo_p : process(clock, reset)
	begin
		if reset = '1' then
			srf_we <= '0';

		elsif rising_edge(Clock) then
			if snp_req_i.val = '1' then
				srf_in <= snp_req_i;
				srf_we <= '1';
			else
				srf_we <= '0';
			end if;
		end if;
	end process;

	-- * Stores bus response into fifo
	-- * bus_res_i;; -> ;bsf_in, bsf_we;
	bus_res_fifo_p : process(clock, reset)
	begin
		if reset = '1' then
			bsf_we <= '0';

		elsif rising_edge(Clock) then
			if bus_res_i.val = '1' then

				bsf_in <= bus_res_i;
				bsf_we <= '1';
			else
				bsf_we <= '0';
			end if;
		end if;
	end process;

	-- * Process requests from cpu
	-- * snp_res_i,snp_hit_i;cpu_mem_res;
	-- *  -> ;cpu_res1, mcu_write_req, crf_re, snp_c_req1, cpu_mem_ack, cpu_mem_hit,
	-- *      tmp_cpu_res1, cpu_res1, snp_req, snp_c_ack1;
	-- *     bus_req_o
	cpu_req_p : process(reset, clock)
		-- TODO should they be signals instead of variables?
		variable st      : integer := 0;
		variable prev_st : integer := -1;
		variable idx     : integer := 0;
		variable tmp     : MSG_T;
	begin
		if (reset = '1') then
			-- reset signals
			cpu_res1      <= ZERO_MSG;
			mcu_write_req <= ZERO_MSG;
			bus_req_o     <= ZERO_MSG;
			crf_re        <= '0';
			snp_c_req1    <= ZERO_MSG;
		-- tmp_write_req <= nilreq;
		elsif rising_edge(clock) then
			-- dbg_chg("cpu_req_p(" & str(id_i) & ")", st, prev_st);
			if st = 0 then              -- wait_fifo
				bus_req_o <= ZERO_MSG;
				if crf_re = '0' and crf_emp = '0' then
					crf_re <= '1';
					st     := 1;
				end if;
			elsif st = 1 then           -- access
				crf_re <= '0';
				
					if is_pwr_cmd(bus_req_s) then -- fwd pwr req TODO cpu should not have
						-- to go through cache to comm. with bus
						----report "pwr req<<<<<<" & std_logic_vector'image(bus_req_s.dat);
          				bus_req_o <= bus_req_s;
						st        := 0;
					else                -- is mem request
						if cpu_mem_ack = '1' then
							----report "here";
							if cpu_mem_hit = '1' then
								if cpu_mem_res.cmd = WRITE_CMD then
									mcu_write_req <= cpu_mem_res;
									tmp_cpu_res1  <= cpu_mem_res;
									st            := 3;
								else    -- read cmd
									
									cpu_res1 <= cpu_mem_res;
									st       := 4;
								end if;
							else        -- it's a miss
								--report "here";
								snp_c_req1 <= cpu_mem_res;
								snpreq     <= cpu_mem_res;
								st         := 5;
							end if;
						end if;
					end if;
				
			elsif st = 3 then           -- get_resp_from_mcu
				if write_ack = '1' then
					mcu_write_req <= ZERO_MSG;
					cpu_res1      <= tmp_cpu_res1;
					st            := 4;
				end if;
			elsif st = 4 then           -- output_resp
				if ack1 = '1' then
					cpu_res1 <= ZERO_MSG;
					st       := 0;
				end if;
			elsif st = 5 then           -- get_snp_req_ack
				if snp_c_ack1 = '1' then
					snp_c_req1 <= ZERO_MSG;
					st         := 6;
				end if;
			-- now we wait for the snoop response
			elsif st = 6 then           -- get_snp_resp
				if snp_res_i.val = '1' then
					-- if we get a snoop response  and the address is the same  => 
					if snp_res_i.adr = snpreq.adr and (snp_res_i.tag = CPU0_TAG or snp_res_i.tag = CPU1_TAG) then
						if snp_hit_i = '1' then
							st     := 7;
							snp_wt <= snp_res_i;
							tmp    := snp_res_i;
						else
							bus_req_o <= snp_res_i;
							st        := 0;
						end if;
					end if;
				end if;
			elsif st = 7 then
				if snp_wt_ack = '1' then
					snp_wt   <= ZERO_MSG;
					cpu_res1 <= tmp;
					st       := 4;
				end if;
			end if;
		end if;
	end process;

	-- * Process snoop requests (from another cache)
	snp_req_p : process(reset, clock)
		variable addr  : ADR_T;
		variable state : integer := 0;
	begin
		if (reset = '1') then
			-- reset signals
			snp_res_o     <= ZERO_MSG;
			snp_hit_o     <= '0';
			srf_re        <= '0';
			snp_mem_req_1 <= ZERO_MSG;
		elsif rising_edge(clock)  then
			if state = 0 then           -- wait_fifo
				snp_res_o <= ZERO_MSG;
				if srf_re = '0' and srf_emp = '0' then
					srf_re <= '1';
					state  := 1;
				end if;
			elsif state = 1 then        -- gen_snp_mem_req (and send to arbiter)
				srf_re <= '0';
				if srf_out.val = '1' then
					snp_mem_req_1 <= srf_out;
					addr          := srf_out.adr;
					state         := 3;
				end if;
			elsif state = 3 then        -- get_ack
				if snp_mem_ack1 = '1' then
					snp_mem_req_1 <= ZERO_MSG;
					state         := 4;
				end if;
			elsif state = 4 then        -- TODO should states 4 and 2 be merged?
				if snp_mem_ack = '1' and snp_mem_res.adr = addr then
						snp_res_o <=snp_mem_res;
						snp_hit_o<=snp_mem_hit;
						state:=0;
				end if;
			end if;
		end if;
	end process;

	-- * Process upstream snoop requests (from bus on behalf of devices)
	-- the difference --with snp_req-- is that when it's  uprequest snoop, once it
	-- fails (a miss), it will go to the other cache snoop
	-- also when found, the write will be operated here directly, and return
	-- nothing
	-- if it's read, then the data will be returned to request source
	ureq_req_p : process(reset, clock)
		variable state : integer := 0;
		variable tmp_h:std_logic;
		variable tmp_res:MSG_T;
	begin
		if (reset = '1') then
			state        := 0;
			up_snp_res_o <= ZERO_MSG;
			up_snp_hit_o <= '1';        -- TODO should it be 0?
			brf_re       <= '0';
			snp_c_req2   <= ZERO_MSG;
		elsif rising_edge(Clock) then
			if state = 0 then           -- wait_fifo
				up_snp_res_o <= ZERO_MSG;
				up_snp_hit_o <= '0';
				if brf_re = '0' and brf_emp = '0' then
					brf_re <= '1';
					state  := 1;
				end if;
			elsif state = 1 then        -- access
				brf_re <= '0';
				if usnp_mem_ack = '1' then -- if hit
					if usnp_mem_hit = '1' then
						up_snp_res_o <= usnp_mem_res;
						up_snp_hit_o <= '1';
						state        := 0;
					else                -- it's a miss
					-- --report "miss form cache 0, now send to cache1";
						snp_c_req2 <= usnp_mem_res;
						upreq      <= usnp_mem_res;
						state      := 2;
					end if;
				end if;
			elsif state = 2 then        -- wait_peer
				if snp_c_ack2 = '1' then
					-- --report "sent";
					snp_c_req2 <= ZERO_MSG;
					state      := 3;
				end if;
			elsif state = 3 then        -- output_resp
				if snp_res_i.val = '1' then
					-- --report "snp response received from cache 1";
					-- if we get a snoop response and the address is the same  => 
					if snp_res_i.adr = upreq.adr then
						tmp_res := (snp_res_i.val, snp_res_i.cmd,
						                 snp_res_i.tag, snp_res_i.id,
						                 snp_res_i.adr, snp_res_i.dat);
						-- TODO upreq is updated after pcs is finished. Is this a problem?
						tmp_h := snp_hit_i;
						state        := 5;
					end if;
				-- TODO do we need to go back to state 0?
				end if;
			elsif state =5 then
				if full_snpres_i /='1' then
					up_snp_res_o <= tmp_res;
					up_snp_hit_o <= tmp_h;
					report "1 cache send out";
					state     := 0;
				end if;
			end if;
		end if;
	end process;

	-- * Process pwr response
	-- pwr_res_p : process(reset,clock)
	-- variable tmp_msg : MSG_T;
	-- begin
	-- if reset='1' then
	-- elsif rising_edge(Clock) then
	-- tmp_msg := bus_res(BMSG_WIDTH-1 downto BMSG_WIDTH - MSG_WIDTH);
	-- if is_valid(tmp_msg) and is_pwr_cmd(tmp_msg) then
	-- --report integer'image(BMSG_WIDTH - MSG_WIDTH);
	-- cpu_res2 <= tmp_msg; -- TODO should be cpu_res3
	-- end if;
	-- end if;
	-- end process;

	-- * Process snoop response (to snoop request issued by this cache)
	bus_res_p : process(reset, clock)
		variable state : integer := 0;
	begin
		if reset = '1' then
			-- reset signals
			cpu_res2 <= ZERO_MSG;
			-- upd_req <= nilreq;
			bsf_re <= '0';
		elsif rising_edge(Clock) then
			if state = 0 then           -- wait_fifo
				if bsf_re = '0' and bsf_emp = '0' then
					bsf_re <= '1';
					state  := 1;
				end if;
			elsif state = 1 then        --
				bsf_re <= '0';
				if upd_ack = '1' then
					cpu_res2 <= upd_res;
					state    := 2;
				end if;
			elsif state = 2 then        --
				if ack2 = '1' then      -- TODO ack2 from cpu_resp_arbiter? meaning?
					cpu_res2 <= ZERO_MSG;
					state    := 0;
				end if;
			end if;

		end if;
	end process;

	-- * Deals with cache memory
	-- * full_wb_i;
	-- * bus_req_s, snp_mem_req, usnp_mem_req,
	-- *   mcu_write_req, bus_res, ;
	-- *   -> ;
	-- *      ROM_array, write_ack, write_res, upd_ack, upd_res
	-- *        cpu_mem_ack, cpu_mem_hit, cpu_mem_res,
	-- *        snp_mem_ack, snp_mem_hit, snp_mem_res,
	-- *        usnp_mem_ack, usnp_mem_hit, usnp_mem_res;
	-- *      wb_req_o
--	mem_control_unit : process(reset, clock)
--		variable idx     : integer;
--		variable memcont : std_logic_vector(52 downto 0);
--		variable shifter : boolean := false;
--		variable turn    : integer := 0;
--	begin
--		if (reset = '1') then
--			-- reset signals;
--			cpu_mem_res <= ZERO_MSG;
--			snp_mem_res <= ZERO_MSG;
--			write_ack   <= '0';
--			upd_ack     <= '0';
--			turn        := 0;
--		elsif rising_edge(Clock) then
--			cpu_mem_res <= ZERO_MSG;
--			snp_mem_res <= ZERO_MSG;
--			write_ack   <= '0';
--			upd_ack     <= '0';
--			wb_req_o    <= ZERO_BMSG;

--			-- cpu memory request
--			if bus_req_s.val = '1' then
--				----report "hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeee";
--				idx  := to_integer(unsigned(bus_req_s.adr(14 downto 0)));
--				fidx <= to_integer(unsigned(bus_req_s.adr(14 downto 0)));
				
--				tcontent <= ROM_array(idx);
--				memcont  := ROM_array(idx);
--				-- if we can't find it in memory
--				if memcont(52 downto 52) = "0" or (bus_req_s.cmd = READ_CMD and memcont(50 downto 50) = "0") or bus_req_s.cmd = WRITE_CMD or memcont(49 downto 32) /= bus_req_s.adr(31 downto 14) then -- 31 to 14
--					cpu_mem_ack <= '1';
--					cpu_mem_hit <= '0';
--					cpu_mem_res <= bus_req_s;
--				else                    -- it's a hit
--					cpu_mem_ack <= '1';
--					cpu_mem_hit <= '1';
--					if bus_req_s.cmd = WRITE_CMD then
--						cpu_mem_res <= bus_req_s;
--					else
--						cpu_mem_res   <= (bus_req_s.val, bus_req_s.cmd, bus_req_s.tag,
--                          bus_req_s.id, bus_req_s.adr, memcont(31 downto 0));
--					end if;
--				end if;
--			else
--				cpu_mem_ack <= '0';
--			end if;

--			-- snoop memory request
--			if snp_mem_req.val = '1' then
--				idx     := to_integer(unsigned(snp_mem_req.adr(13 downto 0)));
--				memcont := ROM_array(idx);
--				-- if we can't find it in memory
--				if memcont(52 downto 52) = "0" or -- it's a miss
--					 memcont(49 downto 32) /= snp_mem_req.adr(31 downto 14) then -- cmp 
--					snp_mem_ack <= '1';
--					snp_mem_hit <= '0';
--					snp_mem_res <= snp_mem_req;
--				else
--					snp_mem_ack <= '1';
--					snp_mem_hit <= '1';
--					-- if it's write, invalidate the cache line
--					if snp_mem_req.cmd = WRITE_CMD then
--						--ROM_array(idx)(52)          <= '0'; -- it's a miss
--						--ROM_array(idx)(31 downto 0) <= snp_mem_req.dat;
--						snp_mem_req.dat             <= ROM_array(idx)(31 downto 0);
--						snp_mem_res                 <= snp_mem_req;
--					else
--						-- if it's read, mark the exclusive as 0
--						--ROM_array(idx)(50) <= '0';
--						snp_mem_res        <= ('1', snp_mem_req.cmd, snp_mem_req.tag,
--						                snp_mem_req.id, snp_mem_req.adr,
--						                ROM_array(idx)(31 downto 0));
--					end if;

--				end if;
--			else
--				snp_mem_ack <= '0';
--			end if;

--			-- upstream snoop req
--			if usnp_mem_req.val = '1' then
--				-- TODO whats in usnp_mem_req(41 downto 32)?
--				idx     := to_integer(unsigned(usnp_mem_req.adr(13 downto 0))); -- index
--				memcont := ROM_array(idx);
--				-- if we can't find it in memory
--				-- invalide  ---or tag different
--				-- or its write, but not exclusive
--				if memcont(52 downto 52) = "0" or -- mem not found
--					 (bus_req_s.cmd = WRITE_CMD and memcont(50 downto 50) = "0") or -- TODO what is this bit?
--					 memcont(49 downto 32) /= usnp_mem_req.adr(31 downto 14) then
--					usnp_mem_ack <= '1';
--					usnp_mem_hit <= '0';
--					usnp_mem_res <= usnp_mem_req;
--				else                    -- it's a hit
--					usnp_mem_ack <= '1';
--					usnp_mem_hit <= '1';
--					-- if it's write, write it directly
--					-- ---this need to be changed TODO ?
--					if usnp_mem_req.cmd = WRITE_CMD then
--						--ROM_array(idx)(52)          <= '0';
--						--ROM_array(idx)(31 downto 0) <= usnp_mem_req.dat;
--						usnp_mem_res                <= ('1', usnp_mem_req.cmd, usnp_mem_req.tag,
--						                 usnp_mem_req.id, usnp_mem_req.adr,
--						                 ROM_array(idx)(31 downto 0));
--					else
--						-- if it's read, mark the exclusive as 0
--						-- -not for this situation, because it is shared by other ips
--						-- -ROM_array(idx)(54) <= '0';
--						usnp_mem_res <= ('1', usnp_mem_req.cmd, usnp_mem_req.tag,
--						                 usnp_mem_req.id, usnp_mem_req.adr,
--						                 ROM_array(idx)(31 downto 0));
--					end if;
--				end if;
--			else                        -- invalid req
--				usnp_mem_ack <= '0';
--			end if;

--			snp_wt_ack <= '0';
--			content    <= ROM_array(7967);
--			if mcu_write_req.val = '1' then
--				idx            := to_integer(unsigned(mcu_write_req.adr(13 downto 0)));
--				--ROM_array(idx) <= "110" & mcu_write_req.adr(31 downto 14) & mcu_write_req.dat;
--				write_ack      <= '1';
--				upd_ack        <= '0';
--				write_res      <= mcu_write_req;
--				turn           := 0;
--			elsif snp_wt.val = '1' then
--				turn           := 0;
--				idx            := to_integer(unsigned(snp_wt.adr(13 downto 0)));
--				ROM_array(idx) <= "100" & snp_wt.adr(31 downto 14) & snp_wt.dat;
--				snp_wt_ack     <= '1';
--				turn           := 0;
--			elsif bus_res.val = '1' then
--				turn    := 0;
--				idx     := to_integer(unsigned(bus_res.adr(13 downto 0))) /16 * 16;
--				tidx    <= to_integer(unsigned(bus_res.adr(13 downto 0)));
--				memcont := ROM_array(idx);

--				-- if tags do not match, dirty bit is 1,
--				-- and write_back fifo in BUS is not full,
----				if memcont(52 downto 52) = "1" and memcont(51 downto 51) = "1" and memcont(49 downto 32) /= bus_res.adr(31 downto 14) and full_wb_i /= '1' then
----					wb_req_o <= ('1', WRITE_CMD, ZERO_TAG, ZERO_ID, bus_res.adr,
----					             ROM_array(idx + 15)(31 downto 0) & ROM_array(idx + 14)(31 downto 0) & ROM_array(idx + 13)(31 downto 0) & ROM_array(idx + 12)(31 downto 0) & ROM_array(idx + 11)(31 downto 0) & ROM_array(idx + 10)(31 downto 0) & ROM_array(idx + 9)(31 downto 0) & ROM_array(idx + 8)(31 downto 0) & ROM_array(idx + 7)(31 downto 0) & ROM_array(idx + 6)(31 downto 0) & ROM_array(idx + 5)(31 downto 0) & ROM_array(idx + 4)(31 downto 0) & ROM_array(idx + 3)(31 downto 0) & ROM_array(idx + 2)(31 downto 0) & ROM_array(idx + 1)(31 downto 0) & ROM_array(idx)(31 downto 0));
----				end if;
----				ROM_array(idx + 15) <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(511 downto 480);
----				ROM_array(idx + 14) <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(479 downto 448);
----				ROM_array(idx + 13) <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(447 downto 416);
----				ROM_array(idx + 12) <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(415 downto 384);
----				ROM_array(idx + 11) <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(383 downto 352);
----				ROM_array(idx + 10) <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(351 downto 320);
----				ROM_array(idx + 9)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(319 downto 288);
----				ROM_array(idx + 8)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(287 downto 256);
----				ROM_array(idx + 7)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(255 downto 224);
----				ROM_array(idx + 6)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(223 downto 192);
----				ROM_array(idx + 5)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(191 downto 160);
----				ROM_array(idx + 4)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(159 downto 128);
----				ROM_array(idx + 3)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(127 downto 96);
----				ROM_array(idx + 2)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(95 downto 64);
----				ROM_array(idx + 1)  <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(63 downto 32);
----				ROM_array(idx)      <= "101" & bus_res.adr(31 downto 14) & bus_res.dat(31 downto 0);
--				upd_ack             <= '1';
--				upd_res             <= (bus_res.val, bus_res.cmd, bus_res.tag, bus_res.id, bus_res.adr,
--				            bus_res.dat(to_integer(unsigned(bus_res.adr(3 downto 0)))
--                           * 32 + 31 downto to_integer(unsigned(bus_res.adr(3 downto 0))) * 32));
--				write_ack           <= '0';
--			end if;
--		end if;
--	end process;

end rtl;
