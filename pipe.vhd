library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pipe is
	generic (initialX : integer range 0 to 641 := 600;
				color : std_logic_vector := "000011110000");
	port (vert_sync_out : in std_logic;
			rand_num : in std_logic_vector(9 downto 0);
			pixel_row : in std_logic_vector(9 downto 0);
			pixel_column : in std_logic_vector(9 downto 0);
			ball_x_pos, ball_y_posin : in std_logic_vector(9 downto 0);
			ball_size : in std_logic_vector(9 downto 0);
			test_ball_enable : in std_logic;
			clk : in std_logic;
			rgb : out std_logic_vector (11 downto 0);
			enable : out std_logic;
			collision : out std_logic;
			score_out : out std_logic;
			game_enable, reset : in std_logic;
			level : std_logic_vector(1 downto 0)
			);
end entity;

architecture arch1 of pipe is
constant pipe_width : integer range 0 to 256 := 60;
constant pipe_gap : integer range 0 to 256 := 110;
constant int_ball_size : integer range 0 to 16 := to_integer(unsigned(ball_size));
constant int_ballX : integer range 0 to 512:= 320;
signal toggleRand : std_logic := '1';
signal randomizer : unsigned (9 downto 0) := "1010011110";
signal x_pos_left : signed(10 downto 0) := to_signed(initialX,11);
signal tmpEnable : std_logic := '1';
signal flag, last_collision : std_logic := '0';
signal score_up : std_logic := '0';
begin
	rgb <= color;
	random : process 
	begin
		wait until toggleRand'event AND toggleRand = '1';
		randomizer <=(unsigned(rand_num));
	end process random;

	drawing : process(pixel_column,pixel_row, randomizer, x_pos_left, vert_sync_out, ball_y_posin, tmpEnable, flag, test_ball_enable, clk, game_enable)
	variable int_xpos : integer range -60 to 650 := 600;
	variable y_pos_tophalf : integer range 0 to 400 := 200;
	variable int_ballY : integer range 0 to 480 := 0;
	--variable temp_collision : std_logic := '0';
	--variable randomizer : integer range 0 to 1023 := 670;
   --variable x_pos_left : signed(10 downto 0) := to_signed(600,11);
	--variable y_pos_tophalf : signed(10 downto 0) := to_signed(200,11);
	begin
		int_xpos := to_integer(x_pos_left);
		y_pos_tophalf := (to_integer(randomizer)/10)*3;
		int_ballY := to_integer(unsigned(ball_y_posin));
		
--		if(((int_ballX+int_ball_size)<(int_xpos+pipe_width+int_ball_size))AND((int_ballX)>(int_xpos-int_ball_size))) 
--		AND((((int_ballY)>=0)AND((int_ballY+int_ball_size)<(int_ball_size+y_pos_tophalf)))  
--		OR(((int_ballY+int_ball_size)<=480)AND((int_ballY)>(y_pos_tophalf+pipe_gap-int_ball_size)))) then 
--		if(((int_ballX+int_ball_size)<(int_xpos+pipe_width+int_ball_size))AND((int_ballX)>(int_xpos-int_ball_size))) 
--		AND (int_ballY
--			collision <= '0';
--			possible_collison <= '1';
--		else
--			collision <= '1';
--			possible_collison <= '1';
--		end if;
--		
		--if(signed('0' & pixel_column) >= (to_signed(x_pos_left,11)))AND(signed('0' & pixel_column) <= (to_signed(x_pos_left+pipe_width,11)))
		--AND((signed('0'&pixel_row) <= (to_signed(y_pos_tophalf,11)))OR(signed('0'&pixel_row) >= (to_signed(y_pos_tophalf+pipe_gap,11))))then
		if(signed('0' & pixel_column) >= (x_pos_left))AND(signed('0' & pixel_column) <= (to_signed(to_integer(x_pos_left)+pipe_width,11)))
		AND((signed('0'&pixel_row) <= (to_signed(y_pos_tophalf,11)))OR(signed('0'&pixel_row) >= (to_signed(y_pos_tophalf+pipe_gap,11))))then
		--if('0'&signed(pixel_column) >=(x_pos_left)AND('0'&signed(pixel_column) <= x_pos_left+to_signed(pipe_width,11))
		--AND(('0'&signed(pixel_row) <= y_pos_tophalf)OR('0'&signed(pixel_row) >= y_pos_tophalf+to_signed(pipe_gap,11))))then	
			tmpEnable <= '1' and game_enable;
		else 
			tmpEnable <= '0';
		end if;	
		
		
		
		if(clk'event and clk = '1') then
			if (test_ball_enable = '1' AND tmpEnable = '1') then
				last_collision <= '1';
				flag <= '1';
			end if;
			
			if(pixel_column = "0000000000" and pixel_row = "0000000000") then
				if flag = '0' then
					last_collision <= '0';
				end if;
				flag <= '0';
			end if;
			if(int_xpos >= 300 and int_xpos <= 315) then
				score_up <= '1';
			else
				score_up <= '0';
			end if;
		end if;
		
		if(vert_sync_out'event and vert_sync_out = '1') then
			if(to_integer(x_pos_left) < -60) then
				x_pos_left <= to_signed(641,11);
				toggleRand <= '1';
			else
				x_pos_left <= to_signed((to_integer(x_pos_left)) - (to_integer(unsigned(level))+1),11);
--				x_pos_left <= to_signed((to_integer(x_pos_left) - 1),11);
				toggleRand <= '0';
			end if;
			
			if(reset = '1') then 
			int_xpos := 600;
			y_pos_tophalf := 200;
			int_ballY := 0;
			x_pos_left <= to_signed(initialX,11);
			end if;
		end if;
		
	end process drawing;	
		collision <= last_collision;
		enable <= tmpEnable;
		score_out <= score_up;
	--check collision with the ball
--	collision <= '1' when test_ball_enable = '1' and tmpEnable = '1' else
--					'0';
--	if(((int_ballX+int_ball_size)<(int_xpos+pipe_width+int_ball_size))AND((int_ballX)>(int_xpos-int_ball_size)))  --checks if ball X is within pipe X range
--	AND((((int_ballY)>=0)AND((int_ballY+int_ball_size)<(int_ball_size+y_pos_tophalf)))  --checks if ball Y is within pipe top-half Y range
--	OR(((int_ballY+int_ball_size)<=480)AND((int_ballY)>(y_pos_tophalf+pipe_gap-int_ball_size)))) then  --checks if ball Y is within pipe bottom-half Y range
--		collision <= '1';
--		possible_collison <= '1';
--	else
--		collision <= '0';
--		possible_collison <= '1';
--	end if;
	
end architecture;