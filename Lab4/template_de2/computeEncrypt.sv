module computeEncrypt(input clk,input reset,input [7:0] s_q, input [7:0]encrypt_K_q, 
							output wrenS, output wrenD, output [7:0]dencrypt_K_data, output [4:0]kE_add,output [4:0]kD_add, output [7:0]s_add,output [7:0] s_data   );
// i is address to sMEM, k is address to eMEM and dMEM, s is the data back from sMEM, enK is data from eMEM, denK is data to dMEM
reg [7:0] sI;
reg [7:0] sJ;
reg [7:0] sF;
reg [4:0] kCurrent;
reg [4:0] k;
reg [7:0] f;
reg [7:0] i;
reg [7:0] j;
reg [7:0]encrypt_K;
reg [7:0]dencrypt_K;

reg [4:0] state;
parameter [4:0] SLEEP 			= 5'b00111;
parameter [4:0] INIT 			= 5'b00001;
parameter [4:0] INCREMENT_I 	= 5'b00011;
parameter [4:0] READ_S_I 		= 5'b00010;
parameter [4:0] WAIT_S_I 		= 5'b00110;
parameter [4:0] INCREMENT_J 	= 5'b00100;
parameter [4:0] READ_S_J 		= 5'b01100;
parameter [4:0] WAIT_S_J 		= 5'b01000;
parameter [4:0] SWAP_WRITE_I 	= 5'b11000;
parameter [4:0] SWAP_WAIT_I 	= 5'b10000;
parameter [4:0] SWAP_PAUSE		= 5'b00000;
parameter [4:0] SWAP_WRITE_J 	= 5'b10010;
parameter [4:0] SWAP_WAIT_J 	= 5'b11010;
parameter [4:0] F_ADD 			= 5'b01010;
parameter [4:0] READ_F 			= 5'b01110;
parameter [4:0] WAIT_F 			= 5'b01111;
parameter [4:0] READ_ECRYPT 	= 5'b01011;
parameter [4:0] WAIT_ECRYPT 	= 5'b01001;
parameter [4:0] XOR_F_ECRYPT 	= 5'b01101;
parameter [4:0] WRITE_DECRYPT = 5'b11101;
parameter [4:0] WAIT_DECRYPT 	= 5'b11111;

initial state = SLEEP;

always_ff @(posedge clk or posedge reset)
begin
	if(reset)
		state<= INIT;
	else
	begin
		case(state)
			INIT: 
					begin 
					if (kCurrent <= 8'd31)
						state <= INCREMENT_I;
					end
			INCREMENT_I:
					begin
					state <= READ_S_I;
					end
			READ_S_I:
					begin 
						state <= WAIT_S_I;
					end
			WAIT_S_I: 
					begin
					state <= INCREMENT_J;
					end
			INCREMENT_J:
					begin
					state <= READ_S_J;
					end
			READ_S_J:
					begin
					state <= WAIT_S_J;
					end
			WAIT_S_J:
					begin
					state <= SWAP_WRITE_I;
					end
			SWAP_WRITE_I:
					begin
					state <= SWAP_WAIT_I;
					end
			SWAP_WAIT_I:
					begin
					state <= SWAP_PAUSE;
					end
			SWAP_PAUSE:
					begin
					state <= SWAP_WRITE_J;
					end
			SWAP_WRITE_J:
					begin
					state <= SWAP_WAIT_J;
					end
			SWAP_WAIT_J:
					begin
					state <= F_ADD;
					end
			F_ADD:
					begin
					state <= READ_F;
					end
			READ_F:
					begin
					state <= WAIT_F;
					end
			WAIT_F:
					begin
					state <= READ_ECRYPT;
					end
			READ_ECRYPT:
					begin
					state <= WAIT_ECRYPT;
					end
			WAIT_ECRYPT:
					begin
					state <= XOR_F_ECRYPT;
					end
			XOR_F_ECRYPT:
					begin
					state <= WRITE_DECRYPT;
					end
			WRITE_DECRYPT:
					begin
					state <= WAIT_DECRYPT;
					end
			WAIT_DECRYPT:
					begin
					state <= INIT;
					end
			SLEEP:
					begin
						state <= SLEEP;
					end
			default: state <= INIT;
		endcase
	end
end

always @(posedge clk)
begin
	if (state == INCREMENT_I)begin
		i <= i + 1'd1;
	end else if (state == READ_S_I)begin
		s_add <= i;
	end else if (state == WAIT_S_I)begin
		sI <= s_q;
	end else if (state == INCREMENT_J)begin
		j <= j + sI; 
	end else if (state == READ_S_J)begin
		s_add <= j;
	end else if (state == WAIT_S_I)begin
		sJ <= s_q;
	end else if (state == SWAP_WRITE_I)begin
		s_add <= i;
		s_data <= sJ;
	end else if (state == SWAP_WRITE_J)begin
		s_add <= j;
		s_data <= sI;
	end else if (state == F_ADD)begin
		f <= sJ+sI;
	end else if (state == READ_F)begin
		s_add <= f;
	end else if (state == WAIT_F)begin
		sF <= s_q;
		kCurrent <= k;
	end else if (state == READ_ECRYPT)begin
		kE_add <= kCurrent;
	end else if (state == WAIT_ECRYPT)begin
		encrypt_K <= encrypt_K_q;
	end else if (state == XOR_F_ECRYPT)begin
		dencrypt_K <= (sF^encrypt_K);
	end else if (state == WRITE_DECRYPT)begin
		kD_add <= kCurrent;
		dencrypt_K_data <=dencrypt_K; 
	end else if (state == WAIT_DECRYPT)begin
		k = kCurrent + 1'd1;
	end
end

always_comb
begin
	wrenS = (state[4] & !state[2]);
	wrenD = (state[4] & state[2]);
end
endmodule



// initial vars
// inc i
// read s[i] (store it somewhere)
	//inc j by j and s[i]
// perform a swap
	// read s[j] and store it
// write to s[i] 
// write to s[j]
// f is add s[i] and s[j] (dont use stored val)
// read value
// read encrypt_K
// xor value with f
// write to decrypt_K
//repear