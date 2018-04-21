library ieee;
use ieee.std_logic_1164.all;

entity main is
	port(clk, reset, intr : in std_logic;
	input_port		  	  : in std_logic_vector(15 downto 0);
	output_port			  : out std_logic_vector(15 downto 0));
end entity main;

architecture main_arch of main is

	-- fetch
	signal ret_add		 				  		 	: std_logic_vector(15 downto 0);
    signal returned							  	 	: std_logic; 
    signal inst_f, immediate_f, pc_out    		 	: std_logic_vector(15 downto 0);

    -- write back
	signal data_w, low_w, high_w, inst_w 			: std_logic_vector(15 downto 0);
    signal reg_sel_w1, reg_sel_w2					: std_logic_vector(15 downto 0);
    signal data_bus_w1, data_bus_w2		    		: std_logic_vector(15 downto 0);

	-- memory
	signal mar, mdr      							: std_logic_vector(15 downto 0);
    signal data_m, inst_m, low_m, high_m			: std_logic_vector(15 downto 0);
    
    -- execution
    signal flag_wr 							 		: std_logic;
    signal flag, flag_tmp, low_e, high_e    		: std_logic_vector(15 downto 0);
    signal src_e, dst_e, inst_e                     : std_logic_vector(15 downto 0);


	-- decode
	signal reg_sel_r1, reg_sel_r2					: std_logic_vector(15 downto 0);
	signal data_bus_r1, data_bus_r2					: std_logic_vector(15 downto 0);
	signal immediate_d, pc_d, inst_d				: std_logic_vector(15 downto 0);
	signal stall, branch_res					 	: std_logic;
    signal branch_pc							 	: std_logic_vector(15 downto 0);
    signal src_d, dst_d								: std_logic_vector(15 downto 0);

begin

	f : entity work.fetch_stage	port map(ret_add, branch_pc, stall, reset, intr, branch_res, clk, returned, inst_f, immediate_f, pc_out);

	d : entity work.decode_stage port map(inst_m, data_m, low_m, high_m, flag_tmp, flag_wr, inst_e, low_e, high_e, flag, pc_d, 
		data_bus_r1, data_bus_r2, input_port, immediate_d, reset, stall, branch_res, reg_sel_r1, reg_sel_r2, inst_d, src_d, dst_d, branch_pc);

	e : entity work.execution_stage port map(inst_m, inst_w, data_m, data_w, low_w, high_w, low_m, high_m, reset, clk, flag_wr, low_e, high_e,
		flag, flag_tmp, src_e, dst_e, inst_e);

	m : entity work.memory_stage port map(mar, mdr, reset, clk, data_m, inst_m, low_m, high_m);

	w : entity work.write_back_stage port map(data_w, low_w, high_w, inst_w, reset, reg_sel_w1, reg_sel_w2, data_bus_w1, data_bus_w2, output_port);

	r : entity work.register_file port map(data_bus_w1, data_bus_w2, reg_sel_w1, reg_sel_w2, reset, clk, data_bus_r1, data_bus_r2, reg_sel_r1, reg_sel_r2);

end architecture ;