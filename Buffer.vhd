library ieee;
use ieee.std_logic_1164.all;

entity internal_buffer is 
	generic (n : integer := 16);
	port (	buffer_in 		 : in std_logic_vector (n - 1 downto 0);
			buffer_out 		 : out std_logic_vector (n - 1 downto 0);
			rst, clk : in std_logic );
end entity internal_buffer;

architecture internal_buffer_arch of internal_buffer is
	component dff is 
	port (	d, rst, clk, enable : in std_logic;
		q : out std_logic );
	end component;
begin
	l: for i in 0 to n - 1 generate
          u: dff port map (buffer_in(i), rst, clk, '1', buffer_out(i));
    end generate;
end internal_buffer_arch;