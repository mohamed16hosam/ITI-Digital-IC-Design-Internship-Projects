LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use std.textio.all ;
use ieee.std_logic_textio.all ;
-- USE ieee.std_logic_arith.ALL;

package seq_divider_package is
	constant N: integer := 4 ;
	procedure seq_divider_procedure 	(	signal a_tb: inout signed (N-1 downto 0);
														signal b_tb: inout signed (N-1 downto 0);
														signal clk_tb: in std_logic ;
														signal RST_tb, start_tb: inout std_logic ;				
														signal m_tb: in signed (N-1 downto 0) ;
														signal r_tb: in signed (N-1 downto 0);
														signal error_tb, busy_tb, valid_tb: in std_logic ) ;
end package seq_divider_package ; 

package body seq_divider_package is
	procedure seq_divider_procedure (	signal a_tb: inout signed (N-1 downto 0);
														signal b_tb: inout signed (N-1 downto 0);
														signal clk_tb: in std_logic ;
														signal RST_tb, start_tb: inout std_logic ;				
														signal m_tb: in signed (N-1 downto 0) ;
														signal r_tb: in signed (N-1 downto 0);
														signal error_tb, busy_tb, valid_tb: in std_logic ) is 
			file vectors_f: text open READ_MODE is "seq_divider_test_cases.txt" ;
			file results_f: text open write_mode is "seq_divider_results.txt" ;
			variable stimuli_l, res_l: line ;
			variable pause: time ;
			variable a_text: std_logic_vector (N-1 downto 0);
			variable b_text: std_logic_vector (N-1 downto 0);
			variable m_expec: std_logic_vector (N-1 downto 0); 
			variable r_expec: std_logic_vector (N-1 downto 0); 
			variable error_expec, busy_expec, valid_expec: std_logic ;			
			variable start_text: std_logic ;
			variable msg: string(1 to 43) ;
			variable z,i,j: integer ;		
			
			begin
					i:=0 ;
					j:=0 ;
					z:=0 ;
					RST_tb<='1' ;
					-- clk_tb<='0' ;
					start_tb<='0' ;
					a_tb<=(others=>'0') ;
					b_tb<=(N-1 downto 1=>'0') & '1' ;
					wait for 10 ns ;
					RST_tb<='0' ;
					
					while not endfile (vectors_f) loop
					
					readline (vectors_f, stimuli_l) ;				
					writeline (results_f, stimuli_l) ;
					
					readline (vectors_f, stimuli_l) ;
					read (stimuli_l, start_text) ;					
					read (stimuli_l, a_text) ;			
					read (stimuli_l, b_text) ;
					start_tb<=start_text ;
					a_tb<=signed(a_text) ;
					b_tb<=signed(b_text) ;				
					read (stimuli_l, pause) ;
					wait for pause ;
					read (stimuli_l, start_text) ;
					start_tb<=start_text ;					
					read (stimuli_l, error_expec) ;	
					read (stimuli_l, busy_expec) ;
					read (stimuli_l, valid_expec) ;
					write (res_l, string'("a= ")) ;
					write (res_l, to_integer(a_tb)) ;				
					write (res_l, string'(", b= ")) ;
					write (res_l, to_integer(b_tb)) ;					
					if(error_tb=error_expec) then
					write (res_l, string'(", error signal is as expected, ")) ;
					else
					write (res_l, string'(", error signal is unexpected, ")) ;
					end if ;	
					if(busy_tb=busy_expec) then
					write (res_l, string'(", busy signal is as expected, ")) ;
					else
					write (res_l, string'(", busy signal is unexpected, ")) ;
					end if ;
					if(valid_tb=valid_expec) then
					write (res_l, string'(", valid signal is as expected, ")) ;
					else
					write (res_l, string'(", valid signal is unexpected, ")) ;
					end if ;
					if ((error_tb=error_expec)and(busy_tb=busy_expec)and(valid_tb=valid_expec)) then				
						j:=j+1 ;
					end if ;				
					read (stimuli_l, pause) ;
					wait for pause ;
					read (stimuli_l, valid_expec) ;	
					read (stimuli_l, m_expec) ;
					read (stimuli_l, r_expec) ;	
					read (stimuli_l, busy_expec) ;

					write (res_l, string'(", m= ")) ;
					write (res_l, to_integer(m_tb)) ;				
					write (res_l, string'(", r= ")) ;
					write (res_l, to_integer(r_tb)) ;				
					
					if(busy_tb=busy_expec) then
					write (res_l, string'(", busy signal is as expected, ")) ;
					else
					write (res_l, string'(", busy signal is unexpected, ")) ;
					end if ;
					if(valid_tb=valid_expec) then
					write (res_l, string'(", valid signal is as expected, ")) ;
					else
					write (res_l, string'(", valid signal is unexpected, ")) ;
					end if ;		
					if(m_tb=signed(m_expec)) then
					write (res_l, string'(", m signal is as expected, ")) ;
					else
					write (res_l, string'(", m signal is unexpected, ")) ;
					end if ;
					if(r_tb=signed(r_expec)) then
					write (res_l, string'(", r signal is as expected, ")) ;
					else
					write (res_l, string'(", r signal is unexpected, ")) ;
					end if ;				

					if ((m_tb=signed(m_expec))and(busy_tb=busy_expec)and(valid_tb=valid_expec)and(r_tb=signed(r_expec))) then				
						i:=i+1 ;
					end if ;
					
					-- write (res_l, string'(", a= ")) ;
					-- write (res_l, to_integer(a_tb)) ;				
					-- write (res_l, string'(", b= ")) ;
					-- write (res_l, to_integer(b_tb)) ;			
					-- write (res_l, string'(", m= ")) ;
					-- write (res_l, to_integer(m_tb)) ;				
					-- write (res_l, string'(", r= ")) ;
					-- write (res_l, to_integer(unsigned(r_tb))) ;
				
					writeline (results_f, res_l) ;									
					
					end loop ;

					if i<j then
						z:=i ;
					elsif i>j then
						z:=j ;
					else
						z:=i ;
					end if ;				
					
					write (res_l, string'("The total number of passed testcases as a ratio from the total testcases is: ")) ;
					write (res_l, z) ;
					write (res_l, string'("/6")) ;
					writeline (results_f, res_l) ;

					wait for 10 ns ;
					
	end procedure seq_divider_procedure ;
end package body ;