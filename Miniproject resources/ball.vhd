		-- Bouncing Ball Video 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;
LIBRARY work;


ENTITY ball IS
Generic(ADDR_WIDTH: integer := 12; DATA_WIDTH: integer := 1);

   PORT(SIGNAL PB1, PB2, Clock 			: IN std_logic;
		  signal left_button	: in std_logic;
		  signal buttons : in STD_LOGIC_VECTOR(8 downto 0);
		  signal pixel_row_in, pixel_column_in : in std_LOGIC_VECTOR(9 downto 0);
		  signal vert_sync : in std_LOGIC;
		  signal speed : in std_loGIC_vector (9 downto 0);
        --SIGNAL Red,Green,Blue 			: OUT std_logic_vector(3 downto 0);
		  signal rgb : out STD_LOGIC_VECTOR(11 DOWNTO 0);
		  signal enable : out std_LOGIC;
		  ball_x, ball_size, ball_y : out std_LOGIC_vector(9 downto 0);
		  game_enable, reset : in std_logic
		  );		
END ball;

architecture behavior of ball is

			-- Video Display Signals   
SIGNAL vert_sync_int, Ball_on, Direction			: std_logic;
signal Red_Data, Green_Data, Blue_Data : std_logic_vector(3 DOWNTO 0); 
SIGNAL SizeY, SizeX 								: std_logic_vector(9 DOWNTO 0);  
SIGNAL Ball_Y_motion 						: std_logic_vector(9 DOWNTO 0) := "0000000000";
SIGNAL Ball_X_pos				: std_logic_vector(9 DOWNTO 0);
signal Ball_Y_pos: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(100,10);
SIGNAL pixel_row, pixel_column				: std_logic_vector(9 DOWNTO 0); 
SIGNAL char_output : std_LOGIC;

BEGIN         
ball_x <= Ball_X_pos;
ball_size <= SizeY;
ball_y <= Ball_Y_pos;
pixel_row <= pixel_row_in;
pixel_column <= pixel_column_in;
				
SizeY <= CONV_STD_LOGIC_VECTOR(16,10);
SizeX <= CONV_STD_LOGIC_VECTOR(32,10);
Ball_X_pos <= CONV_STD_LOGIC_VECTOR(320,10);

		-- need internal copy of vert_sync to read
vert_sync_int <= vert_sync;

		-- Colors for pixel data on video signal
Red_Data(0) <= not('1' and Ball_on);
Red_Data(1) <= not(buttons(0) and Ball_on);
Red_Data(2) <= not(buttons(1) and Ball_on);
Red_Data(3) <= not(buttons(2) and Ball_on);

Green_Data(0) <= not('1' and Ball_on);
Green_Data(1) <= not(buttons(3) and Ball_on);
Green_Data(2) <= not(buttons(4) and Ball_on);
Green_Data(3) <= not(buttons(5) and Ball_on);

Blue_Data(0) <=  not('1'and Ball_on);
Blue_Data(1) <=  not(buttons(6) and Ball_on);
Blue_Data(2) <=  not(buttons(7) and Ball_on);
Blue_Data(3) <=  not(buttons(8) and Ball_on);

RGB_Display: Process (Ball_X_pos, Ball_Y_pos, pixel_column, pixel_row, SizeX, SizeY, game_enable)
BEGIN
		
		-- Set Ball_on ='1' to display ball
	IF ('0' & Ball_X_pos <= pixel_column) AND
			-- compare positive numbers only
	(Ball_X_pos + SizeX >= '0' & pixel_column) AND
	('0' & Ball_Y_pos <= pixel_row) AND
	(Ball_Y_pos + SizeY >= '0' & pixel_row ) THEN
		Ball_on <= '1' and game_enable;
	ELSE
		Ball_on <= '0';
	END IF;
END process RGB_Display;

Move_Ball: process
	variable counter : std_logic_vector(9 downto 0) := "0000000000";
BEGIN
			-- Move ball once every vertical sync
	
	WAIT UNTIL vert_sync_int'event and vert_sync_int = '1';
			
			-- Bounce off top or bottom of screen
			if(game_enable = '1') then
			if	(left_button = '1') then -- if the button IS pressed then move up
				Ball_Y_motion <=  CONV_STD_LOGIC_VECTOR(1,10);
				counter := counter + "0000000001";
			else 
				Ball_Y_motion <= - speed;--this is the ball speed when holding the mouse button
				--Ball_Y_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
				counter := "0000000000";
			end if;
			end if;	
			
			--check colisions 
			IF (('0' & Ball_Y_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - SizeY) THEN
			if	(left_button = '0') then -- if the button is not pressed then move down
				Ball_Y_motion <= - CONV_STD_LOGIC_VECTOR(1,10);
			else 
			 Ball_Y_motion <= "0000000000";--keep the ball in that position
			 counter := "0000000000";
			end if;
			ELSIF Ball_Y_pos <= SizeY THEN
			if (left_button = '1') then -- if the button IS pressed then move up
				Ball_Y_motion <= CONV_STD_LOGIC_VECTOR(1,10);
			else 
				Ball_Y_motion <= "0000000000";
				counter := "0000000000";
			end if;
			END IF;
			Ball_Y_pos <= Ball_Y_pos + Ball_Y_motion + (counter(9 downto 3));
			if(reset = '1') then 
				Ball_Y_pos <= CONV_STD_LOGIC_VECTOR(100,10);
				counter := "0000000000";
				Ball_Y_motion <= "0000000000";
			end if;
			
			
END process Move_Ball;

rgb(11 downto 8) <= red_Data;
rgb(7 downto 4) <= blue_Data;
rgb(3 downto 0) <= green_Data;
enable <= Ball_on; --shouldnt be 1 always, only when ball is being rendered
END behavior;

