module RF (
	input wire										clk,RST,WE3,
	input wire				[4:0]					A1,A2,A3,
	input wire				[31:0]				WD3,
	output reg				[31:0]				RD1,RD2
);

	reg 						[31:0]				mem		[0:31]	;
	integer i ;
	
	always@(posedge clk or negedge RST)
		begin
			if(!RST)
				begin
					RD1<=32'b0 ;
					RD2<=32'b0 ;
					for(i=0; i<=31;i=i+1)
						mem[i]<=32'b0 ;
				end
			else
				begin
					RD1<=mem[A1] ;
					RD2<=mem[A2] ;
					if(WE3)
						mem[A3]<=WD3 ;					
				end
		end
		
always @(*)
 begin
     if(!RST)
	  begin
         RD1=32'b0 ;
	     RD2=32'b0 ;	     
	  end
	  
	 else
	  begin
         RD1=mem[A1] ;
	     RD2=mem[A2] ;
	  end
	  
 end		
	
endmodule