module s_array_fsm(clk,
						 rst,
						 address,
						 data,
						 q,
						 wren);

input clk;	// Clock 50
input rst;	// Reset pin
						 
reg [2:0] state;	// state register

reg [7:0] counter;	// loop counter

output reg [7:0] address;	// address to write data to
output reg [7:0] data;	// data to write into memory
output reg [7:0] q;	// memory output
output logic wren;	// 1 = write to memory, 0 = do not write 

parameter [2:0] INIT = 3'b000;
parameter [2:0] INCREMENT = 3'b001;
parameter [2:0] COMPARE = 3'b011;
parameter [2:0] SET_ADDR = 3'b010;
parameter [2:0] WRITE_DATA = 3'b110;

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
					state <= COMPARE;
			end
			SET_ADDR:
			begin
				state <= WRITE_DATA;
			end
			WRITE_DATA:
			begin
				state <= INCREMENT;
			end
			default: state <= INIT;
		endcase
	end
end

// Output Logic
s_memory s_array(.address(address),
						  .clock(clk),
						  .data(data),
						  .wren(wren),
						  .q(q));	

assign address = counter;
assign data = counter;
						  
always @(posedge clk)
begin
	if(state == INIT)
	begin
		counter = 8'd0;
		wren = 1'b0;
	end
	else if(state == INCREMENT)
	begin
		counter = counter + 8'd1;
		wren = 1'b0;
	end
	else if(state == SET_ADDR)
		wren <= 1'b1;
	else
		wren <= 1'b0;
end

endmodule