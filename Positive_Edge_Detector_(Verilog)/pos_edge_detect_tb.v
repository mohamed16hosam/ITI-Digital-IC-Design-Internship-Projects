module pos_edge_detect_tb () ;

	reg							clk_tb,sig_tb ;
	wire							pe_tb ;	

	pos_edge_detect dut (
	.clk(clk_tb),
	.sig(sig_tb),
	.pe(pe_tb)
	) ;
	
initial 
	begin
		clk_tb=1'b0 ;
		sig_tb=1'b0 ;
		#10
		sig_tb=1'b1 ;
		#20
		sig_tb=1'b0 ;
		#10		
		$finish ;
	end

always #5 clk_tb=~clk_tb ;	
	
endmodule