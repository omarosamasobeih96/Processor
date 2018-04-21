library ieee;
use ieee.std_logic_1164.all;

entity register_file is 
	generic (n : integer := 16);
    port (databus_wr1, databus_wr2      : in std_logic_vector(n - 1 downto 0);
    sel_wr1, sel_wr2                    : in std_logic_vector(n - 1 downto 0);
    rst, clk                            : in std_logic;
    databus_rd1, databus_rd2            : out std_logic_vector(n - 1 downto 0);
    sel_rd1, sel_rd2                    : in std_logic_vector(n - 1 downto 0));

    signal r0, r1, r2, r3, r4, r5, r6, en, wr : std_logic_vector(n - 1 downto 0);
     
end entity register_file;

architecture register_file_arch of register_file is begin

    en <= sel_rd1 or sel_rd2 or sel_wr1 or sel_wr2;
    wr <= sel_wr1 or sel_wr2;

    -- TODO make selection one bit only

    r0 <= databus_wr1 when sel_wr1 = x"01"
        else databus_wr2 when sel_wr2 = x"01"
        else (others => 'Z');

    r1 <= databus_wr1 when sel_wr1 = x"02"
        else databus_wr2 when sel_wr2 = x"02"
        else (others => 'Z');
    
    r2 <= databus_wr1 when sel_wr1 = x"04"
        else databus_wr2 when sel_wr2 = x"04"
        else (others => 'Z');
    
    r3 <= databus_wr1 when sel_wr1 = x"08"
        else databus_wr2 when sel_wr2 = x"08"
        else (others => 'Z');
    
    r4 <= databus_wr1 when sel_wr1 = x"10"
        else databus_wr2 when sel_wr2 = x"10"
        else (others => 'Z');
    
    r5 <= databus_wr1 when sel_wr1 = x"20"
        else databus_wr2 when sel_wr2 = x"20"
        else (others => 'Z');
    
    r6 <= databus_wr1 when sel_wr1 = x"40"
        else databus_wr2 when sel_wr2 = x"40"
        else (others => 'Z');
    
    databus_rd1 <= r0 when sel_rd1 = x"01"
        else r1 when sel_rd1 = x"02"
        else r2 when sel_rd1 = x"04"
        else r3 when sel_rd1 = x"08"
        else r4 when sel_rd1 = x"10"
        else r5 when sel_rd1 = x"20"
        else r6 when sel_rd1 = x"40"
        else (others => 'Z');
        
    databus_rd2 <= r0 when sel_rd2 = x"01"
        else r1 when sel_rd2 = x"02"
        else r2 when sel_rd2 = x"04"
        else r3 when sel_rd2 = x"08"
        else r4 when sel_rd2 = x"10"
        else r5 when sel_rd2 = x"20"
        else r6 when sel_rd2 = x"40"
        else (others => 'Z');
    
    u0 : entity work.reg generic map (n => n) port map (r0, rst, clk, en(0), wr(0));
    u1 : entity work.reg generic map (n => n) port map (r1, rst, clk, en(1), wr(1));
    u2 : entity work.reg generic map (n => n) port map (r2, rst, clk, en(2), wr(2));
    u3 : entity work.reg generic map (n => n) port map (r3, rst, clk, en(3), wr(3));
    u4 : entity work.reg generic map (n => n) port map (r4, rst, clk, en(4), wr(4));	
    u5 : entity work.reg generic map (n => n) port map (r5, rst, clk, en(5), wr(5));	
    u6 : entity work.reg generic map (n => n) port map (r6, rst, clk, en(6), wr(6));
	
end register_file_arch;