library ieee;
use ieee.std_logic_1164.all;

entity decode_stage is
    generic (n : integer := 16; m : integer := 8);
    port (fwdng_wb_inst, fwdng_wb_data		     		: in std_logic_vector(n - 1 downto 0);
    fwdng_wb_low, fwdng_wb_high   				 		: in std_logic_vector(n - 1 downto 0);
    fwdng_mem_inst, fwdng_mem_data		     			: in std_logic_vector(n - 1 downto 0);
    fwdng_exc_low, fwdng_exc_high   				 	: in std_logic_vector(n - 1 downto 0);
    fwdng_alu_flag                    	             	: in std_logic_vector(n - 1 downto 0);
    fwdng_alu_flag_wr                                	: in std_logic;
    fwdng_alu_inst, fwdng_alu_low, fwdng_alu_high	 	: in std_logic_vector(n - 1 downto 0);
    flag, pc, data_bus1, data_bus2, input_port       	: in std_logic_vector(n - 1 downto 0);
    immediate                                       	: in std_logic_vector(n - 1 downto 0);
    reset                                           	: in std_logic; 
    stall, branch_res                               	: out std_logic;
    reg_sel1, reg_sel2                               	: out std_logic_vector(m - 1 downto 0);
    inst                                             	: in std_logic_vector(n - 1 downto 0);
    src, dst, branch_pc                              	: out std_logic_vector(n - 1 downto 0);
    inst_o 											 	: out std_logic_vector(n - 1 downto 0));

    signal port_en, nmem		                     	: std_logic;
    signal stall_s                      		    	: std_logic;
    signal add                                      	: std_logic_vector(n - 1 downto 0);
	signal is_ldm, is_ldd, is_std, is_shl, is_shr		: std_logic;
	signal src_s, dst_s, dst_branch						: std_logic_vector(n - 1 downto 0);
	
	constant std										: std_logic_vector(3 downto 0) := "1010";					
	constant ldd										: std_logic_vector(3 downto 0) := "1100";					
	constant imm_cs										: std_logic_vector(3 downto 0) := "0000";
    constant nop 										: std_logic_vector(n - 1 downto 0) := (others => '0');
	constant shl 										: std_logic_vector(3 downto 0) := "1000";
	constant shr 										: std_logic_vector(3 downto 0) := "1001";
	
end entity decode_stage;

architecture decode_stage_arch of decode_stage is begin

    b  : entity work.branching_unit generic map (n => n) port map(fwdng_alu_inst, fwdng_alu_low, fwdng_alu_high, fwdng_mem_inst, fwdng_exc_low, fwdng_exc_high, fwdng_mem_data, fwdng_wb_inst, fwdng_wb_low, fwdng_wb_high, fwdng_wb_data, inst, dst_s, src_s, flag, fwdng_alu_flag, fwdng_alu_flag_wr, branch_res, src, stall_s, dst_branch);

    d1 : entity work.decoder port map(inst(3), inst(4), inst(5), '1', reg_sel1);
    d2 : entity work.decoder port map(inst(0), inst(1), inst(2), '1', reg_sel2);

    -- 1 word inst
    nmem <= not inst(15);

    -- src = 7
    port_en <= nmem and inst(5)and inst(4) and inst(3);

    -- LDM opcode unique id bits 15 = 1 and 14 = 1
    is_ldm <= inst(15) and inst(14);
    is_std <= inst(15) and (not inst(14)) and (not inst(12));
    is_ldd <= inst(15) and (not inst(14)) and inst(12);
    is_shl <= nmem when inst(9 downto 6) = shl else '0';
    is_shr <= nmem when inst(9 downto 6) = shr else '0';
    
    add(15 downto 10) <= (others => '0');
    -- effective address in LDD and STD 
    add(9) <= inst(13);
    add(8 downto 0) <= inst(11 downto 3);

	-- TODO mar, mdr not correct
    src_s <= input_port when port_en = '1' else immediate when is_ldm = '1' else add when inst(15) = '1' else data_bus1;
    dst_s <= pc when is_std = '0' and is_ldd = '0' and is_shl = '0' and is_shr = '0' and inst(10) = '1' else data_bus2;
	branch_pc <= dst_branch; 
	dst <= dst_branch;
	
    inst_o(15 downto 14) <= nop(15 downto 14) when reset = '1' or stall_s = '1' else inst(15 downto 14);
    inst_o(13 downto 10) <= nop(13 downto 10) when reset = '1' or stall_s = '1' or is_shl = '1' or is_shr = '1' else std when is_std = '1' else ldd when is_ldd = '1' else inst(13 downto 10);
    inst_o(9 downto 6) <= nop(9 downto 6) when reset = '1' or stall_s = '1' or inst(15) = '1' else inst(9 downto 6);	
	inst_o(5 downto 0) <= nop(5 downto 0) when reset = '1' or stall_s = '1' else inst(5 downto 0);	
	
    stall <= stall_s;

end decode_stage_arch;