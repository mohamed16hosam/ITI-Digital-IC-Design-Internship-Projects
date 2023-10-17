module pos_edge_detect (
	input wire 			clk,sig,
	output wire			pe
);

reg sig_delayed ;

assign pe=(sig&~sig_delayed) ? 1'b1:1'b0 ; 

always@(posedge clk)
	begin
		sig_delayed<=sig ;
	end

endmodule