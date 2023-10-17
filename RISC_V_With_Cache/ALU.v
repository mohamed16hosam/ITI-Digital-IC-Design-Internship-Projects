module ALU (
	input wire					[31:0]				SrcA,SrcB,
	input wire					[2:0]					ALUControl,
	output reg					[31:0]				ALUResult,
	output wire										Zero
);

assign Zero=(SrcA==SrcB) ;

always@(*)
	begin
		case(ALUControl)
			3'b0: ALUResult=SrcA+SrcB ;
			3'b1: ALUResult=SrcA-SrcB ;
			3'b10: ALUResult=SrcA & SrcB ;
			3'b11: ALUResult=SrcA | SrcB ;
			3'b101: ALUResult= {31'b0,(SrcA<SrcB)} ;
			default: ALUResult=SrcA+SrcB ;
			endcase
	end

endmodule