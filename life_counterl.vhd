library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity life_counter is
	port( collision, clk, score_up, reset : in std_logic;
		   life : out std_logic_vector(2 downto 0);
			game_over : out std_logic;
			pickup_collision : in std_logic
		  );
end entity;



architecture behaviour of life_counter is
begin
	process (clk, collision)
	variable count : integer range 0 to 5 := 5;
	variable prev, current : std_logic := '0';
	begin
		if (reset = '1' or pickup_collision = '1') then 
			count := 5;
			game_over <= '0';
		elsif(rising_edge(clk)) then
			prev := current;
			current := collision;
			if(count = 0) then
				game_over <= '1';
			elsif(collision = '1') then
				if(prev = '0' and current = '1') then
					count := count - 1;
					game_over <= '0';
				end if;
			end if;
		end if;
		life <= std_logic_vector(to_unsigned(count,3));
	end process;
end architecture;
			