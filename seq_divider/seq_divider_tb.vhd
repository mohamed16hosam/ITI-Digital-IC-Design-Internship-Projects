LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use std.textio.all ;
use ieee.std_logic_textio.all ;
use work.seq_divider_package.all ;
-- USE ieee.std_logic_arith.ALL;
-- use ieee.numeric_bit.all;

entity seq_divider_tb is
	generic (N: integer := 4) ;
end entity seq_divider_tb ;

architecture restored_seq_divider of seq_divider_tb is
	component seq_divider is
		generic (N: integer :=4) ;	
		port ( a: in signed (N-1 downto 0); b: in signed (N-1 downto 0); clk, RST, start: in std_logic ; m: out signed (N-1 downto 0) ; r: out signed (N-1 downto 0); error, busy, valid: out std_logic);
	end component seq_divider ;
	
	signal 	a_tb: signed (N-1 downto 0);
	signal	b_tb: signed (N-1 downto 0);
	signal	clk_tb, RST_tb, start_tb: std_logic ;				
	signal	m_tb: signed (N-1 downto 0) ;
	signal	r_tb: signed (N-1 downto 0);
	signal	error_tb, busy_tb, valid_tb: std_logic ;
	
	begin
		behav: seq_divider port map(a=>a_tb, b=>b_tb, clk=>clk_tb, RST=>RST_tb, start=>start_tb, m=>m_tb, r=>r_tb, error=>error_tb, busy=>busy_tb, valid=>valid_tb) ;
		
		clock:process is
			begin
				clk_tb<='0', '1' after 5 ns ;   -- clock period=20 ns
				wait for 10 ns ;
			end process clock ;		
		
		prc: process is
			begin				
				seq_divider_procedure(a_tb, b_tb, clk_tb, RST_tb, start_tb, m_tb, r_tb, error_tb, busy_tb, valid_tb) ;				
				
				wait ;								
			end process prc ;
	end architecture restored_seq_divider ;