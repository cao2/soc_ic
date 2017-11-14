library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.defs.all;

entity arbiter32 is
  Generic (
    constant FIFO_DEPTH	: positive := 8
	);
  Port ( 
    CLK		: in  STD_LOGIC;
    RST		: in  STD_LOGIC;
    DataIn	: in  ALL_T;
    DataOut	: out TST_TO;
    Full	: out STD_LOGIC := '0'
	);
end arbiter32;

architecture rtl of arbiter32 is
 --signal td1: std_logic_vector(31 downto 0);
 --signal td2: std_logic_vector(31 downto 0);
 signal tts0, tts1, tts2, tts3, tts4, tts5, tts6, tts7, tts8, tts9, tts10,tts11, tts12,tts13, tts14,
 tts15, tts16, tts17, tts18, tts19, tts20,tts21, tts22, tts23, tts24, tts25, tts26, tts27, tts28, tts29, tts30,
 tts31: TST_TTS;
 
begin
	fifo0 : entity work.fifo(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK,
			RST     => RST,
			DataIn  => brf_in,
			WriteEn => brf_we,
			ReadEn  => brf_re,
			DataOut => readreq3,
			Full    => brf_full,
			Empty   => brf_emp
		);
  -- Memory Pointer Process
  fifo_proc : process (clk)
    type FIFO_Memory is
      array (0 to FIFO_DEPTH - 1) of TST_TO;
    variable Memory : FIFO_Memory;
    
    variable Head : natural range 0 to FIFO_DEPTH - 1;
    variable Tail : natural range 0 to FIFO_DEPTH - 1;
    
    variable Looped : boolean;
    variable len: integer :=0;
    variable i: integer :=0;
    variable first: boolean := true;
    variable amount: integer :=0;
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
        while (i<32) loop
          if (((Looped = false) or (Head /= Tail))) and DataIn(i).val='1' then

            if (first=true) then
                Memory(Head) := (DataIn(i).val,DataIn(i).sender,DataIn(i).receiver,DataIn(i).cmd,DataIn(i).tag,DataIn(i).id,DataIn(i).adr,'1') ;
                first := false;
             else
                 Memory(Head) := (DataIn(i).val,DataIn(i).sender,DataIn(i).receiver,DataIn(i).cmd,DataIn(i).tag,DataIn(i).id,DataIn(i).adr,'0') ;
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
                      Full <= '1';
                      report "the fifo is too small, it is full!!!!!!!!!!!!";
                    else
                      DataOut.val<='0';
                    end if;
                  else
                    Full    <= '0';
                  end if;
       end loop;

          if ((Looped = true) or (Head /= Tail)) then
            -- Update data output
            DataOut <= Memory(Tail);
            amount := amount -1;
            -- Update Tail pointer as needed
            if (Tail = FIFO_DEPTH - 1) then
              Tail := 0;
              
              Looped := false;
            else
              Tail := Tail + 1;
            end if;
          end if;
     
      end if;
   end if;
  end process;
  
end rtl;
