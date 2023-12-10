module RF (
	input wire										clk,RST,WE3,f,flsw,NV,DZ,OF,UF,NX,RegWritei,RegReadi,
	input wire				[4:0]					A1,A2,A3,
	input wire				[31:0]				WD3,
	output reg				[31:0]				RD1,RD2
);

	reg 						[31:0]				int_mem		[0:31]	;
	reg						[31:0]				fmem			[0:31] ;
	reg						[31:0]				fcsr ;
	integer i ;
	
	always@(posedge clk or negedge RST)
		begin
			if(!RST)
				begin
					// RD1<=32'b0 ;
					// RD2<=32'b0 ;
					for(i=0; i<=31;i=i+1)
						begin
							int_mem[i]<=32'b0 ;
							fmem[i]<=32'b0 ;							
						end
					fcsr<=32'b0 ;
				end
			else
				begin
					// RD1<=int_mem[A1] ;
					// RD2<=int_mem[A2] ;
					fcsr<={27'b0,NV,DZ,OF,UF,NX} ;
					if(WE3)
						begin
							if(RegWritei)
								int_mem[A3]<=WD3 ;
							else if(f)
								fmem[A3]<=WD3 ;					
							else	
								int_mem[A3]<=WD3 ;											
						end
				end
		end
		
always @(*)
 begin
	if(flsw)
		begin
			RD1=int_mem[A1] ;
			RD2=fmem[A2] ;
		end
	else if(RegReadi)
		begin
			RD1=int_mem[A1] ;
			RD2=int_mem[A2] ;			
		end
	else if(f)
		begin
			RD1=fmem[A1] ;
			RD2=fmem[A2] ;			
		end
	else
		begin
			RD1=int_mem[A1] ;
			RD2=int_mem[A2] ;
		end
 end		
	
endmodule