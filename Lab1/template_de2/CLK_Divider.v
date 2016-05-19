module CLK_Divider #(parameter BITS = 16)(CLOCK_50M,CLK_Div,out_CLK);
	input CLOCK_50M; //50Mhz
	input [BITS-1:0]CLK_Div;

	
	output logic out_CLK;
	
	reg [BITS-1:0]counter = 0;
	
	always @(posedge CLOCK_50M )
	begin			
		if(counter !== (CLK_Div-1))
			begin
				counter <= counter + 1;
			end
		else	
			begin
				out_CLK = !out_CLK;
				counter <= 0;	
			end
	end
endmodule
