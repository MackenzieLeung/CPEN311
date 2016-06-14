module mux_3to1(input clk, input [7:0]s_array, input [7:0]encrypt, input [7:0]shuffle, input [1:0]sel, output [7:0]to_s_mem);

always@(posedge clk)
	begin
		case(sel)
			2'b00: to_s_mem <= 8'bZZZZZZZZ;
			2'b01: to_s_mem <= s_array;
			2'b10: to_s_mem <= shuffle;
			2'b11: to_s_mem <= encrypt;
			default: to_s_mem <= 8'bZZZZZZZZ;
		endcase
	end
endmodule