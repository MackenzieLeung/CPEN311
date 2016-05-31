module addr_fsm(state,
					 addr_hi,
					 clk,
					 rst);

output reg [3:0] state;
output reg [21:0] addr_hi;
input clk;
input rst;

parameter [3:0] INIT = 4'b0000;					 
parameter [3:0] SET_ADDR = 4'b0001;
parameter [3:0] INC_ADDR = 4'b0011;

logic inc_addr_clk;
assign inc_addr_clk = state[1];

always_ff @ (posedge clk or posedge rst)
begin
	if(rst == 1'b1) state = INIT;
	else
	begin
		case(state)
			INIT:
				begin
					state <= SET_ADDR;
				end
			SET_ADDR:
				begin
					state <= INC_ADDR;
				end
			INC_ADDR:
				begin
					state <= SET_ADDR;
				end
			default: state = INIT;
		endcase
	end
end

// Output logic
// Address increment logic
always_ff @(posedge inc_addr_clk)
begin
	addr_hi <= addr_hi+2;
end 
endmodule	