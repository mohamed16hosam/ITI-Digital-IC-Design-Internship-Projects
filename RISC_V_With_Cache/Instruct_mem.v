module Instruct_mem (
	input wire						[31:0]					A,
	output reg						[31:0]					Instr
);

	reg								[31:0]					PC ;
	reg								[31:0]					mem			[0:99]	;

always@(*)
	begin
		PC=A>>2 ;
		Instr=mem[PC] ;	
	end

initial
	begin
		$readmemh("Instr_Cache_hex.txt", mem) ;		
	end
	
endmodule