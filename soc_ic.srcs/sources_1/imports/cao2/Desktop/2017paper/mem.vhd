library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.util.all;
use work.test.all;

entity memory is
  Port(Clock      : in  std_logic;
       reset      : in  std_logic;
       ---write address chanel
       waddr_i      : in  std_logic_vector(31 downto 0);
       wlen_i       : in  std_logic_vector(9 downto 0);
       wsize_i      : in  std_logic_vector(9 downto 0);
       wvalid_i     : in  std_logic;
       wready_o     : out std_logic;
       ---write data channel
       wdata_i      : in  std_logic_vector(31 downto 0);
       wtrb_i       : in  std_logic_vector(3 downto 0);
       wlast_i      : in  std_logic;
       wdvalid_i    : in  std_logic;
       wdataready_o : out std_logic;
       ---write response channel
       wrready_i    : in  std_logic;
       wrvalid_o    : out std_logic;
       wrsp_o       : out std_logic_vector(1 downto 0);

       ---read address channel
       raddr_i      : in  std_logic_vector(31 downto 0);
       rlen_i       : in  std_logic_vector(9 downto 0);
       rsize_i      : in  std_logic_vector(9 downto 0);
       rvalid_i  : in  std_logic;
       rready_o     : out std_logic;
       ---read data channel
       rdata_o      : out std_logic_vector(31 downto 0);
       rstrb_o      : out std_logic_vector(3 downto 0);
       rlast_o      : out std_logic;
       rdvalid_o    : out std_logic; -- sig from mem to ic meaning "here comes
       -- the data"
       rdready_i    : in  std_logic; -- sig from ic to mem meaning "done"
       -- sending data
       rres_o   : out std_logic_vector(1 downto 0)
       );
end Memory;

architecture rtl of Memory is
  --type rom_type is array (2**32-1 downto 0) of std_logic_vector (31 downto 0);
  type ram_type is array (0 to natural(2 ** 2 - 1) - 1) of std_logic_vector(wdata_i'range);
  type ram_type1 is array (0 to natural(2 ** 2 - 1) - 1) of ram_type;
  signal ROM_array : ram_type1 := (others => (others => (others => '0')));

  signal r,w : std_logic := '0';
  
begin
  write : process(Clock, reset)
    variable slot       : integer;
    variable address    : integer;
    variable len        : integer;
    variable size       : std_logic_vector(9 downto 0);
    variable st, st_nxt : natural := 0;
    variable cnt        : natural;
    variable lp         : integer := 0;
  begin
    if reset = '1' then
      wready_o     <= '1';
      wdataready_o <= '0';
    elsif (rising_edge(Clock)) then
    	if st = 0 then
    		wready_o <='1';
        wrvalid_o <= '0';
        wrsp_o    <= "10";
        if wvalid_i = '1' then
          wready_o     <= '0';
          slot       := to_integer(unsigned(waddr_i(26 downto 15)));
          address    := to_integer(unsigned(waddr_i(15 downto 0)));
          len        := to_integer(unsigned(wlen_i));
          size       := wsize_i;
          wdataready_o <= '1';
          st      := 2;
        end if;

      elsif st = 2 then
        if wdvalid_i = '1' then
          st := 4;
          st_nxt := 5;
        end if;
      elsif st = 5 then
        if lp < len - 1 then
          wdataready_o <= '0';
          ---strob here is not considered
          ROM_array(slot)(address + lp) <= wdata_i(31 downto 0);
          lp := lp + 1;
          wdataready_o <= '1';
          if wlast_i = '1' then
            st := 4;
            st_nxt := 3;
          end if;
        else
          cnt := MEM_DELAY;
          st := 4;
          st_nxt := 3;
        end if;
      elsif st = 3 then
  --      w <= '0';
        if wrready_i = '1' then
          wrvalid_o <= '1';
          wrsp_o    <= "00";
          st   := 0;
        end if;
      elsif st = 4 then
  --      w <= '1';
        delay(cnt, st, st_nxt);
      end if;
    end if;
  end process;

  read : process(Clock, reset)
    variable slot    : integer;
    variable address : integer;
    variable len     : integer;
    variable size    : std_logic_vector(9 downto 0);
    variable st, st_nxt   : natural := 0;
    variable lp      : integer := 0;
    variable dt      : std_logic_vector(31 downto 0);
    variable cnt     : natural;
  begin
    if reset = '1' then
      rready_o  <= '1';
      rdvalid_o <= '0';
      rstrb_o   <= "1111";
      rlast_o   <= '0';
      address := 0;
    elsif (rising_edge(Clock)) then
      if st = 0 then
        lp := 0;
        if rvalid_i = '1' then
          rready_o  <= '0';
          slot    := to_integer(unsigned(waddr_i(26 downto 25)));
          address := to_integer(unsigned(waddr_i(15 downto 14)));
          len     := to_integer(unsigned(rlen_i));
          size    := rsize_i;
          st   := 2;
        end if;

      elsif st = 2 then
        if rdready_i = '1' then
          cnt := MEM_DELAY;
          st := 4;
          st_nxt := 5;
        end if;
      elsif st = 5 then
          if lp < 16 then
            rdvalid_o <= '1';
            ---strob here is not considered
            ---left alone , dono how to fix
            ---if ROM_array(address+lp) ="00000000000000000000000000000000" then
            ---ROM_array(address+lp) := selection(2**15-1,32); -- TODO replace all calls "selection" in this file by rand_int, etc...
            ---end if;
            --dt      := selection(2 ** 15 - 1, 32);
            ---rdata_o <= dt;
            rdata_o   <= ROM_array(slot)(address + lp);
            lp      := lp + 1;
            rres_o <= "00";
            if lp = len then
              st := 3;
              rlast_o <= '1';
            end if;
          else
            st := 3;
          end if;

      elsif st = 3 then
--        r <= '0';
        rdvalid_o <= '0';
        rready_o  <= '1';
        rlast_o   <= '0';
        st   := 0;
      elsif st = 4 then
--        r <= '1';
        delay(cnt, st, st_nxt);
      end if;
    end if;
  end process;

end rtl;
