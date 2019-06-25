library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity collision_detector is
	port( collision1, collision2, collision3 : in std_logic;
			collision_out : out std_logic
		 );
end entity;

architecture behaviour of collision_detector is
begin
	collision_out <= collision1 OR collision2 OR collision3;
end architecture;
	