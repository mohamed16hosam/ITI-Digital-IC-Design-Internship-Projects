module seq_multiplier #(parameter N=4)(
	input wire					[N-1:0]				a,b,
	input wire												clk, RST, start,				
	output reg					[N-1:0]				m,r,
	output wire												busy, valid
);

	reg					[$clog2(N):0]					counter ;
	reg					[(2*N)-1:0]					result ;
	reg					[N-1:0]							a_reg,b_reg ;
	reg															valid_reg ;
	
	assign busy=(start | ((counter>='b1)&(counter<=N))) ;
	assign valid=valid_reg ;
	
always@(posedge clk or negedge RST)
	begin
		if(!RST)
			begin
				counter<='b0 ;
				result<='b0 ;
				a_reg<='b0 ;
				b_reg<='b0 ;
				valid_reg<=1'b0 ;
				m<='b0 ;
				r<='b0 ;
			end
		else if(start)
			begin
				valid_reg<=1'b0 ;
				counter<=counter+1'b1 ;
				a_reg<=a ;
				b_reg<=b ;
				result<=a & {N{b[counter]}} ;				
			end
		else if((counter>='b1)&(counter<=(N-1)))
			begin
				counter<=counter+1'b1 ;
				result<=result+((a_reg & {N{b_reg[counter]}})<<(counter)) ;
			end
		else if(counter>=N)
			begin
				m<=result[N-1:0] ;
				r<=result[(2*N)-1:N] ;
				valid_reg<=1'b1 ;
				counter<='b0 ;
				result<='b0 ;
				a_reg<='b0 ;
				b_reg<='b0 ;
			end
		else
			begin
				valid_reg<=1'b0 ;
			end
	end

endmodule