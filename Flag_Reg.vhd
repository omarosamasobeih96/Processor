library ieee;
use ieee.std_logic_1164.all;

entity flag_reg is
	generic (n : integer := 16);
	port(inp			    		: in std_logic_vector(n - 1 downto 0);
	flag_push, flag_pop, flag_wr	: in std_logic;
	clk, rst						: in std_logic;
	flag							: out std_logic_vector(n - 1 downto 0));

end entity flag_reg;

architecture flag_reg_arch of flag_reg is begin

end flag_reg_arch;