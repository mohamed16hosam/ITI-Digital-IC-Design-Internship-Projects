module Control_Unit (
	input wire												zero,funct7,
	input wire						[6:0]					op,
	input wire						[2:0]					funct3,
	output wire											PCSrc,MemWrite,MemRead,ALUSrc,RegWrite,
	output wire					[1:0]					ImmSrc,ResultSrc,
	output wire					[2:0]					ALUControl
);

	wire								[1:0]					ALUOp ;
	wire														Jump,Branch ;

assign PCSrc=(zero&Branch)|Jump ;	
	
CU_main_decode MD (
.op(op),
.Branch(Branch),
.ResultSrc(ResultSrc),
.MemWrite(MemWrite),
.MemRead(MemRead),
.ALUSrc(ALUSrc),
.RegWrite(RegWrite),
.ImmSrc(ImmSrc),
.ALUOp(ALUOp),
.Jump(Jump)
) ;

ALU_Decoder AD (
.op5(op[5]),
.funct7(funct7),
.funct3(funct3),
.ALUOp(ALUOp),
.ALUControl(ALUControl)
);

endmodule 