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
	 array_init_flag: OUT STD_LOGIC
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
	 secret_key : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	 address : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 q : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	 wren : OUT STD_LOGIC;
	 array_init_flag : IN STD_LOGIC;
	 swap_done_flag : OUT STD_LOGIC
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

    -- clock and reset signals  
	 signal clk, reset_n : std_logic;
	 signal s_address, s_data, s_q : std_logic_vector (7 downto 0);
	 signal s_wren : std_logic;
	 signal s_array_init_flag : std_logic;
	 signal secret_key : std_logic_vector (23 downto 0);
	 signal swap_done_flag : std_logic;
	 signal line_select : STD_LOGIC_VECTOR (1 downto 0);
	 signal ledr_reg : STD_LOGIC_VECTOR (8 downto 0);

	 signal d_address: std_logic_vector (4 downto 0);
	 signal d_data, d_q : std_logic_vector (7 downto 0);
	 signal d_wren: std_logic;
	 signal e_address : std_logic_vector (4 downto 0);
	 signal e_q : std_logic_vector (7 downto 0);
	 signal s_address_array, s_address_shuffle, s_address_encrypt : std_logic_vector (7 downto 0);
	 signal s_data_array, s_data_shuffle, s_data_encrypt : std_logic_vector (7 downto 0);
	 signal s_q_array, s_q_shuffle, s_q_encrypt : std_logic_vector (7 downto 0);
	 signal s_wren_array, s_wren_shuffle, s_wren_encrypt : std_logic;


begin

    clk <= CLOCK_50;
    reset_n <= KEY(3);
	 
	 -- LEDR <= SW;
	 LEDR(8 downto 0) <= ledr_reg;
	 LEDG(0) <= s_array_init_flag;
	 LEDG(7) <= KEY(3);
	 
	 -- Concatenate bits
	 secret_key <= B"000000" & SW;
	 
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
	 array_init_flag => s_array_init_flag
	 );
	 
	 S_ARRAY_SWAP: COMPONENT array_shuffle PORT MAP(
	 clk => clk,
	 secret_key => secret_key,
	 address => s_address_shuffle,
	 data => s_data_shuffle,
	 q => s_q_shuffle,
	 wren => s_wren_shuffle,
	 array_init_flag => s_array_init_flag,
	 swap_done_flag => swap_done_flag
	 ); 
	 
end RTL;


