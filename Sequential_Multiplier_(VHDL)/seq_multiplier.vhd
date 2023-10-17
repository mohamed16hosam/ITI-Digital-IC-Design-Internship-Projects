LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.all;
-- USE ieee.std_logic_arith.ALL;
use work.log2_ceil_func.all ;
-- use ieee.numeric_bit.all;

entity seq_multiplier is
	generic (N: integer :=4) ;
	port (	a: in signed (N-1 downto 0);
				b: in signed (N-1 downto 0);
				clk, RST, start: in std_logic ;				
				m: out signed (N-1 downto 0) ;
				r: out signed (N-1 downto 0);
				busy, valid: out std_logic) ;	
end entity seq_multiplier ;

architecture mult of seq_multiplier is
	signal counter: std_logic_vector ((log2ceil(N)) downto 0) ;
	signal valid_reg: std_logic ;
	begin

		busy<= '1' when (((start='1') and (not(b=(N-1 downto 0=>'0'))))or((counter>=((log2ceil(N)) downto 1=>'0') & '1')and(counter <= std_logic_vector(to_unsigned (N,log2ceil(N)+1))))) else '0' ;
		valid<= valid_reg ;
		
		multiply: process (clk,RST) is
			variable qutionet: std_logic_vector (N-1 downto 0) ;
			variable reminder, divisor: std_logic_vector ((2*N)-1 downto 0) ;
			variable sign: std_logic ;
			begin
				if RST='1' then
					m<=(others=> '0') ;
					r<=(others=> '0') ;
					qutionet:= (others=>'0') ;
					reminder:= (others=>'0') ;
					divisor:= (others=>'0') ;
					counter<= (others=>'0') ;
					sign:='0' ;
					valid_reg<='0' ;
				elsif rising_edge(clk) then
					if (not((start='1') and (b=(N-1 downto 0=>'0')))) then
						if start='1' then
							sign:=a(N-1)xor b(N-1) ;
							if a(N-1)='1' then
								reminder:= ((2*N)-1 downto N=>'0')&(not(std_logic_vector(a))+((N-1 downto 1=>'0')&'1')) ;
							else
								reminder:= ((2*N)-1 downto N=>'0')& std_logic_vector(a) ;
							end if ;
							if b(N-1)='1' then
								divisor:= (not(std_logic_vector(b))+((N-1 downto 1=>'0')&'1')) & (N-1 downto 0=>'0') ;
							else
								divisor:= std_logic_vector(b) & (N-1 downto 0=>'0') ;
							end if ;
							counter<= ((log2ceil(N)) downto 1=>'0') & '1' ;
							qutionet:= (others=>'0') ;
							valid_reg<='0' ;
							m<=(others=> '0') ;
							r<=(others=> '0') ;
						elsif ((counter>=((log2ceil(N)) downto 1=>'0') & '1')and(counter <= std_logic_vector(to_unsigned (N,log2ceil(N)+1)))) then
							reminder:= (reminder((2*N)-2 downto 0) &'0') - divisor ;
							counter<= counter+(((log2ceil(N)) downto 1=>'0')&'1') ;
							valid_reg<='0' ;
							if reminder((2*N)-1)='0' then
								qutionet:= qutionet(N-2 downto 0) & '1' ;
							else
								qutionet:= qutionet(N-2 downto 0) & '0' ;
								reminder:= reminder+divisor ;
							end if ;										
						elsif counter > std_logic_vector(to_unsigned (N,log2ceil(N))) then
								valid_reg<='1' ;
								if sign='1' then
									m<=signed(not(qutionet)+((N-1 downto 1=>'0') & '1')) ;
								else
									m<=signed(qutionet) ;
								end if ;
								r<=signed(reminder((2*N)-1 downto N)) ;		
								counter<= (others=>'0') ;								
						else
							counter<= (others=>'0') ;
							m<=(others=>'0') ;
							r<=(others=>'0') ;
							qutionet:= (others=>'0') ;
							reminder:= (others=>'0') ;
							divisor:= (others=>'0') ;
							valid_reg<='0' ;
						end if ;
					else
						counter<= (others=>'0') ;
						m<=(others=>'0') ;
						r<=(others=>'0') ;
						qutionet:= (others=>'0') ;
						reminder:= (others=>'0') ;
						divisor:= (others=>'0') ;
						valid_reg<='0' ;						
					end if ;
				end if ;
			end process multiply ;
	end architecture mult ;