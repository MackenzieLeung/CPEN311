module toneGenerator(CLOCK_50M,SW,CLKDiv,reset);
   input CLOCK_50M; //50Mhz
	input [3:0]SW;
	output logic [15:0]CLKDiv;
	output logic reset;
	
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
						CLKDiv <= 16'b1000_1011_1110_1001;
					3'b100: //783hz SO
						CLKDiv <= 16'b0111_1100_1011_1000;
					3'b101: //987hz LA
						CLKDiv <= 16'b0110_0010_1111_0001;
					3'b110: //880hz SI
						CLKDiv <= 16'b0110_1110_1111_1001;
					3'b111: //1046hz DO
						CLKDiv <= 16'b0101_1101_0101_1101;
					default:
						CLKDiv <= 16'b0000_0000_0000_0000;
				endcase 
				reset <= 1;
			end
		else
			begin
				reset <= 0;
			end
	end
endmodule
