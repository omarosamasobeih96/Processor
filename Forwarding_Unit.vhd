library ieee;
use ieee.std_logic_1164.all;

entity forwarding_unit is
	generic (n : integer := 16);
	port (inst_0, data_0, low_0, high_0 	: in std_logic_vector(n - 1 downto 0);
	inst_1, data_1, low_1, high_1			: in std_logic_vector(n - 1 downto 0);
	inst, inp_0, inp_1						: in std_logic_vector(n - 1 downto 0);
	out_0, out_1							: out std_logic_vector(n - 1 downto 0));


	signal nmem_0, nmem_1					: std_logic;
	signal is_mult_0, is_mult_1			 	: std_logic;
	signal en1_0, en1_1						: std_logic;
	signal en2_0, en2_1						: std_logic;
	signal dec_sel_0, dec_sel_1				: std_logic_vector(2 downto 0);	


	constant mult_inst        				: std_logic_vector(3 downto 0) := "1111";
	
end entity forwarding_unit;

architecture forwarding_unit_arch of forwarding_unit is begin
	
	nmem_0 <= not inst_0(15);
    is_mult_0 <= nmem_0 when inst_0(9 downto 6) = mult_inst else '0';
    dec_sel_0 <= inst_0(5 downto 3) when inst_0(13) = '1' else inst_0(2 downto 0);
    en1_0 <= inst_0(14);
    en2_0 <= inst_0(12);
	
	nmem_1 <= not inst_1(15);
    is_mult_1 <= nmem_1 when inst_1(9 downto 6) = mult_inst else '0';
    dec_sel_1 <= inst_1(5 downto 3) when inst_1(13) = '1' else inst_1(2 downto 0);
    en1_1 <= inst_1(14);
    en2_1 <= inst_1(12);
	
	out_0 <= inp_0 when inst(15) = '1' 
		else low_0 when inst(5 downto 3) = dec_sel_0 and en1_0 = '1'
		else high_0 when is_mult_0 = '1' and inst(5 downto 3) = inst_0(5 downto 3)
		else data_0 when en2_0 = '1' and inst(5 downto 3) = inst_0(2 downto 0)
		else low_1 when inst(5 downto 3) = dec_sel_1 and en1_1 = '1'
		else high_1 when is_mult_1 = '1' and inst(5 downto 3) = inst_1(5 downto 3)
		else data_1 when en2_1 = '1' and inst(5 downto 3) = inst_1(2 downto 0)
		else inp_0;

	out_1 <= inp_1 when inst(10) = '1' 
		else low_0 when inst(2 downto 0) = dec_sel_0 and en1_0 = '1'
		else high_0 when is_mult_0 = '1' and inst(2 downto 0) = inst_0(5 downto 3)
		else data_0 when en2_0 = '1' and inst(2 downto 0) = inst_0(2 downto 0)
		else low_1 when inst(2 downto 0) = dec_sel_1 and en1_1 = '1'
		else high_1 when is_mult_1 = '1' and inst(2 downto 0) = inst_1(5 downto 3)
		else data_1 when en2_1 = '1' and inst(2 downto 0) = inst_1(2 downto 0)
		else inp_1;

end forwarding_unit_arch;