module PCTarget (
	input wire				[31:0]				PC,
	input wire				[31:0]				ImmExt,
	output wire			[31:0]				PCTarget
);

assign PCTarget=PC+ImmExt ;

endmodule