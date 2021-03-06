library ieee;
use ieee.std_logic_1164.all;

entity memory_stage is
    generic (n : integer := 16; m : integer := 9);
    port (mar, mdr          : in std_logic_vector(n - 1 downto 0);
    reset, clk              : in std_logic;
    data  				    : out std_logic_vector(n - 1 downto 0);
    inst, low, high         : in std_logic_vector(n - 1 downto 0);
    inst_o, low_o, high_o   : out std_logic_vector(n - 1 downto 0));

    signal we			 	: std_logic;
    signal actual_add 	    : std_logic_vector(m - 1 downto 0);
    constant nop : std_logic_vector(n - 1 downto 0) := (others => '0');
    
end entity memory_stage;

architecture memory_stage_arch of memory_stage is begin
	-- we = write enable
    we <= inst(11) and (not reset) and inst(13);
    actual_add <= low(m-1 downto 0) when we = '0' else mar(m-1 downto 0);

	inst_o <= nop when reset = '1' else inst;
	low_o <= low;
	high_o <= high;

    u : entity work.data_memory port map(clk, we, actual_add, mdr, data);
end memory_stage_arch;