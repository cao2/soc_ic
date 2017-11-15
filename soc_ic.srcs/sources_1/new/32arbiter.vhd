library ieee;
use ieee.std_logic_1164.ALL;
--use iEEE.std_logic_unsigned.all ;
use ieee.numeric_std.ALL;
use work.defs.all;
use work.util.all;

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
	signal in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31                                                                 : TST_TTS;
	signal we0, we1, we2, we3, we4, we5, we6, we7, we8, we9, we10, we11, we12, we13, we14, we15, we16, we17, we18, we19, we20, we21, we22, we23, we24, we25, we26, we27, we28, we29, we30, we31                                                                 : std_logic;
	signal full0, full1, full2, full3, full4, full5, full6, full7, full8, full9, full10, full11, full12, full13, full14, full15, full16, full17, full18, full19, full20, full21, full22, full23, full24, full25, full26, full27, full28, full29, full30, full31 : std_logic;
	signal emp0, emp1, emp2, emp3, emp4, emp5, emp6, emp7, emp8, emp9, emp10, emp11, emp12, emp13, emp14, emp15, emp16, emp17, emp18, emp19, emp20, emp21, emp22, emp23, emp24, emp25, emp26, emp27, emp28, emp29, emp30, emp31                                 : std_logic;
	signal count                                                                                                                                                                                                                                                : integer := 0;
	signal layer1_1, layer1_2, layer1_3, layer1_4, layer1_5, layer1_6, layer1_7, layer1_8, layer1_9, layer1_10, layer1_11, layer1_12, layer1_13, layer1_14, layer1_15, layer1_16                                                                                : TST_TTS;
	signal layer2_1, layer2_2, layer2_3, layer2_4, layer2_5, layer2_6, layer2_7, layer2_8: TST_TTS;
	signal layer3_1, layer3_2, layer3_3, layer3_4 : TST_TTS;
	signal layer4_1, layer4_2 : TST_TTS;
	constant DEPTH : positive := 2;
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
	final_arb : process(CLK)
		variable old_tim : integer := 0;
	begin
		if rising_edge(CLK) then
			
			if layer4_1.val = '1' and layer4_2.val = '0' then
				if layer4_1.tim = old_tim then
					DataOut <= (layer4_1.val, layer4_1.sender, layer4_1.receiver, layer4_1.cmd, layer4_1.tag, layer4_1.id, layer4_1.adr, '0');
				else
					DataOut <= (layer4_1.val, layer4_1.sender, layer4_1.receiver, layer4_1.cmd, layer4_1.tag, layer4_1.id, layer4_1.adr, '1');
				end if;
				ack(layer4_1.channel)<='1';
			elsif layer4_1.val = '0' and layer4_2.val = '1' then
				if layer4_2.tim = old_tim then
					DataOut <= (layer4_2.val, layer4_2.sender, layer4_2.receiver, layer4_2.cmd, layer4_2.tag, layer4_2.id, layer4_2.adr, '0');
				else
					DataOut <= (layer4_2.val, layer4_2.sender, layer4_2.receiver, layer4_2.cmd, layer4_2.tag, layer4_2.id, layer4_2.adr, '1');
				end if;
				ack(layer4_2.channel)<='1';
			elsif layer4_1.val = '1' and layer4_2.val = '1' then
				if layer4_1.tim < layer4_2.tim then
					if layer4_1.tim = old_tim then
						DataOut <= (layer4_1.val, layer4_1.sender, layer4_1.receiver, layer4_1.cmd, layer4_1.tag, layer4_1.id, layer4_1.adr, '0');
					else
						DataOut <= (layer4_1.val, layer4_1.sender, layer4_1.receiver, layer4_1.cmd, layer4_1.tag, layer4_1.id, layer4_1.adr, '1');
					end if;
					ack(layer4_1.channel)<='1';
				else
					if layer4_2.tim = old_tim then
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
	count_p : process(CLK)
	begin
		if rising_edge(CLK) then
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
	fifo0_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we0 <= '0';
			elsif DataIn(0).val = '1' then -- if req is valid
				in0 <= (DataIn(0).val, DataIn(0).sender,
				        DataIn(0).receiver, DataIn(0).cmd, DataIn(0).tag, DataIn(0).id, DataIn(0).adr, count, 0
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
	fifo1_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we1 <= '0';
			elsif DataIn(1).val = '1' then -- if req is valid
				in1 <= (DataIn(1).val, DataIn(1).sender,
				        DataIn(1).receiver, DataIn(1).cmd, DataIn(1).tag, DataIn(1).id, DataIn(1).adr, count, 1
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

	fifo2_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we2 <= '0';
			elsif DataIn(2).val = '1' then -- if req is valid
				in2 <= (DataIn(2).val, DataIn(2).sender,
				        DataIn(2).receiver, DataIn(2).cmd, DataIn(2).tag, DataIn(2).id, DataIn(2).adr, count, 2
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
	fifo3_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we3 <= '0';
			elsif DataIn(3).val = '1' then -- if req is valid
				in3 <= (DataIn(3).val, DataIn(3).sender,
				        DataIn(3).receiver, DataIn(3).cmd, DataIn(3).tag, DataIn(3).id, DataIn(3).adr, count, 3
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
	fifo4_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we4 <= '0';
			elsif DataIn(4).val = '1' then -- if req is valid
				in4 <= (DataIn(4).val, DataIn(4).sender,
				        DataIn(4).receiver, DataIn(4).cmd, DataIn(4).tag, DataIn(4).id, DataIn(4).adr, count, 4
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
	fifo5_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we5 <= '0';
			elsif DataIn(5).val = '1' then -- if req is valid
				in5 <= (DataIn(5).val, DataIn(5).sender,
				        DataIn(5).receiver, DataIn(5).cmd, DataIn(5).tag, DataIn(5).id, DataIn(5).adr, count, 5
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
	fifo6_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we6 <= '0';
			elsif DataIn(6).val = '1' then -- if req is valid
				in6 <= (DataIn(6).val, DataIn(6).sender,
				        DataIn(6).receiver, DataIn(6).cmd, DataIn(6).tag, DataIn(6).id, DataIn(6).adr, count, 6
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
	fifo7_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we7 <= '0';
			elsif DataIn(7).val = '1' then -- if req is valid
				in7 <= (DataIn(7).val, DataIn(7).sender,
				        DataIn(7).receiver, DataIn(7).cmd, DataIn(7).tag, DataIn(7).id, DataIn(7).adr, count, 7
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
	fifo8_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we8 <= '0';
			elsif DataIn(8).val = '1' then -- if req is valid
				in8 <= (DataIn(8).val, DataIn(8).sender,
				        DataIn(8).receiver, DataIn(8).cmd, DataIn(8).tag, DataIn(8).id, DataIn(8).adr, count, 8
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
	fifo9_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we9 <= '0';
			elsif DataIn(9).val = '1' then -- if req is valid
				in9 <= (DataIn(9).val, DataIn(9).sender,
				        DataIn(9).receiver, DataIn(9).cmd, DataIn(9).tag, DataIn(9).id, DataIn(9).adr, count, 9
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
	fifo10_p : process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='1' then
				we10 <= '0';
			elsif DataIn(10).val = '1' then -- if req is valid
				in10 <= (DataIn(10).val, DataIn(10).sender,
				         DataIn(10).receiver, DataIn(10).cmd, DataIn(10).tag, DataIn(10).id, DataIn(10).adr, count, 10
				        );
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
				in11 <= (DataIn(11).val, DataIn(11).sender,
				         DataIn(11).receiver, DataIn(11).cmd, DataIn(11).tag, DataIn(11).id, DataIn(11).adr, count, 11
				        );
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
				in12 <= (DataIn(12).val, DataIn(12).sender,
				         DataIn(12).receiver, DataIn(12).cmd, DataIn(12).tag, DataIn(12).id, DataIn(12).adr, count, 12
				        );
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
				in13 <= (DataIn(13).val, DataIn(13).sender,
				         DataIn(13).receiver, DataIn(13).cmd, DataIn(13).tag, DataIn(13).id, DataIn(13).adr, count, 13
				        );
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
				in14 <= (DataIn(14).val, DataIn(14).sender,
				         DataIn(14).receiver, DataIn(14).cmd, DataIn(14).tag, DataIn(14).id, DataIn(14).adr, count, 14
				        );
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
				in15 <= (DataIn(15).val, DataIn(15).sender,
				         DataIn(15).receiver, DataIn(15).cmd, DataIn(15).tag, DataIn(15).id, DataIn(15).adr, count, 15
				        );
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
				in16 <= (DataIn(16).val, DataIn(16).sender,
				         DataIn(16).receiver, DataIn(16).cmd, DataIn(16).tag, DataIn(16).id, DataIn(16).adr, count, 16
				        );
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
				in17 <= (DataIn(17).val, DataIn(17).sender,
				         DataIn(17).receiver, DataIn(17).cmd, DataIn(17).tag, DataIn(17).id, DataIn(17).adr, count, 17
				        );
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
				in18 <= (DataIn(18).val, DataIn(18).sender,
				         DataIn(18).receiver, DataIn(18).cmd, DataIn(18).tag, DataIn(18).id, DataIn(18).adr, count, 18
				        );
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
				in19 <= (DataIn(19).val, DataIn(19).sender,
				         DataIn(19).receiver, DataIn(19).cmd, DataIn(19).tag, DataIn(19).id, DataIn(19).adr, count, 19
				        );
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
				in20 <= (DataIn(20).val, DataIn(20).sender,
				         DataIn(20).receiver, DataIn(20).cmd, DataIn(20).tag, DataIn(20).id, DataIn(20).adr, count, 20
				        );
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
				in21 <= (DataIn(21).val, DataIn(21).sender,
				         DataIn(21).receiver, DataIn(21).cmd, DataIn(21).tag, DataIn(21).id, DataIn(21).adr, count, 21
				        );
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
				in22 <= (DataIn(22).val, DataIn(22).sender,
				         DataIn(22).receiver, DataIn(22).cmd, DataIn(22).tag, DataIn(22).id, DataIn(22).adr, count, 22
				        );
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
				in23 <= (DataIn(23).val, DataIn(23).sender,
				         DataIn(23).receiver, DataIn(23).cmd, DataIn(23).tag, DataIn(23).id, DataIn(23).adr, count, 23
				        );
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
				in24 <= (DataIn(24).val, DataIn(24).sender,
				         DataIn(24).receiver, DataIn(24).cmd, DataIn(24).tag, DataIn(24).id, DataIn(24).adr, count, 24
				        );
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
				in25 <= (DataIn(25).val, DataIn(25).sender,
				         DataIn(25).receiver, DataIn(25).cmd, DataIn(25).tag, DataIn(25).id, DataIn(25).adr, count, 25
				        );
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
				in26 <= (DataIn(26).val, DataIn(26).sender,
				         DataIn(26).receiver, DataIn(26).cmd, DataIn(26).tag, DataIn(26).id, DataIn(26).adr, count, 26
				        );
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
				in27 <= (DataIn(27).val, DataIn(27).sender,
				         DataIn(27).receiver, DataIn(27).cmd, DataIn(27).tag, DataIn(27).id, DataIn(27).adr, count, 27
				        );
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
				in28 <= (DataIn(28).val, DataIn(28).sender,
				         DataIn(28).receiver, DataIn(28).cmd, DataIn(28).tag, DataIn(28).id, DataIn(28).adr, count, 28
				        );
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
				in29 <= (DataIn(29).val, DataIn(29).sender,
				         DataIn(29).receiver, DataIn(29).cmd, DataIn(29).tag, DataIn(29).id, DataIn(29).adr, count, 29
				        );
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
				in30 <= (DataIn(30).val, DataIn(30).sender,
				         DataIn(30).receiver, DataIn(30).cmd, DataIn(30).tag, DataIn(30).id, DataIn(30).adr, count, 30
				        );
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
				in31 <= (DataIn(31).val, DataIn(31).sender,
				         DataIn(31).receiver, DataIn(31).cmd, DataIn(31).tag, DataIn(31).id, DataIn(31).adr, count, 31
				        );
				we31 <= '1';
			else
				we31 <= '0';
			end if;
		end if;
	end process;

	
end rtl;
