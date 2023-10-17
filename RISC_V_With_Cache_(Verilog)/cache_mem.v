module cache_mem (
	input wire 										clk,RST,ready,wr_en,rd_en,MemWrite,MemRead, //WE,
	input wire					[9:0]			WA,
	// input wire					[4:0]			index,
	// input wire					[1:0]			offset,	
	input wire 					[31:0]			Data_in,
	input wire 					[127:0]		RD,	
	output reg					[31:0]			Data_out,
	output wire										miss
);

	reg							[31:0]				cache		   [0:127]	;
	reg							[4:0]					index ;
	reg							[1:0]					offset ;
	reg													valid  		   [0:31] ;
	reg							[2:0]					tag			   [0:31] ;
	reg													MemWrite_reg ;
	
	integer i ;
	
	assign miss=(~(MemRead|MemWrite_reg))|((WA[9:7]==tag[index])&(valid[index]==1'b1)) ? 1'b0:1'b1 ;
	
always@(negedge clk or negedge RST)
	begin
		if(!RST)
			begin
				MemWrite_reg<=1'b0 ;
			end
		else
			begin
				MemWrite_reg<=MemWrite ;
			end
	end

always@(posedge clk or negedge RST)
	begin
		if(!RST)
			begin
				for(i=0; i<=127;i=i+1)
					cache[i]<=32'b0 ;
				for(i=0; i<=31; i=i+1)
					begin
						valid[i]<=1'b0 ;
						tag[i]<=3'b0 ;
					end
			end
		else if(wr_en)
			begin
				if((WA[9:7]==tag[index])&(valid[index]==1'b1))
					begin
						cache[{index,offset}]<=Data_in ;
					end
			end	
		else if(rd_en)
			begin
				if(WA[9:7]!=tag[index])
					begin
						tag[index]<=WA[9:7] ;								
					end			
				else if(valid[index]==1'b0 )
					begin
						valid[index]<=1'b1 ;
					end			
				if(ready)
					begin
						{cache[{index,2'b11}],cache[{index,2'b10}],cache[{index,2'b01}],cache[{index,2'b00}]}<=RD ;
					end
			end
	end
	
always @(*)
	begin
		index=WA[6:2] ;
		offset=WA[1:0] ;
		Data_out=cache[{index,offset}] ;			
	end			

endmodule