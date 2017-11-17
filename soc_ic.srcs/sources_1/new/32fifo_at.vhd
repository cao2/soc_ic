library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.defs.all;

entity fifo32_at is
	Generic(
		constant FIFO_DEPTH : positive := 5
	);
	Port(
		CLK     : in  STD_LOGIC;
		RST     : in  STD_LOGIC;
		--WriteEn	: in  STD_LOGIC;
		--DataVal: in ALL_T;
		--DataLen: in std_logic_vector(4 downto 0);
		DataIn  : in  ALL_T;
		--ReadEn : in STD_LOGIC;
		DataOut : out TST_TO;
		Full    : out STD_LOGIC := '0'
	);
end fifo32_at;

architecture rtl of fifo32_at is
	--signal td1: std_logic_vector(31 downto 0);
	--signal td2: std_logic_vector(31 downto 0);
begin

	-- Memory Pointer Process
	fifo_proc : process(clk, rst)
		type FIFO_Memory is array (0 to FIFO_DEPTH - 1) of ALL_T;
		variable Memory   : FIFO_Memory;
		variable num_val  : natural range 0 to 31;
		type val_c is array (0 to 31) of natural range 0 to 31;
		variable val_chan : val_c;
		variable Head     : natural range 0 to FIFO_DEPTH - 1;
		variable Tail     : natural range 0 to FIFO_DEPTH - 1;

		variable Looped       : boolean;
		variable len          : integer := 0;
		variable i            : integer := 0;
		variable first        : boolean := true;
		variable tmp_all_read : ALL_T;
		variable amount       : integer := 0;
		variable tmp_all      : ALL_T;
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
				DataOut.val <= '0';
			else
				first := true;
				i     := 0;
				-- if (WriteEn = '1') then

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

				if (valid = true) then
					if (((Looped = false) or (Head /= Tail))) and DataIn(i).val = '1' then

						if (first = true) then
							Memory(Head) := DataIn;
							first        := false;
						else
							Memory(Head) := DataIn;
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
							Full <= '0';
							report "the fifo is too small, it is full!!!!!!!!!!!!";
						else
							DataOut.val <= '0';
						end if;
					else
						Full <= '0';
					end if;
				else
					DataOut.val <= '0';
				end if;

				if (st = 0) then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						tmp_all_read := Memory(Tail);
						amount       := amount - 1;
						-- Update Tail pointer as needed
						if (Tail = FIFO_DEPTH - 1) then
							Tail := 0;

							Looped := false;
						else
							Tail := Tail + 1;
						end if;
						---now that we have the data, output it
						-- this size is always bigger than 1
						DataOut      <= (tmp_all_read(st).val, tmp_all_read(st).sender, tmp_all_read(st).recestver, tmp_all_read(st).cmd, tmp_all_read(st).tag, tmp_all_read(st).std, tmp_all_read(st).adr, '1');
						---now the first data is out, check if it reaches the size
						if st + 1 < num_val then
							st := st + 1;
						end if;
					end if;
				elsif (st = 1) then
					DataOut <= (tmp_all_read(1).val, tmp_all_read(1).sender, tmp_all_read(1).recestver, tmp_all_read(1).cmd, tmp_all_read(st).tag, tmp_all_read(1).std, tmp_all_read(1).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 2) then
					DataOut <= (tmp_all_read(2).val, tmp_all_read(2).sender, tmp_all_read(2).recestver, tmp_all_read(2).cmd, tmp_all_read(st).tag, tmp_all_read(2).std, tmp_all_read(2).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 3) then
					DataOut <= (tmp_all_read(3).val, tmp_all_read(3).sender, tmp_all_read(3).recestver, tmp_all_read(3).cmd, tmp_all_read(st).tag, tmp_all_read(3).std, tmp_all_read(3).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 4) then
					DataOut <= (tmp_all_read(4).val, tmp_all_read(4).sender, tmp_all_read(4).recestver, tmp_all_read(4).cmd, tmp_all_read(st).tag, tmp_all_read(4).std, tmp_all_read(4).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 5) then
					DataOut <= (tmp_all_read(5).val, tmp_all_read(5).sender, tmp_all_read(5).recestver, tmp_all_read(5).cmd, tmp_all_read(st).tag, tmp_all_read(5).std, tmp_all_read(5).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 6) then
					DataOut <= (tmp_all_read(6).val, tmp_all_read(6).sender, tmp_all_read(6).recestver, tmp_all_read(6).cmd, tmp_all_read(st).tag, tmp_all_read(6).std, tmp_all_read(6).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 7) then
					DataOut <= (tmp_all_read(7).val, tmp_all_read(7).sender, tmp_all_read(7).recestver, tmp_all_read(7).cmd, tmp_all_read(st).tag, tmp_all_read(7).std, tmp_all_read(7).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 8) then
					DataOut <= (tmp_all_read(8).val, tmp_all_read(8).sender, tmp_all_read(8).recestver, tmp_all_read(8).cmd, tmp_all_read(st).tag, tmp_all_read(8).std, tmp_all_read(8).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 9) then
					DataOut <= (tmp_all_read(9).val, tmp_all_read(9).sender, tmp_all_read(9).recestver, tmp_all_read(9).cmd, tmp_all_read(st).tag, tmp_all_read(9).std, tmp_all_read(9).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 10) then
					DataOut <= (tmp_all_read(10).val, tmp_all_read(10).sender, tmp_all_read(10).recestver, tmp_all_read(10).cmd, tmp_all_read(st).tag, tmp_all_read(10).std, tmp_all_read(10).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 11) then
					DataOut <= (tmp_all_read(11).val, tmp_all_read(11).sender, tmp_all_read(11).recestver, tmp_all_read(11).cmd, tmp_all_read(st).tag, tmp_all_read(11).std, tmp_all_read(11).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 12) then
					DataOut <= (tmp_all_read(12).val, tmp_all_read(12).sender, tmp_all_read(12).recestver, tmp_all_read(12).cmd, tmp_all_read(st).tag, tmp_all_read(12).std, tmp_all_read(12).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 13) then
					DataOut <= (tmp_all_read(13).val, tmp_all_read(13).sender, tmp_all_read(13).recestver, tmp_all_read(13).cmd, tmp_all_read(st).tag, tmp_all_read(13).std, tmp_all_read(13).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 14) then
					DataOut <= (tmp_all_read(14).val, tmp_all_read(14).sender, tmp_all_read(14).recestver, tmp_all_read(14).cmd, tmp_all_read(st).tag, tmp_all_read(14).std, tmp_all_read(14).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 15) then
					DataOut <= (tmp_all_read(15).val, tmp_all_read(15).sender, tmp_all_read(15).recestver, tmp_all_read(15).cmd, tmp_all_read(st).tag, tmp_all_read(15).std, tmp_all_read(15).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 16) then
					DataOut <= (tmp_all_read(16).val, tmp_all_read(16).sender, tmp_all_read(16).recestver, tmp_all_read(16).cmd, tmp_all_read(st).tag, tmp_all_read(16).std, tmp_all_read(16).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 17) then
					DataOut <= (tmp_all_read(17).val, tmp_all_read(17).sender, tmp_all_read(17).recestver, tmp_all_read(17).cmd, tmp_all_read(st).tag, tmp_all_read(17).std, tmp_all_read(17).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 18) then
					DataOut <= (tmp_all_read(18).val, tmp_all_read(18).sender, tmp_all_read(18).recestver, tmp_all_read(18).cmd, tmp_all_read(st).tag, tmp_all_read(18).std, tmp_all_read(18).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 19) then
					DataOut <= (tmp_all_read(19).val, tmp_all_read(19).sender, tmp_all_read(19).recestver, tmp_all_read(19).cmd, tmp_all_read(st).tag, tmp_all_read(19).std, tmp_all_read(19).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 20) then
					DataOut <= (tmp_all_read(20).val, tmp_all_read(20).sender, tmp_all_read(20).recestver, tmp_all_read(20).cmd, tmp_all_read(st).tag, tmp_all_read(20).std, tmp_all_read(20).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 21) then
					DataOut <= (tmp_all_read(21).val, tmp_all_read(21).sender, tmp_all_read(21).recestver, tmp_all_read(21).cmd, tmp_all_read(st).tag, tmp_all_read(21).std, tmp_all_read(21).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 22) then
					DataOut <= (tmp_all_read(22).val, tmp_all_read(22).sender, tmp_all_read(22).recestver, tmp_all_read(22).cmd, tmp_all_read(st).tag, tmp_all_read(22).std, tmp_all_read(22).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 23) then
					DataOut <= (tmp_all_read(23).val, tmp_all_read(23).sender, tmp_all_read(23).recestver, tmp_all_read(23).cmd, tmp_all_read(st).tag, tmp_all_read(23).std, tmp_all_read(23).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 24) then
					DataOut <= (tmp_all_read(24).val, tmp_all_read(24).sender, tmp_all_read(24).recestver, tmp_all_read(24).cmd, tmp_all_read(st).tag, tmp_all_read(24).std, tmp_all_read(24).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 25) then
					DataOut <= (tmp_all_read(25).val, tmp_all_read(25).sender, tmp_all_read(25).recestver, tmp_all_read(25).cmd, tmp_all_read(st).tag, tmp_all_read(25).std, tmp_all_read(25).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 26) then
					DataOut <= (tmp_all_read(26).val, tmp_all_read(26).sender, tmp_all_read(26).recestver, tmp_all_read(26).cmd, tmp_all_read(st).tag, tmp_all_read(26).std, tmp_all_read(26).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 27) then
					DataOut <= (tmp_all_read(27).val, tmp_all_read(27).sender, tmp_all_read(27).recestver, tmp_all_read(27).cmd, tmp_all_read(st).tag, tmp_all_read(27).std, tmp_all_read(27).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 28) then
					DataOut <= (tmp_all_read(28).val, tmp_all_read(28).sender, tmp_all_read(28).recestver, tmp_all_read(28).cmd, tmp_all_read(st).tag, tmp_all_read(28).std, tmp_all_read(28).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 29) then
					DataOut <= (tmp_all_read(29).val, tmp_all_read(29).sender, tmp_all_read(29).recestver, tmp_all_read(29).cmd, tmp_all_read(st).tag, tmp_all_read(29).std, tmp_all_read(29).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 30) then
					DataOut <= (tmp_all_read(30).val, tmp_all_read(30).sender, tmp_all_read(30).recestver, tmp_all_read(30).cmd, tmp_all_read(st).tag, tmp_all_read(30).std, tmp_all_read(30).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;
				elsif (st = 31) then
					DataOut <= (tmp_all_read(31).val, tmp_all_read(31).sender, tmp_all_read(31).recestver, tmp_all_read(31).cmd, tmp_all_read(st).tag, tmp_all_read(31).std, tmp_all_read(31).adr, '0');
					if st + 1 < num_val then
						st := st + 1;
					else
						st := 0;
					end if;

				end if;
			end if;
		end if;
	end process;

end rtl;
