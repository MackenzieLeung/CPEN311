module control_fsm(state,
						 key_pressed,
						 clk,
						 rst,
						 restart_flag,
						 dir_flag,
						 start_bit);

output reg [3:0]state;	// The current state
input [7:0]key_pressed;	// ASCII code of the key pressed
input clk;	// 50 MHz clock signal
input rst;	// Reset signal
output dir_flag;
output start_bit;
output restart_flag;

// Key Parameters
parameter character_B = 8'h42;
parameter character_D = 8'h44;
parameter character_E = 8'h45;
parameter character_F = 8'h46;
parameter character_R = 8'h52;

// State Parameters
parameter [3:0] INIT = 4'b0000;
parameter [3:0] STOP = 4'b0001;
parameter [3:0] PLAY = 4'b0011;
parameter [3:0] PLAY_BACK = 4'b0101;
parameter [3:0] PLAY_FORWARD = 4'b0100;
parameter [3:0] RESTART = 4'b1100;
parameter [3:0] STOP_BACK = 4'b1101;

always_ff @(posedge clk or posedge rst)
begin

	if(rst) state <= INIT;
	else
	begin
		case(state)
			INIT:
				begin
					state <= STOP;
				end
			STOP:
				begin
					if (key_pressed == character_E) state <= PLAY;
					else if (key_pressed == character_B) state <= STOP_BACK;
					else state <= STOP;
				end
			PLAY:
				begin
					if (key_pressed == character_D) state <= STOP;
					else if (key_pressed == character_B) state <= PLAY_BACK;
					else if (key_pressed == character_R) state <= RESTART;
					else state <= PLAY;
				end 
			PLAY_BACK:
				begin
					if(key_pressed == character_F) state <= PLAY;
					else if (key_pressed == character_D) state <= STOP_BACK;
					else state <= PLAY_BACK;
				end 
			RESTART:
				begin
					if (key_pressed == character_R) state <= RESTART;
					else state <= PLAY;
				end 
			STOP_BACK:
				begin
					if (key_pressed == character_E) state <= PLAY_BACK;
					else if(key_pressed == character_F) state <= STOP;
					else state <= STOP_BACK;
				end
			default: state <= INIT; 
		endcase
	end
end

// Output Logic
always_ff @(posedge clk)
begin
	if((state == PLAY) | (state == PLAY_BACK))
		start_bit = 1'b1;
	else
		start_bit = 1'b0;
end

always_ff @(posedge clk)
begin
	if((state == PLAY_BACK) | (state == STOP_BACK))
		dir_flag = 1'b1;
	else
		dir_flag = 1'b0;
end

endmodule