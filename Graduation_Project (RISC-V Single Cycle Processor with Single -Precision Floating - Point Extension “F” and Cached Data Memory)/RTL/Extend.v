module Extend (
	input wire					[24:0]				Imm,
	input wire					[1:0]					ImmSrc,
	output reg					[31:0]				ImmExt
);

always@(*)
	begin
		case(ImmSrc)
		2'b0: begin
					ImmExt= {{20{Imm[24]}},Imm[24:13]} ;					
				end
		2'b1: begin
					ImmExt= {{20{Imm[24]}},Imm[24:18],Imm[4:0]} ;					
				end
		2'b10: begin
					ImmExt= {{20{Imm[24]}},Imm[0],Imm[23:18],Imm[4:1],1'b0} ;						
				 end
		2'b11: begin
					ImmExt= {{12{Imm[24]}},Imm[12:5],Imm[13],Imm[23:14],1'b0} ;						
				 end				 
		default: begin
						ImmExt= {{20{Imm[24]}},Imm[24:13]} ;								
					end
		endcase
	end

endmodule