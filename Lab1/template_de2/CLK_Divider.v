module CLK_Divider(CLOCK_50M,CLKDiv,reset,outCLK);
	input CLOCK_50M; //50Mhz
	input [15:0]CLKDiv;
	input reset; 
	
	output logic outCLK;
	
	reg [15:0]counter;
	
	always @(posedge CLOCK_50M )
	begin			
		if (reset == 1'b0)
			begin
				counter <= 0;
				outCLK <= 0; 
			end
		else if(counter !== CLKDiv)
			begin
				counter <= counter + 1;
			end
		else	
			begin
				outCLK = !outCLK;
				counter <= 0;	
			end
	end
endmodule
