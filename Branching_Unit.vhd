library ieee;
use ieee.std_logic_1164.all;

entity branching_unit is
	generic (n : integer := 16);
	port (inst_0, data_0, low_0, high_0 	: in std_logic_vector(n - 1 downto 0);
	inst_1, low_1, high_1					: in std_logic_vector(n - 1 downto 0);
	inst, inp, flag, alu_flag				: in std_logic_vector(n - 1 downto 0);
	flag_wr									: in std_logic;
	branch_res, stall						: out std_logic;
	branch_pc								: out std_logic_vector(n - 1 downto 0));

end entity branching_unit;

architecture branching_unit_arch of branching_unit is begin

end branching_unit_arch;