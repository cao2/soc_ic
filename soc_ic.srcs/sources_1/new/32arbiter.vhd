library ieee;
use ieee.std_logic_1164.ALL;
--use iEEE.std_logic_unsigned.all ;
use ieee.numeric_std.ALL;
use work.defs.all;
use work.util.all;
Library UNISIM;
use UNISIM.vcomponents.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;
--  <-----Cut code below this line and paste into the architecture body---->

   -- FIFO_SYNC_MACRO: Synchronous First-In, First-Out (FIFO) RAM Buffer
   --                  Artix-7
   -- Xilinx HDL Language Template, version 2017.2

   -- Note -  This Unimacro model assumes the port directions to be "downto". 
   --         Simulation of this model with "to" in the port directions could lead to erroneous results.

   -----------------------------------------------------------------
   -- DATA_WIDTH | FIFO_SIZE | FIFO Depth | RDCOUNT/WRCOUNT Width --
   -- ===========|===========|============|=======================--
   --   37-72    |  "36Kb"   |     512    |         9-bit         --
   --   19-36    |  "36Kb"   |    1024    |        10-bit         --
   --   19-36    |  "18Kb"   |     512    |         9-bit         --
   --   10-18    |  "36Kb"   |    2048    |        11-bit         --
   --   10-18    |  "18Kb"   |    1024    |        10-bit         --
   --    5-9     |  "36Kb"   |    4096    |        12-bit         --
   --    5-9     |  "18Kb"   |    2048    |        11-bit         --
   --    1-4     |  "36Kb"   |    8192    |        13-bit         --
   --    1-4     |  "18Kb"   |    4096    |        12-bit         --
   -----------------------------------------------------------------


entity arbiter32 is
	Generic(
		constant FIFO_DEPTH : positive := 3
	);
	Port(
		CLK     : in  STD_LOGIC;
		RST     : in  STD_LOGIC;
		DataIn  : in  ALL_T;
		DataOut : out std_logic_vector(37 downto 0);
		Full    : out STD_LOGIC := '0'
	);
end arbiter32;

architecture rtl of arbiter32 is
	--signal td1: std_logic_vector(31 downto 0);
	--signal td2: std_logic_vector(31 downto 0);
	signal tts0, tts1, tts2, tts3, tts4, tts5, tts6, tts7, tts8, tts9, tts10, tts11, tts12, tts13, tts14, tts15, tts16, tts17, tts18, tts19, tts20, tts21, tts22, tts23, tts24, tts25, tts26, tts27, tts28, tts29, tts30, tts31                                 : std_logic_vector(36 downto 0);
	type tts_a is array (0 to 31) of std_logic_vector(36 downto 0);
	signal tts_array: tts_a;
	signal in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31                                                                 : std_logic_vector(36 downto 0);
	signal we0, we1, we2, we3, we4, we5, we6, we7, we8, we9, we10, we11, we12, we13, we14, we15, we16, we17, we18, we19, we20, we21, we22, we23, we24, we25, we26, we27, we28, we29, we30, we31                                                                 : std_logic;
	signal full0, full1, full2, full3, full4, full5, full6, full7, full8, full9, full10, full11, full12, full13, full14, full15, full16, full17, full18, full19, full20, full21, full22, full23, full24, full25, full26, full27, full28, full29, full30, full31 : std_logic;
	signal emp0, emp1, emp2, emp3, emp4, emp5, emp6, emp7, emp8, emp9, emp10, emp11, emp12, emp13, emp14, emp15, emp16, emp17, emp18, emp19, emp20, emp21, emp22, emp23, emp24, emp25, emp26, emp27, emp28, emp29, emp30, emp31                                 : std_logic;
	signal count                                                                                                                                                                                                                                                : integer := 0;
    signal en31,en30,en29,en28,en27,en26,en25,en24,en23,en22,en21,en20,en19,en18,en17,en16,en15,en14,en13,en12,en11,en10,en9,en8,en7,en6,en5,en4,en3,en2,en1,en0 : std_logic:='0';
--	signal layer1_1, layer1_2, layer1_3, layer1_4, layer1_5, layer1_6, layer1_7, layer1_8, layer1_9, layer1_10, layer1_11, layer1_12, layer1_13, layer1_14, layer1_15, layer1_16                                                                                : TST_TTS;
--	signal layer2_1, layer2_2, layer2_3, layer2_4, layer2_5, layer2_6, layer2_7, layer2_8: TST_TTS;
--	signal layer3_1, layer3_2, layer3_3, layer3_4 : TST_TTS;
--	signal layer4_1, layer4_2 : TST_TTS;
	constant DEPTH : positive := 16;
	signal ack                                                                                                                                                                                                                                                  : std_logic_vector(31 downto 0);
begin
    tts_map: process(clk)
    begin
        if rising_edge(clk) then
            tts_array(1) <= tts1;
        tts_array(2) <= tts2;
        tts_array(3) <= tts3;
        tts_array(4) <= tts4;
        tts_array(5) <= tts5;
        tts_array(6) <= tts6;
        tts_array(7) <= tts7;
        tts_array(8) <= tts8;
        tts_array(9) <= tts9;
        tts_array(10) <= tts10;
        tts_array(11) <= tts11;
        tts_array(12) <= tts12;
        tts_array(13) <= tts13;
        tts_array(14) <= tts14;
        tts_array(15) <= tts15;
        tts_array(16) <= tts16;
        tts_array(17) <= tts17;
        tts_array(18) <= tts18;
        tts_array(19) <= tts19;
        tts_array(20) <= tts20;
        tts_array(21) <= tts21;
        tts_array(22) <= tts22;
        tts_array(23) <= tts23;
        tts_array(24) <= tts24;
        tts_array(25) <= tts25;
        tts_array(26) <= tts26;
        tts_array(27) <= tts27;
        tts_array(28) <= tts28;
        tts_array(29) <= tts29;
        tts_array(30) <= tts30;
        tts_array(31) <= tts31;

            
        end if;
    end process;
    fifo_proc : process(clk, rst)
   -- type ram_t is array (0 to FIFO_DEPTH - 1) of ALL_T;
   -- variable Memory   : ram_t;
    variable num_val  : natural range 0 to 31;
    type val_c is array (0 to 31) of natural range 0 to 31;
    variable val_chan : val_c;
    variable Head     : natural range 0 to FIFO_DEPTH - 1;
    variable Tail     : natural range 0 to FIFO_DEPTH - 1;

    variable Looped       : boolean;
    variable len          : integer := 0;
    --variable i            : integer := 0;
    --variable first        : boolean := true;
    ---variable tmp_all_read : ALL_T;
    --variable amount       : integer := 0;
   -- variable tmp_all      : ALL_T;
    variable st           : natural range 0 to 31 := 0;
    variable valid        : boolean := false;
begin
    if rising_edge(CLK) then
        if RST = '1' then
            Head        := 0;
            Tail        := 0;
            Looped      := false;
            Full        <= '0';
            --        Empty <= '1';
            DataOut<=(others=>'0');
        else
            ----now need to calculate number of valid
            if (DataIn(0).val = '1') then
                valid             := true;
                val_chan(num_val) := 0;
                num_val           := num_val + 1;
            end if;
            if (DataIn(1).val = '1') then
                valid             := true;
                val_chan(num_val) := 1;
                num_val           := num_val + 1;
            end if;
            if (DataIn(2).val = '1') then
                valid             := true;
                val_chan(num_val) := 2;
                num_val           := num_val + 1;
            end if;
            if (DataIn(3).val = '1') then
                valid             := true;
                val_chan(num_val) := 3;
                num_val           := num_val + 1;
            end if;
            if (DataIn(4).val = '1') then
                valid             := true;
                val_chan(num_val) := 4;
                num_val           := num_val + 1;
            end if;
            if (DataIn(5).val = '1') then
                valid             := true;
                val_chan(num_val) := 5;
                num_val           := num_val + 1;
            end if;
            if (DataIn(6).val = '1') then
                valid             := true;
                val_chan(num_val) := 6;
                num_val           := num_val + 1;
            end if;
            if (DataIn(7).val = '1') then
                valid             := true;
                val_chan(num_val) := 7;
                num_val           := num_val + 1;
            end if;
            if (DataIn(8).val = '1') then
                valid             := true;
                val_chan(num_val) := 8;
                num_val           := num_val + 1;
            end if;
            if (DataIn(9).val = '1') then
                valid             := true;
                val_chan(num_val) := 9;
                num_val           := num_val + 1;
            end if;
            if (DataIn(10).val = '1') then
                valid             := true;
                val_chan(num_val) := 10;
                num_val           := num_val + 1;
            end if;
            if (DataIn(11).val = '1') then
                valid             := true;
                val_chan(num_val) := 11;
                num_val           := num_val + 1;
            end if;
            if (DataIn(12).val = '1') then
                valid             := true;
                val_chan(num_val) := 12;
                num_val           := num_val + 1;
            end if;
            if (DataIn(13).val = '1') then
                valid             := true;
                val_chan(num_val) := 13;
                num_val           := num_val + 1;
            end if;
            if (DataIn(14).val = '1') then
                valid             := true;
                val_chan(num_val) := 14;
                num_val           := num_val + 1;
            end if;
            if (DataIn(15).val = '1') then
                valid             := true;
                val_chan(num_val) := 15;
                num_val           := num_val + 1;
            end if;
            if (DataIn(16).val = '1') then
                valid             := true;
                val_chan(num_val) := 16;
                num_val           := num_val + 1;
            end if;
            if (DataIn(17).val = '1') then
                valid             := true;
                val_chan(num_val) := 17;
                num_val           := num_val + 1;
            end if;
            if (DataIn(18).val = '1') then
                valid             := true;
                val_chan(num_val) := 18;
                num_val           := num_val + 1;
            end if;
            if (DataIn(19).val = '1') then
                valid             := true;
                val_chan(num_val) := 19;
                num_val           := num_val + 1;
            end if;
            if (DataIn(20).val = '1') then
                valid             := true;
                val_chan(num_val) := 20;
                num_val           := num_val + 1;
            end if;
            if (DataIn(21).val = '1') then
                valid             := true;
                val_chan(num_val) := 21;
                num_val           := num_val + 1;
            end if;
            if (DataIn(22).val = '1') then
                valid             := true;
                val_chan(num_val) := 22;
                num_val           := num_val + 1;
            end if;
            if (DataIn(23).val = '1') then
                valid             := true;
                val_chan(num_val) := 23;
                num_val           := num_val + 1;
            end if;
            if (DataIn(24).val = '1') then
                valid             := true;
                val_chan(num_val) := 24;
                num_val           := num_val + 1;
            end if;
            if (DataIn(25).val = '1') then
                valid             := true;
                val_chan(num_val) := 25;
                num_val           := num_val + 1;
            end if;
            if (DataIn(26).val = '1') then
                valid             := true;
                val_chan(num_val) := 26;
                num_val           := num_val + 1;
            end if;
            if (DataIn(27).val = '1') then
                valid             := true;
                val_chan(num_val) := 27;
                num_val           := num_val + 1;
            end if;
            if (DataIn(28).val = '1') then
                valid             := true;
                val_chan(num_val) := 28;
                num_val           := num_val + 1;
            end if;
            if (DataIn(29).val = '1') then
                valid             := true;
                val_chan(num_val) := 29;
                num_val           := num_val + 1;
            end if;
            if (DataIn(30).val = '1') then
                valid             := true;
                val_chan(num_val) := 30;
                num_val           := num_val + 1;
            end if;
            if (DataIn(31).val = '1') then
                valid             := true;
                val_chan(num_val) := 31;
                num_val           := num_val + 1;
            end if;
            ack<=(others=>'0');
            if (valid = true) then
            if (st = 0) then
                    DataOut<= tts_array(val_chan(0))&'1';
                    ---now the first data is out, check if it reaches the size
                    if st + 1 < num_val then
                        st := st + 1;
                    end if;
                end if;
           elsif (st = 1) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(1))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 2) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(2))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 3) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(3))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 4) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(4))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 5) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(5))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 6) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(6))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 7) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(7))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 8) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(8))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 9) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(9))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 10) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(10))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 11) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(11))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 12) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(12))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 13) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(13))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 14) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(14))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 15) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(15))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 16) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(16))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 17) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(17))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 18) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(18))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 19) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(19))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 20) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(20))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 21) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(21))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 22) then
                 if tts_array(val_chan(st))(36 downto 36)="0" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(22))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 23) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(23))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 24) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(24))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 25) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(25))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 26) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(26))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 27) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(27))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 28) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(28))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 29) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(29))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 30) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(30))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;
                elsif (st = 31) then
                 if tts_array(val_chan(st))(36 downto 36)="1" then
                   DataOut <=tts_array(val_chan(st))&'0';
                  ack(val_chan(31))<='1';
                  if st+1<num_val then
                   st:=st+1;
                  else
                   st:=0;
                  end if;
                 end if;



            end if;
        end if;
    end if;
end process;
    
    
   FIFO_SYNC_MACRO_inst : FIFO_SYNC_MACRO
   generic map (
      DEVICE => "7SERIES",            -- Target Device: "VIRTEX5, "VIRTEX6", "7SERIES" 
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => 37,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "36Kb")            -- Target BRAM, "18Kb" or "36Kb" 
   port map (
     -- ALMOSTEMPTY => ,   -- 1-bit output almost empty
      --ALMOSTFULL => ALMOSTFULL,     -- 1-bit output almost full
      DO => in0,                     -- Output data, width defined by DATA_WIDTH parameter
      EMPTY => emp0,               -- 1-bit output empty
      FULL => full0,                 -- 1-bit output full
    --  RDCOUNT => RDCOUNT,           -- Output read count, width determined by FIFO depth
    --  RDERR => RDERR,               -- 1-bit output read error
    --  WRCOUNT => WRCOUNT,           -- Output write count, width determined by FIFO depth
     -- WRERR => WRERR,               -- 1-bit output write error
      CLK => CLK,                   -- 1-bit input clock
      DI => tts0,                     -- Input data, width defined by DATA_WIDTH parameter
      RDEN => en0,                 -- 1-bit input read enable
      RST => RST,                   -- 1-bit input reset
      WREN => we0                  -- 1-bit input write enable
   );
    

	fifo0_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we0 <= '0';
			elsif DataIn(0).val = '1' then -- if req is valid
				in0 <= slv(DataIn(0));
				we0 <= '1';
			else
				we0 <= '0';
			end if;
		end if;
	end process;

	
	fifo1_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we1 <= '0';
			elsif DataIn(1).val = '1' then -- if req is valid
				in1 <= DataIn(1);
				we1 <= '1';
			else
				we1 <= '0';
			end if;
		end if;
	end process;

	fifo2 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(2),
			RST     => RST,
			DataIn  => in2,
			WriteEn => we2,
			ReadEn  => '1',
			DataOut => tts2,
			Full    => full2,
			Empty   => emp2
		);

	fifo2_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we2 <= '0';
			elsif DataIn(2).val = '1' then -- if req is valid
				in2 <= DataIn(2);
				we2 <= '1';
			else
				we2 <= '0';
			end if;
		end if;
	end process;

	fifo3 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(3),
			RST     => RST,
			DataIn  => in3,
			WriteEn => we3,
			ReadEn  => '1',
			DataOut => tts3,
			Full    => full3,
			Empty   => emp3
		);
	fifo3_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we3 <= '0';
			elsif DataIn(3).val = '1' then -- if req is valid
				in3 <= DataIn(3);
				we3 <= '1';
			else
				we3 <= '0';
			end if;
		end if;
	end process;

	fifo4 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(4),
			RST     => RST,
			DataIn  => in4,
			WriteEn => we4,
			ReadEn  => '1',
			DataOut => tts4,
			Full    => full4,
			Empty   => emp4
		);
	fifo4_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we4 <= '0';
			elsif DataIn(4).val = '1' then -- if req is valid
				in4 <= DataIn(4);
				we4 <= '1';
			else
				we4 <= '0';
			end if;
		end if;
	end process;

	fifo5 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(5),
			RST     => RST,
			DataIn  => in5,
			WriteEn => we5,
			ReadEn  => '1',
			DataOut => tts5,
			Full    => full5,
			Empty   => emp5
		);
	fifo5_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we5 <= '0';
			elsif DataIn(5).val = '1' then -- if req is valid
				in5 <= DataIn(5);
				we5 <= '1';
			else
				we5 <= '0';
			end if;
		end if;
	end process;

	fifo6 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(6),
			RST     => RST,
			DataIn  => in6,
			WriteEn => we6,
			ReadEn  => '1',
			DataOut => tts6,
			Full    => full6,
			Empty   => emp6
		);
	fifo6_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we6 <= '0';
			elsif DataIn(6).val = '1' then -- if req is valid
				in6 <= DataIn(6);
				we6 <= '1';
			else
				we6 <= '0';
			end if;
		end if;
	end process;

	fifo7 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(7),
			RST     => RST,
			DataIn  => in7,
			WriteEn => we7,
			ReadEn  => '1',
			DataOut => tts7,
			Full    => full7,
			Empty   => emp7
		);
	fifo7_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we7 <= '0';
			elsif DataIn(7).val = '1' then -- if req is valid
				in7 <= DataIn(7);
				we7 <= '1';
			else
				we7 <= '0';
			end if;
		end if;
	end process;

	fifo8 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(8),
			RST     => RST,
			DataIn  => in8,
			WriteEn => we8,
			ReadEn  => '1',
			DataOut => tts8,
			Full    => full8,
			Empty   => emp8
		);
	fifo8_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we8 <= '0';
			elsif DataIn(8).val = '1' then -- if req is valid
				in8 <= DataIn(8);
				we8 <= '1';
			else
				we8 <= '0';
			end if;
		end if;
	end process;

	fifo9 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(9),
			RST     => RST,
			DataIn  => in9,
			WriteEn => we9,
			ReadEn  => '1',
			DataOut => tts9,
			Full    => full9,
			Empty   => emp9
		);
	fifo9_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we9 <= '0';
			elsif DataIn(9).val = '1' then -- if req is valid
				in9 <= DataIn(9);
				we9 <= '1';
			else
				we9 <= '0';
			end if;
		end if;
	end process;

	fifo10 : entity work.fifo_ack(rtl)  -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(10),
			RST     => RST,
			DataIn  => in10,
			WriteEn => we10,
			ReadEn  => '1',
			DataOut => tts10,
			Full    => full10,
			Empty   => emp10
		);
	fifo10_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we10 <= '0';
			elsif DataIn(10).val = '1' then -- if req is valid
				in10 <= DataIn(10);
				we10 <= '1';
			else
				we10 <= '0';
			end if;
		end if;
	end process;

	fifo11 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			fifo_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(11),
			RST     => RST,
			DataIn => in11,
			WriteEn => we11,
			ReadEn  => '1',
			DataOut => tts11,
			full   => full11,
			empty  => emp11
		);
	fifo11_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we11 <= '0';
			elsif DataIn(11).val = '1' then -- if req is valid
				in11 <= DataIn(11);
				we11 <= '1';
			else
				we11 <= '0';
			end if;
		end if;
	end process;

	fifo12 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(12),
			RST     => RST,
			DataIn => in12,
			WriteEn => we12,
			ReadEn  => '1',
			DataOut => tts12,
			full => full12,
			empty  => emp12
		);
	fifo12_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we12 <= '0';
			elsif DataIn(12).val = '1' then -- if req is valid
				in12 <= DataIn(12);
				we12 <= '1';
			else
				we12 <= '0';
			end if;
		end if;
	end process;

	fifo13 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(13),
			RST     => RST,
			DataIn => in13,
			WriteEn => we13,
			ReadEn  => '1',
			DataOut => tts13,
			full => full13,
			empty  => emp13
		);
	fifo13_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we13 <= '0';
			elsif DataIn(13).val = '1' then -- if req is valid
				in13 <=DataIn(13);
				we13 <= '1';
			else
				we13 <= '0';
			end if;
		end if;
	end process;

	fifo14 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(14),
			RST     => RST,
			DataIn => in14,
			WriteEn => we14,
			ReadEn  => '1',
			DataOut => tts14,
			full => full14,
			empty  => emp14
		);
	fifo14_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we14 <= '0';
			elsif DataIn(14).val = '1' then -- if req is valid
				in14 <= DataIn(14);
				we14 <= '1';
			else
				we14 <= '0';
			end if;
		end if;
	end process;

	fifo15 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(15),
			RST     => RST,
			DataIn => in15,
			WriteEn => we15,
			ReadEn  => '1',
			DataOut => tts15,
			full => full15,
			empty  => emp15
		);
	fifo15_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we15 <= '0';
			elsif DataIn(15).val = '1' then -- if req is valid
				in15 <= DataIn(15);
				we15 <= '1';
			else
				we15 <= '0';
			end if;
		end if;
	end process;

	fifo16 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(16),
			RST     => RST,
			DataIn => in16,
			WriteEn => we16,
			ReadEn  => '1',
			DataOut => tts16,
			full => full16,
			empty  => emp16
		);
	fifo16_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we16 <= '0';
			elsif DataIn(16).val = '1' then -- if req is valid
				in16 <= DataIn(16);
				we16 <= '1';
			else
				we16 <= '0';
			end if;
		end if;
	end process;

	fifo17 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(17),
			RST     => RST,
			DataIn => in17,
			WriteEn => we17,
			ReadEn  => '1',
			DataOut => tts17,
			full => full17,
			empty  => emp17
		);
	fifo17_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we17 <= '0';
			elsif DataIn(17).val = '1' then -- if req is valid
				in17 <= DataIn(17);
				we17 <= '1';
			else
				we17 <= '0';
			end if;
		end if;
	end process;

	fifo18 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(18),
			RST     => RST,
			DataIn => in18,
			WriteEn => we18,
			ReadEn  => '1',
			DataOut => tts18,
			full => full18,
			empty  => emp18
		);
	fifo18_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we18 <= '0';
			elsif DataIn(18).val = '1' then -- if req is valid
				in18 <= DataIn(18);
				we18 <= '1';
			else
				we18 <= '0';
			end if;
		end if;
	end process;

	fifo19 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(19),
			RST     => RST,
			DataIn => in19,
			WriteEn => we19,
			ReadEn  => '1',
			DataOut => tts19,
			full => full19,
			empty  => emp19
		);
	fifo19_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we19 <= '0';
			elsif DataIn(19).val = '1' then -- if req is valid
				in19 <= DataIn(19);
				we19 <= '1';
			else
				we19 <= '0';
			end if;
		end if;
	end process;

	fifo20 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(20),
			RST     => RST,
			DataIn => in20,
			WriteEn => we20,
			ReadEn  => '1',
			DataOut => tts20,
			full => full20,
			empty  => emp20
		);
	fifo20_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we20 <= '0';
			elsif DataIn(20).val = '1' then -- if req is valid
				in20 <= DataIn(20);
				we20 <= '1';
			else
				we20 <= '0';
			end if;
		end if;
	end process;

	fifo21 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(21),
			RST     => RST,
			DataIn => in21,
			WriteEn => we21,
			ReadEn  => '1',
			DataOut => tts21,
			full => full21,
			empty  => emp21
		);
	fifo21_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we21 <= '0';
			elsif DataIn(21).val = '1' then -- if req is valid
				in21 <= DataIn(21);
				we21 <= '1';
			else
				we21 <= '0';
			end if;
		end if;
	end process;

	fifo22 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(22),
			RST     => RST,
			DataIn => in22,
			WriteEn => we22,
			ReadEn  => '1',
			DataOut => tts22,
			full => full22,
			empty  => emp22
		);
	fifo22_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we22 <= '0';
			elsif DataIn(22).val = '1' then -- if req is valid
				in22 <= DataIn(22);
				we22 <= '1';
			else
				we22 <= '0';
			end if;
		end if;
	end process;

	fifo23 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(23),
			RST     => RST,
			DataIn => in23,
			WriteEn => we23,
			ReadEn  => '1',
			DataOut => tts23,
			full => full23,
			empty  => emp23
		);
	fifo23_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we23 <= '0';
			elsif DataIn(23).val = '1' then -- if req is valid
				in23 <= DataIn(23);
				we23 <= '1';
			else
				we23 <= '0';
			end if;
		end if;
	end process;

	fifo24 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(24),
			RST     => RST,
			DataIn => in24,
			WriteEn => we24,
			ReadEn  => '1',
			DataOut => tts24,
			full => full24,
			empty  => emp24
		);
	fifo24_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we24 <= '0';
			elsif DataIn(24).val = '1' then -- if req is valid
				in24 <= DataIn(24);
				we24 <= '1';
			else
				we24 <= '0';
			end if;
		end if;
	end process;

	fifo25 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(25),
			RST     => RST,
			DataIn => in25,
			WriteEn => we25,
			ReadEn  => '1',
			DataOut => tts25,
			full => full25,
			empty  => emp25
		);
	fifo25_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we25 <= '0';
			elsif DataIn(25).val = '1' then -- if req is valid
				in25 <= DataIn(25);
				we25 <= '1';
			else
				we25 <= '0';
			end if;
		end if;
	end process;

	fifo26 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(26),
			RST     => RST,
			DataIn => in26,
			WriteEn => we26,
			ReadEn  => '1',
			DataOut => tts26,
			full => full26,
			empty  => emp26
		);
	fifo26_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we26 <= '0';
			elsif DataIn(26).val = '1' then -- if req is valid
				in26 <= DataIn(26);
				we26 <= '1';
			else
				we26 <= '0';
			end if;
		end if;
	end process;

	fifo27 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(27),
			RST     => RST,
			DataIn => in27,
			WriteEn => we27,
			ReadEn  => '1',
			DataOut => tts27,
			full => full27,
			empty  => emp27
		);
	fifo27_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we27 <= '0';
			elsif DataIn(27).val = '1' then -- if req is valid
				in27 <= DataIn(27);
				we27 <= '1';
			else
				we27 <= '0';
			end if;
		end if;
	end process;

	fifo28 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(28),
			RST     => RST,
			DataIn => in28,
			WriteEn => we28,
			ReadEn  => '1',
			DataOut => tts28,
			full => full28,
			empty  => emp28
		);
	fifo28_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we28 <= '0';
			elsif DataIn(28).val = '1' then -- if req is valid
				in28 <= DataIn(28);
				we28 <= '1';
			else
				we28 <= '0';
			end if;
		end if;
	end process;

	fifo29 : entity work.fifo_ack(rtl)     -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(29),
			RST     => RST,
			DataIn => in29,
			WriteEn => we29,
			ReadEn  => '1',
			DataOut => tts29,
			full => full29,
			empty  => emp29
		);
	fifo29_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we29 <= '0';
			elsif DataIn(29).val = '1' then -- if req is valid
				in29 <= DataIn(29);
				we29 <= '1';
			else
				we29 <= '0';
			end if;
		end if;
	end process;

	fifo30 : entity work.fifo_ack(rtl)  -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(30),
			RST     => RST,
			DataIn  => in30,
			WriteEn => we30,
			ReadEn  => '1',
			DataOut => tts30,
			Full    => full30,
			Empty   => emp30
		);
	fifo30_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we30 <= '0';
			elsif DataIn(30).val = '1' then -- if req is valid
				in30 <= DataIn(30);
				we30 <= '1';
			else
				we30 <= '0';
			end if;
		end if;
	end process;

	fifo31 : entity work.fifo_ack(rtl)  -- req from device
		generic map(
			FIFO_DEPTH => DEPTH
		)
		port map(
			CLK     => CLK, ack => ack(31),
			RST     => RST,
			DataIn  => in31,
			WriteEn => we31,
			ReadEn  => '1',
			DataOut => tts31,
			Full    => full31,
			Empty   => emp31
		);
	fifo31_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we31 <= '0';
			elsif DataIn(31).val = '1' then -- if req is valid
				in31 <= DataIn(31);
				we31 <= '1';
			else
				we31 <= '0';
			end if;
		end if;
	end process;

	
end rtl;
