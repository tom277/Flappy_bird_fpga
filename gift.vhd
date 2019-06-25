library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity gift is
	generic (initialX : integer range 0 to 525 := 524;
				color : std_logic_vector := "110011001100");
	port (vert_sync_out : in std_logic;
			rand_num : in std_logic_vector(9 downto 0);
			pixel_row : in std_logic_vector(9 downto 0);
			pixel_column : in std_logic_vector(9 downto 0);
			--ball_x_pos, ball_y_posin : in std_logic_vector(9 downto 0);
			--ball_size : in std_logic_vector(9 downto 0);
			test_ball_enable : in std_logic;
			clk : in std_logic;
			rgb : out std_logic_vector (11 downto 0);
			enable : out std_logic;
			collision : out std_logic;
			gift_x, gift_y : out std_logic_vector(9 downto 0);
			--score_out : out std_logic;
			game_enable, reset : in std_logic;
			level : in std_logic_vector(1 downto 0)
			);
end entity;

architecture behvaiour of gift is
signal toggleRand : std_logic := '1';
signal randomizer : unsigned (9 downto 0) := "1010011110";
signal x_pos_left : signed(10 downto 0) := to_signed(initialX,11);
signal tmpEnable1, tmpEnable2 : std_logic := '1';
signal flag, last_collision : std_logic := '0';
signal score_up : std_logic := '0';
begin
	rgb <= color;
	random : process 
	begin
		wait until toggleRand'event AND toggleRand = '1';
		randomizer <=(unsigned(rand_num));
	end process random;
	
	process(clk, vert_sync_out,pixel_column,pixel_row)
	variable gift_width : integer range 0 to 16 := 16;
	variable int_xpos : integer range -32 to 641 := initialX;
	variable int_ypos : integer range 0 to 400 := 200;
--	variable int_ballY : integer range 0 to 480 := 0;
	begin
		int_ypos := ((to_integer(randomizer)/10)*4)+15;
--		int_ballY := to_integer(unsigned(ball_y_posin));
		
		if(((signed('0'&pixel_row) >= to_signed(int_ypos,11)) AND (signed('0'&pixel_row) < to_signed((int_ypos+gift_width),11))) 
		AND ((signed('0'&pixel_column) >= to_signed(int_xpos,11)) AND (signed('0'&pixel_column) < to_signed((int_xpos+gift_width),11)))) then
			tmpenable1 <= '1' and game_enable;
		else
			tmpenable1 <= '0' and game_enable;
		end if;
		
		if(clk'event and clk = '1') then
			if (test_ball_enable = '1' AND tmpEnable1 = '1') then
				last_collision <= '1';
				flag <= '1';
			end if;
			
			if(pixel_column = "0000000000" and pixel_row = "0000000000") then
				if flag = '0' then
					last_collision <= '0';
				end if;
				flag <= '0';
			end if;
		end if;
		
		if (vert_sync_out'event and vert_sync_out = '1') then
			if(last_collision = '1') then
				tmpEnable2 <= '0';
			end if;
			if(int_xpos < -16) then
				int_xpos := 641;
				toggleRand <= '1';
				tmpEnable2 <= '1';
			else
				int_xpos := int_xpos - (to_integer(unsigned(level))+1);
--				int_xpos := int_xpos - 1;
				toggleRand <= '0';
			end if;
			
			if (reset = '1') then
			int_xpos := initialX;
			int_ypos := 200;
--			flag <= '0';
--			last_collision <= '0';
			end if;
			gift_x <= std_logic_vector(to_unsigned(int_xpos,10));
			gift_y <= std_logic_vector(to_unsigned(int_ypos,10));
		end if;
		collision <= last_collision;
		enable <= tmpEnable1 and tmpEnable2;
	end process;
end architecture;
	
	
