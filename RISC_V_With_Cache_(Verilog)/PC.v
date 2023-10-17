module PC (
	input wire												clk,RST,stall,
	input wire 				[31:0]					PCNext,
	output reg					[31:0]					PC	
);

always@(posedge clk or negedge RST)
	begin
		if(!RST)
			begin
				PC<=32'b0 ;
			end
		else if(!stall)
			begin
				PC<=PCNext ;				
			end
	end

endmodule