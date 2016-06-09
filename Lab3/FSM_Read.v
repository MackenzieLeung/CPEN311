module FSM_Read(CLK, start,waitRead, waitOutput, waitComplete,
					 CE, OE ,startRead_flag ,startComplete_flag,startOutput_flag, 
					 startOutputLow_flag, addr_odd, addr_out, flashed_flag);

input CLK,start,waitRead,waitOutput,waitComplete;
input [21:0]addr_odd;
output logic CE, OE;
output logic startRead_flag, startComplete_flag,startOutput_flag,startOutputLow_flag,flashed_flag;
output [21:0]addr_out;
//state parameters
parameter idle					= 3'b000;
parameter waitToReadLow		= 3'b100;
parameter readOutputLow		= 3'b110;
parameter waitToCompleteLow= 3'b011;
parameter waitToRead			= 3'b101;
parameter readOutput			= 3'b111;
parameter waitToComplete	= 3'b010;

reg [2:0] state;
reg startB;
always_ff @(posedge CLK)
	begin
		case(state)
			idle: 			if(start & !startB) 	state <= waitToReadLow; //detects edge of clock and then moves to next state
								else						state <= idle;
			waitToReadLow:	if(waitRead) 			state <= readOutputLow; //waits for 140ns (min 110 ns)
								else 						state <= waitToReadLow;
			readOutputLow: if(waitOutput)			state <= waitToCompleteLow; //waits 40 ns
								else						state <= readOutputLow;
			waitToCompleteLow: 						state <= waitToRead;
			waitToRead:		if(waitRead) 			state <= readOutput; //waits for 140ns (min 110 ns)
								else 						state <= waitToRead;
			readOutput: 	if(waitOutput)			state <= waitToComplete; //waits 40 ns
								else						state <= readOutput;
			waitToComplete:if(waitComplete)		state <= idle;
								else						state <= waitToComplete;
			default:										state <= idle;
		endcase
	end

//edge detector
always_ff @(posedge CLK)  
begin	
	if(start)
		startB <= 1'b1;
	else	
		startB <= 1'b0;
end
	
	
	
//Output to control flash
always_comb				
	begin
		CE								= !(state[2]);
		OE 							= !(state[2]);
		startRead_flag 			= (state == waitToReadLow | state == waitToRead);		// starts counter for read
		startOutput_flag 			= (state == readOutputLow | state == readOutput);		// starts counter for output
		startOutputLow_flag 		= (state == readOutputLow);  //flag notifies addr_fsm to get next address
		flashed_flag 				= (state == waitToComplete | state == waitToCompleteLow);
		startComplete_flag 		= (state == waitToComplete);  //flag notifies addr_fsm to get next address
		addr_out						= {(addr_odd[21:1]),(state[0])};
	end
	
endmodule