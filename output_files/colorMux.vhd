LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--USE  IEEE.STD_LOGIC_ARITH.all;
--USE  IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity colorMux is 
port (bird_n, char_n, pipe1_n : in std_logic;
		bird : in STD_LOGIC_VECTOR(11 DOWNTO 0);
		char : in STD_LOGIC_VECTOR(11 DOWNTO 0);
		pipe1 : in STD_LOGIC_VECTOR(11 DOWNTO 0);
		clk : in std_logic;
		pixel_row : in std_logic_vector(9 downto 0);
		pixel_column : in std_logic_vector(9 downto 0);
		red, green, blue	: out STD_LOGIC_VECTOR(3 DOWNTO 0);
		pipe2_n, pipe3_n : in std_logic;
		pipe2 : in STD_LOGIC_VECTOR(11 DOWNTO 0);
		pipe3 : in STD_LOGIC_VECTOR(11 DOWNTO 0);
		collision : in std_LOGIC;
		gift1 : in std_logic_vector(11 downto 0);
		gift2 : in std_logic_vector(11 downto 0);
		gift1_n, gift2_n : in std_logic
		);
end colorMux;


architecture arc1 of colorMux is 
signal imgPixelAdr : STD_LOGIC_VECTOR (14 DOWNTO 0);
signal activePixel : STD_LOGIC_VECTOR (11 DOWNTO 0);
signal activeRed : STD_LOGIC_VECTOR (3 downto 0) := "1111";
signal activeGreen : STD_LOGIC_VECTOR (3 downto 0) := "1111";
signal activeBlue : STD_LOGIC_VECTOR (3 downto 0) := "1111";
signal tmpRed : std_LOGIC_vector(3 downto 0) := "0000";
component bgrom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
END component bgrom;


begin 
	bgrom1:bgrom port map(
	 address => imgPixelAdr,
	 clock => clk,
	 q => activePixel
	);
	
	--activeBlue <= activePixel(0) &  activePixel(1) &  activePixel(2) &  activePixel(3) ;
	--activeGreen <= activePixel(4) &  activePixel(5) &  activePixel(6) &  activePixel(7) ;
	--activeRed <= activePixel(8) &  activePixel(9) &  activePixel(10) &  activePixel(11) ;

	activeBlue <= activePixel(3 downto 0);
	activeGreen <= activePixel(7 downto 4);
	activeRed <= activePixel(11 downto 8);
	tmpRed <=	char(3 downto 0) when char_n = '1' else 
				pipe2(3 downto 0) when pipe2_n = '1' else
				pipe3(3 downto 0) when pipe3_n = '1' else
				pipe1(3 downto 0) when pipe1_n = '1' else
				gift1(3 downto 0) when gift1_n = '1' else
				gift2(3 downto 0) when gift2_n = '1' else
				bird(3 downto 0) when bird_n = '1' else 
				---"1111";
				activeRed;
	green <= char(7 downto 4) when char_n = '1' else
				pipe2(7 downto 4) when pipe2_n = '1' else
				pipe3(7 downto 4) when pipe3_n = '1' else
				pipe1(7 downto 4) when pipe1_n = '1' else
				gift1(7 downto 4) when gift1_n = '1' else
				gift2(7 downto 4) when gift2_n = '1' else
				bird(7 downto 4) when bird_n = '1' else 
				--"1111";
				activeGreen;
	blue <= char(11 downto 8) when char_n = '1' else
				pipe2(11 downto 8) when pipe2_n = '1' else
				pipe3(11 downto 8) when pipe3_n = '1' else
			   pipe1(11 downto 8) when pipe1_n = '1' else
				gift1(11 downto 8) when gift1_n = '1' else
				gift2(11 downto 8) when gift2_n = '1' else	
				bird(11 downto 8) when bird_n = '1' else
				--"1111";
				activeBlue;
				
	red <= (tmpRed(3) and not(collision)) & (tmpRed(2) and not(collision)) & (tmpRed(1) and not(collision)) & tmpRed(0);
				
	process (pixel_row, pixel_column, clk)
	variable tempAddress : integer range 0 to 19200 := 0;
	variable MSBrow : integer range 0 to 255 := 0;
	variable MSBcol : integer range 0 to 255 := 0;
	begin
		if(rising_edge(clk)) then
			MSBrow := to_integer(unsigned(pixel_row(9 downto 2)));
			MSBcol := to_integer(unsigned(pixel_column(9 downto 2)));
			tempAddress := MSBcol + (MSBrow*160);
			
			imgPixelAdr <= std_logic_vector(to_unsigned(tempAddress,15));
		end if;
	end process;
end architecture;