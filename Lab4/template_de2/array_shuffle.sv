module array_shuffle(clk,
							rst,
							secret_key,
							secret_byte,
							address,
							address_i,
							address_j,
							data,
							q,
							q_i,
							q_j,
							wren,
							array_done_flag,
							swap_done_flag,
							test_bit,
							temp_reg
							);

input clk;	// Clock 50
input rst;

input reg [23:0] secret_key;	// 24-bit secret key
output reg [7:0] secret_byte;
						 
reg [3:0] state;	// state register

output reg [7:0] address_i;	// address for s[i]
output reg [7:0] address_j;	// address for s[j]
output reg [7:0] address;	// address for s_memory

output reg [7:0] data;	// register holding data for s_memory

output reg [7:0] q_i;	// s[i] memory output
output reg [7:0] q_j; // s[j] memory output
input reg [7:0] q;	// s_memory output

output wren;	// 1 = write to memory, 0 = do not write

output reg [7:0] temp_reg;	// temporary data register for swapping

input array_done_flag;	// 1 = array initialization complete
output swap_done_flag;	// 1 = swap_done_flag, 0 = not finished

reg [8:0] counter;

output logic test_bit;


// State Encodings
parameter [3:0] INIT = 4'b0000;	// initialize the loop counter
parameter [3:0] CALC_J = 4'b0001;	// calculate j address
parameter [3:0] READ_SJ = 4'b0011;	
parameter [3:0] SWAP_REG = 4'b0010;	
parameter [3:0] SET_J_ADDR = 4'b0110;	
parameter [3:0] WRITE_I_TO_J = 4'b0111;	
parameter [3:0] WAIT = 4'b0101;	
parameter [3:0] SET_I_ADDR = 4'b0100;
parameter [3:0] WRITE_J_TO_I = 4'b1100;	
parameter [3:0] INCR_I = 4'b1101;	
parameter [3:0] CMP_I = 4'b1111;
parameter [3:0] END_SWAP = 4'b1110;	


always_ff @(posedge clk or negedge rst)
begin
	if(!rst) state <= INIT;
	else
	begin
		case(state)
			INIT:
			begin
				if(array_done_flag)
					state <= CALC_J;
				else
					state <= INIT;
			end
			
			CALC_J:
			begin
				state <= READ_SJ;
			end

			READ_SJ:
			begin
				state <= SWAP_REG;
			end
			
			SWAP_REG:
			begin
				state <= SET_J_ADDR;
			end
			
			SET_J_ADDR:
			begin
				state <= WRITE_I_TO_J;
			end
			
			WRITE_I_TO_J:
			begin
				state <= WAIT;
			end	
			
			WAIT:
			begin
				state <= SET_I_ADDR;
			end	
			
			SET_I_ADDR:
			begin
				state <= WRITE_J_TO_I;
			end	
			
			WRITE_J_TO_I:
			begin
				state <= INCR_I;
			end
						
			INCR_I:
			begin
				state <= CMP_I;
			end

			CMP_I:
			begin
				if(counter <= 9'd255)
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
			counter = 9'd0;
			address_i = 8'd0; // Initialize addresses to 0
			address_j = 8'd0;
			address = address_i; // initialize smem address to address_i
			wren = 1'b0; // set to read
			swap_done_flag = 1'b0;
		end
		
	else if(state == CALC_J)
		begin			
			// Read q into s[i]
			q_i = q;
			
			// Calculate the secret byte
			if((address_i % 8'd3) == 8'd0)
				address_j = address_j + q_i + secret_key[23:16];
			else if((address_i % 8'd3) == 8'd1)
				address_j = address_j + q_i + secret_key[15:8];
			else
				address_j = address_j + q_i + secret_key[7:0];
						
			// Set address as address_j
			address = address_j;
			
			wren = 1'b0;
			swap_done_flag = 1'b0;
		end

	else if(state == READ_SJ)
	begin
		// Read q into s[j]
		q_j = q;
		
		wren = 1'b0;
		swap_done_flag = 1'b0;
	end
		
	else if(state == SWAP_REG)
		begin
			// Store s[j] into temp register
			temp_reg = q_j;
			
			// Make s[j] = s[i]
			q_j = q_i;
			
			// Make s[i] = s[j]
			q_i = temp_reg;
			
			wren = 1'b0;
			swap_done_flag = 1'b0;
		end

	else if(state == SET_J_ADDR)
		begin
			address = address_j;
			data = q_j;
			wren = 1'b0;
			swap_done_flag = 1'b0;
		end
		
	else if(state == WRITE_I_TO_J)
		begin
			wren = 1'b1;
			swap_done_flag = 1'b0;
		end
		
	else if(state == WAIT)
		begin
			wren = 1'b0;
			swap_done_flag = 1'b0;
		end
		
	else if(state == SET_I_ADDR)
		begin
			address = address_i;
			data = q_i;
			wren = 1'b0;
			swap_done_flag = 1'b0;
		end

	else if(state == WRITE_J_TO_I)
		begin
			wren = 1'b1;
			swap_done_flag = 1'b0;
		end
		
	else if(state == INCR_I)
		begin
			counter = counter + 9'd1;
			wren = 1'b0;
			swap_done_flag = 1'b0;
		end
		
	else if(state == CMP_I)
		begin
			address_i = counter[7:0];
			address = address_i;
			wren = 1'b0;
			swap_done_flag = 1'b0;
		end
		
	else if(state == END_SWAP)
		begin
			wren = 1'b0;
			swap_done_flag = 1'b1;
		end
	else
		begin
			wren = 1'b0;
			swap_done_flag = 1'b0;
		end
end

endmodule