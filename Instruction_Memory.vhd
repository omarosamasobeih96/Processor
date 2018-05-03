library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is
	port(
		clk : in std_logic;
		address : in  std_logic_vector(9 downto 0);
		dataout : out std_logic_vector(15 downto 0));
end entity instruction_memory;

architecture instruction_memory_arch of instruction_memory is

	type ram_type is array(0 to 1023) of std_logic_vector(15 downto 0);
	signal ram : ram_type := (others => x"00ff");
	
begin
	dataout <= ram(to_integer(unsigned(address)));
end instruction_memory_arch;