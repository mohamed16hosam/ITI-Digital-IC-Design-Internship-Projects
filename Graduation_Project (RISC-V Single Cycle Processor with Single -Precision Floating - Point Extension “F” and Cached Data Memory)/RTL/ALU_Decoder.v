module ALU_Decoder (
	input wire					[6:0]						op,
	input wire					[4:0]						funct7,	
	input wire					[2:0]						funct3,
	input wire					[1:0]						ALUOp,
	input wire												unsigned_conv,
	output reg					[4:0]						ALUControl
);

	wire 							[1:0]						inter ;
	
	assign inter={op[5],funct7[3]} ;

always @(*)
	begin
		case(ALUOp)
			2'b0: begin
						ALUControl=5'b0 ;
					end
			2'b1: begin
						ALUControl=5'b1 ;
					end
			2'b10: begin
						case(funct3)
							3'b0: begin
										if(inter<2'b11)
											ALUControl=5'b0 ;
										else
											ALUControl=5'b1 ;
									end
							3'b10: begin
										ALUControl=5'b101 ;
									 end
							3'b110: begin
										ALUControl=5'b11 ;
									   end
							3'b111: begin
										ALUControl=5'b10 ;
									   end
							default: begin
											ALUControl=5'b0 ;
										end
						endcase
					 end
			2'b11: begin
						if(op==7'b1010011)
							begin
								case(funct7)
									5'b0: begin //fadd
												ALUControl=5'b100 ;
											end
									5'b1: begin //fsub
												ALUControl=5'b111 ;
											end
									5'b100: begin 
												if(funct3==3'b0)
													ALUControl=5'b1000 ; //sign injection
												else if(funct3==3'b1)
													ALUControl=5'b1001 ; //n-sign injection
												else
													ALUControl=5'b1010 ; //xor-sign injection
											   end
									5'b101: begin 
												if(funct3==3'b0)
													ALUControl=5'b1011 ; //min
												else
													ALUControl=5'b1100 ; //max
											   end
									5'b10100: begin 
												if(funct3==3'b10)
													ALUControl=5'b1101 ; //feq
												else if(funct3==3'b1)
													ALUControl=5'b1110 ; //flt
												else
													ALUControl=5'b1111 ; //fle
											   end
									5'b11100: begin
													if(funct3==3'b1)
														ALUControl=5'b10001 ; //fclass
													else
														ALUControl=5'b10010 ; //fmov to integer register												
												  end
									5'b11110: ALUControl=5'b10010 ; //fmov to fp register
									5'b11000: begin//fconv to int
													if(unsigned_conv)
														ALUControl=5'b10100 ; //unsigned_conv
													else
														ALUControl=5'b10101 ; //signed_conv														
												  end									
									5'b11010: begin//fconv to float
													if(unsigned_conv)
														ALUControl=5'b10110 ; //unsigned_conv
													else
														ALUControl=5'b10111 ; //signed_conv														
												  end
									default: begin
													ALUControl=5'b100 ;													
												end
								endcase						
							end
						else if(op==7'b111) //flw
							begin
								ALUControl=5'b10000 ;
							end
						else
							begin
								ALUControl=5'b10011 ;
							end
					 end
			default: begin
							ALUControl=5'b0 ;
						end
		endcase
	end

endmodule