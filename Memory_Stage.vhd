library ieee;
use ieee.std_logic_1164.all;

entity memory_stage is
    generic (n : integer := 16; m : integer := 10);
    port (mar, mdr      : in std_logic_vector(n - 1 downto 0);
    reset, clk          : in std_logic;
    data  				: out std_logic_vector(n - 1 downto 0);
    inst, low, high     : inout std_logic_vector(n - 1 downto 0));

    signal mem_en, we, wr 	: std_logic;
    signal actual_add 	: std_logic_vector(m - 1 downto 0);
end entity memory_stage;

architecture memory_stage_arch of memory_stage is begin
    mem_en <= (not reset) and ((inst(15) and (not inst(14))) or inst(13));
    wr <= (not inst(12)) when inst(15) = '1' and inst(14) = '0' else inst(11);
    we <= wr and mem_en;
    actual_add <= low(9 downto 0) when we = '1' else mar(9 downto 0);

    u : entity work.data_memory port map(clk, we, actual_add, mdr, data);
end memory_stage_arch;