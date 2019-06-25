LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--USE  IEEE.STD_LOGIC_ARITH.all;
--USE  IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity mouseController is 
port (
		clk : in std_logic;
		left_click : in std_logic;
		speed : out std_logic_vector(9 downto 0);
		click : out std_logic
		);
end mouseController;

architecture arc1 of mouseController is 
--signal
 signal tmp_speed : integer range 0 to 16 := 5;
begin 

process (clk, left_click, tmp_speed)
variable counter : integer range 0 to 10000000 := 0;
variable tmp_clicked: std_logic := '0';
variable prev_click, current_click : std_logic := '0';
begin 
	if (clk'event and clk = '1') then 
		counter := counter + 1;
			
		if (counter > 8000000) then 
			tmp_clicked := '0';
			counter := 0;
		end if;
		
		if ( counter > 7000000) then 
			tmp_speed <= 1;
		elsif ( counter > 6000000) then
			tmp_speed <= 2;
		elsif ( counter > 5000000) then 
			tmp_speed <= 3;
		elsif ( counter > 4000000) then
			tmp_speed <= 4;
		else
			tmp_speed <= 5;
		end if;
		
		prev_click := current_click;
		
	end if;

	if prev_click = '0' and left_click = '1' then
		counter := 0;
		tmp_clicked := '1';
	end if;
	
	if left_click = '1' then 
		current_click := '1';
	else 
		current_click := '0';
	end if;
	
	click <= not(tmp_clicked);
	speed <= std_logic_vector(to_unsigned(tmp_speed, 10));
end process;
end architecture;