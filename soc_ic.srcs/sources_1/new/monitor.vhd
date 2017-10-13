library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.defs.all;

entity monitor is
	Generic(
		constant interface_type : positive := 1
	);
	Port(
		clk           : in  STD_LOGIC;
		rst           : in  STD_LOGIC;
		----AXI interface
		master_id : in std_logic_vector(IP_CT downto 0);
		slave_id: in std_logic_vector(IP_CT downto 0);
		id_i          : in  IP_T;
		---write address channel
		waddr_i       : in  ADR_T;
		wlen_i        : in  std_logic_vector(9 downto 0);
		wsize_i       : in  std_logic_vector(9 downto 0);
		wvalid_i      : in  std_logic;
		wready_i      : in  std_logic;
		---write data channel
		wdata_i       : in  std_logic_vector(31 downto 0);
		wtrb_i        : in  std_logic_vector(3 downto 0); --TODO not implemented
		wlast_i       : in  std_logic;
		wdvalid_i     : in  std_logic;
		wdataready_i  : in  std_logic;
		---write response channel
		wrready_i     : in  std_logic;
		wrvalid_i     : in  std_logic;
		wrsp_i        : in  std_logic_vector(1 downto 0);
		---read address channel
		raddr_i       : in  std_logic_vector(31 downto 0);
		rlen_i        : in  std_logic_vector(9 downto 0);
		rsize_i       : in  std_logic_vector(9 downto 0);
		rvalid_i      : in  std_logic;
		rready_i      : in  std_logic;
		---read data channel
		rdata_i       : in  std_logic_vector(31 downto 0);
		rstrb_i       : in  std_logic_vector(3 downto 0);
		rlast_i       : in  std_logic;
		rdvalid_i     : in  std_logic;
		rdready_i     : in  std_logic;
		rres_i        : in  std_logic_vector(1 downto 0);
		----output 
		id_o          : out IP_T;
		---write address channel
		waddr_o       : out ADR_T;
		wlen_o        : out std_logic_vector(9 downto 0);
		wsize_o       : out std_logic_vector(9 downto 0);
		wvalid_o      : out std_logic;
		wready_o      : out std_logic;
		---write data channel
		wdata_o       : out std_logic_vector(31 downto 0);
		wtrb_o        : out std_logic_vector(3 downto 0); --TODO not implemented
		wlast_o       : out std_logic;
		wdvalid_o     : out std_logic;
		wdataready_o  : out std_logic;
		---write response channel
		wrready_o     : out std_logic;
		wrvalid_o     : out std_logic;
		wrsp_o        : out std_logic_vector(1 downto 0);
		---read address channel
		raddr_o       : out std_logic_vector(31 downto 0);
		rlen_o        : out std_logic_vector(9 downto 0);
		rsize_o       : out std_logic_vector(9 downto 0);
		rvalid_o      : out std_logic;
		rready_o      : out std_logic;
		---read data channel
		rdata_o       : out std_logic_vector(31 downto 0);
		rstrb_o       : out std_logic_vector(3 downto 0);
		rlast_o       : out std_logic;
		rdvalid_o     : out std_logic;
		rdready_o     : out std_logic;
		rres_o        : out std_logic_vector(1 downto 0);
		------Customized interface

		inter2_i      : in  MSG_T;
		inter2_o      : out MSG_T;
		transaction_o : out TST_T;
		transaction_o2 : out TST_T
	);
end monitor;

architecture rtl of monitor is
	--signal td1: std_logic_vector(31 downto 0);
	--signal td2: std_logic_vector(31 downto 0);
	type state is (one, two, three, four, five);
begin
	
	axi_wt_extractor_write : process(clk)
		variable tmp_transaction : TST_T;
		variable st: state := one;
	begin
		if rising_edge(clk) then
			if st = one then
				if interface_type = 0 then
					if wready_i ='1' then
						st :=two;
					end if;
				end if;
			elsif st = two then
				if wvalid_i ='1' then
				    tmp_transaction.sender := master_id;
				    tmp_transaction.receiver := slave_id;
					tmp_transaction.cmd := WRITE_CMD;
					---ATTENTION: addr need to be taken care of
					---so is tag and id
					tmp_transaction.adr := "00";
					---Note: there are also size, and length, ignored here
					st:= three;
				end if;
			elsif st = three then
				if wdataready_i ='1' then
					---Note: the data is available here
					---, do we need to check that?
					if wdvalid_i ='1' and wlast_i='1' then
					   st := four;
						---read response here is done
						transaction_o <= tmp_transaction;
					end if;
				end if;
			elsif st = four then
			transaction_o.val<='0';
			if wrvalid_i='1' then
			 if wrsp_i ="00" then
			     tmp_transaction.sender:=slave_id;
			     tmp_transaction.receiver:=master_id;
			     tmp_transaction.cmd := WRITE_CMD;
                 transaction_o <= tmp_transaction;
                 st := one;
             end if;
			end if;
			end if;
		end if;
	end process;
	
	
	axi_rd_extractor : process(clk)
		variable tmp_transaction : TST_T;
		variable st: state := one;
	begin
		if rising_edge(clk) then
			if st = one then
			    transaction_o2.val <='0';
				if interface_type = 0 then
					----axi protocol
					----read protocol
					if rready_i ='1' then
						st :=two;
					end if;
				elsif interface_type = 1 then
					if inter2_i.val='1' then
					tmp_transaction.val:='1';
					tmp_transaction.cmd:=inter2_i.cmd;
					----these three fields need to be carfully considered
					tmp_transaction.adr:="00";
					tmp_transaction.tag:="00";
					tmp_transaction.id:= "00";
					transaction_o2 <= tmp_transaction;
					end if;
				end if;
			elsif st = two then
				if rvalid_i ='1' then
					tmp_transaction.cmd := READ_CMD;---set the c
					---ommand => don't remmeber the specific code, 
					---change whenever have time
					---ATTENTION: addr need to be taken care of
					---so is tag and id
					tmp_transaction.adr := "00";
					tmp_transaction.sender := master_id;
					tmp_transaction.receiver := slave_id;
					transaction_o2 <= tmp_transaction;
					---Note: there are also size, and length, ignored here
					st:= three;
				end if;
			elsif st = three then
			    transaction_o2.val <='0';
				if rdready_i ='1' then
				   st := four;
				end if;
			elsif st=four then
			  ---Note: the data is available here
                                ---, do we need to check that?
                                if rdvalid_i='1' and rlast_i='1' and  rres_i="00" then
                                    ---read response here is done
                                    tmp_transaction.sender := slave_id;
                                    tmp_transaction.receiver := master_id;
                                    transaction_o2 <= tmp_transaction;
                                    st := one;
                                end if;
			end if;
		end if;
	end process;
	output : process(clk)
	begin
		if rising_edge(clk) then
			---------customized protocol
			inter2_o     <= inter2_i;
			---------axi protocol
			id_o         <= id_i;
			waddr_o      <= waddr_i;
			wlen_o       <= wlen_i;
			wsize_o      <= wsize_i;
			wvalid_o     <= wvalid_i;
			wready_o     <= wready_i;
			---write data channel
			wdata_o      <= wdata_i;
			wtrb_o       <= wtrb_i;
			wlast_o      <= wlast_i;
			wdvalid_o    <= wdvalid_i;
			wdataready_o <= wdataready_i;
			---write response channel
			wrready_o    <= wrready_i;
			wrvalid_o    <= wrvalid_i;
			wrsp_o       <= wrsp_i;
			---read address channel
			raddr_o      <= raddr_i;
			rlen_o       <= rlen_i;
			rsize_o      <= rsize_i;
			rvalid_o     <= rvalid_i;
			rready_o     <= rready_i;
			---read data channel
			rdata_o      <= rdata_i;
			rstrb_o      <= rstrb_i;
			rlast_o      <= rlast_i;
			rdvalid_o    <= rdvalid_i;
			rdready_o    <= rdready_i;
			rres_o       <= rres_i;
		end if;
	end process;
end rtl;
