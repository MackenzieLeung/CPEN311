module array_shuffle(clk,
							secret_key,
							address,
							data,
							q,
							wren,
							array_init_flag,
							swap_done_flag,
							line_sel
							);

input clk;	// Clock 50

input reg [23:0] secret_key;	// 24-bit secret key
						 
reg [3:0] state;	// state register

reg [7:0] address_i;	// address for s[i]; loop counter
reg [7:0] address_j;	// address for s[j]
output reg [7:0] address;	// address for s_memory

reg [7:0] data_i;	// register holding s[i]
reg [7:0] data_j;	// register holding s[j]
output reg [7:0] data;	// register holding data for s_memory

reg [7:0] q_i;	// s[i] memory output
reg [7:0] q_j; // s[j] memory output
input reg [7:0] q;	// s_memory output

output wren;	// 1 = write to memory, 0 = do not write

reg [7:0] temp_reg;	// temporary data register for swapping

input array_init_flag;	// 1 = array initialization complete
output swap_done_flag;	// 1 = swap_done_flag, 0 = not finished

output reg [1:0] line_sel;

parameter KEYLENGTH = 4'd3;	// key length is 3

// State Encodings
parameter [3:0] INIT = 4'b0000;	// initialize the loop counter
parameter [3:0] CALC_J = 4'b0001;	// calculate j address
parameter [3:0] SET_I_ADDR = 4'b0011;	// set address to i
parameter [3:0] STORE_I_TO_TEMP = 4'b0010;	// store s[i] to temp register
parameter [3:0] SET_J_ADDR = 4'b0110;	// set address to j
parameter [3:0] READ_J_DATA = 4'b0111;	// set data to s[j]
parameter [3:0] WRITE_J_TO_I = 4'b0101;	// write s[j] to s[i]
parameter [3:0] SET_I_TO_TEMP = 4'b0100;	// set data to temp register
parameter [3:0] SET_J_ADDR_2 = 4'b1100;	// set address to s[j]
parameter [3:0] WRITE_I_TO_J = 4'b1101;	// write s[i] to s[j]
parameter [3:0] INCR_I = 4'b1111;	// increment the i address
parameter [3:0] CMP_I = 4'b1110;	// compare if greater than 256
parameter [3:0] END_SWAP = 4'b1010;	// done swapping

always_ff @(posedge clk or posedge array_init_flag)
begin
	if(array_init_flag) state <= INIT;
	else
	begin
		case(state)
			INIT:
			begin
				state <= CALC_J;
			end
			
			CALC_J:
			begin
				state <= SET_I_ADDR;
			end
			
			SET_I_ADDR:
			begin
				state <= STORE_I_TO_TEMP;
			end
			
			STORE_I_TO_TEMP:
			begin
				state <= SET_J_ADDR;
			end
			
			SET_J_ADDR:
			begin
				state <= READ_J_DATA;
			end
			
			READ_J_DATA:
			begin
				state <= WRITE_J_TO_I;
			end
			
			WRITE_J_TO_I:
			begin
				state <= SET_I_TO_TEMP;
			end
			
			SET_I_TO_TEMP:
			begin
				state <= SET_J_ADDR_2;
			end
			
			SET_J_ADDR_2:
			begin
				state <= WRITE_I_TO_J;
			end
			
			WRITE_I_TO_J:
			begin
				state <= INCR_I;
			end
			
			INCR_I:
			begin
				state <= CMP_I;
			end

			CMP_I:
			begin
				if(address_i <= 8'd255)
					state <= CALC_J;
				else
					state <= END_SWAP;
			end

			END_SWAP:
			begin
				state <= END_SWAP;
			end
			
			default: state <= INIT;
		endcase
	end
end

// Output logic
always @ (posedge clk)
begin
	if(state == INIT)
		begin
			address_i = 8'd0;
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
		
	else if(state == CALC_J)
		begin
			address_j = address_j + q_i + secret_key[address_i % KEYLENGTH];
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end

	else if(state == SET_I_ADDR)
		begin
			address = address_i;
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == STORE_I_TO_TEMP)
		begin
			temp_reg = q;
			q_i = q;
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == SET_J_ADDR)
		begin
			address = address_j;
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == READ_J_DATA)
		begin
			q_j = q;
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == WRITE_J_TO_I)
		begin
			address = address_i;
			data = q_j;
			wren = 1'b1;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == SET_I_TO_TEMP )
		begin
			data = temp_reg;
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == SET_J_ADDR_2)
		begin
			address = address_j;
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == WRITE_I_TO_J)
		begin
			wren = 1'b1;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == INCR_I)
		begin
			address_i = address_i + 8'd1;
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == CMP_I)
		begin
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
	else if(state == END_SWAP)
		begin
			wren = 1'b0;
			swap_done_flag = 1'b1;
			line_sel = 2'd2;
		end
	else
		begin
			wren = 1'b0;
			swap_done_flag = 1'b0;
			line_sel = 2'd2;
		end
end

endmodule