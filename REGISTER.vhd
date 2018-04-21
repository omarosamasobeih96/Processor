library ieee;
use ieee.std_logic_1164.all;

entity reg is 
	generic (n : integer := 16);
	port (	reg_bus : inout std_logic_vector (n - 1 downto 0);
		rst, clk, enable, wr : in std_logic );
end entity reg;

architecture reg_arch of reg is
	component dff is 
	port (	d, rst, clk, enable : in std_logic;
		q : out std_logic );
	end component;
	signal d_enable, q_enable : std_logic;
	signal reg_d, reg_q : std_logic_vector (n - 1 downto 0);
begin
	d_enable <= enable and wr;
	q_enable <= enable and (not wr);
	reg_d <= reg_bus when d_enable = '1';
	reg_bus <= reg_q when q_enable = '1'
				else (others => 'Z');
	l: for i in 0 to n - 1 generate
          u: dff port map (reg_d(i), rst, clk, d_enable, reg_q(i));
    end generate;
end reg_arch;