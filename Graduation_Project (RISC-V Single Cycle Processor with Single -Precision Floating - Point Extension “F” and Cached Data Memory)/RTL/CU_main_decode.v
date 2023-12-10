module CU_main_decode (
	input wire						[6:0]					op,
	input wire						[4:0]					funct7,
	input wire						[2:0]					funct3,	
	output reg												Jump,Branch,MemWrite,MemRead,ALUSrc,RegWrite,f,flsw,RegWritei,RegReadi,
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
						f=1'b0 ;
						flsw=1'b0 ;
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;
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
						f=1'b0 ;					
						flsw=1'b0 ;
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;						
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
						f=1'b0 ;			
						flsw=1'b0 ;
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;						
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
						f=1'b0 ;			
						flsw=1'b0 ;
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;						
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
						f=1'b0 ;			
						flsw=1'b0 ;
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;						
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
						f=1'b0 ;			
						flsw=1'b0 ;
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;						
					 end
			// 7'b1000011: begin //1-fmadd
						// RegWrite=1'b1 ;
						// ImmSrc=2'b11 ;
						// ALUSrc=1'b0 ;
						// MemWrite=1'b0 ;
						// MemRead=1'b0 ;								
						// ResultSrc=2'b0 ;
						// Branch=1'b0 ;
						// ALUOp=2'b11 ;
						// Jump=1'b0 ;
						// f=1'b1 ;		
						// flsw=1'b0 ;
						// 						
					 // end				
			// 7'b1000111: begin //2-fmsub
						// RegWrite=1'b1 ;
						// ImmSrc=2'b11 ;
						// ALUSrc=1'b0 ;
						// MemWrite=1'b0 ;
						// MemRead=1'b0 ;								
						// ResultSrc=2'b0 ;
						// Branch=1'b0 ;
						// ALUOp=2'b11 ;
						// Jump=1'b0 ;
						// f=1'b1 ;	
						// flsw=1'b0 ;
						// 						
					 // end			
			// 7'b1001011: begin //3-fnmadd
						// RegWrite=1'b1 ;
						// ImmSrc=2'b11 ;
						// ALUSrc=1'b0 ;
						// MemWrite=1'b0 ;
						// MemRead=1'b0 ;								
						// ResultSrc=2'b0 ;
						// Branch=1'b0 ;
						// ALUOp=2'b11 ;
						// Jump=1'b0 ;
						// f=1'b1 ;		
						// flsw=1'b0 ;
						// 						
					 // end				
			// 7'b1001111: begin //4-fnmsub
						// RegWrite=1'b1 ;
						// ImmSrc=2'b11 ;
						// ALUSrc=1'b0 ;
						// MemWrite=1'b0 ;
						// MemRead=1'b0 ;								
						// ResultSrc=2'b0 ;
						// Branch=1'b0 ;
						// ALUOp=2'b11 ;
						// Jump=1'b0 ;
						// f=1'b1 ;	
						// flsw=1'b0 ;
						// 						
					 // end					 
			7'b1010011: begin //5-fadd/sub and other R types...
						RegWrite=1'b1 ;
						ImmSrc=2'b11 ;
						ALUSrc=1'b0 ;
						MemWrite=1'b0 ;
						MemRead=1'b0 ;								
						ResultSrc=2'b0 ;
						Branch=1'b0 ;
						ALUOp=2'b11 ;
						Jump=1'b0 ;
						f=1'b1 ;			
						flsw=1'b0 ;
						if(funct7==5'b11000)
							begin
								RegReadi=1'b0 ;
								RegWritei=1'b1 ;								
							end	
						else if(funct7==5'b11010)
							begin
								RegReadi=1'b1 ;
								RegWritei=1'b0 ;								
							end						
						else if((funct7==5'b11100)&((funct3==3'b0)|(funct3==3'b1)))
							begin
								RegReadi=1'b0 ;
								RegWritei=1'b1 ;								
							end
						else if((funct7==5'b11110)&(funct3==3'b0))
							begin
								RegReadi=1'b1 ;
								RegWritei=1'b0 ;
							end									
						else
							begin
								RegReadi=1'b0 ;
								RegWritei=1'b0 ;
							end							
					 end	
			7'b111: begin //6-fLW
						RegWrite=1'b1 ;
						ImmSrc=2'b0 ;
						ALUSrc=1'b1 ;
						MemWrite=1'b0 ;
						MemRead=1'b1 ;
						ResultSrc=2'b1 ;
						Branch=1'b0 ;
						ALUOp=2'b0 ;
						Jump=1'b0 ;
						f=1'b1 ;
						flsw=1'b1 ;	
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;						
					 end
			7'b100111: begin //7-fSW
						RegWrite=1'b0 ;
						ImmSrc=2'b1 ;
						ALUSrc=1'b1 ;
						MemWrite=1'b1 ;
						MemRead=1'b0 ;						
						ResultSrc=2'b1 ;
						Branch=1'b0 ;
						ALUOp=2'b0 ;
						Jump=1'b0 ;
						f=1'b1 ;
						flsw=1'b1 ;
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;						
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
						f=1'b0 ;
						flsw=1'b0 ;
						RegWritei=1'b0 ;
						RegReadi=1'b0 ;						
					 end					 
		endcase
	end

endmodule