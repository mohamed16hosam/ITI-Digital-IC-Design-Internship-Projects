module CU_main_decode (
	input wire						[6:0]					op,
	output reg												Jump,Branch,MemWrite,MemRead,ALUSrc,RegWrite,
	output reg						[1:0]					ImmSrc,ALUOp,ResultSrc
);

always@(*)
	begin
		case(op)
			7'b11: begin
						RegWrite=1'b1 ;
						ImmSrc=2'b0 ;
						ALUSrc=1'b1 ;
						MemWrite=1'b0 ;
						MemRead=1'b1 ;
						ResultSrc=2'b1 ;
						Branch=1'b0 ;
						ALUOp=2'b0 ;
						Jump=1'b0 ;
					 end
			7'b100011: begin
						RegWrite=1'b0 ;
						ImmSrc=2'b1 ;
						ALUSrc=1'b1 ;
						MemWrite=1'b1 ;
						MemRead=1'b0 ;						
						ResultSrc=2'b1 ;
						Branch=1'b0 ;
						ALUOp=2'b0 ;
						Jump=1'b0 ;						
					 end
			7'b110011: begin
						RegWrite=1'b1 ;
						ImmSrc=2'b0 ;
						ALUSrc=1'b0 ;
						MemWrite=1'b0 ;
						MemRead=1'b0 ;								
						ResultSrc=2'b0 ;
						Branch=1'b0 ;
						ALUOp=2'b10 ;
						Jump=1'b0 ;						
					 end
			7'b1100011: begin
						RegWrite=1'b0 ;
						ImmSrc=2'b10 ;
						ALUSrc=1'b0 ;
						MemWrite=1'b0 ;
						MemRead=1'b0 ;								
						ResultSrc=2'b0 ;
						Branch=1'b1 ;
						ALUOp=2'b1 ;
						Jump=1'b0 ;						
					 end
			7'b10011: begin
						RegWrite=1'b1 ;
						ImmSrc=2'b0 ;
						ALUSrc=1'b1 ;
						MemWrite=1'b0 ;
						MemRead=1'b0 ;								
						ResultSrc=2'b0 ;
						Branch=1'b0 ;
						ALUOp=2'b10 ;
						Jump=1'b0 ;						
					 end
			7'b1101111: begin
						RegWrite=1'b1 ;
						ImmSrc=2'b11 ;
						ALUSrc=1'b1 ;
						MemWrite=1'b0 ;
						MemRead=1'b0 ;								
						ResultSrc=2'b10 ;
						Branch=1'b0 ;
						ALUOp=2'b10 ;
						Jump=1'b1 ;						
					 end					 
			default: begin
						RegWrite=1'b1 ;
						ImmSrc=2'b0 ;
						ALUSrc=1'b0 ;
						MemWrite=1'b0 ;
						MemRead=1'b0 ;								
						ResultSrc=2'b0 ;
						Branch=1'b0 ;
						ALUOp=2'b10 ;
						Jump=1'b0 ;						
					 end					 
		endcase
	end

endmodule