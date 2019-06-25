library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity energy_counter is 
	port (clk, mouse_click, reset : in std_logic;
			energy : out std_logic_vector (5 downto 0);
			game_over : out std_logic;
			pickup_collision : in std_logic
		  );
end entity;

architecture behaviour of energy_counter is
begin
	process(clk, mouse_click)
	variable count : integer range 0 to 50 := 50;
	variable prev, current : std_logic := '0';
	begin
		if(reset = '1' or pickup_collision = '1') then
			count := 50;
			game_over <= '0';
		elsif(rising_edge(clk)) then
			prev := current;
			current := mouse_click;
			if(count = 0) then
				game_over <= '1';
			elsif (mouse_click = '1') then
				if(prev = '0' and current = '1') then
					count := count - 1;
					game_over <= '0';
				end if;
			end if;
		end if;
		energy <= std_logic_vector(to_unsigned(count,6));
	end process;
end architecture;