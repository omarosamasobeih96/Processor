library ieee;
use ieee.std_logic_1164.all;

entity branching_unit is
	generic (n : integer := 16);
	port (inst_0, low_0, high_0 			: in std_logic_vector(n - 1 downto 0);
	inst_1, low_1, high_1, data_1			: in std_logic_vector(n - 1 downto 0);
	inst, inp, flag, alu_flag				: in std_logic_vector(n - 1 downto 0);
	flag_wr									: in std_logic;
	branch_res, stall						: out std_logic;
	branch_pc								: out std_logic_vector(n - 1 downto 0));

	signal acctual_flag						: std_logic_vector(n - 1 downto 0);

	signal nmem_0, nmem_1					: std_logic;
	signal is_mult_0, is_mult_1			 	: std_logic;
	signal en1_0, en1_1						: std_logic;
	signal en2_0, en2_1						: std_logic;
	signal dec_sel_0, dec_sel_1				: std_logic_vector(2 downto 0);	
	signal is_branch						: std_logic;

	signal branch_res_s						: std_logic;

	constant mult_inst        				: std_logic_vector(3 downto 0) := "1111";

end entity branching_unit;

architecture branching_unit_arch of branching_unit is begin
	
	nmem_0 <= not inst_0(15);
    is_mult_0 <= nmem_0 when inst_0(9 downto 6) = mult_inst else '0';
    dec_sel_0 <= inst_0(5 downto 3) when inst_0(13) = '1' else inst_0(2 downto 0);
    en1_0 <= inst_0(14);
    en2_0 <= inst_0(12);
	
	is_branch <= inst(9) and inst(8) and (not inst(7));
	
	nmem_1 <= not inst_1(15);
    is_mult_1 <= nmem_1 when inst_1(9 downto 6) = mult_inst else '0';
    dec_sel_1 <= inst_1(5 downto 3) when inst_1(13) = '1' else inst_1(2 downto 0);
    en1_1 <= inst_1(14);
    en2_1 <= inst_1(12);
    
    acctual_flag <= alu_flag when flag_wr = '1' else flag;
	
	branch_pc <= inp when inst(15) = '1' 
		else low_0 when inst(2 downto 0) = dec_sel_0 and en1_0 = '1'
		else high_0 when is_mult_0 = '1' and inst(2 downto 0) = inst_0(5 downto 3)
		else low_1 when inst(2 downto 0) = dec_sel_1 and en1_1 = '1'
		else high_1 when is_mult_1 = '1' and inst(2 downto 0) = inst_1(5 downto 3)
		else data_1 when en2_1 = '1' and inst(2 downto 0) = inst_1(2 downto 0)
		else inp;
	
	stall <= branch_res_s and is_branch and en2_0 when inst(2 downto 0) = inst_0(2 downto 0) else '0';
	
	branch_res_s <= '0' when	is_branch = '0'
		else '1' when inst(6) = '1'
		else '1' when inst(5 downto 3) = "000"
		else '1' when (inst(5) and acctual_flag(1)) = '1'
		else '1' when (inst(4) and acctual_flag(0)) = '1'
		else '1' when (inst(3) and acctual_flag(2)) = '1'
		else '0';
	
	branch_res <= branch_res_s;
end branching_unit_arch;