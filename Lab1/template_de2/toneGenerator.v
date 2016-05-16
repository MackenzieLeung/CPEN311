module toneGenerator(CLOCK_50M,SW,CLKDiv, scope_units, reset);
   input CLOCK_50M; //50Mhz
	input [3:0]SW;
	output reg [31:0]scope_units;
	output logic [15:0]CLKDiv;
	output logic reset;
	
//Uppercase Letters
parameter character_D =8'h44;
parameter character_F =8'h46;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_X =8'h58;

//Lowercase Letters
parameter character_lowercase_a= 8'h61;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_i= 8'h69;
parameter character_lowercase_o= 8'h6F;
parameter character_lowercase_u= 8'h75;

//Other Characters
parameter character_space=8'h20; //' '     

	
	always @(posedge CLOCK_50M )
	begin
		if(SW[0] == 1'b1)
			begin
				case(SW[3:1])
					3'b000: //587hz DO 
					begin
						CLKDiv <= 16'b1010_0110_0101_1101;
						scope_units <= {character_space, character_D, character_lowercase_o, character_space};
					end
					3'b001: //523hz RE
					begin
						CLKDiv <= 16'b1011_1010_1011_1001;
						scope_units <= {character_space, character_R, character_lowercase_e, character_space};
					end						
					3'b010: //659hz MI
					begin
						CLKDiv <= 16'b1001_0100_0011_0000;
						scope_units <= {character_space, character_M, character_lowercase_i, character_space};
					end
					3'b011: //698hz FA
					begin
						CLKDiv <= 16'b1000_1011_1110_1001;
						scope_units <= {character_space, character_F, character_lowercase_a, character_space};
					end
					3'b100: //783hz SO
					begin
						CLKDiv <= 16'b0111_1100_1011_1000;
						scope_units <= {character_space, character_S, character_lowercase_o, character_space};
					end
					3'b101: //987hz LA
					begin
						CLKDiv <= 16'b0110_0010_1111_0001;
						scope_units <= {character_space, character_L, character_lowercase_a, character_space};
					end
					3'b110: //880hz SI
					begin
						CLKDiv <= 16'b0110_1110_1111_1001;
						scope_units <= {character_space, character_T, character_lowercase_i, character_space};
					end
					3'b111: //1046hz DO
					begin
						CLKDiv <= 16'b0101_1101_0101_1101;
						scope_units <= {character_space, character_D, character_lowercase_o, character_space};
					end
					default:
					begin
						CLKDiv <= 16'b0000_0000_0000_0000;
						scope_units <= {character_X, character_X, character_X, character_X};
					end
				endcase 
				reset <= 1;
			end
		else
			begin
				reset <= 0;
			end
	end
endmodule
