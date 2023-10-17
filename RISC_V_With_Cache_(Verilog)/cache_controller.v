module cache_controller (
	input wire											clk,RST,ready_in,MemRead,MemWrite,miss,
	// input wire						[9:0]				WA,
	output reg											stall_reg,ready_out,wr_en,rd_en
	// output reg					[4:0]				index_out,
	// output reg					[1:0]				offset_out
);

	localparam	IDLE=2'b0 ,
						READ=2'b1,
						WRITE=2'b10 ;

	reg								[1:0]				current_state, next_state ;
	reg													stall, ready_reg ;
	// reg														valid     [0:31] ;
	// reg								[2:0]				tag		[0:31] ;
	
always@(negedge clk or negedge RST)
	begin
		if(!RST)
			begin
				current_state<=IDLE ;
				stall_reg<=1'b0 ;
				// ready_reg<=1'b0 ;
			end
		else
			begin
				current_state<=next_state ;
				stall_reg<=stall ;
				// ready_reg<=ready_in ;
			end
	end

always@(posedge clk or negedge RST)
	begin
		if(!RST)
			begin
				ready_reg<=1'b0 ;
			end
		else
			begin
				ready_reg<=ready_in ;
			end			
	end
	
always@(*)
	begin
		stall=1'b0 ;
		ready_out=ready_in ;
		wr_en=1'b0 ;		
		rd_en=1'b0 ;
		next_state=IDLE ;
		// miss=1'b0 ;
		// index_out=5'b0 ;
		// offset_out=5'b0 ;		
		case(current_state)
			IDLE: begin
						 if(MemRead &(!MemWrite)&miss)
							begin
								next_state=READ ;
								stall=1'b1 ;
							end
						else if(MemWrite &(!MemRead))
							begin
								next_state=WRITE ;
								stall=1'b1 ;
							end
						else
							begin
								next_state=IDLE ;
							end
					  end
			READ: begin
						 // index_out=WA[6:2] ;
						 // offset_out=WA[1:0] ;
						stall=1'b1 ;
						rd_en=1'b1 ;
						ready_out=ready_in ;
						if(ready_reg)
							begin
								next_state=IDLE ;
								stall=1'b0 ;
							end
						else
							begin
								next_state=READ ;
							end
					   end
			WRITE: begin
							 stall=1'b1 ;
							 wr_en=1'b1 ;
							ready_out=ready_in ;
							if(ready_reg)
								begin
									next_state=IDLE ;
									stall=1'b0 ;
								end
							else
								begin
									next_state=WRITE ;
								end							 
						 end
			default: begin
							next_state=IDLE ;	
						  end
		endcase
	end

endmodule