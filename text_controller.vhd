library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity text_controller is
	port (Clk : in std_logic;
			pixel_row, pixel_column : in std_logic_vector(9 downto 0);
			score : in std_logic_vector (9 downto 0);
			address : out std_logic_vector(8 downto 0);
			text_enable : out std_logic;
			pause_enable, game_enable, training_enable, menu_enable : in std_logic;
			energy : in std_logic_vector(5 downto 0);
			life : in std_logic_vector (2 downto 0);
			level : in std_logic_vector (1 downto 0)
			);
end entity text_controller;

architecture behaviour of text_controller is
signal rom_address : std_logic_vector(5 downto 0) := "100000";  --space character
begin 
process(Clk, pixel_row, pixel_column) is
variable int_col : integer range 0 to 640 := 0;
variable int_row : integer range 0 to 480 := 0;
variable font_row : std_logic_vector(2 downto 0) := "000";
variable int_score : integer range 0 to 999 := 0;
variable hundreds : integer range 0 to 9 := 1;
variable tens : integer range 0 to 9 := 2;
variable ones : integer range 0 to 9 := 3;
variable int_life : integer range 0 to 5;
variable int_energy : integer range 0 to 50;
variable energy_tens : integer range 0 to 5;
variable energy_ones : integer range 0 to 9;
variable int_lvl : integer range 0 to 3 := 0;
begin 
	int_col := to_integer(unsigned(pixel_column));
	int_row := to_integer(unsigned(pixel_row));
	font_row := pixel_row(3 downto 1) + "110";
	int_score := to_integer(unsigned(score));
	hundreds := integer(int_score/100);
	tens := (int_score rem 100)/10;
	ones := (int_score rem 10);
	int_life := to_integer(unsigned(life));
	int_energy := to_integer(unsigned(energy));
	energy_tens := integer(int_energy/10);
	energy_ones := int_energy rem 10;
	int_lvl := to_integer(unsigned(level));
	if(game_enable = '1' OR training_enable = '1') then
		if (int_row >= 4 and int_row < 20 and int_col >= 0  and int_col < 80) then
			text_enable <= '1';
			case int_col is
				when 0 to 15 => rom_address <= "010011";     --S
				when 16 to 31 => rom_address <= "000011";		--C
				when 32 to 47 => rom_address <= "001111";		--O
				when 48 to 63 => rom_address <= "010010";		--R
				when 64 to 79 => rom_address <= "000101";		--E
				when others => rom_address <= "100000";
			end case;
		elsif (int_row >= 20 and int_row < 36 and int_col >= 16  and int_col < 32) then  --hundreds
			text_enable <= '1';
			case hundreds is
				when 0 => rom_address <= "110000";		--0
				when 1 => rom_address <= "110001";		--1
				when 2 => rom_address <= "110010";		--2
				when 3 => rom_address <= "110011";		--3
				when 4 => rom_address <= "110100";		--4
				when 5 => rom_address <= "110101";		--5
				when 6 => rom_address <= "110110";		--6
				when 7 => rom_address <= "110111";		--7
				when 8 => rom_address <= "111000";		--8
				when 9 => rom_address <= "111001";		--9
				when others => rom_address <= "100000";
			end case;
		elsif (int_row >= 20 and int_row < 36 and int_col >= 32  and int_col < 48) then  --tens
			text_enable <= '1';
			case tens is
				when 0 => rom_address <= "110000";		--0
				when 1 => rom_address <= "110001";		--1
				when 2 => rom_address <= "110010";		--2
				when 3 => rom_address <= "110011";		--3
				when 4 => rom_address <= "110100";		--4
				when 5 => rom_address <= "110101";		--5
				when 6 => rom_address <= "110110";		--6
				when 7 => rom_address <= "110111";		--7
				when 8 => rom_address <= "111000";		--8
				when 9 => rom_address <= "111001";		--9
				when others => rom_address <= "100000";
			end case;
		elsif (int_row >= 20 and int_row < 36 and int_col >= 48  and int_col < 64) then  --ones
			text_enable <= '1';
			case ones is
				when 0 => rom_address <= "110000";		--0
				when 1 => rom_address <= "110001";		--1
				when 2 => rom_address <= "110010";		--2
				when 3 => rom_address <= "110011";		--3
				when 4 => rom_address <= "110100";		--4
				when 5 => rom_address <= "110101";		--5
				when 6 => rom_address <= "110110";		--6
				when 7 => rom_address <= "110111";		--7
				when 8 => rom_address <= "111000";		--8
				when 9 => rom_address <= "111001";		--9
				when others => rom_address <= "100000";
			end case;
		elsif (int_row >= 4 and int_row < 20 and int_col >= 560 and int_col < 640) then
			text_enable <= '1';
				case int_col is
					when 560 to 575 => rom_address <= "001100";		--L
					when 576 to 591 => rom_address <= "001001";		--I
					when 592 to 607 => rom_address <= "010110";		--V
					when 608 to 623 => rom_address <= "000101";		--E
					when 624 to 639 => rom_address <= "010011";		--S
					when others => rom_address <= "100000";
				end case;
		elsif (int_row >= 20 and int_row < 36 and int_col >= 592 and int_col < 608) then
			text_enable <= '1';
				case int_life is
					when 5 => rom_address <= "110101";     --5
					when 4 => rom_address <= "110100";		--4
					when 3 => rom_address <= "110011";		--3
					when 2 => rom_address <= "110010";		--2
					when 1 => rom_address <= "110001";		--1
					when 0 => rom_address <= "110000";     --0
					when others => rom_address <= "100000";
				end case;
		elsif (int_row >= 4 and int_row < 20 and int_col >= 272 and int_col < 368) then
			text_enable <= '1';
				case int_col is
					when 272 to 287 => rom_address <= "000101";     --E
					when 288 to 303 => rom_address <= "001110";		--N
					when 304 to 319 => rom_address <= "000101";		--E
					when 320 to 335 => rom_address <= "010010";		--R
					when 336 to 351 => rom_address <= "000111";		--G
					when 352 to 367 => rom_address <= "011001";     --Y
					when others => rom_address <= "100000";
				end case;
		elsif (int_row >= 20 and int_row < 36 and int_col >= 304 and int_col < 320) then
			text_enable <= '1';
				case energy_tens is
					when 0 => rom_address <= "110000";		--0
					when 1 => rom_address <= "110001";		--1
					when 2 => rom_address <= "110010";		--2
					when 3 => rom_address <= "110011";		--3
					when 4 => rom_address <= "110100";		--4
					when 5 => rom_address <= "110101";		--5
					when others => rom_address <= "100000";
				end case;
		elsif (int_row >= 20 and int_row < 36 and int_col >= 320 and int_col < 336) then
		text_enable <= '1';
			case energy_ones is
				when 0 => rom_address <= "110000";		--0
				when 1 => rom_address <= "110001";		--1
				when 2 => rom_address <= "110010";		--2
				when 3 => rom_address <= "110011";		--3
				when 4 => rom_address <= "110100";		--4
				when 5 => rom_address <= "110101";		--5
				when 6 => rom_address <= "110110";		--6
				when 7 => rom_address <= "110111";		--7
				when 8 => rom_address <= "111000";		--8
				when 9 => rom_address <= "111001";		--9
				when others => rom_address <= "100000";
			end case;
		else
			text_enable <= '0';
			rom_address <= "100000";
		end if;
	elsif (game_enable = '1' and training_enable = '0') then
		if (int_row >= 402 and int_row < 418 and int_col >= 255  and int_col < 351) then
			case int_col is
				when 255 to 270 => rom_address <= "001100";		--L
				when 271 to 286 => rom_address <= "000101";		--E
				when 287 to 302 => rom_address <= "010110";		--V
				when 303 to 318 => rom_address <= "000101";		--E
				when 319 to 334 => rom_address <= "001100";		--L
				when 335 to 350 => rom_address <= "100000";		--(space)
				when others => rom_address <= "100000";
			end case;
		elsif (int_row >= 402 and int_row < 418 and int_col >= 351  and int_col < 367) then
			case int_lvl is
				when 0 => rom_address <= "110000";		--0
				when 1 => rom_address <= "110001";		--1
				when 2 => rom_address <= "110010";		--2
				when 3 => rom_address <= "110011";		--3
				when others => rom_address <= "100000";
			end case;
		end if;
	elsif (training_enable = '1' and game_enable = '1') then
		elsif (int_row >= 402 and int_row < 418 and int_col >= 208  and int_col < 416) then
			case int_col is
				when 208 to 223 => rom_address <= "010100";		--T
				when 224 to 239 => rom_address <= "010010";		--R
				when 240 to 255 => rom_address <= "000001";		--A
				when 256 to 271 => rom_address <= "001001";		--I
				when 272 to 287 => rom_address <= "001110";		--N
				when 288 to 303 => rom_address <= "001001";		--I
				when 304 to 319 => rom_address <= "001100";		--N
				when 320 to 335 => rom_address <= "000111";		--G
				when 336 to 351 => rom_address <= "100000";		--(space)
				when 352 to 367 => rom_address <= "001101";		--M
				when 368 to 383 => rom_address <= "001111";		--O
				when 384 to 399 => rom_address <= "000100";		--D
				when 400 to 415 => rom_address <= "000101";		--E
				when others => rom_address <= "100000";
			end case;
	elsif (menu_enable = '1') then
		if (int_row >= 227 and int_row < 243 and int_col >= 224  and int_col < 400) then  --Flappy Bird
		text_enable <= '1';
			case int_col is
				when 224 to 239 => rom_address <= "000110";		--F
				when 240 to 255 => rom_address <= "001100";		--L
				when 256 to 271 => rom_address <= "000001";		--A
				when 272 to 287 => rom_address <= "010000";		--P
				when 289 to 303 => rom_address <= "010000";		--P
				when 304 to 319 => rom_address <= "011001";		--Y
				when 320 to 335 => rom_address <= "100000";		--(space)
				when 336 to 351 => rom_address <= "000010";		--B
				when 352 to 367 => rom_address <= "001001";		--I
				when 368 to 383 => rom_address <= "010010";		--R
				when 384 to 399 => rom_address <= "000100";		--D
				when others => rom_address <= "100000";
			end case;
		elsif (int_row >= 259 and int_row < 275 and int_col >= 160 and int_col < 480) then  -- Button 2 = Game Mode
		text_enable <= '1';
			case int_col is
				when 160 to 175 => rom_address <= "000010";		--B
				when 176 to 191 => rom_address <= "010101";		--U
				when 192 to 207 => rom_address <= "010100";		--T
				when 208 to 223 => rom_address <= "010100";		--T
				when 224 to 239 => rom_address <= "001111";		--O
				when 240 to 255 => rom_address <= "001110";		--N
				when 256 to 271 => rom_address <= "100000";		--(space)
				when 272 to 287 => rom_address <= "110010";		--2
				when 288 to 303 => rom_address <= "100000";		--(space)
				when 304 to 319 => rom_address <= "101101";		--=
				when 320 to 335 => rom_address <= "100000";		--(space)
				when 336 to 351 => rom_address <= "000111";		--G
				when 352 to 367 => rom_address <= "000001";		--A
				when 368 to 383 => rom_address <= "001101";		--M
				when 384 to 399 => rom_address <= "000101";		--E
				when 400 to 415 => rom_address <= "100000";		--(space)
				when 416 to 431 => rom_address <= "001101";		--M
				when 432 to 447 => rom_address <= "001111";		--O
				when 448 to 463 => rom_address <= "000100";		--D
				when 464 to 479 => rom_address <= "000101";		--E
				when others => rom_address <= "100000";
			end case;
		elsif (int_row >= 275 and int_row < 291 and int_col >= 128 and int_col < 512) then  --Button 0 = Training Mode
		text_enable <= '1';
			case int_col is
				when 128 to 143 => rom_address <= "000010";		--B
				when 144 to 159 => rom_address <= "010101";		--U
				when 160 to 175 => rom_address <= "010100";		--T
				when 176 to 191 => rom_address <= "010100";		--T
				when 192 to 207 => rom_address <= "001111";		--O
				when 208 to 223 => rom_address <= "001110";		--N
				when 224 to 239 => rom_address <= "100000";		--(space)
				when 240 to 255 => rom_address <= "001111";		--0
				when 256 to 271 => rom_address <= "100000";		--(space)
				when 272 to 287 => rom_address <= "101101";		--=
				when 288 to 303 => rom_address <= "100000";		--(space)
				when 304 to 319 => rom_address <= "010100";		--T
				when 320 to 335 => rom_address <= "010010";		--R
				when 336 to 351 => rom_address <= "000001";		--A
				when 352 to 367 => rom_address <= "001001";		--I
				when 368 to 383 => rom_address <= "001110";		--N
				when 384 to 399 => rom_address <= "001001";		--I
				when 400 to 415 => rom_address <= "001110";		--N
				when 416 to 431 => rom_address <= "000111";		--G
				when 432 to 447 => rom_address <= "100000";		--(space)
				when 448 to 463 => rom_address <= "001101";		--M
				when 464 to 479 => rom_address <= "001111";		--O
				when 480 to 495 => rom_address <= "000100";		--D
				when 496 to 511 => rom_address <= "000101";		--E
				when others => rom_address <= "100000";
			end case;
		else
			text_enable <= '0';
			rom_address <= "100000";
		end if;
	elsif (pause_enable = '1') then
		if (int_row >= 227 and int_row < 243 and int_col >= 272 and int_col < 352) then  --pause
		text_enable <= '1';
			case int_col is
				when 272 to 287 => rom_address <= "010000";		--P
				when 288 to 303 => rom_address <= "000001";		--A
				when 304 to 319 => rom_address <= "010101";		--U
				when 320 to 335 => rom_address <= "010011";		--S
				when 336 to 351 => rom_address <= "000101";		--E
				when others => rom_address <= "100000";
			end case;
		else
			text_enable <= '0';
		end if;
	end if;
	address <= rom_address & font_row;
end process;
end architecture;