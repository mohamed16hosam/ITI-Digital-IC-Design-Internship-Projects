module seq_multiplier_tb #(parameter N=4)() ;

	reg								[N-1:0]				a_tb,b_tb ;
	reg															clk_tb, RST_tb, start_tb ;				
	wire							[N-1:0]				m_tb,r_tb ;
	wire														busy_tb, valid_tb ;

seq_multiplier #(4) dut (
.a(a_tb),
.b(b_tb),
.clk(clk_tb), 
.RST(RST_tb), 
.start(start_tb),				
.m(m_tb),
.r(r_tb),
.busy(busy_tb), 
.valid(valid_tb)
);	

always #5 clk_tb=~clk_tb ;

initial
	begin
		clk_tb=1'b0 ;
		RST_tb=1'b0 ;
		a_tb='b0 ;
		b_tb='b0 ;
		start_tb=1'b0 ;
		#10 ;
		RST_tb=1'b1 ;
		
		a_tb='b1010 ;
		b_tb='b10 ;
		start_tb=1'b1 ;
		#10
		start_tb=1'b0 ;
		#40 
		
		a_tb='b1011 ;
		b_tb='b11 ;
		start_tb=1'b1 ;
		#10
		start_tb=1'b0 ;
		#40
 		
		$finish ;
	end
	
endmodule