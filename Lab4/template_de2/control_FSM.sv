module control_FSM(input clk, input start_flag,
						input s_array_flag, input s_array_address, input s_array_data, input s_array_wren, 
						input shuffle_flag, input shuffle_address, input shuffle_data, input shuffle_wren, 
						input computeEncrypt_flag, input computeEncrypt_address, input computeEncrypt_data,input computeEncrypt_wren, 
						output s_array_init, output computeEncrypt_init, output shuffle_init,output s_address, output s_data, output s_wren
						);
	
reg [2:0]state;
parameter INIT 2'b00;
parameter S_ARRAY 2'b01;
parameter SHUFFLE 2'b10;
parameter COMPUTE	2'b11;

always_ff @(posedge clk)
begin
	case state
		INIT: begin if start_flag
					state <= S_ARRAY;
				end else begin
					state <= INIT;
				end
		S_ARRAY: begin if s_array_flag
						state <= COMPUTE;
					end else begin
						state <= S_ARRAY;
					end
		COMPUTE:	begin if s_array_address
									state <= INIT;
								end else begin
									state <= COMPUTE;
								end							
	endcase
end

always @(posedge clk)
begin
	if(state == INIT)
	begin
		s_array_init <= 1'b1;
		s_wren 		 <= 1'b0;
	end
	else if(state == S_ARRAY)
	begin
		s_address <= s_array_address;
		s_data 	 <= s_array_data;
		s_wren 	 <= s_array_wren;
	end
	else if(state == COMPUTE)
		s_address <= computeEncrypt_address;
		s_data 	 <= computeEncrypt_data;
		s_wren 	 <= computeEncrypt_data;
	end

end

endmodule