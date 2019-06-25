library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gameover_detector is
	port( game_over1, game_over2, vert_sync_out : in std_logic;
			bird_ypos : in std_logic_vector(9 downto 0);
			reset : std_logic;
			gameover : out std_logic
		 );
end entity;

architecture behaviour of gameover_detector is
signal bird_grounded : std_logic := '0';
begin
	process (vert_sync_out)
	variable int_birdY : integer range 0 to 480 := 0;
	begin
		int_birdY := to_integer(unsigned(bird_ypos));
		if reset = '1' then 
			bird_grounded <= '0';
		elsif(int_birdY >= 465) then
			bird_grounded <= '1';
		else 
			bird_grounded <= '0';
		end if;
	end process;
	gameover <= game_over1 OR game_over2 or bird_grounded;
end architecture;