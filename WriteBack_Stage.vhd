library ieee;
use ieee.std_logic_1164.all;

entity write_back_stage is
    generic (n : integer := 16; m : integer := 8);
    port (data, low, high, inst                     : in std_logic_vector(n - 1 downto 0);
    reset                                           : in std_logic;
    reg_sel1, reg_sel2								: out std_logic_vector(m - 1 downto 0);
    data_bus1, data_bus2, output_port    			: out std_logic_vector(n - 1 downto 0));

    signal port_en, is_mult, nmem	   		  : std_logic;
    signal dec_sel1_0, dec_sel1_1, dec_sel1_2 : std_logic;
    signal dec_sel2_0, dec_sel2_1, dec_sel2_2 : std_logic;
    signal en1, en2							  : std_logic;
    
    -- TODO write the actual inst
    constant mult_inst        				  : std_logic_vector(3 downto 0) := "1111";
end entity write_back_stage;

architecture write_back_stage_arch of write_back_stage is begin
	nmem <= not inst(15);
	
    -- unique key of multiply instruction
    is_mult <= nmem when inst(9 downto 6) = mult_inst else '0';

    -- dst = 7
    port_en <= nmem and inst(2) and inst(1) and inst(0);
    output_port <= low when port_en = '1' else (others => 'Z');

    data_bus1 <= low;
    data_bus2 <= high when is_mult = '1' else data;

    -- alu write back destination 
    dec_sel1_0 <= inst(3) when inst(13) = '1' else inst(0);
    dec_sel1_1 <= inst(4) when inst(13) = '1' else inst(1);
    dec_sel1_2 <= inst(5) when inst(13) = '1' else inst(2);

    -- data/high write back destination
    dec_sel2_0 <= inst(3) when is_mult = '1' else inst(0);
    dec_sel2_1 <= inst(4) when is_mult = '1' else inst(1);
    dec_sel2_2 <= inst(5) when is_mult = '1' else inst(2);

    en1 <= inst(14) and (not reset);
    en2 <= (inst(12) or is_mult) and (not reset);

    u1 : entity work.decoder port map(dec_sel1_0, dec_sel1_1, dec_sel1_2, en1, reg_sel1);
    u2 : entity work.decoder port map(dec_sel2_0, dec_sel2_1, dec_sel2_2, en2, reg_sel2);

end write_back_stage_arch;