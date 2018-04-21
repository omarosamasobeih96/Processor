library ieee;
use ieee.std_logic_1164.all;

entity exc_alu is
	generic (n : integer := 16);
	port(op1, op2, inst			    : in std_logic_vector(n - 1 downto 0);
	flag_push, flag_pop, flag_wr	: out std_logic;
	low, high, flag					: out std_logic_vector(n - 1 downto 0));

end entity exc_alu;

architecture exc_alu_arch of exc_alu is begin

	-- in LDD address = ALU output

end exc_alu_arch;