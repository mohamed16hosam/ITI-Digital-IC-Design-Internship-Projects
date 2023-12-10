module RISC_V_SC_tb () ;

reg										clk_tb,RST_tb ;

RISC_V_SC_top RVSC (
.clk(clk_tb),
.RST(RST_tb)
);


initial
	begin
		RST_tb=1'b0 ;
		clk_tb=1'b0 ;
		#10 ;
		RST_tb=1'b1 ;
		#6000 ;
		$finish ;
	end

always #5 clk_tb=~clk_tb ;	
	
endmodule