module LEDtoSW (CLOCK_50M,LED,SW);
   input CLOCK_50M;
	input [7:0]LED; 
	output logic [2:0]SW;
	
	always @(posedge CLOCK_50M )
	begin
		case(LED[7:0])
			8'b0000_0001: //587hz DO 
				SW <= 3'b000;
			8'b0000_0010: //523hz RE
				SW <= 3'b001;
			8'b0000_0100: //659hz MI
				SW <= 3'b010;
			8'b0000_1000: //698hz FA
				SW <= 3'b011;
			8'b0001_0000: //783hz SO
				SW <= 3'b100;
			8'b0010_0000: //987hz LA
				SW <= 3'b101;
			8'b0100_0000: //880hz SI
				SW <= 3'b110;
			8'b1000_0000: //1046hz DO
				SW <= 3'b111;
			default:
				SW <= 3'b000;
		endcase 
	end
endmodule
