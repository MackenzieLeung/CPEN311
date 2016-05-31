module wait_counter #(parameter BITS = 3)(input CLOCK_50M, input [BITS-1:0]CLK_Div, input flag, output logic completed );	
	reg [BITS-1:0]counter;
	initial counter = 0;
	always @(posedge CLOCK_50M )
	begin			
		if(!flag) begin
			counter <= 0;
			completed <= 0;
		end else if(counter !== CLK_Div) begin
			counter <= counter + 1;
		end else	 begin
			completed <= 1;
			counter <= 0;	
		end
	end
endmodule