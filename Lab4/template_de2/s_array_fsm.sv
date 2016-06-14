module s_array_fsm(clk,
						 rst,
						 address,
						 data,
						 q,
						 wren,
						 array_init_flag);

input clk;	// Clock 50
input rst;	// Reset pin
						 
reg [2:0] state;	// state register

reg [7:0] counter;	// loop counter

output reg [7:0] address;	// address to write data to
output reg [7:0] data;	// data to write into memory
input reg [7:0] q;	// memory output
output wren;	// 1 = write to memory, 0 = do not write

output array_init_flag;	// 1 = array initialized, 0 = not initialized 

parameter [2:0] INIT = 3'b000;
parameter [2:0] INCREMENT = 3'b001;
parameter [2:0] COMPARE = 3'b011;
parameter [2:0] SET_ADDR = 3'b010;
parameter [2:0] WRITE_DATA = 3'b110;
parameter [2:0] ARRAY_FILLED = 3'b111;

// State Logic
always_ff @(posedge clk or posedge rst)
begin
	if(rst)
		state <= INIT;
	else
	begin
		case(state)
			INIT:
			begin
				state <= INCREMENT;
			end
			INCREMENT:
			begin
				state <= COMPARE;
			end
			COMPARE:
			begin
				if(counter <= 8'd255)
					state <= SET_ADDR;
				else
					state <= ARRAY_FILLED;
			end
			SET_ADDR:
			begin
				state <= WRITE_DATA;
			end
			WRITE_DATA:
			begin
				state <= INCREMENT;
			end
			ARRAY_FILLED:
			begin
				state <= ARRAY_FILLED;
			end
			default: state <= INIT;
		endcase
	end
end

// Output Logic
assign address = counter;
assign data = counter;
						  
always @(posedge clk)
begin
	if(state == INIT)
	begin
		counter = 8'd0;
		wren = 1'b0;
		array_init_flag <= 1'b0;
	end
	else if(state == INCREMENT)
	begin
		counter = counter + 8'd1;
		wren = 1'b0;
		array_init_flag <= 1'b0;
	end
	else if(state == SET_ADDR)
	begin
		wren <= 1'b1;
		array_init_flag <= 1'b0;
	end
	else if(state == ARRAY_FILLED)
		array_init_flag <= 1'b1;
	else
	begin
		wren <= 1'b0;
		array_init_flag <= 1'b0;
	end
end

endmodule