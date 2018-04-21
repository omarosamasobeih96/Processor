library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is 
	port ( a0, a1, a2, e : in std_logic;
			d : out std_logic_vector (7 downto 0));    
end entity decoder;


architecture data_arch of decoder is
begin
	d <= x"00" when e = '0'
		else x"01" when a0 = '0' and a1 = '0' and a2 = '0'
		else x"02" when a0 = '1' and a1 = '0' and a2 = '0'
		else x"04" when a0 = '0' and a1 = '1' and a2 = '0'
		else x"08" when a0 = '1' and a1 = '1' and a2 = '0'		
		else x"10" when a0 = '0' and a1 = '0' and a2 = '1'
		else x"20" when a0 = '1' and a1 = '0' and a2 = '1'
		else x"40" when a0 = '0' and a1 = '1' and a2 = '1'
		else x"80";
end data_arch;