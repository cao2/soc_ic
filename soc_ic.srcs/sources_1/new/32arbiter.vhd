library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.defs.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.defs.all;

entity arbiter_2layer is
	Port(
		clock : in  std_logic;
		reset : in  std_logic;
		din1  : in  TST_TTS;
		din2  : in  TST_TTS;
		dout  : out TST_TO
	);
end arbiter_2layer;

-- version 2
architecture rtl of arbiter_2layer is
begin
	process(clock)
		variable st : STATE := one;
	begin
		if reset = '1' then
			dout.val <= '0';
		elsif rising_edge(clock) then
			if din1.val = '1' and din2.val = '0' then
				dout <= din1;
			elsif din2.val = '1' and din1.val = '0' then
				dout <= din2;
			elsif din1.val = '1' and din2.val = '1' then
				if din1.tim < din2.tim then
					dout <= din1;
				else
					dout <= din2;
				end if;
			else
				dout.val <= '0';
			end if;

		end if;
	end process;
end architecture rtl;

entity arbiter32 is
	Generic(
		constant FIFO_DEPTH : positive := 8
	);
	Port(
		CLK     : in  STD_LOGIC;
		RST     : in  STD_LOGIC;
		DataIn  : in  ALL_T;
		DataOut : out TST_TO;
		Full    : out STD_LOGIC := '0'
	);
end arbiter32;

architecture rtl of arbiter32 is
	--signal td1: std_logic_vector(31 downto 0);
	--signal td2: std_logic_vector(31 downto 0);
	signal tts0, tts1, tts2, tts3, tts4, tts5, tts6, tts7, tts8, tts9, tts10, tts11, tts12, tts13, tts14, tts15, tts16, tts17, tts18, tts19, tts20, tts21, tts22, tts23, tts24, tts25, tts26, tts27, tts28, tts29, tts30, tts31                                 : TST_TTS;
	signal in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31                                                                 : TST_in;
	signal we0, we1, we2, we3, we4, we5, we6, we7, we8, we9, we10, we11, we12, we13, we14, we15, we16, we17, we18, we19, we20, we21, we22, we23, we24, we25, we26, we27, we28, we29, we30, we31                                                                 : std_logic;
	signal full0, full1, full2, full3, full4, full5, full6, full7, full8, full9, full10, full11, full12, full13, full14, full15, full16, full17, full18, full19, full20, full21, full22, full23, full24, full25, full26, full27, full28, full29, full30, full31 : std_logic;
	signal emp0, emp1, emp2, emp3, emp4, emp5, emp6, emp7, emp8, emp9, emp10, emp11, emp12, emp13, emp14, emp15, emp16, emp17, emp18, emp19, emp20, emp21, emp22, emp23, emp24, emp25, emp26, emp27, emp28, emp29, emp30, emp31                                 : std_logic;
	signal count                                                                                                                                                                                                                                                : integer := 0;
	signal layer1_1, layer1_2, layer1_3, layer1_4, layer1_5, layer1_6, layer1_7, layer1_8, layer1_9, layer1_10, layer1_11, layer1_12, layer1_13, layer1_14, layer1_15, layer1_16                                                                                : TST_TTS;
	signal ack                                                                                                                                                                                                                                                  : std_logic_vector(31 downto 0);
begin

	arb0 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts0,
			din2  => tts1,
			dout  => layer1_1
		);
	arb1 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts2,
			din2  => tts3,
			dout  => layer1_2
		);
	arb2 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts4,
			din2  => tts5,
			dout  => layer1_3
		);
	arb3 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts6,
			din2  => tts7,
			dout  => layer1_4
		);
	arb4 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts8,
			din2  => tts9,
			dout  => layer1_5
		);
	arb5 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts10,
			din2  => tts11,
			dout  => layer1_6
		);
	arb6 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts12,
			din2  => tts13,
			dout  => layer1_7
		);
	arb7 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts14,
			din2  => tts15,
			dout  => layer1_8
		);
	arb8 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts16,
			din2  => tts17,
			dout  => layer1_9
		);
	arb9 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts18,
			din2  => tts19,
			dout  => layer1_10
		);
	arb10 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts20,
			din2  => tts21,
			dout  => layer1_11
		);
	arb11 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts22,
			din2  => tts23,
			dout  => layer1_12
		);
	arb12 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts24,
			din2  => tts25,
			dout  => layer1_13
		);
	arb13 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts26,
			din2  => tts27,
			dout  => layer1_14
		);
	arb14 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts28,
			din2  => tts29,
			dout  => layer1_15
		);
	arb15 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => tts30,
			din2  => tts31,
			dout  => layer1_16
		);

	---second layer
	arb16 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer1_1,
			din2  => layer1_2,
			dout  => layer2_1
		);
	arb17 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer1_3,
			din2  => layer1_4,
			dout  => layer2_2
		);
	arb18 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer1_5,
			din2  => layer1_6,
			dout  => layer2_3
		);
	arb19 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer1_7,
			din2  => layer1_8,
			dout  => layer2_4
		);
	arb20 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer1_9,
			din2  => layer1_10,
			dout  => layer2_5
		);
	arb21 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer1_11,
			din2  => layer1_12,
			dout  => layer2_6
		);
	arb22 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer1_13,
			din2  => layer1_14,
			dout  => layer2_7
		);
	arb23 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer1_15,
			din2  => layer1_16,
			dout  => layer2_8
		);
	---third layer
	arb24 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer2_1,
			din2  => layer2_2,
			dout  => layer3_1
		);
	arb25 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer2_3,
			din2  => layer2_4,
			dout  => layer3_2
		);
	arb26 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer2_5,
			din2  => layer2_6,
			dout  => layer3_3
		);
	arb27 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer2_7,
			din2  => layer2_8,
			dout  => layer3_4
		);
	--fourth layer
	arb28 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer3_1,
			din2  => layer3_2,
			dout  => layer4_1
		);
	arb29 : entity work.arbiter_2layer(rtl)
		port map(
			clock => CLK,
			reset => RST,
			din1  => layer3_3,
			din2  => layer3_4,
			dout  => layer4_2
		);
	final_arb : process(clock)
		variable old_tim : interger := 0;
	begin
		if rising_edge(clock) then
			
			if layer4_1.val = '1' and layer4_2.val = '0' then
				if layer4_1.tim = old_time then
					DataOut <= (layer4_1.val, layer4_1.sender, layer4_1.receiver, layer4_1.cmd, layer4_1.tag, layer4_1.id, layer4_1.adr, '0');
				else
					DataOut <= (layer4_1.val, layer4_1.sender, layer4_1.receiver, layer4_1.cmd, layer4_1.tag, layer4_1.id, layer4_1.adr, '1');
				end if;
				ack(layer4_1.channel)<='1';
			elsif layer4_1.val = '0' and layer4_2.val = '1' then
				if layer4_2.tim = old_time then
					DataOut <= (layer4_2.val, layer4_2.sender, layer4_2.receiver, layer4_2.cmd, layer4_2.tag, layer4_2.id, layer4_2.adr, '0');
				else
					DataOut <= (layer4_2.val, layer4_2.sender, layer4_2.receiver, layer4_2.cmd, layer4_2.tag, layer4_2.id, layer4_2.adr, '1');
				end if;
				ack(layer4_2.channel)<='1';
			elsif layer4_1.val = '1' and layer4_2.val = '1' then
				if layer4_1.tim < layer4_2.tim then
					if layer4_1.tim = old_time then
						DataOut <= (layer4_1.val, layer4_1.sender, layer4_1.receiver, layer4_1.cmd, layer4_1.tag, layer4_1.id, layer4_1.adr, '0');
					else
						DataOut <= (layer4_1.val, layer4_1.sender, layer4_1.receiver, layer4_1.cmd, layer4_1.tag, layer4_1.id, layer4_1.adr, '1');
					end if;
					ack(layer4_1.channel)<='1';
				else
					if layer4_2.tim = old_time then
						DataOut <= (layer4_2.val, layer4_2.sender, layer4_2.receiver, layer4_2.cmd, layer4_2.tag, layer4_2.id, layer4_2.adr, '0');
					else
						DataOut <= (layer4_2.val, layer4_2.sender, layer4_2.receiver, layer4_2.cmd, layer4_2.tag, layer4_2.id, layer4_2.adr, '1');
					end if;
					ack(layer4_2.channel)<='1';
				end if;
			else
				DataOut.val<='0';
				ack<=(others=>'0');
			end if;
		end if;
	end process;
	count_p : process(clock)
	begin
		if rising_edge(clock) then
			count <= count + 1;
		end if;

	end process;
	fifo0 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(0),
			RST     => RST,
			DataIn  => in0,
			WriteEn => we0,
			ReadEn  => '1',
			DataOut => tts0,
			Full    => full0,
			Empty   => emp0
		);
	fifo0_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we0 <= '0';
			elsif DataIn(0).val = '1' then -- if req is valid
				in0 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 0
				       );
				we0 <= '1';
			else
				we0 <= '0';
			end if;
		end if;
	end process;

	fifo1 : entity work.fifo_ack(rtl)   -- req from device
		generic map(
			FIFO_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(1),
			RST     => RST,
			DataIn  => in1,
			WriteEn => we1,
			ReadEn  => '1',
			DataOut => tts1,
			Full    => full1,
			Empty   => emp1
		);
	fifo1_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we1 <= '0';
			elsif DataIn(1).val = '1' then -- if req is valid
				in1 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 1
				       );
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

	fifo2_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we2 <= '0';
			elsif DataIn(2).val = '1' then -- if req is valid
				in2 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 2
				       );
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
	fifo3_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we3 <= '0';
			elsif DataIn(3).val = '1' then -- if req is valid
				in3 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 3
				       );
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
	fifo4_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we4 <= '0';
			elsif DataIn(4).val = '1' then -- if req is valid
				in4 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 4
				       );
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
	fifo5_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we5 <= '0';
			elsif DataIn(5).val = '1' then -- if req is valid
				in5 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 5
				       );
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
	fifo6_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we6 <= '0';
			elsif DataIn(6).val = '1' then -- if req is valid
				in6 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 6
				       );
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
	fifo7_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we7 <= '0';
			elsif DataIn(7).val = '1' then -- if req is valid
				in7 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 7
				       );
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
	fifo8_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we8 <= '0';
			elsif DataIn(8).val = '1' then -- if req is valid
				in8 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 8
				       );
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
	fifo9_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we9 <= '0';
			elsif DataIn(9).val = '1' then -- if req is valid
				in9 <= (DataIn(i).val, DataIn(i).sender,
				        DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 9
				       );
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
	fifo10_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we10 <= '0';
			elsif DataIn(10).val = '1' then -- if req is valid
				in10 <= (DataIn(i).val, DataIn(i).sender,
				         DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 10
				        );
				we10 <= '1';
			else
				we10 <= '0';
			end if;
		end if;
	end process;

	fifo11 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(11),
			RST     => RST,
			Datain1 => in11,
			WriteEn => we11,
			ReadEn  => '1',
			DataOut => tts11,
			full1   => full11,
			emp1ty  => emp11
		);
	fifo11_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we11 <= '0';
			elsif Datain1(1).val = '1' then -- if req is valid
				in11 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 11
				        );
				we11 <= '1';
			else
				we11 <= '0';
			end if;
		end if;
	end process;

	fifo12 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(12),
			RST     => RST,
			Datain1 => in12,
			WriteEn => we12,
			ReadEn  => '1',
			DataOut => tts12,
			full1   => full12,
			emp1ty  => emp12
		);
	fifo12_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we12 <= '0';
			elsif Datain1(2).val = '1' then -- if req is valid
				in12 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 12
				        );
				we12 <= '1';
			else
				we12 <= '0';
			end if;
		end if;
	end process;

	fifo13 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(13),
			RST     => RST,
			Datain1 => in13,
			WriteEn => we13,
			ReadEn  => '1',
			DataOut => tts13,
			full1   => full13,
			emp1ty  => emp13
		);
	fifo13_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we13 <= '0';
			elsif Datain1(3).val = '1' then -- if req is valid
				in13 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 13
				        );
				we13 <= '1';
			else
				we13 <= '0';
			end if;
		end if;
	end process;

	fifo14 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(14),
			RST     => RST,
			Datain1 => in14,
			WriteEn => we14,
			ReadEn  => '1',
			DataOut => tts14,
			full1   => full14,
			emp1ty  => emp14
		);
	fifo14_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we14 <= '0';
			elsif Datain1(4).val = '1' then -- if req is valid
				in14 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 14
				        );
				we14 <= '1';
			else
				we14 <= '0';
			end if;
		end if;
	end process;

	fifo15 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(15),
			RST     => RST,
			Datain1 => in15,
			WriteEn => we15,
			ReadEn  => '1',
			DataOut => tts15,
			full1   => full15,
			emp1ty  => emp15
		);
	fifo15_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we15 <= '0';
			elsif Datain1(5).val = '1' then -- if req is valid
				in15 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 15
				        );
				we15 <= '1';
			else
				we15 <= '0';
			end if;
		end if;
	end process;

	fifo16 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(16),
			RST     => RST,
			Datain1 => in16,
			WriteEn => we16,
			ReadEn  => '1',
			DataOut => tts16,
			full1   => full16,
			emp1ty  => emp16
		);
	fifo16_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we16 <= '0';
			elsif Datain1(6).val = '1' then -- if req is valid
				in16 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 16
				        );
				we16 <= '1';
			else
				we16 <= '0';
			end if;
		end if;
	end process;

	fifo17 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(17),
			RST     => RST,
			Datain1 => in17,
			WriteEn => we17,
			ReadEn  => '1',
			DataOut => tts17,
			full1   => full17,
			emp1ty  => emp17
		);
	fifo17_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we17 <= '0';
			elsif Datain1(7).val = '1' then -- if req is valid
				in17 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 17
				        );
				we17 <= '1';
			else
				we17 <= '0';
			end if;
		end if;
	end process;

	fifo18 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(18),
			RST     => RST,
			Datain1 => in18,
			WriteEn => we18,
			ReadEn  => '1',
			DataOut => tts18,
			full1   => full18,
			emp1ty  => emp18
		);
	fifo18_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we18 <= '0';
			elsif Datain1(8).val = '1' then -- if req is valid
				in18 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 18
				        );
				we18 <= '1';
			else
				we18 <= '0';
			end if;
		end if;
	end process;

	fifo19 : entity work.fifo1(rtl)     -- req from device
		generic map(
			fifo1_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(19),
			RST     => RST,
			Datain1 => in19,
			WriteEn => we19,
			ReadEn  => '1',
			DataOut => tts19,
			full1   => full19,
			emp1ty  => emp19
		);
	fifo19_p : process(clock)
	begin
		if risin1g_edge(clock) then
			if reset = '1' then
				we19 <= '0';
			elsif Datain1(9).val = '1' then -- if req is valid
				in19 <= (Datain1(i).val, Datain1(i).sender,
				         Datain1(i).receiver, Datain1(i).cmd, Datain1(i).tag, Datain1(i).id, Datain1(i).adr, count, 19
				        );
				we19 <= '1';
			else
				we19 <= '0';
			end if;
		end if;
	end process;

	fifo20 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(20),
			RST     => RST,
			Datain2 => in20,
			WriteEn => we20,
			ReadEn  => '1',
			DataOut => tts20,
			full2   => full20,
			emp2ty  => emp20
		);
	fifo20_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we20 <= '0';
			elsif Datain2(0).val = '1' then -- if req is valid
				in20 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 20
				        );
				we20 <= '1';
			else
				we20 <= '0';
			end if;
		end if;
	end process;

	fifo21 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(21),
			RST     => RST,
			Datain2 => in21,
			WriteEn => we21,
			ReadEn  => '1',
			DataOut => tts21,
			full2   => full21,
			emp2ty  => emp21
		);
	fifo21_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we21 <= '0';
			elsif Datain2(1).val = '1' then -- if req is valid
				in21 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 21
				        );
				we21 <= '1';
			else
				we21 <= '0';
			end if;
		end if;
	end process;

	fifo22 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(22),
			RST     => RST,
			Datain2 => in22,
			WriteEn => we22,
			ReadEn  => '1',
			DataOut => tts22,
			full2   => full22,
			emp2ty  => emp22
		);
	fifo22_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we22 <= '0';
			elsif Datain2(2).val = '1' then -- if req is valid
				in22 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 22
				        );
				we22 <= '1';
			else
				we22 <= '0';
			end if;
		end if;
	end process;

	fifo23 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(23),
			RST     => RST,
			Datain2 => in23,
			WriteEn => we23,
			ReadEn  => '1',
			DataOut => tts23,
			full2   => full23,
			emp2ty  => emp23
		);
	fifo23_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we23 <= '0';
			elsif Datain2(3).val = '1' then -- if req is valid
				in23 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 23
				        );
				we23 <= '1';
			else
				we23 <= '0';
			end if;
		end if;
	end process;

	fifo24 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(24),
			RST     => RST,
			Datain2 => in24,
			WriteEn => we24,
			ReadEn  => '1',
			DataOut => tts24,
			full2   => full24,
			emp2ty  => emp24
		);
	fifo24_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we24 <= '0';
			elsif Datain2(4).val = '1' then -- if req is valid
				in24 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 24
				        );
				we24 <= '1';
			else
				we24 <= '0';
			end if;
		end if;
	end process;

	fifo25 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(25),
			RST     => RST,
			Datain2 => in25,
			WriteEn => we25,
			ReadEn  => '1',
			DataOut => tts25,
			full2   => full25,
			emp2ty  => emp25
		);
	fifo25_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we25 <= '0';
			elsif Datain2(5).val = '1' then -- if req is valid
				in25 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 25
				        );
				we25 <= '1';
			else
				we25 <= '0';
			end if;
		end if;
	end process;

	fifo26 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(26),
			RST     => RST,
			Datain2 => in26,
			WriteEn => we26,
			ReadEn  => '1',
			DataOut => tts26,
			full2   => full26,
			emp2ty  => emp26
		);
	fifo26_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we26 <= '0';
			elsif Datain2(6).val = '1' then -- if req is valid
				in26 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 26
				        );
				we26 <= '1';
			else
				we26 <= '0';
			end if;
		end if;
	end process;

	fifo27 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(27),
			RST     => RST,
			Datain2 => in27,
			WriteEn => we27,
			ReadEn  => '1',
			DataOut => tts27,
			full2   => full27,
			emp2ty  => emp27
		);
	fifo27_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we27 <= '0';
			elsif Datain2(7).val = '1' then -- if req is valid
				in27 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 27
				        );
				we27 <= '1';
			else
				we27 <= '0';
			end if;
		end if;
	end process;

	fifo28 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(28),
			RST     => RST,
			Datain2 => in28,
			WriteEn => we28,
			ReadEn  => '1',
			DataOut => tts28,
			full2   => full28,
			emp2ty  => emp28
		);
	fifo28_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we28 <= '0';
			elsif Datain2(8).val = '1' then -- if req is valid
				in28 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 28
				        );
				we28 <= '1';
			else
				we28 <= '0';
			end if;
		end if;
	end process;

	fifo29 : entity work.fifo2(rtl)     -- req from device
		generic map(
			fifo2_DEPTH => 3
		)
		port map(
			CLK     => CLK, ack => ack(29),
			RST     => RST,
			Datain2 => in29,
			WriteEn => we29,
			ReadEn  => '1',
			DataOut => tts29,
			full2   => full29,
			emp2ty  => emp29
		);
	fifo29_p : process(clock)
	begin
		if risin2g_edge(clock) then
			if reset = '1' then
				we29 <= '0';
			elsif Datain2(9).val = '1' then -- if req is valid
				in29 <= (Datain2(i).val, Datain2(i).sender,
				         Datain2(i).receiver, Datain2(i).cmd, Datain2(i).tag, Datain2(i).id, Datain2(i).adr, count, 29
				        );
				we29 <= '1';
			else
				we29 <= '0';
			end if;
		end if;
	end process;

	fifo30 : entity work.fifo_ack(rtl)  -- req from device
		generic map(
			FIFO_DEPTH => 3
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
	fifo30_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we30 <= '0';
			elsif DataIn(30).val = '1' then -- if req is valid
				in30 <= (DataIn(i).val, DataIn(i).sender,
				         DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 30
				        );
				we30 <= '1';
			else
				we30 <= '0';
			end if;
		end if;
	end process;

	fifo31 : entity work.fifo_ack(rtl)  -- req from device
		generic map(
			FIFO_DEPTH => 3
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
	fifo31_p : process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				we31 <= '0';
			elsif DataIn(31).val = '1' then -- if req is valid
				in31 <= (DataIn(i).val, DataIn(i).sender,
				         DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, count, 31
				        );
				we31 <= '1';
			else
				we31 <= '0';
			end if;
		end if;
	end process;

	-- Memory Pointer Process
	fifo_proc : process(clk)
		type FIFO_Memory is array (0 to FIFO_DEPTH - 1) of TST_TO;
		variable Memory : FIFO_Memory;

		variable Head : natural range 0 to FIFO_DEPTH - 1;
		variable Tail : natural range 0 to FIFO_DEPTH - 1;

		variable Looped : boolean;
		variable len    : integer := 0;
		variable i      : integer := 0;
		variable first  : boolean := true;
		variable amount : integer := 0;
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				Head        := 0;
				Tail        := 0;
				Looped      := false;
				Full        <= '0';
				--        Empty <= '1';
				DataOut.val <= '0';
			else
				first := true;
				i     := 0;
				-- if (WriteEn = '1') then
				while (i < 32) loop
					if (((Looped = false) or (Head /= Tail))) and DataIn(i).val = '1' then

						if (first = true) then
							Memory(Head) := (DataIn(i).val, DataIn(i).sender, DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, '1');
							first        := false;
						else
							Memory(Head) := (DataIn(i).val, DataIn(i).sender, DataIn(i).receiver, DataIn(i).cmd, DataIn(i).tag, DataIn(i).id, DataIn(i).adr, '0');
						end if;
						-- Increment Head pointer as needed
						if (Head = FIFO_DEPTH - 1) then
							Head   := 0;
							Looped := true;
						else
							Head := Head + 1;
						end if;
					end if;
					i := i + 1;
					amount := amount + 1;
					if (Head = Tail) then
						if Looped then
							Full <= '1';
							report "the fifo is too small, it is full!!!!!!!!!!!!";
						else
							DataOut.val <= '0';
						end if;
					else
						Full <= '0';
					end if;
				end loop;

				if ((Looped = true) or (Head /= Tail)) then
					-- Update data output
					DataOut <= Memory(Tail);
					amount  := amount - 1;
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
