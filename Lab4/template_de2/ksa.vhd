library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ksa is
  port(
    CLOCK_50           : in  std_logic;  -- Clock pin
    KEY                : in  std_logic_vector(3 downto 0);  -- push button switches
    SW                 : in  std_logic_vector(17 downto 0);  -- slider switches
    LEDR : out std_logic_vector(17 downto 0);  -- red lights
	 LEDG : out std_LOGIC_VECTOR(7 downto 0);
    HEX0 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX3 : out std_logic_vector(6 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX5 : out std_logic_vector(6 downto 0));
end ksa;

architecture rtl of ksa is
   COMPONENT SevenSegmentDisplayDecoder IS
    PORT
    (
        ssOut 	: OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        nIn 	: IN STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
    END COMPONENT;
	 
	 COMPONENT mux_3to1 IS
	 PORT(
	 clk		: IN STD_LOGIC;
	 s_array	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 shuffle	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 encrypt	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 sel     : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
	 to_s_mem: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	 );
	 END COMPONENT;
	 
	 COMPONENT wrenOR IS
	 PORT(
	 clk		: IN STD_LOGIC;
	 s_array	: IN STD_LOGIC;
	 shuffle	: IN STD_LOGIC;
	 encrypt	: IN STD_LOGIC;
	 wren		: OUT STD_LOGIC
	 );
	 END COMPONENT;
	 
	 COMPONENT s_array_fsm IS
	 PORT(
	 clk		: IN STD_LOGIC;
	 rst		: IN STD_LOGIC;
	 address	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 data		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 q			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 wren		: OUT STD_LOGIC;
	 start_flag : IN STD_LOGIC;
	 array_done_flag: OUT STD_LOGIC
	 );
	 END COMPONENT;
	 
	 COMPONENT computeEncrypt IS
	 PORT(
	 clk					: IN STD_LOGIC;
	 reset				: IN STD_LOGIC;
	 s_q					: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 encrypt_K_q		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 dencrypt_K_data	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 kE_add				: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	 kD_add				: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	 s_add				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 s_data				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 wrenS				: OUT STD_LOGIC;
	 wrenD				: OUT STD_LOGIC
	 );
	 END COMPONENT;
	 
	 COMPONENT s_memory IS
	 PORT(
	 address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 clock 	: IN STD_LOGIC;
	 data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 wren 	: IN STD_LOGIC ;
	 q 		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	 );
	 END COMPONENT;
	 
	 COMPONENT array_shuffle IS
	 PORT(
	 clk : IN STD_LOGIC;
	 rst : IN STD_LOGIC;
	 secret_key : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	 secret_byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 address : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 address_i : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 address_j : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 q : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	 q_i : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 q_j : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 wren : OUT STD_LOGIC;
	 array_done_flag : IN STD_LOGIC;
	 swap_done_flag : OUT STD_LOGIC;
	 test_bit : OUT STD_LOGIC;
	 temp_reg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	 );
	 END COMPONENT;

	COMPONENT d_memory IS
	PORT
	(
	address	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	clock		: IN STD_LOGIC  := '1';
	data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	wren		: IN STD_LOGIC ;
	q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;
	 
	COMPONENT e_memory IS 
	PORT
	(
	address	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	clock		: IN STD_LOGIC  := '1';
	q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);	
	END COMPONENT;
	
	COMPONENT control_FSM IS
	PORT(
	clk : IN STD_LOGIC;
	start_flag : IN STD_LOGIC;
	array_start_flag : OUT STD_LOGIC; 
	s_array_address : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
	s_array_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	s_array_wren : IN STD_LOGIC; 
	s_array_q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	
	shuffle_address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	shuffle_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	shuffle_wren : IN STD_LOGIC;
	shuffle_q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	computeEncrypt_address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	computeEncrypt_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	computeEncrypt_wren : IN STD_LOGIC;
	computeEncrypt_q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	array_done_flag : IN STD_LOGIC; 
	swap_done_flag : IN STD_LOGIC;
	compute_done_flag : IN STD_LOGIC;
	s_address: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	s_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	s_wren : OUT STD_LOGIC;
	s_q : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	test_bit : OUT STD_LOGIC
	);
	END COMPONENT;

    -- clock and reset signals  
	 signal clk, reset_n : std_logic;
	 signal secret_key : std_logic_vector (23 downto 0);
	 
	 -- FSM START FLAGS
	 signal start_flag : std_logic;
	 signal array_start_flag : std_logic;
	 
	 -- FSM FINISH FLAGS
	 signal array_done_flag : std_logic;
	 signal swap_done_flag : std_logic;
	 signal compute_done_flag : std_logic;
	 	 
	 -- S-MEMORY SIGNALS
	 signal s_address, s_data, s_q : std_logic_vector (7 downto 0);
	 signal s_wren : std_logic;

	 -- D-MEMORY SIGNALS
	 signal d_address: std_logic_vector (4 downto 0);
	 signal d_data, d_q : std_logic_vector (7 downto 0);
	 signal d_wren: std_logic;
	 
	 -- E-MEMORY SIGNALS
	 signal e_address : std_logic_vector (4 downto 0);
	 signal e_q : std_logic_vector (7 downto 0);
	 
	 -- S-MEMORY REGISTERS
	 signal s_address_array, s_address_shuffle, s_address_encrypt : std_logic_vector (7 downto 0);
	 signal s_data_array, s_data_shuffle, s_data_encrypt : std_logic_vector (7 downto 0);
	 signal s_q_array, s_q_shuffle, s_q_encrypt : std_logic_vector (7 downto 0);
	 signal s_wren_array, s_wren_shuffle, s_wren_encrypt : std_logic;
	 
	 -- REGISTERS
	 signal secret_byte, address_i, address_j, q_i, q_j, temp_reg : std_logic_vector (7 downto 0);
	 signal test_bit : std_logic;
	 
begin

    clk <= CLOCK_50;
    reset_n <= KEY(3);
	 start_flag <= KEY(0);
	 
	 -- OUTPUT SECRET KEY TO LEDR
	 LEDR <= secret_key(17 downto 0);
	 
	 -- DISPLAY FLAGS ON LEDG
	 LEDG(0) <= array_done_flag;
	 LEDG(1) <= swap_done_flag;
	 LEDG(2) <= compute_done_flag;
	 LEDG(6) <= test_bit;
	 LEDG(7) <= KEY(3);
	 
	 -- Concatenate bits
	 secret_key <= B"000000" & SW;
	 
	 -- Instantiate the control FSM
	 CON_FSM: component control_FSM	port map(
	 clk => clk,
	 start_flag => '1',
	 array_start_flag => array_start_flag,
	 s_array_address => s_address_array,
	 s_array_data => s_data_array,
	 s_array_wren => s_wren_array,
	 s_array_q => s_q_array,
	 shuffle_address => s_address_shuffle,
	 shuffle_data => s_data_shuffle,
	 shuffle_wren  => s_wren_shuffle,
	 shuffle_q => s_q_shuffle,
	 computeEncrypt_address => s_address_encrypt, 
	 computeEncrypt_data => s_data_encrypt,
	 computeEncrypt_wren => s_wren_encrypt,
	 computeEncrypt_q => s_q_encrypt,
	 array_done_flag => array_done_flag,
	 swap_done_flag => swap_done_flag,
	 compute_done_flag => compute_done_flag,
	 s_address => s_address,
	 s_data => s_data,
	 s_wren => s_wren,
	 s_q => s_q
	);
	 
	 -- Instantiate an s-memory module
	 S_MEM: COMPONENT s_memory PORT MAP(
	 address => s_address,
	 clock => clk,
	 data => s_data,
	 wren => s_wren,
	 q => s_q
	 );

	 -- Instantiate an s-memory filling FSM
	 S_ARRAY: COMPONENT s_array_fsm PORT MAP(
	 clk => clk,
	 rst => reset_n,
	 address => s_address_array,
	 data => s_data_array,
	 q => s_q_array,
	 wren => s_wren_array,
	 start_flag => array_start_flag,
	 array_done_flag => array_done_flag
	 );
	 
	 S_ARRAY_SWAP: COMPONENT array_shuffle PORT MAP(
	 clk => clk,
	 rst => reset_n,
	 secret_key => secret_key,
	 secret_byte => secret_byte,
	 address => s_address_shuffle,
	 address_i => address_i,
	 address_j => address_j,
	 data => s_data_shuffle,
	 q => s_q_shuffle,
	 q_i => q_i,
	 q_j => q_j,
	 wren => s_wren_shuffle,
	 array_done_flag => array_done_flag,
	 swap_done_flag => swap_done_flag,
	 test_bit => test_bit,
	 temp_reg => temp_reg
	 ); 
	 
--	 s_address <= s_address_array;
--	 s_data <= s_data_array;
--	 s_wren <= s_wren_array;
	 
end RTL;


