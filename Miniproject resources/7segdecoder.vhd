library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity sevensegdecoder is
 port( digit : in std_logic_vector(3 downto 0);
   LED_out : out std_logic_vector(7 downto 0));
end sevensegdecoder;
architecture arc1 of sevensegdecoder is
 signal tmp : std_logic_vector(7 downto 0);
begin
 tmp <= "11000000" when digit = "0000" else -- 0
    "11111001" when digit = "0001" else --1
    "10100100" when digit = "0010" else --2
    "10110000" when digit = "0011" else --3
    "10011001" when digit = "0100" else --4
    "10010010" when digit = "0101" else --5
    "10000010" when digit = "0110" else --6
    "11111000" when digit = "0111" else --7
    "10000000" when digit = "1000" else -- 8
    "10010000" when digit = "1001" else -- 9
    "10001000" when digit = "1010" else -- A
    "10000011" when digit = "1011" else -- B
    "11000110" when digit = "1100" else -- C
    "10100001" when digit = "1101" else -- D
    "10000110" when digit = "1110" else -- E
    "10001110" when digit = "1111" else -- F
    "00000000";
 LED_out <= tmp;
end architecture arc1;