module output_transition(input clk, input [7:0]d, output logic [7:0]q);

always_ff @(posedge clk) //flip-flop flash output
	begin
		if(clk)
			q <= d;
	end
endmodule