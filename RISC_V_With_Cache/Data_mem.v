module Data_mem (
	input wire 										clk,RST,miss,rd_en,wr_en,
	input wire						[9:0]				WA,
	input wire 					[31:0]			WD,
	output reg						[127:0]			RD,
	output reg											ready,rd_en_reg
);

	reg							[31:0]			mem		[0:1023]	;
	reg							[2:0]			counter ;
	// reg							[127:0]		RD ;
	// reg												ready ;
	integer i ;
	
always@(posedge clk or negedge RST)
	begin
		if(!RST)
			begin
				rd_en_reg<=1'b0 ;
			end
		else
			begin
				rd_en_reg<=rd_en ;
			end
	end
	
	
always@(posedge clk or negedge RST)
	begin
		if(!RST)
			begin
				counter<=3'b0 ;
			end
		else if(rd_en)
			begin
				if(miss)
					begin
						counter<=3'b1 ;
					end
				if((counter>=3'b1)&(counter<=3'b11))
					begin
						counter<=counter+1'b1 ;
					end
			end
		else if(wr_en)
			begin
				if(counter<3'b11)
					begin
						counter<=counter+1'b1 ;
					end
				else if(counter>=3'b11)
					begin
						counter<=3'b0 ;
					end
			end
		else
			begin
				counter<=3'b0 ;
			end			
	end
	
always@(posedge clk or negedge RST)
	begin
		if(!RST)
			begin
				$readmemh("data_hex.txt", mem) ;			
				for(i=4; i<=1023;i=i+1)
					mem[i]<=32'b0 ;
				RD<=128'b0 ;
				ready<=1'b0 ;
			end
		else
			begin
				if(rd_en)
				  begin
					RD={mem[{WA[9:2],2'b11}],mem[{WA[9:2],2'b10}],mem[{WA[9:2],2'b01}],mem[{WA[9:2],2'b00}] };				  
					if(counter==3'b11)
						begin
							ready<=1'b1 ;
						end
					else
						begin
							ready<=1'b0 ;				
						end
				  end
				else if(wr_en)
					begin
						mem[WA]=WD ;					
						if(counter==3'b11)
							begin
								ready<=1'b1 ;
							end
						else
							begin
								ready<=1'b0 ;
							end
					end
				else
					begin
						ready<=1'b0 ;
					end
			end
	end
	
// always @(*)
 // begin
	 // if(rd_en&miss)
	  // begin
		// if(counter==3'b100)
			// begin
				// RD={mem[{WA[9:2],2'b11}],mem[{WA[9:2],2'b10}],mem[{WA[9:2],2'b01}],mem[{WA[9:2],2'b00}] };
				// ready=1'b1 ;
			// end
		// else
			// begin
				// RD={mem[{WA[9:2],2'b11}],mem[{WA[9:2],2'b10}],mem[{WA[9:2],2'b01}],mem[{WA[9:2],2'b00}] };
				// ready=1'b0 ;				
			// end
	  // end
	 // else if(wr_en)
		// begin
			// RD=128'b0 ;
			// if(counter==3'b11)
				// begin
					// ready=1'b1 ;
				// end
			// else
				// begin
					// ready=1'b0 ;
				// end
		// end
	 // else
		// begin
			// RD=128'b0 ;
			// ready=1'b0 ;
		// end
	  
 // end			

endmodule