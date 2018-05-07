library ieee;
use ieee.std_logic_1164.all;

entity dff is 
	port (	d, rst, clk, enable : in std_logic;
		q : out std_logic );
end entity dff;

architecture dff_arch of dff is
begin
	process(clk, rst)
	begin
		if (rst = '1') then
			q <= '0';
		elsif falling_edge(clk) then
			if enable = '1' then
				q <= d;
			end if;
		end if;
	end process;
end dff_arch;