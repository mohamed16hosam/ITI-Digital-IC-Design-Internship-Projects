module Control_Unit (
	input wire												zero,unsigned_conv,
	input wire						[4:0]					funct7,
	input wire						[6:0]					op,
	input wire						[2:0]					funct3,
	output wire											PCSrc,MemWrite,MemRead,ALUSrc,RegWrite,f,flsw,RegWritei,RegReadi,
	output wire					[1:0]					ImmSrc,ResultSrc,
	output wire					[4:0]					ALUControl
);

	wire								[1:0]					ALUOp ;
	wire														Jump,Branch ;

assign PCSrc=(zero&Branch)|Jump ;	
	
CU_main_decode MD (
.op(op),
.funct7(funct7),
.funct3(funct3),
.Branch(Branch),
.ResultSrc(ResultSrc),
.MemWrite(MemWrite),
.MemRead(MemRead),
.ALUSrc(ALUSrc),
.RegWrite(RegWrite),
.ImmSrc(ImmSrc),
.ALUOp(ALUOp),
.Jump(Jump),
.f(f),
.flsw(flsw),
.RegWritei(RegWritei),
.RegReadi(RegReadi)
) ;

ALU_Decoder AD (
.op(op),
.funct7(funct7),
.funct3(funct3),
.ALUOp(ALUOp),
.unsigned_conv(unsigned_conv),
.ALUControl(ALUControl)
);

endmodule 