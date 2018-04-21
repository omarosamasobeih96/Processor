library ieee;
use ieee.std_logic_1164.all;

entity fetch_stage is
    generic (n : integer := 16; m : integer := 10);
    port (ret_add		 				  : in std_logic_vector(n - 1 downto 0);
    branch_pc               			  : in std_logic_vector(n - 1 downto 0);
    stall, reset, intr, branch_res, clk   : in std_logic;
    returned							  : in std_logic; 
    inst, immediate, pc_out        		  : out std_logic_vector(n - 1 downto 0));

    signal mem_address     	   		: std_logic_vector(m - 1 downto 0);
    signal mem_data    		   		: std_logic_vector(n - 1 downto 0);
    signal waiting_ret, reading_pc	: std_logic;
    signal pc, pc_new, pc_inc	   	: std_logic_vector(n - 1 downto 0);
    constant intr_inst 		   		: std_logic_vector(n - 1 downto 0) := "0110100110110110"; 	
    constant nop 	  		   		: std_logic_vector(n - 1 downto 0) := (others => '0');
    constant rst_add   		   		: std_logic_vector(m - 1 downto 0) := (others => '0');
    constant int_add   		   		: std_logic_vector(m - 1 downto 0) := "0000000001";

end entity fetch_stage;

architecture fetch_stage_arch of fetch_stage is begin
    
	u : entity work.instruction_memory port map(clk, mem_address, mem_data);

	p : entity work.pc_adder port map(pc, pc_inc);

	mem_address <= rst_add when reset = '1' 
	else ret_add(9 downto 0) when waiting_ret = '1' and returned = '1' 
	else int_add  when intr = '1' and stall = '0' and waiting_ret = '0'
	else branch_pc(9 downto 0) when branch_res = '1' else pc_inc(9 downto 0);

	pc_new(9 downto 0) <= mem_data(9 downto 0) when reading_pc = '1' else mem_address;
	
    inst <= nop when reset = '1' or stall = '1' or waiting_ret = '1' else intr_inst when intr = '1' else mem_data;
end fetch_stage_arch;