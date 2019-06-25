LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity lfsr is 
port (clk, enable, reset : in std_logic;
		num : out std_logic_vector(9 downto 0));
end lfsr;

architecture arc1 of lfsr is 
signal seed : std_logic_vector(9 downto 0) := "0101010110";
signal tmp : std_logic_vector(10 downto 1) := "0101010110";
begin 
 num <= tmp(10 downto 1);
 
process (clk, reset)
begin 
	if(reset = '1') then 
		tmp <= seed;
	elsif (clk'event and clk = '1' and enable = '1') then 
		tmp(10) <= tmp(1);
		tmp(9) <= tmp(10)xor tmp(8);
		tmp(8) <= tmp(9) xor tmp(2);
		tmp(7) <= tmp(8);
      tmp(6) <= tmp(7);
      tmp(5) <= tmp(6)xor tmp(3);
      tmp(4) <= tmp(5);
      tmp(3) <= tmp(4)xor tmp(6);
      tmp(2) <= tmp(3);
      tmp(1) <= tmp(2);
	end if;
	
end process;
end architecture;