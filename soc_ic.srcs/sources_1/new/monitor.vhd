library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.defs.all;

entity monitor is
  Generic (
    constant interface_type	: positive := 1
	);
  Port ( 
    CLK		: in  STD_LOGIC;
    RST		: in  STD_LOGIC;
    
    ----AXI interface
    id_i       : in IP_T;
      
           ---write address channel
           waddr_i      : in  ADR_T;
           wlen_i       : in  std_logic_vector(9 downto 0);
           wsize_i      : in  std_logic_vector(9 downto 0);
           wvalid_i     : in  std_logic;
           wready_o     : in std_logic;
           ---write data channel
           wdata_i      : in  std_logic_vector(31 downto 0);
           wtrb_i       : in  std_logic_vector(3 downto 0);  --TODO not implemented
           wlast_i      : in  std_logic;
           wdvalid_i    : in  std_logic;
           wdataready_o : in std_logic;
           ---write response channel
           wrready_i    : in  std_logic;
           wrvalid_o    : in std_logic;
           wrsp_o       : in std_logic_vector(1 downto 0);
    
           ---read address channel
           raddr_i      : in  std_logic_vector(31 downto 0);
           rlen_i       : in  std_logic_vector(9 downto 0);
           rsize_i      : in  std_logic_vector(9 downto 0);
           rvalid_i     : in  std_logic;
           rready_o     : in std_logic;
           ---read data channel
           rdata_o       : in std_logic_vector(31 downto 0);
           rstrb_o       : in std_logic_vector(3 downto 0);
           rlast_o       : in std_logic;
           rdvalid_o     : in std_logic;
           rdready_i     : in  std_logic;
           rres_o        : in std_logic_vector(1 downto 0);
           
           ------Customized interface
           
           inter2_i: in MSG_T;
           inter2_o: out MSG_T
	);
end monitor;

architecture rtl of monitor is
 --signal td1: std_logic_vector(31 downto 0);
 --signal td2: std_logic_vector(31 downto 0);
begin
	
 
end rtl;
