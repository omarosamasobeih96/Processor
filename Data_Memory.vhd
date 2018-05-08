library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
	generic(n : integer := 16; m : integer := 9);
	port(
		clk : in std_logic;
		we  : in std_logic;
		address : in  std_logic_vector(m - 1 downto 0);
		datain  : in  std_logic_vector(n - 1 downto 0);
		dataout : out std_logic_vector(n - 1 downto 0));
end entity data_memory;

architecture data_memory_arch of data_memory is

	type ram_type is array(0 to 512) of std_logic_vector(15 downto 0);
	signal ram : ram_type := (others => x"0000");
	
	
	begin
		process(clk) is
			begin
				if rising_edge(clk) then  
					if we = '1' then
						ram(to_integer(unsigned(address))) <= datain;
					end if;
				end if;
		end process;
		dataout <= ram(to_integer(unsigned(address)));
end data_memory_arch;