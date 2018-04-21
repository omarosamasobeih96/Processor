library ieee;
use ieee.std_logic_1164.all;

entity decode_stage is
    generic (n : integer := 16; m : integer := 8);
    port (fwdng_mem_inst, fwdng_mem_data		     : in std_logic_vector(n - 1 downto 0);
    fwdng_exc_low, fwdng_exc_high   				 : in std_logic_vector(n - 1 downto 0);
    fwdng_alu_flag                    	             : in std_logic_vector(n - 1 downto 0);
    fwdng_alu_flag_wr                                : in std_logic;
    fwdng_alu_inst, fwdng_alu_low, fwdng_alu_high	 : in std_logic_vector(n - 1 downto 0);
    flag, pc, data_bus1, data_bus2, input_port       : in std_logic_vector(n - 1 downto 0);
    immediate                                        : in std_logic_vector(n - 1 downto 0);
    reset                                            : in std_logic; 
    stall, branch_res                                : out std_logic;
    reg_sel1, reg_sel2                               : out std_logic_vector(m - 1 downto 0);
    inst                                             : inout std_logic_vector(n - 1 downto 0);
    src, dst, branch_pc                              : out std_logic_vector(n - 1 downto 0));

    signal port_en, nmem, is_ldm                     : std_logic;
    signal push_pc, stall_s                          : std_logic;
    signal add                                       : std_logic_vector(n - 1 downto 0);

    constant nop : std_logic_vector(n - 1 downto 0) := (others => '0');

end entity decode_stage;

architecture decode_stage_arch of decode_stage is begin

    b  : entity work.branching_unit generic map (n => n) port map(fwdng_mem_inst, fwdng_mem_data, fwdng_exc_low, fwdng_exc_high, fwdng_alu_inst, fwdng_alu_low, fwdng_alu_high, inst, data_bus2, flag, fwdng_alu_flag, fwdng_alu_flag_wr, branch_res, stall_s, branch_pc);

    d1 : entity work.decoder port map(inst(3), inst(4), inst(5), '1', reg_sel1);
    d2 : entity work.decoder port map(inst(0), inst(1), inst(2), '1', reg_sel2);

    -- dst = 6
    push_pc <= (not inst(15)) and inst(2) and inst(1) and (not inst(0));

    -- 1 word inst
    nmem <= not inst(15);

    -- src = 7
    port_en <= nmem and inst(5)and inst(4) and inst(3);

    -- LDM opcode unique id bits 15 = 1 and 14 = 1
    is_ldm <= inst(15) and inst(14);

    add(15 downto 10) <= (others => '0');
    -- effective address in LDD and STD 
    add(9) <= inst(13);
    add(8 downto 3) <= inst(11 downto 6);
    add(2 downto 0) <= inst(5 downto 3) when inst(12) = '1' else inst(2 downto 0);

    src <= input_port when port_en = '1' else immediate when is_ldm = '1' else add when inst(15) = '1' else data_bus1;
    dst <= pc when push_pc = '1' else data_bus2;

    inst <= nop when reset = '1' or stall_s = '1' else inst;

    stall <= stall_s;

end decode_stage_arch;