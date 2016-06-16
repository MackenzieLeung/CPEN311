module control_FSM(input clk, input start_flag,
						output array_start_flag, 
						input [7:0] s_array_address, input [7:0] s_array_data, input s_array_wren,  
						input [4:0]shuffle_address, input [7:0]shuffle_data, input shuffle_wren,  
						input [4:0]computeEncrypt_address, input [7:0]computeEncrypt_data,input computeEncrypt_wren, 
						input array_done_flag, input swap_done_flag, input compute_done_flag,
						output [7:0] s_address, output [7:0] s_data, output s_wren
						);
	
reg [2:0]state;
parameter [2:0] INIT =  3'b000;
parameter [2:0] S_ARRAY = 3'b001;
parameter [2:0] SHUFFLE = 3'b011;
parameter [2:0] COMPUTE	= 3'b010;

always_ff @(posedge clk)
begin
	case(state)
		INIT: 
		begin 
			if(start_flag)
					state <= S_ARRAY;
			else
					state <= INIT;
		end
		S_ARRAY: 
		begin 
			if(array_done_flag)
				state <= SHUFFLE;
			else
				state <= S_ARRAY;
		end
		SHUFFLE:
		begin
			if(swap_done_flag)
				state <= COMPUTE;
			else
				state <= SHUFFLE;
		end
		COMPUTE:	
		begin 
			if(compute_done_flag)
				state <= INIT;
			else
				state <= COMPUTE;
		end
		default: state <= INIT;
	endcase
end

always @(posedge clk)
begin
	if(state == INIT)
	begin
		array_start_flag <= 1'b1;
	end
	else if(state == S_ARRAY)
	begin
		array_start_flag <= 1'b1;
		s_address <= s_array_address;
		s_data 	 <= s_array_data;
		s_wren 	 <= s_array_wren;
	end
	else if(state == SHUFFLE)
	begin
		array_start_flag <= 1'b0;
		s_address <= shuffle_address;
		s_data <= shuffle_data;
		s_wren <= shuffle_wren;
	end
	else if(state == COMPUTE)
	begin
		array_start_flag <= 1'b0;
		s_address <= computeEncrypt_address;
		s_data 	 <= computeEncrypt_data;
		s_wren 	 <= computeEncrypt_data;
	end
	else
	begin
		array_start_flag <= 1'b0;
	end
end

endmodule