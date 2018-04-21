library ieee;
use ieee.std_logic_1164.all;

entity forwarding_unit is
	generic (n : integer := 16);
	port (inst_0, data_0, low_0, high_0 	: in std_logic_vector(n - 1 downto 0);
	inst_1, data_1, low_1, high_1			: in std_logic_vector(n - 1 downto 0);
	inst, inp_0, inp_1						: in std_logic_vector(n - 1 downto 0);
	out_0, out_1							: out std_logic_vector(n - 1 downto 0));

end entity forwarding_unit;

architecture forwarding_unit_arch of forwarding_unit is begin
	out_0 <= inp_0;
	out_1 <= inp_1;

	-- TODO implement forwarding_unit_arch
end forwarding_unit_arch;