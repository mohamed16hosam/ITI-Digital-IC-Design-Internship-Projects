module ALU_Decoder (
	input wire												op5,funct7,
	input wire					[2:0]						funct3,
	input wire					[1:0]						ALUOp,
	output reg					[2:0]						ALUControl
);

	wire 							[1:0]						inter ;
	
	assign inter={op5,funct7} ;

always @(*)
	begin
		case(ALUOp)
			2'b0: begin
						ALUControl=3'b0 ;
					end
			2'b1: begin
						ALUControl=3'b1 ;
					end
			2'b10: begin
						case(funct3)
							3'b0: begin
										if(inter<2'b11)
											ALUControl=3'b0 ;
										else
											ALUControl=3'b1 ;
									end
							3'b10: begin
										ALUControl=3'b101 ;
									 end
							3'b110: begin
										ALUControl=3'b11 ;
									   end
							3'b111: begin
										ALUControl=3'b10 ;
									   end
							default: begin
											ALUControl=3'b0 ;
										end
						endcase
					 end
			default: begin
							ALUControl=3'b0 ;
						end
		endcase
	end

endmodule