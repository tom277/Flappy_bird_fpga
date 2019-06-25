LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--USE  IEEE.STD_LOGIC_ARITH.all;
--USE  IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity pizzaSkin is 
port (enable_in : in std_LOGIC;
		ball_x_pos, ball_y_pos : in std_logic_vector(9 downto 0);
		clk : in std_logic;
		pixel_row : in std_logic_vector(9 downto 0);
		pixel_column : in std_logic_vector(9 downto 0);
		rgb : out STD_LOGIC_VECTOR(11 DOWNTO 0);
		enable : out std_LOGIC
		);
end pizzaSkin;


architecture arc1 of pizzaSkin is 
signal imgPixelAdr : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal activePixel : STD_LOGIC_VECTOR (12 DOWNTO 0);
signal activeRed : STD_LOGIC_VECTOR (3 downto 0) := "1111";
signal activeGreen : STD_LOGIC_VECTOR (3 downto 0) := "1111";
signal activeBlue : STD_LOGIC_VECTOR (3 downto 0) := "1111";
component pizzarom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
	);
END component pizzarom;


begin 
	pizzarom1:pizzarom port map(
	 address => imgPixelAdr,
	 clock => clk,
	 q => activePixel
	);
	
	process (pixel_row, pixel_column, clk, ball_x_pos, ball_y_pos)
	variable tempAddress : integer range 0 to 5000 := 0;
	variable MSBrow : integer range 0 to 255 := 0;
	variable MSBcol : integer range 0 to 255 := 0;
	variable tmpCorX, tmpCorY : integer range 0 to 255 := 0;
	begin
		if(rising_edge(clk)) then
			tmpCorY := to_integer(unsigned(pixel_row(9 downto 0))) - to_integer(unsigned(ball_y_pos(9 downto 0)));
			tmpCorX := to_integer(unsigned(pixel_column(9 downto 0))) - to_integer(unsigned(ball_x_pos(9 downto 0)))  + 3;

			tempAddress := tmpCorX + (tmpCorY*16);
			
			imgPixelAdr <= std_logic_vector(to_unsigned(tempAddress,8));
		end if;
	end process;
	--rgb <= activePixel(11 downto 0);
	activeBlue <= activePixel(11 downto 8);
	activeGreen <= activePixel(7 downto 4);
	activeRed <= activePixel(3 downto 0);
	rgb <= activeRed & activeGreen & activeBlue;
	enable <= '1' when enable_in = '1' and activePixel(12) = '1' else
					'0';
end architecture;