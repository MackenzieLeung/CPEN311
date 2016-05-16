module tone(outCLK,CLOCK_50M,SW);
   input CLOCK_50M; //50Mhz
	input [3:0]SW;
	output logic outCLK;
	reg [15:0]counter;
	reg [15:0]CLKDiv;
	
	always @(posedge CLOCK_50M )
	begin
		if(SW[0] == 1'b1)
			begin
				case(SW[3:1])
					3'b000: //587hz DO 
						CLKDiv <= 16'b1010_0110_0101_1101;
					3'b001: //523hz RE
						CLKDiv <= 16'b1011_1010_1011_1001;
					3'b010: //659hz MI
						CLKDiv <= 16'b1001_0100_0011_0000;
					3'b011: //698hz FA
						CLKDiv <= 16'b1001_0100_0011_0000;
					3'b100: //783hz SO
						CLKDiv <= 16'b1001_0100_0011_0000;
					3'b101: //987hz LA
						CLKDiv <= 16'b1001_0100_0011_0000;
					3'b110: //880hz SI
						CLKDiv <= 16'b1001_0100_0011_0000;
					3'b111: //1046hz DO
						CLKDiv <= 16'b1001_0100_0011_0000;
					default:
						CLKDiv <= 16'b0000_0000_0000_0000;
				endcase
				
				if(counter !== CLKDiv)
					begin
						counter <= counter + 1;
					end
				else	
					begin
						outCLK = !outCLK;
						counter <= 0;	
					end
			end
	end
endmodule
