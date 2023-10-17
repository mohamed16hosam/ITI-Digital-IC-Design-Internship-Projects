LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.all;
USE ieee.std_logic_arith.ALL;

package log2_ceil_func is
	function log2ceil (n : integer) return integer ;
end package log2_ceil_func ; 

package body log2_ceil_func is
	function log2ceil (n : integer) return integer is 
		variable m, p : integer;
		begin
		m := 0;
		p := 1;
		for i in 0 to n loop
		if p < n then
		m := m + 1;
		p := p * 2;
		end if;
		end loop;
		return m;

	end log2ceil ;
end package body ;

