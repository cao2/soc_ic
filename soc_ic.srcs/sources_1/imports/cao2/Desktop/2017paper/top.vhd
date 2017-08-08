library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

use work.defs.all;
--use work.rand.all;
use work.util.all;
use work.test.all;
Library UNISIM;
use UNISIM.vcomponents.all;
-- IBUFGDS: Differential Global Clock Input Buffer
-- 7 Series
-- Xilinx HDL Libraries Guide, version 14.7

entity top is
	Port(clk   : in  std_logic;
	       clk1 : in std_logic;
	     reset   : in  std_logic;
	     tx_out  : out std_logic;
	     rx_in     : in std_logic
	);
end top;

architecture tb of top is

	-- Clock frequency and signal
	constant tb_period  : time      := 10 ps;
	signal tb_clk       : std_logic := '0';
	signal tb_sim_ended : std_logic := '0';

	signal full_c1_u, full_c2_u, full_b_m         : std_logic;
	signal cpu_res1, cpu_res2, cpu_req1, cpu_req2 : MSG_T;
	signal bus_res1, bus_res2                     : BMSG_T;
	signal snp_hit1, snp_hit2                     : std_logic;
	signal snp_req1, snp_req2                     : MSG_T;
	signal snp_res1, snp_res2                     : MSG_T;
	signal snp_req                                : MSG_T;
	-- -this should be DATA_WIDTH - 1
	signal snp_res                                                                                         : MSG_T;
	signal snp_hit                                                                                         : std_logic;
	signal bus_req1, bus_req2                                                                              : MSG_T;
	signal memres, tomem                                                                                   : MSG_T;
	signal full_crq1, full_srq1, full_brs1, full_wb1, full_srs1, full_crq2, full_brs2, full_wb2, full_srs2 : std_logic;
	-- -signal full_mrs: std_logic;
	signal done1, done2             : std_logic;
	signal mem_wb, wb_req1, wb_req2 : BMSG_T;
	signal wb_ack                   : std_logic;
	signal ic_pwr_req               : MSG_T;
	signal ic_pwr_res               : MSG_T;
	signal pwr_req_full             : std_logic;

	signal gfx_b, togfx                 : MSG_T;
	signal gfx_upreq, gfx_upres, gfx_wb : MSG_T;
	signal gfx_upreq_full, gfx_wb_ack   : std_logic;

	-- pwr
	signal pwr_gfx_req, pwr_gfx_res     : MSG_T;
	signal pwr_audio_req, pwr_audio_res : MSG_T;
	signal pwr_usb_req, pwr_usb_res     : MSG_T;
	signal pwr_uart_req, pwr_uart_res   : MSG_T;

	signal audio_b, toaudio                   : std_logic_vector(53 downto 0);
	signal audio_upreq, audio_upres, audio_wb : MSG_T;
	signal audio_upreq_full, audio_wb_ack     : std_logic;

	signal usb_b, tousb                 : MSG_T;
	signal usb_upreq, usb_upres, usb_wb : MSG_T;
	signal usb_upreq_full, usb_wb_ack   : std_logic;

	signal zero : std_logic := '0';

	signal uart_b, touart                  : MSG_T;
	signal uart_upreq, uart_upres, uart_wb : MSG_T;
	signal uart_upreq_full, uart_wb_ack    : std_logic;

	signal up_snp_req, up_snp_res : MSG_T;
	signal up_snp_hit             : std_logic;

	signal waddr  : ADR_T;
	signal wlen   : std_logic_vector(9 downto 0);
	signal wsize  : std_logic_vector(9 downto 0);
	signal wvalid : std_logic;
	signal wready : std_logic;
	-- -write data channel
	signal wdata      : DAT_T;
	signal wtrb       : std_logic_vector(3 downto 0);
	signal wlast      : std_logic;
	signal wdvalid    : std_logic;
	signal wdataready : std_logic;
	-- -write response channel
	signal wrready : std_logic;
	signal wrvalid : std_logic;
	signal wrsp    : std_logic_vector(1 downto 0);

	-- -read address channel
	signal raddr  : ADR_T;
	signal rlen   : std_logic_vector(9 downto 0);
	signal rsize  : std_logic_vector(9 downto 0);
	signal rvalid : std_logic;
	signal rready : std_logic;
	-- -read data channel
	signal rdata   : DAT_T;
	signal rstrb   : std_logic_vector(3 downto 0);
	signal rlast   : std_logic;
	signal rdvalid : std_logic;
	signal rdready : std_logic;
	signal rres    : std_logic_vector(1 downto 0);

	-- GFX
	-- -_gfx write address channel
	signal waddr_gfx  : ADR_T;
	signal wlen_gfx   : std_logic_vector(9 downto 0);
	signal wsize_gfx  : std_logic_vector(9 downto 0);
	signal wvalid_gfx : std_logic;
	signal wready_gfx : std_logic;
	-- _gfx-write data channel
	signal wdata_gfx      : std_logic_vector(31 downto 0);
	signal wtrb_gfx       : std_logic_vector(3 downto 0);
	signal wlast_gfx      : std_logic;
	signal wdvalid_gfx    : std_logic;
	signal wdataready_gfx : std_logic;
	-- _gfx-write response channel
	signal wrready_gfx : std_logic;
	signal wrvalid_gfx : std_logic;
	signal wrsp_gfx    : std_logic_vector(1 downto 0);

	-- _gfx-read address channel
	signal raddr_gfx  : ADR_T;
	signal rlen_gfx   : std_logic_vector(9 downto 0);
	signal rsize_gfx  : std_logic_vector(9 downto 0);
	signal rvalid_gfx : std_logic;
	signal rready_gfx : std_logic;
	-- _gfx-read data channel
	signal rdata_gfx   : DAT_T;
	signal rstrb_gfx   : std_logic_vector(3 downto 0);
	signal rlast_gfx   : std_logic;
	signal rdvalid_gfx : std_logic;
	signal rdready_gfx : std_logic;
	signal rres_gfx    : std_logic_vector(1 downto 0);

	-- UART
	-- _uart-write address channel
	signal waddr_uart  : ADR_T;
	signal wlen_uart   : std_logic_vector(9 downto 0);
	signal wsize_uart  : std_logic_vector(9 downto 0);
	signal wvalid_uart : std_logic;
	signal wready_uart : std_logic;
	-- _uart-write data channel
	signal wdata_uart      : DAT_T;
	signal wtrb_uart       : std_logic_vector(3 downto 0);
	signal wlast_uart      : std_logic;
	signal wdvalid_uart    : std_logic;
	signal wdataready_uart : std_logic;
	-- _uart-write response channel
	signal wrready_uart : std_logic;
	signal wrvalid_uart : std_logic;
	signal wrsp_uart    : std_logic_vector(1 downto 0);

	-- _uart-read address channel
	signal raddr_uart  : ADR_T;
	signal rlen_uart   : std_logic_vector(9 downto 0);
	signal rsize_uart  : std_logic_vector(9 downto 0);
	signal rvalid_uart : std_logic;
	signal rready_uart : std_logic;
	-- _uart-read data channel
	signal rdata_uart   : DAT_T;
	signal rstrb_uart   : std_logic_vector(3 downto 0);
	signal rlast_uart   : std_logic;
	signal rdvalid_uart : std_logic;
	signal rdready_uart : std_logic;
	signal rres_uart    : std_logic_vector(1 downto 0);

	-- USB
	-- _usb-write address channel
	signal waddr_usb  : ADR_T;
	signal wlen_usb   : std_logic_vector(9 downto 0);
	signal wsize_usb  : std_logic_vector(9 downto 0);
	signal wvalid_usb : std_logic;
	signal wready_usb : std_logic;
	-- _usb-write data channel
	signal wdata_usb      : DAT_T;
	signal wtrb_usb       : std_logic_vector(3 downto 0);
	signal wlast_usb      : std_logic;
	signal wdvalid_usb    : std_logic;
	signal wdataready_usb : std_logic;
	-- _usb-write response channel
	signal wrready_usb : std_logic;
	signal wrvalid_usb : std_logic;
	signal wrsp_usb    : std_logic_vector(1 downto 0);

	-- _usb-read address channel
	signal raddr_usb  : ADR_T;
	signal rlen_usb   : std_logic_vector(9 downto 0);
	signal rsize_usb  : std_logic_vector(9 downto 0);
	signal rvalid_usb : std_logic;
	signal rready_usb : std_logic;
	-- _usb-read data channel
	signal rdata_usb   : DAT_T;
	signal rstrb_usb   : std_logic_vector(3 downto 0);
	signal rlast_usb   : std_logic;
	signal rdvalid_usb : std_logic;
	signal rdready_usb : std_logic;
	signal rres_usb    : std_logic_vector(1 downto 0);

	-- AUDIO
	-- _audio-write address channel
	signal waddr_audio  : ADR_T;
	signal wlen_audio   : std_logic_vector(9 downto 0);
	signal wsize_audio  : std_logic_vector(9 downto 0);
	signal wvalid_audio : std_logic;
	signal wready_audio : std_logic;
	-- _audio-write data channel
	signal wdata_audio      : DAT_T;
	signal wtrb_audio       : std_logic_vector(3 downto 0);
	signal wlast_audio      : std_logic;
	signal wdvalid_audio    : std_logic;
	signal wdataready_audio : std_logic;
	-- _audio-write response channel
	signal wrready_audio : std_logic;
	signal wrvalid_audio : std_logic;
	signal wrsp_audio    : std_logic_vector(1 downto 0);

	-- _audio-read address channel
	signal raddr_audio  : ADR_T;
	signal rlen_audio   : std_logic_vector(9 downto 0);
	signal rsize_audio  : std_logic_vector(9 downto 0);
	signal rvalid_audio : std_logic;
	signal rready_audio : std_logic;
	-- _audio-read data channel
	signal rdata_audio   : DAT_T;
	signal rstrb_audio   : std_logic_vector(3 downto 0);
	signal rlast_audio   : std_logic;
	signal rdvalid_audio : std_logic;
	signal rdready_audio : std_logic;
	signal rres_audio    : std_logic_vector(1 downto 0);

	signal cpu1_pwr_req, cpu1_pwr_res, cpu2_pwr_req, cpu2_pwr_res : MSG_T;

	signal proc0_done, proc1_done, usb_done, uart_done, gfx_done, audio_done : std_logic;
	signal full_snpres                                                       : std_logic;
	signal Clock : std_logic;
begin
        IBUFGDS_inst : IBUFGDS
generic map (
DIFF_TERM => FALSE, -- Differential Termination
IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
IOSTANDARD => "DEFAULT")
port map (
O => Clock, -- Clock buffer output
I => clk, -- Diff_p clock buffer input (connect directly to top-level port)
IB => clk1 -- Diff_n clock buffer input (connect directly to top-level port)
);
-- End of IBUFGDS_inst instantiation
	   proc0_e : entity work.proc(rtl) port map(
	     reset     => reset,
	     Clock     => Clock,
	
	     id_i      => CPU0,
	
	     snp_req_i  => snp_req1, -- snoop req from cache 2
	     snp_hit_o => snp_hit1,
	     snp_res_o => snp_res1,
	
	     up_snp_req_i  => up_snp_req, -- upstream snoop req 
	     up_snp_hit_o => up_snp_hit,
	     up_snp_res_o => up_snp_res,
	     full_snpres_i=> full_snpres,
	
	     snp_req_o => snp_req2, -- fwd snp req to other cache
	     snp_hit_i => snp_hit2,
	     snp_res_i => snp_res2,
	
	     bus_req_o  => bus_req1, -- mem or pwr req to ic
	     bus_res_i   => bus_res1, -- mem or pwr resp from ic    
	
	--     wb_req_o      => wb_req1,
	
	     -- for observation:
	     done_o => proc0_done,
	     cpu_req_o  => cpu_req1,
	     cpu_res_o => cpu_res1
	
	     );
	
	   proc1_e : entity work.proc(rtl) port map(
	     reset     => reset,
	     Clock     => Clock,
	
	     id_i      => CPU1,
	
	     snp_req_i  => snp_req2, -- snoop req from cache 2
	     snp_hit_o => snp_hit2,
	     snp_res_o => snp_res2,
	
	     -- TODO not implemented yet:
	     up_snp_req_i  => ZERO_MSG, -- upstream snoop req 
	     --up_snp_hit_o => ,
	     --up_snp_res_o => ,
		 full_snpres_i=>'0',
	     snp_req_o => snp_req1, -- fwd snp req to other cache
	     snp_hit_i => snp_hit1,
	     snp_res_i => snp_res1,
	
	     bus_req_o  => bus_req2, -- mem or pwr req to ic
	     bus_res_i   => bus_res2, -- mem or pwr resp from ic    
	
	--     wb_req_o      => wb_req2,
	
	     -- for observation:
	     done_o => proc1_done,
	     cpu_req_o  => cpu_req2,
	     cpu_res_o => cpu_res2
	     );
	
	  power : entity work.pwr(rtl) port map(
	    Clock     => Clock,
	    reset     => reset,
	    
	    req_i        => ic_pwr_req,
	    res_o       => ic_pwr_res,
	    
	    audio_req_o  => pwr_audio_req,
	    audio_res_i  => pwr_audio_res,
	    
	    usb_req_o    => pwr_usb_req,
	    usb_res_i    => pwr_usb_res,
	    
	    uart_req_o   => pwr_uart_req,
	    uart_res_i   => pwr_uart_res,
	
	    full_preq => pwr_req_full,
	
	    gfx_req_o    => pwr_gfx_req,
	    gfx_res_i    => pwr_gfx_res
	    );

	   interconnect : entity work.ic(rtl) port map(
	     Clock            => Clock,
	     reset            => reset,

	     gfx_upreq_i      => gfx_upreq,
	     gfx_upres_o      => gfx_upres,
	     gfx_upreq_full_o => gfx_upreq_full,

	     audio_upreq_i      => audio_upreq,
	     audio_upres_o      => audio_upres,
	     audio_upreq_full_o => audio_upreq_full,

	     usb_upreq_i        => usb_upreq,
	     usb_upres_o        => usb_upres,
	     usb_upreq_full_o   => usb_upreq_full,

	     uart_upreq_i       => uart_upreq,
	     uart_upres_o       => uart_upres,
	     uart_upreq_full_o  => uart_upreq_full,
	     full_snpres_o      => full_snpres,  -- enabled if snp res fifo is full
	     -- write
	     waddr            => waddr,
	     wlen             => wlen,
	     wsize            => wsize,
	     wvalid           => wvalid,
	     wready           => wready,
	     wdata            => wdata,
	     wtrb             => wtrb,
	     wlast            => wlast,
	     wdvalid          => wdvalid,
	     wdataready       => wdataready,
	     wrready          => wrready,
	     wrvalid_i        => wrvalid, -- write resp
	     wrsp             => wrsp,
	     -- read
	     raddr            => raddr,
	     rlen             => rlen,
	     rsize            => rsize,
	     rvalid_o       => rvalid,
	     rready           => rready,
	     rdata            => rdata,
	     rstrb            => rstrb,
	     rlast            => rlast,
	     rdvalid_i       => rdvalid,
	     rdready          => rdready,
	     rres             => rres,

	     waddr_gfx        => waddr_gfx,
	     wlen_gfx         => wlen_gfx,
	     wsize_gfx        => wsize_gfx,
	     wvalid_gfx       => wvalid_gfx,
	     wready_gfx       => wready,
	     wdata_gfx        => wdata_gfx,
	     wtrb_gfx         => wtrb_gfx,
	     wlast_gfx        => wlast_gfx,
	     wdvalid_gfx      => wdvalid_gfx,
	     wdataready_gfx   => wdataready_gfx,
	     wrready_gfx      => wrready_gfx,
	     wrvalid_gfx      => wrvalid_gfx,
	     wrsp_gfx         => wrsp_gfx,

	     raddr_gfx        => raddr_gfx,
	     rlen_gfx         => rlen_gfx,
	     rsize_gfx        => rsize_gfx,
	     rvalid_gfx       => rvalid_gfx,
	     rready_gfx       => rready_gfx,
	     rdata_gfx        => rdata_gfx,
	     rstrb_gfx        => rstrb_gfx,
	     rlast_gfx        => rlast_gfx,
	     rdvalid_gfx      => rdvalid_gfx,
	     rdready_gfx      => rdready_gfx,
	     rres_gfx         => rres_gfx,
	     waddr_uart       => waddr_uart,
	     wlen_uart        => wlen_uart,
	     wsize_uart       => wsize_uart,
	     wvalid_uart      => wvalid_uart,
	     wready_uart      => wready_uart,
	     wdata_uart       => wdata_uart,
	     wtrb_uart        => wtrb_uart,
	     wlast_uart       => wlast_uart,
	     wdvalid_uart     => wdvalid_uart,
	     wdataready_uart  => wdataready_uart,
	     wrready_uart     => wrready_uart,
	     wrvalid_uart     => wrvalid_uart,
	     wrsp_uart        => wrsp_uart,
	     raddr_uart       => raddr_uart,
	     rlen_uart        => rlen_uart,
	     rsize_uart       => rsize_uart,
	     rvalid_uart      => rvalid_uart,
	     rready_uart      => rready_uart,
	     rdata_uart       => rdata_uart,
	     rstrb_uart       => rstrb_uart,
	     rlast_uart       => rlast_uart,
	     rdvalid_uart     => rdvalid_uart,
	     rdready_uart     => rdready_uart,
	     rres_uart        => rres_uart,
	     waddr_usb        => waddr_usb,
	     wlen_usb         => wlen_usb,
	     wsize_usb        => wsize_usb,
	     wvalid_usb       => wvalid_usb,
	     wready_usb       => wready_usb,
	     wdata_usb        => wdata_usb,
	     wtrb_usb         => wtrb_usb,
	     wlast_usb        => wlast_usb,
	     wdvalid_usb      => wdvalid_usb,
	     wdataready_usb   => wdataready_usb,
	     wrready_usb      => wrready_usb,
	     wrvalid_usb      => wrvalid_usb,
	     wrsp_usb         => wrsp_usb,
	     raddr_usb        => raddr_usb,
	     rlen_usb         => rlen_usb,
	     rsize_usb        => rsize_usb,
	     rvalid_usb       => rvalid_usb,
	     rready_usb       => rready_usb,
	     rdata_usb        => rdata_usb,
	     rstrb_usb        => rstrb_usb,
	     rlast_usb        => rlast_usb,
	     rdvalid_usb      => rdvalid_usb,
	     rdready_usb      => rdready_usb,
	     rres_usb         => rres_usb,
	     waddr_audio      => waddr_audio,
	     wlen_audio       => wlen_audio,
	     wsize_audio      => wsize_audio,
	     wvalid_audio     => wvalid_audio,
	     wready_audio     => wready_audio,
	     wdata_audio      => wdata_audio,
	     wtrb_audio       => wtrb_audio,
	     wlast_audio      => wlast_audio,
	     wdvalid_audio    => wdvalid_audio,
	     wdataready_audio => wdataready_audio,
	     wrready_audio    => wrready_audio,
	     wrvalid_audio    => wrvalid_audio,
	     wrsp_audio       => wrsp_audio,
	     raddr_audio      => raddr_audio,
	     rlen_audio       => rlen_audio,
	     rsize_audio      => rsize_audio,
	     rvalid_audio     => rvalid_audio,
	     rready_audio     => rready_audio,
	     rdata_audio      => rdata_audio,
	     rstrb_audio      => rstrb_audio,
	     rlast_audio      => rlast_audio,
	     rdvalid_audio    => rdvalid_audio,
	     rdready_audio    => rdready_audio,
	     rres_audio       => rres_audio,

	     up_snp_res_i     => up_snp_res,
	     up_snp_hit_i     => up_snp_hit,

	     cache1_req_i     => bus_req1,
	     cache2_req_i     => bus_req2,

	     pwr_res_i        => ic_pwr_res,

	     wb_req1_i        => wb_req1,
	     wb_req2_i        => wb_req2,
	     pwr_req_full_i   => pwr_req_full,

	     full_snp_req1_i  => full_srq1,

	     bus_res1_o     => bus_res1,
	     bus_res2_o     => bus_res2,
	     up_snp_req_o   => up_snp_req,

	     full_wb1_o         => full_wb1,
	     full_srs1_o        => full_srs1,
	     full_wb2_o         => full_wb2,
	      --full_mrs_o

	     pwr_req_o        => ic_pwr_req
	     );

	uart_entity : entity work.uart_peripheral(rtl)
		port map(
			Clock        => Clock,
			reset        => reset,
			id_i         => GFX,
			tx_out       => tx_out,
			rx_in        => rx_in,
			-- write address channel
			waddr_i      => waddr_gfx,
			wlen_i       => wlen_gfx,
			wsize_i      => wsize_gfx,
			wvalid_i     => wvalid_gfx,
			wready_o     => wready_gfx,
			-- write data channel
			wdata_i      => wdata_gfx,
			wtrb_i       => wtrb_gfx,
			wlast_i      => wlast_gfx,
			wdvalid_i    => wdvalid_gfx,
			wdataready_o => wdataready_gfx,
			-- write response channel
			wrready_i    => wrready_gfx,
			wrvalid_o    => wrvalid_gfx,
			wrsp_o       => wrsp_gfx,
			-- read address channel
			raddr_i      => raddr_gfx,
			rlen_i       => rlen_gfx,
			rsize_i      => rsize_gfx,
			rvalid_i     => rvalid_gfx,
			rready_o     => rready_gfx,
			-- read data channel
			rdata_o      => rdata_gfx,
			rstrb_o      => rstrb_gfx,
			rlast_o      => rlast_gfx,
			rdvalid_o    => rdvalid_gfx,
			rdready_i    => rdready_gfx,
			rres_o       => rres_gfx,
			-- up snp
			upres_i      => gfx_upres,
			upreq_o      => gfx_upreq,
			upreq_full_i => gfx_upreq_full,
			-- power
			pwr_req_i    => pwr_gfx_req,
			pwr_res_o    => pwr_gfx_res,
			done_o       => gfx_done
		);

	audio_entity : entity work.peripheral(rtl)
		port map(
			Clock        => Clock,
			reset        => reset,
			id_i         => AUDIO,
			-- write address channel
			waddr_i      => waddr_audio,
			wlen_i       => wlen_audio,
			wsize_i      => wsize_audio,
			wvalid_i     => wvalid_audio,
			wready_o     => wready_audio,
			-- write data channel
			wdata_i      => wdata_audio,
			wtrb_i       => wtrb_audio,
			wlast_i      => wlast_audio,
			wdvalid_i    => wdvalid_audio,
			wdataready_o => wdataready_audio,
			-- write response channel
			wrready_i    => wrready_audio,
			wrvalid_o    => wrvalid_audio,
			wrsp_o       => wrsp_audio,
			-- read address channel
			raddr_i      => raddr_audio,
			rlen_i       => rlen_audio,
			rsize_i      => rsize_audio,
			rvalid_i     => rvalid_audio,
			rready_o     => rready_audio,
			-- read data channel
			rdata_o      => rdata_audio,
			rstrb_o      => rstrb_audio,
			rlast_o      => rlast_audio,
			rdvalid_o    => rdvalid_audio,
			rdready_i    => rdready_audio,
			rres_o       => rres_audio,
			-- up snp
			upres_i      => audio_upres,
			upreq_o      => audio_upreq,
			upreq_full_i => audio_upreq_full,
			-- power
			pwr_req_i    => pwr_audio_req,
			pwr_res_o    => pwr_audio_res,
			done_o       => audio_done
		);

	usb_entity : entity work.peripheral(rtl)
		port map(
			Clock        => Clock,
			reset        => reset,
			id_i         => USB,
			-- write address channel
			waddr_i      => waddr_usb,
			wlen_i       => wlen_usb,
			wsize_i      => wsize_usb,
			wvalid_i     => wvalid_usb,
			wready_o     => wready_usb,
			-- write data channel
			wdata_i      => wdata_usb,
			wtrb_i       => wtrb_usb,
			wlast_i      => wlast_usb,
			wdvalid_i    => wdvalid_usb,
			wdataready_o => wdataready_usb,
			-- write response channel
			wrready_i    => wrready_usb,
			wrvalid_o    => wrvalid_usb,
			wrsp_o       => wrsp_usb,
			-- read address channel
			raddr_i      => raddr_usb,
			rlen_i       => rlen_usb,
			rsize_i      => rsize_usb,
			rvalid_i     => rvalid_usb,
			rready_o     => rready_usb,
			-- read data channel
			rdata_o      => rdata_usb,
			rstrb_o      => rstrb_usb,
			rlast_o      => rlast_usb,
			rdvalid_o    => rdvalid_usb,
			rdready_i    => rdready_usb,
			rres_o       => rres_usb,
			-- up snp
			upres_i      => usb_upres,
			upreq_o      => usb_upreq,
			upreq_full_i => usb_upreq_full,
			-- power
			pwr_req_i    => pwr_usb_req,
			pwr_res_o    => pwr_usb_res,
			done_o       => usb_done
		);

	gfx_entity : entity work.peripheral(rtl)
		port map(
			Clock        => Clock,
			reset        => reset,
			id_i         => UART,
			-- write address channel
			waddr_i      => waddr_uart,
			wlen_i       => wlen_uart,
			wsize_i      => wsize_uart,
			wvalid_i     => wvalid_uart,
			wready_o     => wready_uart,
			-- write data channel
			wdata_i      => wdata_uart,
			wtrb_i       => wtrb_uart,
			wlast_i      => wlast_uart,
			wdvalid_i    => wdvalid_uart,
			wdataready_o => wdataready_uart,
			-- write response channel
			wrready_i    => wrready_uart,
			wrvalid_o    => wrvalid_uart,
			wrsp_o       => wrsp_uart,
			-- read address channel
			raddr_i      => raddr_uart,
			rlen_i       => rlen_uart,
			rsize_i      => rsize_uart,
			rvalid_i     => rvalid_uart,
			rready_o     => rready_uart,
			-- read data channel
			rdata_o      => rdata_uart,
			rstrb_o      => rstrb_uart,
			rlast_o      => rlast_uart,
			rdvalid_o    => rdvalid_uart,
			rdready_i    => rdready_uart,
			rres_o       => rres_uart,
			-- up snp
			upres_i      => uart_upres,
			upreq_o      => uart_upreq,
			upreq_full_i => uart_upreq_full,
			-- power
			pwr_req_i    => pwr_uart_req,
			pwr_res_o    => pwr_uart_res,
			done_o       => uart_done
		);

	mem : entity work.Memory(rtl)
		port map(
			Clock        => Clock,
			reset        => reset,
			waddr_i      => waddr,
			wlen_i       => wlen,
			wsize_i      => wsize,
			wvalid_i     => wvalid,
			wready_o     => wready,
			wdata_i      => wdata,
			wtrb_i       => wtrb,
			wlast_i      => wlast,
			wdvalid_i    => wdvalid,
			wdataready_o => wdataready,
			wrready_i    => wrready,
			wrvalid_o    => wrvalid,
			wrsp_o       => wrsp,
			raddr_i      => raddr,
			rlen_i       => rlen,
			rsize_i      => rsize,
			rvalid_i     => rvalid,
			rready_o     => rready,
			rdata_o      => rdata,
			rstrb_o      => rstrb,
			rlast_o      => rlast,
			rdvalid_o    => rdvalid,
			rdready_i    => rdready,
			rres_o       => rres
		);

--  -- -- Clock generation, starts at 0
--  tb_clk <= not tb_clk after tb_period/2 when tb_sim_ended /= '1' else '0';
--  Clock <= tb_clk;

--  logger_p : process(tb_clk)
--    file trace_file : TEXT open write_mode is "trace1.txt";
--    variable l : line;
--    constant SEP : String(1 to 1) := ",";
--  begin
--    if GEN_TRACE1 then
--      if rising_edge(tb_clk) then
--        ---- cpu
--        write(l, slv(cpu_req1));--0
--        write(l, SEP);
--        write(l, slv(cpu_res1));--1
--        write(l, SEP);
--        write(l, slv(cpu_req2));--02
--        write(l, SEP);
--        write(l, slv(cpu_res2));--03
--        write(l, SEP);

--        ---- snp
--        write(l, slv(snp_req1));--04
--        write(l, SEP);
--        write(l, slv(snp_res1));--05
--        write(l, SEP);
--        write(l, snp_hit1);--06
--        write(l, SEP);

--        write(l, slv(snp_req2));--07
--        write(l, SEP);
--        write(l, slv(snp_res2));--08
--        write(l, SEP);
--        write(l, snp_hit2);--09
--        write(l, SEP);

--        ---- up_snp
--        write(l, slv(up_snp_req));--010
--        write(l, SEP);
--        write(l, slv(up_snp_res));--011
--        write(l, SEP);
--        write(l, up_snp_hit);--012
--        write(l, SEP);

--        ---- cache_req
--        write(l, slv(bus_req1));--013
--        write(l, SEP);
--        write(l, slv(bus_res1));--014
--        write(l, SEP);

--        write(l, slv(bus_req2));--015
--        write(l, SEP);
--        write(l, slv(bus_res2));--016
--        write(l, SEP);

--        ---- ic
--        ---- read
--        write(l, rvalid);--017
--        write(l, SEP);
--        write(l, raddr);--018
--        write(l, SEP);
--        write(l, rdvalid);--019
--        write(l, SEP);
--        write(l, rlast);--020
--        write(l, SEP);
--        ---- write
--        write(l, wvalid);--021
--        write(l, SEP);
--        write(l, waddr);--022
--        write(l, SEP);
--        write(l, wdvalid);--023
--        write(l, SEP);
--        write(l, wlast);--024
--        write(l, SEP);

--        ---- gfx
--        ---- read
--        write(l, rvalid_gfx);--025
--        write(l, SEP);
--        write(l, raddr_gfx);--026
--        write(l, SEP);
--        write(l, rdvalid_gfx);--027
--        write(l, SEP);
--        write(l, rlast_gfx);--028
--        write(l, SEP);
--        ---- write
--        write(l, wvalid_gfx);--029
--        write(l, SEP);
--        write(l, waddr_gfx);--030
--        write(l, SEP);
--        write(l, wdvalid_gfx);--031
--        write(l, SEP);
--        write(l, wlast_gfx);--032
--        write(l, SEP);

--        ---- uart
--        ---- read
--        write(l, rvalid_uart);--33
--        write(l, SEP);
--        write(l, raddr_uart);--34
--        write(l, SEP);
--        write(l, rdvalid_uart);--35
--        write(l, SEP);
--        write(l, rlast_uart);
--        write(l, SEP);
--        ---- write
--        write(l, wvalid_uart);
--        write(l, SEP);
--        write(l, waddr_uart);
--        write(l, SEP);
--        write(l, wdvalid_uart);
--        write(l, SEP);
--        write(l, wlast_uart);
--        write(l, SEP);

--        ---- usb
--        ---- read
--        write(l, rvalid_usb);
--        write(l, SEP);
--        write(l, raddr_usb);
--        write(l, SEP);
--        write(l, rdvalid_usb);
--        write(l, SEP);
--        write(l, rlast_usb);
--        write(l, SEP);
--        ---- write
--        write(l, wvalid_usb);
--        write(l, SEP);
--        write(l, waddr_usb);
--        write(l, SEP);
--        write(l, wdvalid_usb);
--        write(l, SEP);
--        write(l, wlast_usb);
--        write(l, SEP);

--        ---- audio
--        ---- read
--        write(l, rvalid_audio);
--        write(l, SEP);
--        write(l, raddr_audio);
--        write(l, SEP);
--        write(l, rdvalid_audio);
--        write(l, SEP);
--        write(l, rlast_audio);
--        write(l, SEP);
--        ---- write
--        write(l, wvalid_audio);
--        write(l, SEP);
--        write(l, waddr_audio);
--        write(l, SEP);
--        write(l, wdvalid_audio);
--        write(l, SEP);
--        write(l, wlast_audio);
--        write(l, SEP);

--        -- upreq and upres
--        write(l, slv(gfx_upreq));
--        write(l, SEP);
--        write(l, slv(gfx_upres));
--        write(l, SEP);

--        write(l, slv(uart_upreq));
--        write(l, SEP);
--        write(l, slv(uart_upres));
--        write(l, SEP);

--        write(l, slv(usb_upreq));
--        write(l, SEP);
--        write(l, slv(usb_upres));
--        write(l, SEP);

--        write(l, slv(audio_upreq));
--        write(l, SEP);
--        write(l, slv(audio_upres));
--        write(l, SEP);

--        ---- pwr sigs
--        -- from ic
--        write(l, slv(ic_pwr_req));
--        write(l, SEP);
--        write(l, slv(ic_pwr_res));
--        write(l, SEP);

--        -- from peripherals
--        write(l, slv(pwr_gfx_req));
--        write(l, SEP);
--        write(l, slv(pwr_gfx_res));
--        write(l, SEP);

--        write(l, slv(pwr_uart_req));
--        write(l, SEP);
--        write(l, slv(pwr_uart_res));
--        write(l, SEP);

--        write(l, slv(pwr_usb_req));
--        write(l, SEP);
--        write(l, slv(pwr_usb_res));
--        write(l, SEP);

--        write(l, slv(pwr_audio_req));
--        write(l, SEP);
--        write(l, slv(pwr_audio_res));

--        writeline(trace_file, l); 
--      end if;
--    end if;
--  end process;

--  pwrt_mon_p : process
--    variable c : natural := 0;
--    variable r : MSG_T;
--  begin
--    if is_tset(TEST(PWR)) then
--      wait until is_pwr_cmd(cpu_req1);
--      r := cpu_req1;
--      --c := c + 1;
--      --wait until bus_req1 = r;
--      --c := c + 1;
--      --wait until ic_pwr_req = r;
--      --c := c + 1;
--      ---- ..
--      --wait until ic_pwr_res = r;
--      --c := c + 1;
--      --wait until bus_res1 = rpad(r);
--      --c := c + 1;
--      --wait until cpu_res1 = r;
--      --c := c + 1;
--      wait until is_pwr_cmd(cpu_res1);
--      --dbg("000" & r);
--      --dbg("000" & cpu_res1);
--      info(str(c) & " PWR_TEST OK");
--    end if;
--    wait;
--  end process;

--  --cpu2_w_mon : process
--  --  variable m, t : time := 0 ps;
--  --  variable zeros553 : std_logic_vector(552 downto 0) := (others => '0');
--  --  variable zeros73 : MSG_T := (others => '0');
--  --begin
--  --  if is_tset(TEST(CPU2W)) then
--  --    wait until cpu_res2 /= zeros73;
--  --    report "TEST(CPU2W) OK";
--  --  ---- TODO ... more tests here ...
--  --    --m := 510 ps;
--  --    --wait for m - t;
--  --    --t := m;
--  --    --assert cpu_res2 /= zeros73 report "cpu2_w_mon, msg 8: cpu_res2 is 0" severity error;
--  --  end if;
--  --  wait;
--  --end process;

--  --cpu1_r_mon : process
--  --  variable m, t : time := 0 ps;
--  --  variable zeros553 : std_logic_vector(552 downto 0) := (others => '0');
--  --  variable zeros73 : std_logic_vector(72 downto 0) := (others => '0');
--  --begin
--  --  if is_tset(TEST(CPU1R)) then
--  --    m := 70 ps;
--  --    wait for m - t;
--  --    t := m;
--  --    assert cpu_req1 /= zeros73 report "cpu1_r_mon, msg 1: cpu_req1 is 0" severity error;

--  --    m := 140 ps;
--  --    wait for m - t;
--  --    t := m;
--  --    assert snp_req2 /= zeros73 report "cpu1_r_mon, msg 2: snp_req2 is 0" severity error;

--  --    m := 220 ps;
--  --    wait for m - t;
--  --    t := m;
--  --    assert snp_res2 /= zeros73 report "cpu1_r_mon, msg 3: snp_res2 is 0" severity error;

--  --    m := 230 ps;
--  --    wait for m - t;
--  --    t := m;
--  --    assert bus_req1 /= zeros73 report "cpu1_r_mon, msg 4: bus_req1 is 0" severity error;

--  --    m := 280 ps;
--  --    wait for m - t;
--  --    t := m;
--  --    assert rvalid /= '0' report "cpu1_r_mon, msg 5: rvalid is 0" severity error;

--  --    m := 300 ps;
--  --    wait for m - t;
--  --    t := m;
--  --    assert rdvalid /= '0' report "cpu1_r_mon, msg 6: rdvalid is 0" severity error;

--  --    m := 440 ps;
--  --    wait for m - t;
--  --    t := m;
--  --    assert bus_res1 /= zeros73 report "cpu1_r_mon, msg 7: bus_res1 is 0" severity error;

--  --    m := 550 ps;
--  --    wait for m - t;
--  --    t := m;
--  --    assert cpu_res1 /= zeros73 report "cpu1_r_mon, msg 8: cpu_res1 is 0" severity error;
--  --  --check_inv(t, 550 ps, cpu_res1 /= zeros73, "cpu1_r_mon, msg 8: cpu_res1 is 0");
--  --  end if;
--  --  wait;
--  --end process;

--  stimuli : process
--  begin

--    reset <= '1';
--    wait for 15 ps;
--    reset <= '0';
--    wait until tb_sim_ended = '1';
--    report "SIM END";
--  end process;

--  tb_sim_ended <= proc0_done and proc1_done and usb_done and uart_done and gfx_done and audio_done;
end tb;
