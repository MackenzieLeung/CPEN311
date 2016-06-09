module freq_divider(clk, div_clk_count, div_clk_out);
input clk;
input reg [15:0]div_clk_count;
output div_clk_out;

reg [15:0]counter;
wire div_clk_out;

// Initialize counter to 0, clock out to 0
initial counter = 16'd0;
initial div_clk_out = 1'b0;
	
always @(posedge clk)
begin

	// Count CLOCK_50 pulses
	// Once number of pulses reaches specified specified count,
	// Reset the counter and flip the clock out signal
	if(counter == div_clk_count)
	begin
		counter <= 16'd0;
		div_clk_out <= ~div_clk_out;
	end
	
	// Else, increment the counter every CLOCK_50 pulse
	else
	begin
		counter <= counter + 1;
	end
end

endmodule