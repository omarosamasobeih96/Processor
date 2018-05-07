library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_adder is 
	port(inp : in std_logic_vector(15 downto 0);
	outp  	 : out std_logic_vector(15 downto 0));

end entity pc_adder;

architecture pc_adder_arch of pc_adder is begin

	outp <= std_logic_vector(unsigned(inp) + 1);

end pc_adder_arch;