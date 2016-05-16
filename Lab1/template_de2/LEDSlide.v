module LED_Slide(LED_CLK,LEDG);
   input LED_CLK; 
	
	output logic [7:0]LEDG;
	initial LEDG = 1'b00000001 ;
	logic left;
	initial left = 1; 
	
	always @(posedge LED_CLK )
	begin
		if(LEDG[7] == 1'b1)
			begin
				left = 0;
			end
		else if (LEDG[0] == 1'b1)
			begin
				left = 1;
			end
			
		if(left == 1'b1)
			begin
				LEDG = LEDG << 1;
			end
		else
			begin
				LEDG = LEDG >> 1;
			end
	end
endmodule
