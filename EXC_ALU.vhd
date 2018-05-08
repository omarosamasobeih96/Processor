library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exc_alu is
	generic (n : integer := 16);
	port(op1, op2, inst			   			: in std_logic_vector(n - 1 downto 0);
	flag_wr									: out std_logic;
	low, high, flag_cur, flag_interface		: out std_logic_vector(n - 1 downto 0);
	reset, clk								: in std_logic);

	signal  flag_cur_s					: std_logic_vector(n - 1 downto 0);
	signal adder_out, low_s					: std_logic_vector(n - 1 downto 0);
	signal adder_op2 						: std_logic_vector(n - 1 downto 0);
	signal oper								: std_logic_vector(3 downto 0);
	signal cout, is_mult, exchng_buf, f_wrs: std_logic;
	signal pb, pc							: std_logic_vector(n - 1 downto 0);
	signal pd								: std_logic_vector(31 downto 0);
	signal left_sh							: std_logic_vector(n - 1 downto 0);
	signal right_sh							: std_logic_vector(n - 1 downto 0);
	signal back_flag_d, back_flag			: std_logic_vector(n - 1 downto 0);
	signal frnt_flag_d, frnt_flag			: std_logic_vector(n - 1 downto 0);
	
	constant zero : std_logic_vector(n - 1 downto 0) := (others => '0');
	constant neg_one : std_logic_vector(n - 1 downto 0) := (others => '1');
end entity exc_alu;


-- flag bit 0: carry 
--		bit 1: zero
--		bit 2: negative
-- 0000 F = A
-- 0001 F = A + 1
-- 0010 F = A + B
-- 0011 F = A - B
-- 0100 F = A - 1

-- 0101 F = A and B
-- 0110 F = A or B
-- 0111 F = not A

-- 1000 F = A << B
-- 1001 F = A >> B
-- 1010 F = RLC A
-- 1011 F = RRC A

-- 1100 F = Branch
-- 1101 F = Call
-- 1110 F = Carry 
-- 1111 F = A * B

architecture exc_alu_arch of exc_alu is begin

	oper <= "0100" when inst(10) = '1' else inst(9 downto 6);

	adder_op2 <= neg_one when oper(2) = '1' else zero when oper(1) = '0' else op2 when  oper(0) = '0' else not op2;

	pb <= adder_out when oper(1) = '0' and oper(0) = '0' else op1 and op2 when oper(1) = '0' and oper(0) = '1' else op1 or op2 when oper(1) = '1' and oper(0) = '0' else not op1;
	
	pc <= left_sh when oper(1) = '0' and oper(0) = '0' else right_sh when oper(1) = '0' and oper(0) = '1'
		  else op1(14 downto 0) & frnt_flag(0) when oper(1) = '1' and oper(0) = '0' else frnt_flag(0) & op1(15 downto 1); 
	
	is_mult <= oper(3) and oper(2) and oper(1) and oper(0);
	
	pd <= std_logic_vector(signed(op1) * signed(op2)) when is_mult = '1' else op1 & op1;

	adder : entity work.NBITADDER port map(op1, adder_op2, oper(0), adder_out, cout);
		
		
	low_s <= adder_out when oper(3) = '0'and oper(2) = '0' else pb when oper(3) = '0' and oper(2) = '1' else pc when oper(3) = '1' and oper(2) = '0' else pd(n - 1 downto 0);
	
	low <= low_s;
	high <= pd(31 downto 16);
	
	
	left_sh <= x"0000" when op2(3) = '0' and op2(2) = '0' and op2(1) = '0' and op2(0) = '0'
	else op1(14 downto 0) & "0" when op2(3) = '0' and op2(2) = '0' and op2(1) = '0' and op2(0) = '1'
	else op1(13 downto 0) & "00" when op2(3) = '0' and op2(2) = '0' and op2(1) = '1' and op2(0) = '0'	
	else op1(12 downto 0) & "000" when op2(3) = '0' and op2(2) = '0' and op2(1) = '1' and op2(0) = '1'
	else op1(11 downto 0) & "0000" when op2(3) = '0' and op2(2) = '1' and op2(1) = '0' and op2(0) = '1'
	else op1(10 downto 0) & "00000" when op2(3) = '0' and op2(2) = '1' and op2(1) = '0' and op2(0) = '1'
	else op1(09 downto 0) & "000000" when op2(3) = '0' and op2(2) = '1' and op2(1) = '1' and op2(0) = '0'
	else op1(08 downto 0) & "0000000" when op2(3) = '0' and op2(2) = '1' and op2(1) = '1' and op2(0) = '1'
	else op1(07 downto 0) & "00000000" when op2(3) = '1' and op2(2) = '0' and op2(1) = '0' and op2(0) = '0'
	else op1(06 downto 0) & "000000000" when op2(3) = '1' and op2(2) = '0' and op2(1) = '0' and op2(0) = '1'
	else op1(05 downto 0) & "0000000000" when op2(3) = '1' and op2(2) = '0' and op2(1) = '1' and op2(0) = '0'	
	else op1(04 downto 0) & "00000000000" when op2(3) = '1' and op2(2) = '0' and op2(1) = '1' and op2(0) = '1'
	else op1(03 downto 0) & "000000000000" when op2(3) = '1' and op2(2) = '1' and op2(1) = '0' and op2(0) = '1'
	else op1(02 downto 0) & "0000000000000" when op2(3) = '1' and op2(2) = '1' and op2(1) = '0' and op2(0) = '1'
	else op1(01 downto 0) & "00000000000000" when op2(3) = '1' and op2(2) = '1' and op2(1) = '1' and op2(0) = '0'
	else op1(00 downto 0) & "000000000000000" when op2(3) = '1' and op2(2) = '1' and op2(1) = '1' and op2(0) = '1';
		
	
	right_sh <= x"0000" when op2(3) = '0' and op2(2) = '0' and op2(1) = '0' and op2(0) = '0'
	else "0" & op1(15 downto 01) when op2(3) = '0' and op2(2) = '0' and op2(1) = '0' and op2(0) = '1'
	else "00" & op1(15 downto 02) when op2(3) = '0' and op2(2) = '0' and op2(1) = '1' and op2(0) = '0'	
	else "000" & op1(15 downto 03) when op2(3) = '0' and op2(2) = '0' and op2(1) = '1' and op2(0) = '1'
	else "0000" & op1(15 downto 04) when op2(3) = '0' and op2(2) = '1' and op2(1) = '0' and op2(0) = '1'
	else "00000" & op1(15 downto 05) when op2(3) = '0' and op2(2) = '1' and op2(1) = '0' and op2(0) = '1'
	else "000000" & op1(15 downto 06) when op2(3) = '0' and op2(2) = '1' and op2(1) = '1' and op2(0) = '0'
	else "0000000" & op1(15 downto 07) when op2(3) = '0' and op2(2) = '1' and op2(1) = '1' and op2(0) = '1'
	else "00000000" & op1(15 downto 08) when op2(3) = '1' and op2(2) = '0' and op2(1) = '0' and op2(0) = '0'
	else "000000000" & op1(15 downto 09) when op2(3) = '1' and op2(2) = '0' and op2(1) = '0' and op2(0) = '1'
	else "0000000000" & op1(15 downto 10) when op2(3) = '1' and op2(2) = '0' and op2(1) = '1' and op2(0) = '0'	
	else "00000000000" & op1(15 downto 11) when op2(3) = '1' and op2(2) = '0' and op2(1) = '1' and op2(0) = '1'
	else "000000000000" & op1(15 downto 12) when op2(3) = '1' and op2(2) = '1' and op2(1) = '0' and op2(0) = '1'
	else "0000000000000" & op1(15 downto 13) when op2(3) = '1' and op2(2) = '1' and op2(1) = '0' and op2(0) = '1'
	else "00000000000000" & op1(15 downto 14) when op2(3) = '1' and op2(2) = '1' and op2(1) = '1' and op2(0) = '0'
	else "000000000000000" & op1(15 downto 15) when op2(3) = '1' and op2(2) = '1' and op2(1) = '1' and op2(0) = '1';	


	flag_cur_s(0) <= op1(15) when oper(3 downto 2) & oper(0) = "100" else op1(0) when oper(3 downto 2) & oper(0) = "101" else cout when oper(3) = '0' and (oper(2) = '0' or (oper(1) = '0' and oper(0) = '0')) else inst(0) when oper(3 downto 0) = "1110" else '0';
	flag_cur_s(1) <= frnt_flag(1) when oper(3 downto 0) = "1110" else '1' when (is_mult = '1' and pd = x"00000000") else '1' when low_s = x"0000" else '0';
	flag_cur_s(2) <= frnt_flag(2) when oper(3 downto 0) = "1110" else pd(31) when is_mult = '1' else low_s(15);
	flag_cur_s(15 downto 3) <= (others => '0');
	-- flag write signal
	f_wrs <= '0' when oper = "0000" else '1' when oper(3 downto 0) = "1110" else ((not inst(15)) and inst(14) and (not inst(13)));
	
	back_reg : entity work.internal_buffer port map(back_flag_d, back_flag, reset, clk);
	frnt_reg : entity work.internal_buffer port map(frnt_flag_d, frnt_flag, reset, clk);
		
	exchng_buf <= '1' when inst(10 downto 9) = "10" or (inst(14 downto 11) = "1100" and inst(0) = '1') else '0'; 
	
	back_flag_d <= frnt_flag when exchng_buf = '1' else back_flag;
	frnt_flag_d <= flag_cur_s when f_wrs = '1' else back_flag when exchng_buf = '1' else frnt_flag;
	
	flag_cur <= flag_cur_s;
	flag_wr <= f_wrs;
	flag_interface <= frnt_flag;
end exc_alu_arch;