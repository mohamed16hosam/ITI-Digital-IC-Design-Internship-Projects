module RISC_V_SC_tb () ;

reg										clk_tb,RST_tb ;
wire 					[31:0]			Instr_tb ;
wire 					[31:0]			PC_out_tb ;

RISC_V_SC_top RVSC (
.clk(clk_tb),
.RST(RST_tb),
.Instr(Instr_tb),
.PC_out(PC_out_tb)
);

Instruct_mem im (
.A(PC_out_tb),
.Instr(Instr_tb)
);

initial
	begin
		RST_tb=1'b0 ;
		clk_tb=1'b0 ;
		#10 ;
		RST_tb=1'b1 ;
		#3000 ;
		$finish ;
	end

always #5 clk_tb=~clk_tb ;	
	
endmodule