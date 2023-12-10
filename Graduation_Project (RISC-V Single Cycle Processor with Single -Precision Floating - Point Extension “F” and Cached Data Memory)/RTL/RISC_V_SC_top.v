module RISC_V_SC_top(
	input wire										clk,RST
);

	wire						[31:0]				PCTarget,PCPlus4,SrcA,Instr,PC,PCNext,SrcB,ImmExt,RD2,Result,ReadData,ALUResult ;
	wire												zero,RegWrite,RegWritei,RegReadi,MemWrite,MemRead,PCSrc,ALUSrc,stall,f,flsw,NV,DZ,OF,UF,NX ;
	wire						[1:0]					ImmSrc,ResultSrc ;
	wire						[4:0]					ALUControl ;

assign PCNext=(PCSrc) ? PCTarget : PCPlus4 ;
assign SrcB=(ALUSrc) ? ImmExt : RD2 ;
assign Result=(ResultSrc==2'b0) ? ALUResult :
					 (ResultSrc==2'b1) ? ReadData :
					 (ResultSrc==2'b10) ? PCPlus4 : ALUResult ;

PC pc0 (
.clk(clk),
.RST(RST),
.stall(stall),
.PCNext(PCNext),
.PC(PC)	
);

Instruct_mem im (
.A(PC),
.Instr(Instr)
);

Data_mem_system dms (
.clk(clk),
.RST(RST),
.MemWrite(MemWrite),
.MemRead(MemRead),
.stall(stall),
.WA(ALUResult[9:0]),
.Data_in(RD2),
.Data_out(ReadData)
);

RF rf0 (
.clk(clk),
.RST(RST),
.WE3(RegWrite),
.A1(Instr[19:15]),
.A2(Instr[24:20]),
.A3(Instr[11:7]),
.WD3(Result),
.RD1(SrcA),
.RD2(RD2),
.f(f),
.flsw(flsw),
.RegWritei(RegWritei),
.RegReadi(RegReadi),
.NV(NV),
.DZ(DZ),
.OF(OF),
.UF(UF),
.NX(NX)
);

Control_Unit cu (
.zero(zero),
.unsigned_conv(Instr[20]),
.funct7(Instr[31:27]),
.op(Instr[6:0]),
.funct3(Instr[14:12]),
.PCSrc(PCSrc),
.ResultSrc(ResultSrc),
.MemWrite(MemWrite),
.MemRead(MemRead),
.ALUSrc(ALUSrc),
.RegWrite(RegWrite),
.ImmSrc(ImmSrc),
.ALUControl(ALUControl),
.f(f),
.flsw(flsw),
.RegWritei(RegWritei),
.RegReadi(RegReadi)
);

ALU alu0 (
.SrcA(SrcA),
.SrcB(SrcB),
.f(f),
.ALUControl(ALUControl),
.RoundResult(ALUResult),
.NV(NV),
.DZ(DZ),
.OF(OF),
.UF(UF),
.NX(NX),
.Zero(zero)
);

PCPlus4 pcp4 (
.PC(PC),
.PCPlus4(PCPlus4)
);

PCTarget pct (
.PC(PC),
.ImmExt(ImmExt),
.PCTarget(PCTarget)
);

Extend ext (
.Imm(Instr[31:7]),
.ImmSrc(ImmSrc),
.ImmExt(ImmExt)
);

endmodule