`default_nettype none
module Basic_Organ_Solution(

    //////////// CLOCK //////////
    CLOCK_50,

    //////////// LED //////////
    LEDG,
    LEDR,

    //////////// KEY //////////
    KEY,

    //////////// SW //////////
    SW,

    //////////// SEG7 //////////
    HEX0,
    HEX1,
    HEX2,
    HEX3,
    HEX4,
    HEX5,
    HEX6,
    HEX7,

    //////////// Audio //////////
    AUD_ADCDAT,
    AUD_ADCLRCK,
    AUD_BCLK,
    AUD_DACDAT,
    AUD_DACLRCK,
    AUD_XCK,

    //////////// I2C for Audio  //////////
    I2C_SCLK,
    I2C_SDAT,
 
    //////// GPIO //////////
    GPIO_0,
    GPIO_1,
    
   
    //////////// LCD //////////
    LCD_DATA,
    LCD_EN,
    LCD_ON,
    LCD_RS,
    LCD_RW

);

//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                       CLOCK_50;

//////////// LED //////////
output           [8:0]      LEDG;
output          [17:0]      LEDR;

//////////// KEY //////////
input            [3:0]      KEY;

//////////// SW //////////
input           [17:0]      SW;

//////////// SEG7 //////////
output           [6:0]      HEX0;
output           [6:0]      HEX1;
output           [6:0]      HEX2;
output           [6:0]      HEX3;
output           [6:0]      HEX4;
output           [6:0]      HEX5;
output           [6:0]      HEX6;
output           [6:0]      HEX7;

//////////// LCD //////////
inout            [7:0]      LCD_DATA;
output                      LCD_EN;
output                      LCD_ON;
output                      LCD_RS;
output                      LCD_RW;

//////////// Audio //////////
input                       AUD_ADCDAT;
inout                       AUD_ADCLRCK;
inout                       AUD_BCLK;
output                      AUD_DACDAT;
inout                       AUD_DACLRCK;
output                      AUD_XCK;

//////////// I2C for Audio  //////////
output                      I2C_SCLK;
inout                       I2C_SDAT;

//////////// GPIO //////////
inout           [35:0]      GPIO_0;
inout           [35:0]      GPIO_1;


//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [7:0] LED;
assign CLK_50M =  CLOCK_50;
assign LEDG[7:0] = LED[7:0];
//Character definitions

//numbers
parameter character_0 =8'h30;
parameter character_1 =8'h31;
parameter character_2 =8'h32;
parameter character_3 =8'h33;
parameter character_4 =8'h34;
parameter character_5 =8'h35;
parameter character_6 =8'h36;
parameter character_7 =8'h37;
parameter character_8 =8'h38;
parameter character_9 =8'h39;


//Uppercase Letters
parameter character_A =8'h41;
parameter character_B =8'h42;
parameter character_C =8'h43;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_G =8'h47;
parameter character_H =8'h48;
parameter character_I =8'h49;
parameter character_J =8'h4A;
parameter character_K =8'h4B;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_N =8'h4E;
parameter character_O =8'h4F;
parameter character_P =8'h50;
parameter character_Q =8'h51;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_U =8'h55;
parameter character_V =8'h56;
parameter character_W =8'h57;
parameter character_X =8'h58;
parameter character_Y =8'h59;
parameter character_Z =8'h5A;

//Lowercase Letters
parameter character_lowercase_a= 8'h61;
parameter character_lowercase_b= 8'h62;
parameter character_lowercase_c= 8'h63;
parameter character_lowercase_d= 8'h64;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_f= 8'h66;
parameter character_lowercase_g= 8'h67;
parameter character_lowercase_h= 8'h68;
parameter character_lowercase_i= 8'h69;
parameter character_lowercase_j= 8'h6A;
parameter character_lowercase_k= 8'h6B;
parameter character_lowercase_l= 8'h6C;
parameter character_lowercase_m= 8'h6D;
parameter character_lowercase_n= 8'h6E;
parameter character_lowercase_o= 8'h6F;
parameter character_lowercase_p= 8'h70;
parameter character_lowercase_q= 8'h71;
parameter character_lowercase_r= 8'h72;
parameter character_lowercase_s= 8'h73;
parameter character_lowercase_t= 8'h74;
parameter character_lowercase_u= 8'h75;
parameter character_lowercase_v= 8'h76;
parameter character_lowercase_w= 8'h77;
parameter character_lowercase_x= 8'h78;
parameter character_lowercase_y= 8'h79;
parameter character_lowercase_z= 8'h7A;

//Other Characters
parameter character_colon = 8'h3A;          //':'
parameter character_stop = 8'h2E;           //'.'
parameter character_semi_colon = 8'h3B;   //';'
parameter character_minus = 8'h2D;         //'-'
parameter character_divide = 8'h2F;         //'/'
parameter character_plus = 8'h2B;          //'+'
parameter character_comma = 8'h2C;          // ','
parameter character_less_than = 8'h3C;    //'<'
parameter character_greater_than = 8'h3E; //'>'
parameter character_equals = 8'h3D;         //'='
parameter character_question = 8'h3F;      //'?'
parameter character_dollar = 8'h24;         //'$'
parameter character_space=8'h20;           //' '     
parameter character_exclaim=8'h21;          //'!'


wire Clock_1KHz, Clock_1Hz;
wire Sample_Clk_Signal;

//=======================================================================================================================
//
// Insert your code for Lab1 here!
//
//
<<<<<<< HEAD
wire signal_Out,LED_1Hz;
reg [15:0]CLK_Div_Bits;
reg [31:0] scope_Info_units;
reg [2:0] signal_SW;

CLK_Divider #(.BITS(28)) CLK_Divider_Led(
					.CLOCK_50M(CLOCK_50),
					.CLK_Div(28'b0001_0111_1101_0111_1000_0100_0000),
					.out_CLK(LED_1Hz));

LED_Slide(
	.LED_CLK(LED_1Hz), 
	.LEDG(LED[7:0]));

	

LEDtoSW(
		.CLOCK_50M(CLOCK_50),
		.LED(LED[7:0]),
		.SW(signal_SW[2:0]));
				
toneGenerator(
			.CLOCK_50M(CLOCK_50),
			.SW(SW[10] ? signal_SW[2:0] : SW[3:1]),
			.CLK_Div(CLK_Div_Bits),
			.scope_units(scope_Info_units));

CLK_Divider #(.BITS(16)) CLK_Divider_Tone(
						.CLOCK_50M(CLOCK_50),
						.CLK_Div(CLK_Div_Bits),
						.out_CLK(signal_Out));
assign Sample_Clk_Signal = signal_Out; 
=======
wire signalReset, signalOut;
reg [15:0]CLKDivBits;
logic [31:0] scope_Info_units;
     
toneGenerator(
	.CLOCK_50M(CLOCK_50),
	.SW(SW[3:0]),
	.CLKDiv(CLKDivBits),
	.scope_units(scope_Info_units),
	.reset(signalReset));

CLK_Divider(
	.CLOCK_50M(CLOCK_50),
	.CLKDiv(CLKDivBits),
	.reset(signalReset),
	.outCLK(signalOut));

assign Sample_Clk_Signal = signalOut; 
>>>>>>> b5647283f5241bad0a1650a275267aebb69462db

//===================================
// LCD Info Parameters
//===================================

//assign Sample_Clk_Signal = Clock_1KHz;

//Audio Generation Signal
//Note that the audio needs signed data - so convert 1 bit to 8 bits signed
wire [7:0] audio_data; //generate signed sample audio signal
always @(posedge CLOCK_50)
begin
	if(SW[0] == 1'b1)
		audio_data = {(~Sample_Clk_Signal),{7{Sample_Clk_Signal}}};
	else
		audio_data <= 8'h00;
end

//=====================================================================================
//
// LCD Scope Acquisition Circuitry Wire Definitions                 
//
//=====================================================================================

wire allow_run_LCD_scope;
wire [15:0] scope_channelA, scope_channelB;
wire scope_clk;
reg user_scope_enable_trigger;
wire user_scope_enable;
wire user_scope_enable_trigger_path0, user_scope_enable_trigger_path1;
wire scope_enable_source = SW[16];
wire choose_LCD_or_SCOPE = SW[17];


doublesync user_scope_enable_sync1(.indata(scope_enable_source),
                  .outdata(user_scope_enable),
                  .clk(CLK_50M),
                  .reset(1'b1)); 

//Generate the oscilloscope clock
Generate_Arbitrary_Divided_Clk32 
Generate_LCD_scope_Clk(
.inclk(CLK_50M),
.outclk(scope_clk),
.outclk_Not(),
.div_clk_count(scope_sampling_clock_count),
.Reset(1'h1));

//Scope capture channels

scope_capture LCD_scope_channelA(
.clk(scope_clk),
.the_signal(Sample_Clk_Signal),
.capture_enable(allow_run_LCD_scope & user_scope_enable), 
.captured_data(scope_channelA),
.reset(1'b1));

scope_capture LCD_scope_channelB
(
.clk(scope_clk),
.the_signal(SW[1]),
.capture_enable(allow_run_LCD_scope & user_scope_enable), 
.captured_data(scope_channelB),
.reset(1'b1));

assign LCD_ON   = 1'b1;
//The LCD scope and display
LCD_Scope_Encapsulated_pacoblaze LCD_LED_scope(
                        //LCD control signals
                          .lcd_d(LCD_DATA),//don't touch
                    .lcd_rs(LCD_RS), //don't touch
                    .lcd_rw(LCD_RW), //don't touch
                    .lcd_e(LCD_EN), //don't touch
                    .clk(CLK_50M),  //don't touch
                          
                        //LCD Display values
                      .InH(audio_data),
                      .InG(SW[3:0]),
                      .InF(8'h01),
                      .InE(8'h23),
                      .InD(8'h45),
                      .InC(8'h67),
                      .InB(8'h89),
                      .InA(8'h00),
                           
                     //LCD display information signals
                         .InfoH({character_I,character_N}),
                          .InfoG({character_F,character_O}),
                          .InfoF({character_space,character_C}),
                          .InfoE({character_O,character_N}),
                          .InfoD({character_S,character_O}),
                          .InfoC({character_L,character_E}),
                          .InfoB({character_colon,character_space}),
                          .InfoA({character_space,character_space}),
                          
                  //choose to display the values or the oscilloscope
                          .choose_scope_or_LCD(choose_LCD_or_SCOPE),
                          
                  //scope channel declarations
                          .scope_channelA(scope_channelA), //don't touch
                          .scope_channelB(scope_channelB), //don't touch
                          
                  //scope information generation
                          .ScopeInfoA(scope_Info_units),
                          .ScopeInfoB({character_S,character_W,character_1,character_space}),
                          
                 //enable_scope is used to freeze the scope just before capturing 
                 //the waveform for display (otherwise the sampling would be unreliable)
                          .enable_scope(allow_run_LCD_scope) //don't touch
                          
    );  
    

//=====================================================================================
//
//  Seven-Segment and speed control
//
//=====================================================================================

wire speed_up_event, speed_down_event;

//Generate 1 KHz Clock
Generate_Arbitrary_Divided_Clk32 
Gen_1KHz_clk
(
.inclk(CLK_50M),
.outclk(Clock_1KHz),
.outclk_Not(),
.div_clk_count(32'h61A6), //change this if necessary to suit your module
.Reset(1'h1)); 

wire speed_up_raw;
wire speed_down_raw;

doublesync 
key0_doublsync
(.indata(!KEY[0]),
.outdata(speed_up_raw),
.clk(Clock_1KHz),
.reset(1'b1));


doublesync 
key1_doublsync
(.indata(!KEY[1]),
.outdata(speed_down_raw),
.clk(Clock_1KHz),
.reset(1'b1));


parameter num_updown_events_per_sec = 10;
parameter num_1KHZ_clocks_between_updown_events = 1000/num_updown_events_per_sec;

reg [15:0] updown_counter = 0;
always @(posedge Clock_1KHz)
begin
      if (updown_counter >= num_1KHZ_clocks_between_updown_events)
      begin
            if (speed_up_raw)
            begin
                  speed_up_event_trigger <= 1;          
            end 
            
            if (speed_down_raw)
            begin
                  speed_down_event_trigger <= 1;            
            end 
            updown_counter <= 0;
      end
      else 
      begin
           updown_counter <= updown_counter + 1;
           speed_up_event_trigger <=0;
           speed_down_event_trigger <= 0;
      end     
end

wire speed_up_event_trigger;
wire speed_down_event_trigger;

async_trap_and_reset_gen_1_pulse 
make_speedup_pulse
(
 .async_sig(speed_up_event_trigger), 
 .outclk(CLK_50M), 
 .out_sync_sig(speed_up_event), 
 .auto_reset(1'b1), 
 .reset(1'b1)
 );
 
async_trap_and_reset_gen_1_pulse 
make_speedown_pulse
(
 .async_sig(speed_down_event_trigger), 
 .outclk(CLK_50M), 
 .out_sync_sig(speed_down_event), 
 .auto_reset(1'b1), 
 .reset(1'b1)
 );


wire speed_reset_event; 

doublesync 
key2_doublsync
(.indata(!KEY[2]),
.outdata(speed_reset_event),
.clk(CLK_50M),
.reset(1'b1));

parameter oscilloscope_speed_step = 100;

wire [15:0] speed_control_val;                      
speed_reg_control 
speed_reg_control_inst
(
.clk(CLK_50M),
.up_event(speed_up_event),
.down_event(speed_down_event),
.reset_event(speed_reset_event),
.speed_control_val(speed_control_val)
);

logic [15:0] scope_sampling_clock_count;
parameter [15:0] default_scope_sampling_clock_count = 12499; //2KHz


always @ (posedge CLK_50M) 
begin
    scope_sampling_clock_count <= default_scope_sampling_clock_count+{{16{speed_control_val[15]}},speed_control_val};
end 

        
        
logic [7:0] Seven_Seg_Val[7:0];
logic [3:0] Seven_Seg_Data[7:0];
    
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst0(.ssOut(Seven_Seg_Val[0]), .nIn(Seven_Seg_Data[0]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1(.ssOut(Seven_Seg_Val[1]), .nIn(Seven_Seg_Data[1]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2(.ssOut(Seven_Seg_Val[2]), .nIn(Seven_Seg_Data[2]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3(.ssOut(Seven_Seg_Val[3]), .nIn(Seven_Seg_Data[3]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4(.ssOut(Seven_Seg_Val[4]), .nIn(Seven_Seg_Data[4]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5(.ssOut(Seven_Seg_Val[5]), .nIn(Seven_Seg_Data[5]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst6(.ssOut(Seven_Seg_Val[6]), .nIn(Seven_Seg_Data[6]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst7(.ssOut(Seven_Seg_Val[7]), .nIn(Seven_Seg_Data[7]));

assign HEX0 = Seven_Seg_Val[0];
assign HEX1 = Seven_Seg_Val[1];
assign HEX2 = Seven_Seg_Val[2];
assign HEX3 = Seven_Seg_Val[3];
assign HEX4 = Seven_Seg_Val[4];
assign HEX5 = Seven_Seg_Val[5];
assign HEX6 = Seven_Seg_Val[6];
assign HEX7 = Seven_Seg_Val[7];
            
wire Clock_2Hz;
            
Generate_Arbitrary_Divided_Clk32 
Gen_2Hz_clk
(.inclk(CLK_50M),
.outclk(Clock_2Hz),
.outclk_Not(),
.div_clk_count(32'h17D7840 >> 1),
.Reset(1'h1)
); 
        
logic [31:0] actual_7seg_output;
reg [31:0] regd_actual_7seg_output;

always @(posedge Clock_2Hz)
begin
    regd_actual_7seg_output <= actual_7seg_output;
    Clock_1Hz <= ~Clock_1Hz;
end


assign Seven_Seg_Data[0] = regd_actual_7seg_output[3:0];
assign Seven_Seg_Data[1] = regd_actual_7seg_output[7:4];
assign Seven_Seg_Data[2] = regd_actual_7seg_output[11:8];
assign Seven_Seg_Data[3] = regd_actual_7seg_output[15:12];
assign Seven_Seg_Data[4] = regd_actual_7seg_output[19:16];
assign Seven_Seg_Data[5] = regd_actual_7seg_output[23:20];
assign Seven_Seg_Data[6] = regd_actual_7seg_output[27:24];
assign Seven_Seg_Data[7] = regd_actual_7seg_output[31:28];
    
assign actual_7seg_output =  scope_sampling_clock_count;




//=======================================================================================================================
//
//   Audio controller code - do not touch
//
//========================================================================================================================
wire [$size(audio_data)-1:0] actual_audio_data_left, actual_audio_data_right;
wire audio_left_clock, audio_right_clock;

to_slow_clk_interface 
interface_actual_audio_data_right
 (.indata(audio_data),
  .outdata(actual_audio_data_right),
  .inclk(CLK_50M),
  .outclk(audio_right_clock));
   
   
to_slow_clk_interface 
interface_actual_audio_data_left
 (.indata(audio_data),
  .outdata(actual_audio_data_left),
  .inclk(CLK_50M),
  .outclk(audio_left_clock));
   

audio_controller 
audio_control(
  // Clock Input (50 MHz)
  .iCLK_50(CLK_50M), // 50 MHz
  .iCLK_28(), // 27 MHz
  //  7-SEG Displays
  // I2C
  .I2C_SDAT(I2C_SDAT), // I2C Data
  .oI2C_SCLK(I2C_SCLK), // I2C Clock
  // Audio CODEC
  .AUD_ADCLRCK(AUD_ADCLRCK),                    //  Audio CODEC ADC LR Clock
  .iAUD_ADCDAT(AUD_ADCDAT),                 //  Audio CODEC ADC Data
  .AUD_DACLRCK(AUD_DACLRCK),                    //  Audio CODEC DAC LR Clock
  .oAUD_DACDAT(AUD_DACDAT),                 //  Audio CODEC DAC Data
  .AUD_BCLK(AUD_BCLK),                      //  Audio CODEC Bit-Stream Clock
  .oAUD_XCK(AUD_XCK),                       //  Audio CODEC Chip Clock
  .audio_outL({actual_audio_data_left,8'b1}), 
  .audio_outR({actual_audio_data_right,8'b1}),
  .audio_right_clock(audio_right_clock), 
  .audio_left_clock(audio_left_clock)
);


//=======================================================================================================================
//
//   End Audio controller code
//
//========================================================================================================================
                    
            
endmodule
