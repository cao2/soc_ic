library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.defs.all;

entity fifo32_at is
  Generic (
    constant FIFO_DEPTH	: positive := 5
	);
  Port ( 
    CLK		: in  STD_LOGIC;
    RST		: in  STD_LOGIC;
    --WriteEn	: in  STD_LOGIC;
    --DataVal: in ALL_T;
    --DataLen: in std_logic_vector(4 downto 0);
    DataIn	: in  ALL_T;
    --ReadEn : in STD_LOGIC;
    DataOut	: out TST_TO;
    Full	: out STD_LOGIC := '0'
	);
end fifo32_at;

architecture rtl of fifo32_at is
 --signal td1: std_logic_vector(31 downto 0);
 --signal td2: std_logic_vector(31 downto 0);
begin
	
  -- Memory Pointer Process
  fifo_proc : process (clk,rst)
    type FIFO_Memory is
      array (0 to FIFO_DEPTH - 1) of ALL_T;
    variable Memory : FIFO_Memory;
    variable num_val: natural range 0 to 31;
    type val_c is array (0 to 31) of natural range 0 to 31;
    variable val_chan : val_c;
    variable Head : natural range 0 to FIFO_DEPTH - 1;
    variable Tail : natural range 0 to FIFO_DEPTH - 1;
    
    variable Looped : boolean;
    variable len: integer :=0;
    variable i: integer :=0;
    variable first: boolean := true;
    variable tmp_all_read: ALL_T;
    variable amount: integer :=0;
    variable tmp_all: ALL_T;
    variable st: natural range 0 to 31:=0;
    variable valid: boolean:=false;
  begin
  	if rising_edge(CLK) then
      if RST = '1' then
        Head := 0;
        Tail := 0;
        Looped := false;
        Full  <= '0';
--        Empty <= '1';
        DataOut.val<= '0';
    else
        first  := true;
        i := 0;
       -- if (WriteEn = '1') then
       
       
       ----now need to calculate number of valid
       if (DataIn(0).val='1') then
            valid := true;
            val_chan(num_val) := 0;
            num_val:= num_val+1;
       end if;
       if (valid=true) then
          if (((Looped = false) or (Head /= Tail))) and DataIn(i).val='1' then

            if (first=true) then
                Memory(Head) :=DataIn ;
                first := false;
             else
                 Memory(Head) := DataIn ;
            end if;
            -- Increment Head pointer as needed
            if (Head = FIFO_DEPTH - 1) then
              Head := 0;
              Looped := true;
            else
              Head := Head + 1;
            end if;
          end if;
          i := i+1;
          amount := amount +1;
          if (Head = Tail) then
                    if Looped then
                      Full <= '0';
                      report "the fifo is too small, it is full!!!!!!!!!!!!";
                    else
                      DataOut.val<='0';
                    end if;
                  else
                    Full    <= '0';
                  end if;
       
          end if;
          if (st=0) then
          if ((Looped = true) or (Head /= Tail)) then
            -- Update data output
            tmp_all_read := Memory(Tail);
            amount := amount -1;
            -- Update Tail pointer as needed
            if (Tail = FIFO_DEPTH - 1) then
              Tail := 0;
              
              Looped := false;
            else
              Tail := Tail + 1;
            end if;
          end if;
         elsif (st=1) then
         end if;
      end if;
   end if;
  end process;
  
end rtl;
