module Data_mem_system (
	input wire											clk,RST,MemRead,MemWrite,
	input wire						[9:0]			WA,
	input wire						[31:0]			Data_in,
	output wire											stall,
	output wire						[31:0]			Data_out
);

wire														miss,ready,ready_to_cache,rd_en,wr_en,rd_en_reg ;
wire									[127:0]		Data_mem_out ;
// wire                            		[4:0]			index ;
// wire									[1:0]			offset ;	

Data_mem dm (
.clk(clk),
.RST(RST),
.miss(miss),
.rd_en(rd_en),
.wr_en(wr_en),
.WA(WA),
.WD(Data_in),
.RD(Data_mem_out),
.ready(ready),
.rd_en_reg(rd_en_reg)
);

cache_mem cm (
.clk(clk),
.RST(RST),
.ready(ready_to_cache), 
.wr_en(wr_en),
.rd_en(rd_en_reg),
.MemRead(MemRead),
.MemWrite(MemWrite),
.WA(WA),
.RD(Data_mem_out),
.Data_in(Data_in),
.Data_out(Data_out),
.miss(miss)
);

cache_controller cc (
.clk(clk),
.RST(RST),
.ready_in(ready),
.MemRead(MemRead),
.MemWrite(MemWrite),
.miss(miss),
.stall_reg(stall),
.ready_out(ready_to_cache),
.wr_en(wr_en),
.rd_en(rd_en)
);

endmodule