library ieee;
use ieee.std_logic_1164.all;

entity execution_stage is
    generic (n : integer := 16);
    port (fwdng_mem_inst, fwdng_wb_inst  : in std_logic_vector(n - 1 downto 0);
    fwdng_mem_data, fwdng_wb_data        : in std_logic_vector(n - 1 downto 0);     
    fwdng_wb_low, fwdng_wb_high 		 : in std_logic_vector(n - 1 downto 0);   
    fwdng_exc_low, fwdng_exc_high		 : in std_logic_vector(n - 1 downto 0);
    reset, clk                           : in std_logic;
   	flag_wr 		 					 : out std_logic;
    low, high, flag, flag_tmp            : out std_logic_vector(n - 1 downto 0);
    src, dst, inst	                     : in std_logic_vector(n - 1 downto 0);
    mar, mdr, inst_o				 	 : out std_logic_vector(n - 1 downto 0));

    signal op1, op2 : std_logic_vector(n - 1 downto 0);
    signal flag_s : std_logic_vector(n - 1 downto 0);
    signal flag_push, flag_pop, flag_wr_s : std_logic;
    constant nop : std_logic_vector(n - 1 downto 0) := (others => '0');

end entity execution_stage;

architecture execution_stage_arch of execution_stage is begin
    
	f : entity work.forwarding_unit generic map (n => n) port map (fwdng_wb_inst, fwdng_wb_data, fwdng_wb_low, fwdng_wb_high, fwdng_mem_inst, fwdng_mem_data, fwdng_exc_low, fwdng_exc_high, inst, src, dst, op1, op2);

	e : entity work.exc_alu	generic map (n => n) port map  (op1, op2, inst, flag_wr_s, low, high, flag, flag_s, reset, clk);

	flag_tmp <= flag_s;
	flag_wr <= flag_wr_s;
	inst_o <= nop when reset = '1' else inst;
	mar <= op1;
	mdr <= op2;
end execution_stage_arch;