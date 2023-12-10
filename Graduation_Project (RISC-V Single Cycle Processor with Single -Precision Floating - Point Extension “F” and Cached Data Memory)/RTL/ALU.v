module ALU (
	input wire					[31:0]				SrcA,SrcB,
	input wire											f,
	input wire					[4:0]					ALUControl,
	output reg					[31:0]				RoundResult,
	output reg											NV,DZ,OF,UF,NX,
	output wire										Zero
);

	reg							[54:0]				int_conv_reg, f_conv_reg ;
	reg 													sign,g,r,s ;
	reg							[24:0]				check ;
	reg							[7:0]					exp ;
	reg							[4:0]					j ;
	reg							[31:0]				shift,ALUResult,signed_int ;

	integer i ;
	
assign Zero=(SrcA==SrcB) ;

always@(*)
	begin
		sign=1'b0 ;
		check=25'b0 ;
		j=5'b0 ;
		{g,r,s}=3'b0 ;
		exp=8'b0 ;
		shift=32'b0 ;
		NV=1'b0 ;
		DZ=1'b0 ;
		OF=1'b0 ;
		UF=1'b0 ;
		NX=1'b0 ;
		int_conv_reg=55'b0 ;
		f_conv_reg=55'b0 ;
		signed_int=32'b0 ;
		case(ALUControl)
			5'b0: ALUResult=SrcA+SrcB ;
			5'b1: ALUResult=SrcA-SrcB ;
			5'b10: ALUResult=SrcA & SrcB ;
			5'b11: ALUResult=SrcA | SrcB ;
			5'b101: ALUResult= {31'b0,(SrcA<SrcB)} ;
			//Next is floating operations
			5'b100: begin
								 sign=SrcA[31]^SrcB[31] ;
								 if((SrcA[30:0]==31'b0)&(SrcB[30:0]==31'b0))
									ALUResult=32'b0 ;
								 else if(SrcA[30:0]==31'b0)
									ALUResult=SrcB ;
								 else if(SrcB[30:0]==31'b0)
									ALUResult=SrcA ;
								 else if((SrcA[30:0]==31'h7f800000)&(SrcB[30:0]==31'h7f800000))
									ALUResult={SrcA[31]|SrcB[31],31'h7fc00000} ;
								 else if(SrcA[30:0]==31'h7f800000)
									ALUResult=SrcA ;
								 else if(SrcB[30:0]==31'h7f800000)
									ALUResult=SrcB ;
								 else if((SrcA[30:0]==31'h7fc00000)|(SrcB[30:0]==31'h7fc00000)|(SrcA[30:0]==31'h7fb00000)|(SrcB[30:0]==31'h7fb00000))
									ALUResult={SrcA[31]|SrcB[31],31'h7fc00000} ;
								 else if(sign==1'b0)
									begin
										if(SrcA[30:23]==SrcB[30:23])
											begin
												check={1'b0,1'b1,SrcA[22:0]}+{1'b0,1'b1,SrcB[22:0]} ;
												if(check[24]==1'b1)
													begin
														{g,r,s}={check[0],1'b0,1'b0} ;
														ALUResult={SrcA[31],SrcA[30:23]+1'b1,check[23:1]} ;
														{OF,NX}={2{(ALUResult[30:23]<=SrcA[30:23])}} ;
													end
												else
													begin
														ALUResult={SrcA[31],SrcA[30:23],check[22:0]} ;												
													end
											end
										else if(SrcA[30:23]>SrcB[30:23])
											begin
												exp=SrcA[30:23]-SrcB[30:23] ;
												shift={SrcB[31],SrcA[30:23],1'b1,SrcB[22:1]} ;										
												if(exp==8'b1)
													begin
														{g,r,s}={SrcB[0],1'b0,1'b0} ;
													end
												else if(exp==8'b10)
													begin 
														shift={shift[31:23],shift[22:0]>>1} ;
														{g,r,s}={SrcB[1],SrcB[0],1'b0} ;
													end										
												else 
													begin 
														{shift,g,r}={shift[31:23],({shift[22:0],2'b0}>>(exp-8'b1))} ;
														s=|({231'b1,SrcB[22:0]}<<(8'b11111110-exp+8'b10)) ;
													end
												check={1'b0,1'b1,SrcA[22:0]}+{1'b0,1'b0,shift[22:0]} ;
												if(check[24]==1'b1)
													begin
														{g,r,s}={check[0],g,s|r} ;
														ALUResult={SrcA[31],SrcA[30:23]+1'b1,check[23:1]} ;
														{OF,NX}={2{(ALUResult[30:23]<=SrcA[30:23])}} ;
													end
												else
													begin
														ALUResult={SrcA[31],SrcA[30:23],check[22:0]} ;												
													end										
											end
										else
											begin
												exp=SrcB[30:23]-SrcA[30:23] ;
												shift={SrcA[31],SrcB[30:23],1'b1,SrcA[22:1]} ;										
												if(exp==8'b1)
													begin
														{g,r,s}={SrcA[0],1'b0,1'b0} ;
													end
												else if(exp==8'b10)
													begin 
														shift={shift[31:23],shift[22:0]>>1} ;
														{g,r,s}={SrcA[1],SrcA[0],1'b0} ;
													end										
												else 
													begin 
														{shift,g,r}={shift[31:23],({shift[22:0],2'b0}>>(exp-8'b1))} ;
														s=|({231'b1,SrcA[22:0]}<<(8'b11111110-exp+8'b10)) ;
													end
												check={1'b0,1'b1,SrcB[22:0]}+{1'b0,1'b0,shift[22:0]} ;
												if(check[24]==1'b1)
													begin
														{g,r,s}={check[0],g,s|r} ;
														ALUResult={SrcB[31],SrcB[30:23]+1'b1,check[23:1]} ;
														{OF,NX}={2{(ALUResult[30:23]<=SrcB[30:23])}} ;
													end
												else
													begin
														ALUResult={SrcB[31],SrcB[30:23],check[22:0]} ;												
													end										
											end
									end
								 else
									begin
										if(SrcA[30:23]==SrcB[30:23])
											begin
												if(SrcA[22:0]==SrcB[22:0])
													begin
														ALUResult={SrcA[31],31'b0} ;
													end
												else if(SrcA[22:0]>SrcB[22:0])
													begin
														check={1'b0,1'b1,SrcA[22:0]}-{1'b0,1'b1,SrcB[22:0]} ;
														if(check[23]==1'b0)
															begin
																j=check[22] ? 5'b1 : check[21] ? 5'b10 : check[20] ? 5'b11 : check[19] ? 5'b100 : check[18] ? 5'b101
																   : check[17] ? 5'b110 : check[16] ? 5'b111 : check[15] ? 5'b1000 : check[14] ? 5'b1001
																   : check[13] ? 5'b1010 : check[12] ? 5'b1011 : check[11] ? 5'b1100 : check[10] ? 5'b1101
																   : check[9] ? 5'b1110 : check[8] ? 5'b1111 : check[7] ? 5'b10000 : check[6] ? 5'b10001
																   : check[5] ? 5'b10010 : check[4] ? 5'b10011 : check[3] ? 5'b10100 : check[2] ? 5'b10101
																   : check[1] ? 5'b10110 : 5'b10111 ;           
																ALUResult={SrcA[31],(SrcA[30:23]-j),check[22:0]<<j} ;
																{UF,NX}={2{(ALUResult[30:23]>SrcA[30:23])}} ;
															end
														else
															ALUResult={SrcA[31],SrcA[30:23],check[22:0]} ;												
													end
												else
													begin
														check={1'b0,1'b1,SrcB[22:0]}-{1'b0,1'b1,SrcA[22:0]} ;
														if(check[23]==1'b0)
															begin
																j=check[22] ? 5'b1 : check[21] ? 5'b10 : check[20] ? 5'b11 : check[19] ? 5'b100 : check[18] ? 5'b101
																   : check[17] ? 5'b110 : check[16] ? 5'b111 : check[15] ? 5'b1000 : check[14] ? 5'b1001
																   : check[13] ? 5'b1010 : check[12] ? 5'b1011 : check[11] ? 5'b1100 : check[10] ? 5'b1101
																   : check[9] ? 5'b1110 : check[8] ? 5'b1111 : check[7] ? 5'b10000 : check[6] ? 5'b10001
																   : check[5] ? 5'b10010 : check[4] ? 5'b10011 : check[3] ? 5'b10100 : check[2] ? 5'b10101
																   : check[1] ? 5'b10110 : 5'b10111 ;    
																ALUResult={SrcB[31],(SrcA[30:23]-j),check[22:0]<<j} ;
																{UF,NX}={2{(ALUResult[30:23]>SrcA[30:23])}} ;
															end													
														else
															ALUResult={SrcB[31],SrcA[30:23],check[22:0]} ;														
													end
											end
										else if(SrcA[30:23]>SrcB[30:23])
											begin
												exp=SrcA[30:23]-SrcB[30:23] ;
												shift={SrcB[31],SrcA[30:23],1'b1,SrcB[22:1]} ;										
												if(exp==8'b1)
													begin
														{g,r,s}={SrcB[0],1'b0,1'b0} ;
													end
												else if(exp==8'b10)
													begin 
														shift={shift[31:23],shift[22:0]>>1} ;
														{g,r,s}={SrcB[1],SrcB[0],1'b0} ;
													end										
												else 
													begin 
														{shift,g,r}={shift[31:23],({shift[22:0],2'b0}>>(exp-8'b1))} ;
														s=|({231'b1,SrcB[22:0]}<<(8'b11111110-exp+8'b10)) ;
													end
		//////////////////////////////////////////////////////////////////////////////////////////////////////////										
												check={1'b0,1'b1,SrcA[22:0]}-{1'b0,1'b0,shift[22:0]} ;
												if(check[23]==1'b0)
													begin
														j=check[22] ? 5'b1 : check[21] ? 5'b10 : check[20] ? 5'b11 : check[19] ? 5'b100 : check[18] ? 5'b101
														   : check[17] ? 5'b110 : check[16] ? 5'b111 : check[15] ? 5'b1000 : check[14] ? 5'b1001
														   : check[13] ? 5'b1010 : check[12] ? 5'b1011 : check[11] ? 5'b1100 : check[10] ? 5'b1101
														   : check[9] ? 5'b1110 : check[8] ? 5'b1111 : check[7] ? 5'b10000 : check[6] ? 5'b10001
														   : check[5] ? 5'b10010 : check[4] ? 5'b10011 : check[3] ? 5'b10100 : check[2] ? 5'b10101
														   : check[1] ? 5'b10110 : 5'b10111 ;    
														ALUResult={SrcA[31],(SrcA[30:23]-j),check[22:0]<<j} ;	
														{UF,NX}={2{(ALUResult[30:23]>SrcA[30:23])}} ;
													end
												else
													ALUResult={SrcA[31],SrcA[30:23],check[22:0]} ;																	
											end
										else
											begin
												exp=SrcB[30:23]-SrcA[30:23] ;
												shift={SrcA[31],SrcB[30:23],1'b1,SrcA[22:1]} ;										
												if(exp==8'b1)
													begin
														{g,r,s}={SrcA[0],1'b0,1'b0} ;
													end
												else if(exp==8'b10)
													begin 
														shift={shift[31:23],shift[22:0]>>1} ;
														{g,r,s}={SrcA[1],SrcA[0],1'b0} ;
													end										
												else 
													begin 
														{shift,g,r}={shift[31:23],({shift[22:0],2'b0}>>(exp-8'b1))} ;
														s=|({231'b1,SrcA[22:0]}<<(8'b11111110-exp+8'b10)) ;
													end
		//////////////////////////////////////////////////////////////////////////////////////////////////////////										
												check={1'b0,1'b1,SrcB[22:0]}-{1'b0,1'b0,shift[22:0]} ;
												if(check[23]==1'b0)
													begin
														j=check[22] ? 5'b1 : check[21] ? 5'b10 : check[20] ? 5'b11 : check[19] ? 5'b100 : check[18] ? 5'b101
														   : check[17] ? 5'b110 : check[16] ? 5'b111 : check[15] ? 5'b1000 : check[14] ? 5'b1001
														   : check[13] ? 5'b1010 : check[12] ? 5'b1011 : check[11] ? 5'b1100 : check[10] ? 5'b1101
														   : check[9] ? 5'b1110 : check[8] ? 5'b1111 : check[7] ? 5'b10000 : check[6] ? 5'b10001
														   : check[5] ? 5'b10010 : check[4] ? 5'b10011 : check[3] ? 5'b10100 : check[2] ? 5'b10101
														   : check[1] ? 5'b10110 : 5'b10111 ;    
														ALUResult={SrcB[31],(SrcB[30:23]-j),check[22:0]<<j} ;
														{UF,NX}={2{(ALUResult[30:23]>SrcB[30:23])}} ;
													end
												else
													ALUResult={SrcB[31],SrcB[30:23],check[22:0]} ;											
											end								
									end								
					   end
			5'b111: begin //fsub
						 sign=SrcA[31]^SrcB[31] ;
						 if((SrcA[30:0]==31'b0)&(SrcB[30:0]==31'b0))
							ALUResult={SrcA[31],31'b0} ;
						 else if(SrcA[30:0]==31'b0)
							ALUResult={!SrcB[31],SrcB[30:0] };
						 else if(SrcB[30:0]==31'b0)
							ALUResult=SrcA ;
						 else if((SrcA[30:0]==31'h7f800000)&(SrcB[30:0]==31'h7f800000))
							ALUResult={SrcA[31],31'h7fc00000} ;
						 else if(SrcA[30:0]==31'h7f800000)
							ALUResult=SrcA ;
						 else if(SrcB[30:0]==31'h7f800000)
							ALUResult={!SrcB[31],SrcB[30:0]} ;
						 else if((SrcA[30:0]==31'h7fc00000)|(SrcB[30:0]==31'h7fc00000)|(SrcA[30:0]==31'h7fb00000)|(SrcB[30:0]==31'h7fb00000))
							ALUResult={SrcA[31],31'h7fc00000} ;						 
						 else if(sign==1'b0)
							begin
								if(SrcA[30:23]==SrcB[30:23])
									begin
										if(SrcA[22:0]==SrcB[22:0])
											begin
												ALUResult={SrcA[31],31'b0} ;
											end
										else if(SrcA[22:0]>SrcB[22:0])
											begin
												check={1'b0,1'b1,SrcA[22:0]}-{1'b0,1'b1,SrcB[22:0]} ;
												if(check[23]==1'b0)
													begin
														j=check[22] ? 5'b1 : check[21] ? 5'b10 : check[20] ? 5'b11 : check[19] ? 5'b100 : check[18] ? 5'b101
														   : check[17] ? 5'b110 : check[16] ? 5'b111 : check[15] ? 5'b1000 : check[14] ? 5'b1001
														   : check[13] ? 5'b1010 : check[12] ? 5'b1011 : check[11] ? 5'b1100 : check[10] ? 5'b1101
														   : check[9] ? 5'b1110 : check[8] ? 5'b1111 : check[7] ? 5'b10000 : check[6] ? 5'b10001
														   : check[5] ? 5'b10010 : check[4] ? 5'b10011 : check[3] ? 5'b10100 : check[2] ? 5'b10101
														   : check[1] ? 5'b10110 : 5'b10111 ;    
														ALUResult={SrcA[31],(SrcA[30:23]-j),check[22:0]<<j} ;
														{UF,NX}={2{(ALUResult[30:23]>SrcA[30:23])}} ;
													end
												else
													ALUResult={SrcA[31],SrcA[30:23],check[22:0]} ;												
											end
										else
											begin
												check={1'b0,1'b1,SrcB[22:0]}-{1'b0,1'b1,SrcA[22:0]} ;
												if(check[23]==1'b0)
													begin
														j=check[22] ? 5'b1 : check[21] ? 5'b10 : check[20] ? 5'b11 : check[19] ? 5'b100 : check[18] ? 5'b101
														   : check[17] ? 5'b110 : check[16] ? 5'b111 : check[15] ? 5'b1000 : check[14] ? 5'b1001
														   : check[13] ? 5'b1010 : check[12] ? 5'b1011 : check[11] ? 5'b1100 : check[10] ? 5'b1101
														   : check[9] ? 5'b1110 : check[8] ? 5'b1111 : check[7] ? 5'b10000 : check[6] ? 5'b10001
														   : check[5] ? 5'b10010 : check[4] ? 5'b10011 : check[3] ? 5'b10100 : check[2] ? 5'b10101
														   : check[1] ? 5'b10110 : 5'b10111 ;    
														ALUResult={!SrcB[31],(SrcA[30:23]-j),check[22:0]<<j} ;
														{UF,NX}={2{(ALUResult[30:23]>SrcA[30:23])}} ;
													end													
												else
													ALUResult={!SrcB[31],SrcA[30:23],check[22:0]} ;														
											end
									end
								else if(SrcA[30:23]>SrcB[30:23])
									begin
										exp=SrcA[30:23]-SrcB[30:23] ;
										shift={SrcB[31],SrcA[30:23],1'b1,SrcB[22:1]} ;										
										if(exp==8'b1)
											begin
												{g,r,s}={SrcB[0],1'b0,1'b0} ;
											end
										else if(exp==8'b10)
											begin 
												shift={shift[31:23],shift[22:0]>>1} ;
												{g,r,s}={SrcB[1],SrcB[0],1'b0} ;
											end										
										else 
											begin 
												{shift,g,r}={shift[31:23],({shift[22:0],2'b0}>>(exp-8'b1))} ;
												s=|({231'b1,SrcB[22:0]}<<(8'b11111110-exp+8'b10)) ;
											end
//////////////////////////////////////////////////////////////////////////////////////////////////////////										
										check={1'b0,1'b1,SrcA[22:0]}-{1'b0,1'b0,shift[22:0]} ;
										if(check[23]==1'b0)
											begin
												j=check[22] ? 5'b1 : check[21] ? 5'b10 : check[20] ? 5'b11 : check[19] ? 5'b100 : check[18] ? 5'b101
												   : check[17] ? 5'b110 : check[16] ? 5'b111 : check[15] ? 5'b1000 : check[14] ? 5'b1001
												   : check[13] ? 5'b1010 : check[12] ? 5'b1011 : check[11] ? 5'b1100 : check[10] ? 5'b1101
												   : check[9] ? 5'b1110 : check[8] ? 5'b1111 : check[7] ? 5'b10000 : check[6] ? 5'b10001
												   : check[5] ? 5'b10010 : check[4] ? 5'b10011 : check[3] ? 5'b10100 : check[2] ? 5'b10101
												   : check[1] ? 5'b10110 : 5'b10111 ;    
												ALUResult={SrcA[31],(SrcA[30:23]-j),check[22:0]<<j} ;
												{UF,NX}={2{(ALUResult[30:23]>SrcA[30:23])}} ;
											end
										else
											ALUResult={SrcA[31],SrcA[30:23],check[22:0]} ;																	
									end
								else
									begin
										exp=SrcB[30:23]-SrcA[30:23] ;
										shift={SrcA[31],SrcB[30:23],1'b1,SrcA[22:1]} ;										
										if(exp==8'b1)
											begin
												{g,r,s}={SrcA[0],1'b0,1'b0} ;
											end
										else if(exp==8'b10)
											begin 
												shift={shift[31:23],shift[22:0]>>1} ;
												{g,r,s}={SrcA[1],SrcA[0],1'b0} ;
											end										
										else 
											begin 
												{shift,g,r}={shift[31:23],({shift[22:0],2'b0}>>(exp-8'b1))} ;
												s=|({231'b1,SrcA[22:0]}<<(8'b11111110-exp+8'b10)) ;
											end
//////////////////////////////////////////////////////////////////////////////////////////////////////////										
										check={1'b0,1'b1,SrcB[22:0]}-{1'b0,1'b0,shift[22:0]} ;
										if(check[23]==1'b0)
											begin
												j=check[22] ? 5'b1 : check[21] ? 5'b10 : check[20] ? 5'b11 : check[19] ? 5'b100 : check[18] ? 5'b101
												   : check[17] ? 5'b110 : check[16] ? 5'b111 : check[15] ? 5'b1000 : check[14] ? 5'b1001
												   : check[13] ? 5'b1010 : check[12] ? 5'b1011 : check[11] ? 5'b1100 : check[10] ? 5'b1101
												   : check[9] ? 5'b1110 : check[8] ? 5'b1111 : check[7] ? 5'b10000 : check[6] ? 5'b10001
												   : check[5] ? 5'b10010 : check[4] ? 5'b10011 : check[3] ? 5'b10100 : check[2] ? 5'b10101
												   : check[1] ? 5'b10110 : 5'b10111 ;    
												ALUResult={!SrcB[31],(SrcB[30:23]-j),check[22:0]<<j} ;
												{UF,NX}={2{(ALUResult[30:23]>SrcB[30:23])}} ;
											end
										else
											ALUResult={!SrcB[31],SrcB[30:23],check[22:0]} ;											
									end								
							end
						 else //sign=1'b1
							begin
								if(SrcA[30:23]==SrcB[30:23])
									begin
										check={1'b0,1'b1,SrcA[22:0]}+{1'b0,1'b1,SrcB[22:0]} ;
										if(check[24]==1'b1)
											begin
												{g,r,s}={check[0],1'b0,1'b0} ;
												ALUResult={SrcA[31],SrcA[30:23]+1'b1,check[23:1]} ;
												{OF,NX}={2{(ALUResult[30:23]<=SrcA[30:23])}} ;
											end
										else
											begin
												ALUResult={SrcA[31],SrcA[30:23],check[22:0]} ;												
											end
									end
								else if(SrcA[30:23]>SrcB[30:23])
									begin
										exp=SrcA[30:23]-SrcB[30:23] ;
										shift={SrcB[31],SrcA[30:23],1'b1,SrcB[22:1]} ;										
										if(exp==8'b1)
											begin
												{g,r,s}={SrcB[0],1'b0,1'b0} ;
											end
										else if(exp==8'b10)
											begin 
												shift={shift[31:23],shift[22:0]>>1} ;
												{g,r,s}={SrcB[1],SrcB[0],1'b0} ;
											end										
										else 
											begin 
												{shift,g,r}={shift[31:23],({shift[22:0],2'b0}>>(exp-8'b1))} ;
												s=|({231'b1,SrcB[22:0]}<<(8'b11111110-exp+8'b10)) ;
											end
										check={1'b0,1'b1,SrcA[22:0]}+{1'b0,1'b0,shift[22:0]} ;
										if(check[24]==1'b1)
											begin
												{g,r,s}={check[0],g,s|r} ;
												ALUResult={SrcA[31],SrcA[30:23]+1'b1,check[23:1]} ;
												{OF,NX}={2{(ALUResult[30:23]<=SrcA[30:23])}} ;
											end
										else
											begin
												ALUResult={SrcA[31],SrcA[30:23],check[22:0]} ;												
											end										
									end
								else
									begin
										exp=SrcB[30:23]-SrcA[30:23] ;
										shift={SrcA[31],SrcB[30:23],1'b1,SrcA[22:1]} ;										
										if(exp==8'b1)
											begin
												{g,r,s}={SrcA[0],1'b0,1'b0} ;
											end
										else if(exp==8'b10)
											begin 
												shift={shift[31:23],shift[22:0]>>1} ;
												{g,r,s}={SrcA[1],SrcA[0],1'b0} ;
											end										
										else 
											begin 
												{shift,g,r}={shift[31:23],({shift[22:0],2'b0}>>(exp-8'b1))} ;
												s=|({231'b1,SrcA[22:0]}<<(8'b11111110-exp+8'b10)) ;
											end
										check={1'b0,1'b1,SrcB[22:0]}+{1'b0,1'b0,shift[22:0]} ;
										if(check[24]==1'b1)
											begin
												{g,r,s}={check[0],g,s|r} ;
												ALUResult={SrcA[31],SrcB[30:23]+1'b1,check[23:1]} ;
												{OF,NX}={2{(ALUResult[30:23]<=SrcB[30:23])}} ;
											end
										else
											begin
												ALUResult={SrcA[31],SrcB[30:23],check[22:0]} ;												
											end										
									end							
							end						
					   end
			5'b1000: ALUResult={SrcB[31],SrcA[30:0]} ;
			5'b1001: ALUResult={!SrcB[31],SrcA[30:0]} ;
			5'b1010: ALUResult={SrcA[31]^SrcB[31],SrcA[30:0]} ;
			5'b1011: begin
							if((SrcA==32'h7fb00000)|(SrcA==32'hffb00000)|(SrcB==32'h7fb00000)|(SrcB==32'hffb00000)|(((SrcA==32'h7fc00000)|(SrcA==32'hffc00000))&((SrcB==32'h7fc00000)|(SrcB==32'hffc00000))))
								ALUResult=32'h7fc00000 ;
							else if((SrcA==32'h7fc00000)|(SrcA==32'hffc00000))
								ALUResult=SrcB ;
							else if((SrcB==32'h7fc00000)|(SrcB==32'hffc00000))
								ALUResult=SrcA ;
							else if((SrcA==32'h7f800000)&(SrcB==32'h7f800000))
								ALUResult=32'h7f800000 ;
							else if(SrcA==32'h7f800000)
								ALUResult=SrcB ;
							else if(SrcB==32'h7f800000)
								ALUResult=SrcA ;
							else if((SrcA==32'hff800000)|(SrcB==32'hff800000))
								ALUResult=32'hff800000 ;
							else if(((SrcA==32'b0)|(SrcA==32'h80000000))&((SrcB==32'b0)|(SrcB==32'h80000000)))
								ALUResult=32'b0 ;
							else if((SrcA==32'b0)|(SrcA==32'h80000000))
								ALUResult=SrcB[31] ? SrcB : SrcA ;
							else if((SrcB==32'b0)|(SrcB==32'h80000000))
								ALUResult=SrcA[31] ? SrcA : SrcB ;
							else
								begin
									if(SrcA[31]>SrcB[31])
										ALUResult=SrcA ;
									else if(SrcB[31]>SrcA[31])
										ALUResult=SrcB ;
									else
										begin
											if(SrcA[31]==1'b0)
												begin
													if(SrcA[30:23]>SrcB[30:23])
														ALUResult=SrcB ;
													else if(SrcA[30:23]<SrcB[30:23])
														ALUResult=SrcA ;
													else
														begin
															if(SrcA[22:0]>SrcB[22:0])
																ALUResult=SrcB ;
															else if(SrcA[22:0]<SrcB[22:0])
																ALUResult=SrcA ;
															else
																ALUResult=SrcA ;
														end
												end
											else // sign of both is negative
												begin
													if(SrcA[30:23]>SrcB[30:23])
														ALUResult=SrcA ;
													else if(SrcA[30:23]<SrcB[30:23])
														ALUResult=SrcB ;
													else
														begin
															if(SrcA[22:0]>SrcB[22:0])
																ALUResult=SrcA ;
															else if(SrcA[22:0]<SrcB[22:0])
																ALUResult=SrcB ;
															else
																ALUResult=SrcA ;
														end													
												end
										end
								end
						end
			5'b1100: begin
							if((SrcA==32'h7fb00000)|(SrcA==32'hffb00000)|(SrcB==32'h7fb00000)|(SrcB==32'hffb00000)|(((SrcA==32'h7fc00000)|(SrcA==32'hffc00000))&((SrcB==32'h7fc00000)|(SrcB==32'hffc00000))))
								ALUResult=32'h7fc00000 ;
							else if((SrcA==32'h7fc00000)|(SrcA==32'hffc00000))
								ALUResult=SrcB ;
							else if((SrcB==32'h7fc00000)|(SrcB==32'hffc00000))
								ALUResult=SrcA ;
							else if((SrcA==32'h7f800000)|(SrcB==32'h7f800000))
								ALUResult=32'h7f800000 ;
							else if((SrcA==32'hff800000)&(SrcB==32'hff800000))
								ALUResult=32'hff800000 ;
							else if(SrcA==32'hff800000)
								ALUResult=SrcB ;
							else if(SrcB==32'hff800000)
								ALUResult=SrcA ;								
							else if(((SrcA==32'b0)|(SrcA==32'h80000000))&((SrcB==32'b0)|(SrcB==32'h80000000)))
								ALUResult=32'b0 ;
							else if((SrcA==32'b0)|(SrcA==32'h80000000))
								ALUResult=SrcB[31] ? SrcA : SrcB ;
							else if((SrcB==32'b0)|(SrcB==32'h80000000))
								ALUResult=SrcA[31] ? SrcB : SrcA ;								
							else
								begin
									if(SrcA[31]>SrcB[31])
										ALUResult=SrcB ;
									else if(SrcB[31]>SrcA[31])
										ALUResult=SrcA ;
									else
										begin
											if(SrcA[31]==1'b0)
												begin
													if(SrcA[30:23]>SrcB[30:23])
														ALUResult=SrcA ;
													else if(SrcA[30:23]<SrcB[30:23])
														ALUResult=SrcB ;
													else
														begin
															if(SrcA[22:0]>SrcB[22:0])
																ALUResult=SrcA ;
															else if(SrcA[22:0]<SrcB[22:0])
																ALUResult=SrcB ;
															else
																ALUResult=SrcA ;
														end
												end
											else // sign of both is negative
												begin
													if(SrcA[30:23]>SrcB[30:23])
														ALUResult=SrcB ;
													else if(SrcA[30:23]<SrcB[30:23])
														ALUResult=SrcA ;
													else
														begin
															if(SrcA[22:0]>SrcB[22:0])
																ALUResult=SrcB ;
															else if(SrcA[22:0]<SrcB[22:0])
																ALUResult=SrcA ;
															else
																ALUResult=SrcA ;
														end													
												end
										end
								end							
						end
			5'b1101: begin
							if((SrcA==32'h7fb00000)|(SrcA==32'hffb00000)|(SrcB==32'h7fb00000)|(SrcB==32'hffb00000))
								begin
									ALUResult=32'b0 ;
								end
							else if((SrcA==32'h7fc00000)|(SrcB==32'h7fc00000))
								begin
									ALUResult=32'b0 ;
								end
							else if(((SrcA==32'b0)|(SrcA==32'h80000000))&((SrcB==32'b0)|(SrcB==32'h80000000)))
								ALUResult=32'b1 ;
							else
								ALUResult={31'b0,(SrcA==SrcB)} ;
						end
			5'b1110: begin
							if((SrcA==32'h7fb00000)|(SrcA==32'hffb00000)|(SrcB==32'h7fb00000)|(SrcB==32'hffb00000)|(SrcA==32'h7fc00000)|(SrcA==32'hffc00000)|(SrcB==32'h7fc00000)|(SrcB==32'hffc00000))
								begin
									ALUResult=32'b0 ;
								end
							else if((SrcA==32'h7f800000)&(SrcB==32'h7f800000))
								ALUResult=32'b0 ;
							else if(SrcA==32'h7f800000)
								ALUResult=32'b0 ;
							else if(SrcB==32'h7f800000)
								ALUResult=32'b1 ;
							else if((SrcA==32'hff800000)&(SrcB==32'hff800000))
								ALUResult=32'b0 ;
							else if(SrcA==32'hff800000)
								ALUResult=32'b1 ;
							else if(SrcB==32'hff800000)
								ALUResult=32'b0 ;
							else if(((SrcA==32'b0)|(SrcA==32'h80000000))&((SrcB==32'b0)|(SrcB==32'h80000000)))
								ALUResult=32'b0 ;
							else if((SrcA==32'b0)|(SrcA==32'h80000000))
								ALUResult=SrcB[31] ? 32'b0 : 32'b1 ;
							else if((SrcB==32'b0)|(SrcB==32'h80000000))
								ALUResult=SrcA[31] ? 32'b1 : 32'b0 ;							
							else
								begin
									if(SrcA[31]>SrcB[31])
										ALUResult=32'b1 ;
									else if(SrcB[31]>SrcA[31])
										ALUResult=32'b0 ;
									else
										begin
											if(SrcA[31]==1'b0)
												begin
													if(SrcA[30:23]>SrcB[30:23])
														ALUResult=32'b0 ;
													else if(SrcA[30:23]<SrcB[30:23])
														ALUResult=32'b1 ;
													else
														begin
															if(SrcA[22:0]<SrcB[22:0])
																ALUResult=32'b1 ;
															else
																ALUResult=32'b0 ;
														end
												end
											else // sign of both is negative
												begin
													if(SrcA[30:23]>SrcB[30:23])
														ALUResult=32'b1 ;
													else if(SrcA[30:23]<SrcB[30:23])
														ALUResult=32'b0 ;
													else
														begin
															if(SrcA[22:0]>SrcB[22:0])
																ALUResult=32'b1 ;
															else
																ALUResult=32'b0 ;
														end													
												end
										end								
								end
						end
			5'b1111: begin
							if((SrcA==32'h7fb00000)|(SrcA==32'hffb00000)|(SrcB==32'h7fb00000)|(SrcB==32'hffb00000)|(SrcA==32'h7fc00000)|(SrcA==32'hffc00000)|(SrcB==32'h7fc00000)|(SrcB==32'hffc00000))
								begin
									ALUResult=32'b0 ;
								end
							else if((SrcA==32'h7f800000)&(SrcB==32'h7f800000))
								ALUResult=32'b1 ;
							else if(SrcA==32'h7f800000)
								ALUResult=32'b0 ;
							else if(SrcB==32'h7f800000)
								ALUResult=32'b1 ;
							else if((SrcA==32'hff800000)&(SrcB==32'hff800000))
								ALUResult=32'b1 ;
							else if(SrcA==32'hff800000)
								ALUResult=32'b1 ;
							else if(SrcB==32'hff800000)
								ALUResult=32'b0 ;
							else if(((SrcA==32'b0)|(SrcA==32'h80000000))&((SrcB==32'b0)|(SrcB==32'h80000000)))
								ALUResult=32'b1 ;
							else if((SrcA==32'b0)|(SrcA==32'h80000000))
								ALUResult=SrcB[31] ? 32'b0 : 32'b1 ;
							else if((SrcB==32'b0)|(SrcB==32'h80000000))
								ALUResult=SrcA[31] ? 32'b1 : 32'b0 ;										
							else
								begin
									if(SrcA[31]>SrcB[31])
										ALUResult=32'b1 ;
									else if(SrcB[31]>SrcA[31])
										ALUResult=32'b0 ;
									else
										begin
											if(SrcA[31]==1'b0)
												begin
													if(SrcA[30:23]>SrcB[30:23])
														ALUResult=32'b0 ;
													else if(SrcA[30:23]<SrcB[30:23])
														ALUResult=32'b1 ;
													else
														begin
															if(SrcA[22:0]>SrcB[22:0])
																ALUResult=32'b0 ;
															else
																ALUResult=32'b1 ;
														end
												end
											else // sign of both is negative
												begin
													if(SrcA[30:23]>SrcB[30:23])
														ALUResult=32'b1 ;
													else if(SrcA[30:23]<SrcB[30:23])
														ALUResult=32'b0 ;
													else
														begin
															if(SrcA[22:0]<SrcB[22:0])
																ALUResult=32'b0 ;
															else
																ALUResult=32'b1 ;
														end													
												end
										end								
								end							
						end
			5'b10001: begin //fclassify
							if(SrcA==32'hff800000)
								ALUResult=32'b1 ;
							else if((SrcA[31]==1'b1)&(SrcA!=32'h80000000))
								ALUResult=32'b10 ;
							else if((SrcA[31:23]==9'b1_00000000)&(SrcA!=32'h80000000))
								ALUResult=32'b100 ;								
							else if(SrcA==32'h80000000)
								ALUResult=32'b1000 ;
							else if(SrcA==32'b0)
								ALUResult=32'b10000 ;
							else if((SrcA[31:23]==9'b0))
								ALUResult=32'b100000 ;										
							else if(SrcA==32'h7f800000)
								ALUResult=32'b10000000 ;
							else if((SrcA==32'h7fb00000)|(SrcA==32'hffb00000))
								ALUResult=32'b100000000 ;			
							else if((SrcA==32'h7fc00000)|(SrcA==32'hffc00000))
								ALUResult=32'b1000000000 ;
							else if(SrcA[31]==1'b0)
								ALUResult=32'b1000000 ;										
							else
								ALUResult=32'b1000000 ;
						  end
			5'b10010: ALUResult=SrcA ;
			5'b10100: begin //unsigned fconv to int
							if(SrcA[30:0]==31'b0)
								ALUResult=32'b0 ;
							else if(SrcA==32'h7f800000)
								ALUResult={32{1'b1}} ;
							else if(SrcA==32'hff800000)
								ALUResult=32'b0 ;								
							else if((SrcA[30:0]==31'h7fc00000)|(SrcA[30:0]==31'h7fb00000))
								ALUResult={32{1'b1}} ;
							else if(SrcA[30:23]>8'd127)
								begin
									int_conv_reg={32'b1,SrcA[22:0]}<<(SrcA[30:23]-8'd127) ;
									{g,r}=int_conv_reg[22:21] ;
									s=|({SrcA[20:0],107'b0}>>(8'd254-SrcA[30:23])) ; // 20(to get the bits that shift through the sticky bit alone with zeros on the left) +127(coming from the calculation above of the number of bits to be shifted)
									ALUResult=int_conv_reg[54:23] ;
								end
							else
								begin
									int_conv_reg={32'b1,SrcA[22:0]}>>(8'd127-SrcA[30:23]) ;
									{g,r}=int_conv_reg[22:21] ;
									s=|({125'b1,SrcA[22:20]}<<(SrcA[30:23])) ;
									ALUResult=int_conv_reg[54:23] ;									
								end
						  end
			5'b10101: begin //signed fconv to int
							if(SrcA[30:0]==31'b0)
								ALUResult=32'b0 ;
							else if(SrcA==32'h7f800000)
								ALUResult={1'b0,{31{1'b1}}} ;
							else if(SrcA==32'hff800000)
								ALUResult={32{1'b1}} ;							
							else if((SrcA[30:0]==31'h7fc00000)|(SrcA[30:0]==31'h7fb00000))
								ALUResult={1'b0,{31{1'b1}}} ;
							else if(SrcA[30:23]>8'd127)
								begin
									int_conv_reg={32'b1,SrcA[22:0]}<<(SrcA[30:23]-8'd127) ;
									{g,r}=int_conv_reg[22:21] ;
									s=|({SrcA[20:0],107'b0}>>(8'd254-SrcA[30:23])) ; // 20(to get the bits that shift through the sticky bit alone with zeros on the left) +127(coming from the calculation above of the number of bits to be shifted)
									ALUResult= (SrcA[31]) ? (~int_conv_reg[54:23])+1'b1 : int_conv_reg[54:23] ;
								end
							else
								begin
									int_conv_reg={32'b1,SrcA[22:0]}>>(8'd127-SrcA[30:23]) ;
									{g,r}=int_conv_reg[22:21] ;
									s=|({125'b1,SrcA[22:20]}<<(SrcA[30:23])) ;
									ALUResult= (SrcA[31]) ? (~int_conv_reg[54:23])+1'b1 : int_conv_reg[54:23] ;								
								end							
						  end
			5'b10110: begin //unsigned fconv to float
							if(SrcA==32'b0)
								ALUResult=32'b0 ;
							else
								begin
									j= SrcA[31] ? 5'b11111 : SrcA[30] ? 5'b11110 : SrcA[29] ? 5'b11101 : SrcA[28] ? 5'b11100 : SrcA[27] ? 5'b11011
										: SrcA[26] ? 5'b11010 : SrcA[25] ? 5'b11001 : SrcA[24] ? 5'b11000 : SrcA[23] ? 5'b10111
										: SrcA[22] ? 5'b10110 : SrcA[21] ? 5'b10101 : SrcA[20] ? 5'b10100 : SrcA[19] ? 5'b10011 : SrcA[18] ? 5'b10010
										: SrcA[17] ? 5'b10001 : SrcA[16] ? 5'b10000 : SrcA[15] ? 5'b1111 : SrcA[14] ? 5'b1110
										: SrcA[13] ? 5'b1101 : SrcA[12] ? 5'b1100 : SrcA[11] ? 5'b1011 : SrcA[10] ? 5'b1010
										: SrcA[9] ? 5'b1001 : SrcA[8] ? 5'b1000 : SrcA[7] ? 5'b111 : SrcA[6] ? 5'b110
										: SrcA[5] ? 5'b101 : SrcA[4] ? 5'b100 : SrcA[3] ? 5'b11 : SrcA[2] ? 5'b10
										: SrcA[1] ? 5'b1 : 5'b0 ;
									f_conv_reg={15'b0,(8'd127+j),SrcA<<(5'd32-j)} ;
									ALUResult=f_conv_reg[40:9] ;
									{g,r}=f_conv_reg[8:7] ;
									s=|({SrcA[28:0],3'b0}>>j) ;									
								end
						  end
			5'b10111: begin //signed fconv to float
							if(SrcA==32'b0)
								ALUResult=32'b0 ;
							else
								begin
									if(SrcA[31])
										signed_int=(~SrcA)+1'b1 ;
									else
										signed_int=SrcA ;
									j= signed_int[31] ? 5'b11111 : signed_int[30] ? 5'b11110 : signed_int[29] ? 5'b11101 : signed_int[28] ? 5'b11100 : signed_int[27] ? 5'b11011
										: signed_int[26] ? 5'b11010 : signed_int[25] ? 5'b11001 : signed_int[24] ? 5'b11000 : signed_int[23] ? 5'b10111
										: signed_int[22] ? 5'b10110 : signed_int[21] ? 5'b10101 : signed_int[20] ? 5'b10100 : signed_int[19] ? 5'b10011 : signed_int[18] ? 5'b10010
										: signed_int[17] ? 5'b10001 : signed_int[16] ? 5'b10000 : signed_int[15] ? 5'b1111 : signed_int[14] ? 5'b1110
										: signed_int[13] ? 5'b1101 : signed_int[12] ? 5'b1100 : signed_int[11] ? 5'b1011 : signed_int[10] ? 5'b1010
										: signed_int[9] ? 5'b1001 : signed_int[8] ? 5'b1000 : signed_int[7] ? 5'b111 : signed_int[6] ? 5'b110
										: signed_int[5] ? 5'b101 : signed_int[4] ? 5'b100 : signed_int[3] ? 5'b11 : signed_int[2] ? 5'b10
										: signed_int[1] ? 5'b1 : 5'b0 ;
									f_conv_reg={14'b0,(SrcA[31]),(8'd127+j),signed_int<<(5'd32-j)} ;
									ALUResult=f_conv_reg[40:9] ;			
									{g,r}=f_conv_reg[8:7] ;
									s=|({signed_int[28:0],3'b0}>>j) ;										
								end						
						  end						  
			default: ALUResult=SrcA+SrcB ;
			endcase
			
		if(f)
			begin
				if(|(int_conv_reg)==1'b0)
					begin
						if(g)
							begin
								if(r|s)
									begin
										if(&ALUResult[22:0])
											begin
												RoundResult={ALUResult[31],ALUResult[30:23]+1'b1,ALUResult[22:0]+1'b1} ;
												{OF,NX}={2{(RoundResult[30:23]<=ALUResult[30:23])}} ;												
											end
										else
											RoundResult={ALUResult[31:23],ALUResult[22:0]+1'b1} ;
									end
								else
									begin
										if(ALUResult[0]==1'b0)
											RoundResult=ALUResult ;
										else
											begin
												if(&ALUResult[22:0])
													begin
														RoundResult={ALUResult[31],ALUResult[30:23]+1'b1,ALUResult[22:0]+1'b1} ;
														{OF,NX}={2{(RoundResult[30:23]<=ALUResult[30:23])}} ;
													end
												else
													RoundResult={ALUResult[31:23],ALUResult[22:0]+1'b1} ;
											end
									end
							end
						else
							begin
								RoundResult=ALUResult ;
							end
						if((RoundResult[30:0]==31'h7fb00000)|((RoundResult[30:0]==31'h7fc00000)&((SrcA[30:0]!=31'h7fc00000)|(SrcB[30:0]!=31'h7fc00000)))|((RoundResult[30:0]==31'h7f800000)&((SrcA[30:0]!=31'h7f800000)|(SrcB[30:0]!=31'h7f800000))))
							{NX,OF}=2'b11 ;
						else
							{NX,OF}=2'b0 ;
					end
				else
					begin
						if(g)
							begin
								if(r|s)
									begin
										RoundResult=ALUResult+1'b1 ;
										{OF,NX}={2{(RoundResult<=ALUResult)}} ;
									end
								else
									begin
										if(ALUResult[0]==1'b0)
											RoundResult=ALUResult ;
										else
											begin
												RoundResult=ALUResult+1'b1 ;
												{OF,NX}={2{(RoundResult<=ALUResult)}} ;
											end
									end
							end
						else
							begin
								RoundResult=ALUResult ;
							end						
					end
							
				if(((SrcA==32'h7fb00000)|(SrcA==32'hffb00000)|(SrcB==32'h7fb00000)|(SrcB==32'hffb00000))&((ALUControl!=5'b1000)|(ALUControl!=5'b1001)|(ALUControl!=5'b1010)))
					begin
						NV=1'b1 ;
					end
				else if(((ALUControl==5'b1110)|(ALUControl==5'b1111))&((SrcA==32'h7fc00000)|(SrcA==32'hffc00000)|(SrcB==32'h7fc00000)|(SrcB==32'hffc00000)))
					NV=1'b1 ;
				else
					NV=1'b0 ;
				
			end
		else
			begin
				RoundResult=ALUResult ;
			end
		
	end

endmodule