library ieee;
use ieee.std_logic_1164.all;

entity fetch_stage is
    generic (n : integer := 16; m : integer := 10);
    port (ret_add		 				  	: in std_logic_vector(n - 1 downto 0);
    branch_pc               			  	: in std_logic_vector(n - 1 downto 0);
    stall_b, reset, intr, branch_res, clk   : in std_logic;
    memory_inst							  	: in std_logic_vector(n - 1 downto 0); 
    inst_s, immediate, pc_out        		  	: out std_logic_vector(n - 1 downto 0);
    mem_clk									: in std_logic);

	signal inst								: std_logic_vector(n - 1 downto 0);
	signal stall							: std_logic;
    signal mem_address     	   				: std_logic_vector(m - 1 downto 0);
    signal mem_data    		   				: std_logic_vector(n - 1 downto 0);
    signal waiting_ret						: std_logic;
    signal pc, pc_new, pc_inc	   			: std_logic_vector(n - 1 downto 0);
    signal pre_inst							: std_logic_vector(n - 1 downto 0);
    signal reading_pc						: std_logic;
    signal is_ldm, was_ldm					: std_logic_vector(0 downto 0);
    
    signal pc_inc_inp 						: std_logic_vector(n - 1 downto 0);
    
    constant intr_inst 		   				: std_logic_vector(n - 1 downto 0) := "0110110011110000";
    constant ret_inst						: std_logic_vector(3 downto 0)	   := "1100";
    constant nop 	  		   				: std_logic_vector(n - 1 downto 0) := (others => '0');
    constant rst_add   		   				: std_logic_vector(m - 1 downto 0) := (others => '0');
    constant int_add   		   				: std_logic_vector(m - 1 downto 0) := "0000000001";

end entity fetch_stage;

architecture fetch_stage_arch of fetch_stage is begin
    
	u : entity work.instruction_memory port map(mem_clk, mem_address, mem_data);

	p : entity work.pc_adder port map(pc_inc_inp, pc_inc);

	pc_inc_inp(15 downto 10) <= (others => '0');
	pc_inc_inp(9 downto 0) <= mem_address;

	mem_address <= rst_add when reset = '1' 
	else ret_add(9 downto 0) when memory_inst(14 downto 11) = ret_inst 
	else int_add  when intr = '1' and (stall = '0' or was_ldm(0) = '1') and waiting_ret = '0'
	else branch_pc(9 downto 0) when branch_res = '1' else pc(9 downto 0);
		
	waiting_ret <= '0' when memory_inst(14 downto 11) = ret_inst
		else '1' when inst(14 downto 11) = ret_inst
		else waiting_ret;

	pc_new(15 downto 10) <= (others => '0');
	pc_new(9 downto 0) <= mem_data(9 downto 0) when reading_pc = '1' else pc(9 downto 0) when stall = '1' else pc_inc(9 downto 0);
	
    inst <= nop when reset = '1' or waiting_ret = '1' or mem_data(15 downto 14) = "11"
    else pre_inst when stall = '1' or was_ldm(0) = '1'
    else intr_inst when intr = '1' else mem_data;
   
  	stall <= stall_b or waiting_ret;
  	
  	reading_pc <= reset or (intr and (not stall));
  	
  	
    is_ldm(0) <= '1' when mem_data(15 downto 14) = "11" and was_ldm(0) = '0' else '0';
    
    
    pc_register : entity work.internal_buffer port map(pc_new, pc, '0', clk);
    	
    pre_buffer : entity work.internal_buffer port map(mem_data, pre_inst, reset, clk);
    
    ldm_flag : entity work.internal_buffer generic map(n => 1) port map(is_ldm, was_ldm, reset, mem_clk);
        	
    immediate <= mem_data;
    inst_s <= inst;
    pc_out <= pc when intr = '1' and stall = '0' else pc_inc;
    
end fetch_stage_arch;
