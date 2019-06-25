library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity score_counter is
	port(	score_up, collision : in std_logic;
			clk, reset : in std_logic;
			score : out std_logic_vector(9 downto 0);
			game_enable, training_enable : in std_logic
	);
end entity;

architecture behaviour of score_counter is
begin
	process (collision, score_up,clk)
	variable count : integer range 0 to 999 := 0;
	variable prev, current : std_logic := '0';
	begin
	if reset = '1' then
		count := 0;
	elsif (rising_edge(clk) and game_enable = '1' and training_enable = '0') then
			prev := current;
			current := score_up;
			if(collision = '0' and prev = '0' and current = '1') then
				count := count + 1;
			end if;
		end if;
		score <= std_logic_vector(to_unsigned(count,10));
	end process;
end architecture;