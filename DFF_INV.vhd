library ieee;
use ieee.std_logic_1164.all;

entity dff_inv is 
	port (	d, rst, clk, enable : in std_logic;
		q : out std_logic );
end entity dff_inv;

architecture dff_inv_arch of dff_inv is
begin
	process(clk, rst)
	begin
		if (rst = '1') then
			q <= '1';
		elsif falling_edge(clk) then
			if enable = '1' then
				q <= d;
			end if;
		end if;
	end process;
end dff_inv_arch;
