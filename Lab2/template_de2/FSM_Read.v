module FSM_Read(CLK, start,waitRead,waitComplete, waitOutput, CE, OE ,startRead_flag ,startComplete_flag,startOutput_flag);

input CLK,start,waitRead,waitComplete,waitOutput;

output logic CE, OE;
output logic startRead_flag, startComplete_flag,startOutput_flag;

parameter idle					= 2'b00;
parameter waitToRead			= 2'b10;
parameter readOutput			= 2'b11;
parameter waitToComplete	= 2'b01;

reg [1:0] state;
always_ff @(posedge CLK)
	begin
		case(state)
			idle: 			if(start) 			state <= waitToRead;
								else					state <= idle;
			waitToRead:		if(waitRead) 		state <= readOutput;
								else 					state <= waitToRead;
			readOutput: 	if(waitOutput)		state <= waitToComplete;
								else					state <= readOutput;
			waitToComplete: if(waitComplete) state <= idle;
								 else					state <= waitToComplete;
			default:									state <= idle;
		endcase
	end

always_comb
	begin
		CE								= !(state[1]);
		OE 							= !(state[1]);
		startRead_flag 			= (state == waitToRead);
		startOutput_flag 			= (state == readOutput);
		startComplete_flag 		= (state == waitToComplete);
	end
	
endmodule