library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ksa is
  port(
    CLOCK_50           : in  std_logic;  -- Clock pin
    KEY                : in  std_logic_vector(3 downto 0);  -- push button switches
    SW                 : in  std_logic_vector(17 downto 0);  -- slider switches
    LEDR : out std_logic_vector(17 downto 0);  -- red lights
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
	 

	 signal d_address: std_logic_vector (4 downto 0);
	 signal d_data, d_q : std_logic_vector (7 downto 0);
	 signal d_wren: std_logic;
	 signal e_address : std_logic_vector (4 downto 0);
	 signal e_q : std_logic_vector (7 downto 0);
	 signal s_address_s_array, s_address_shuffle, s_address_encrypt : std_logic_vector (7 downto 0);
	 signal s_data_s_array, s_data_shuffle, s_data_encrypt : std_logic_vector (7 downto 0);
	 signal s_array_wren, shuffle_wren, encrypt_wren : std_logic;

begin

    clk <= CLOCK_50;
    reset_n <= KEY(3);
	 
	 LEDR <= SW;
	 
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

	-- Instantiate an d-memory module
	 D_MEM: COMPONENT d_memory PORT MAP(
	 address => d_address,
	 clock => clk,
	 data => d_data,
	 wren => d_wren,
	 q => d_q
	 );
	 
	 -- Instantiate an e-memory module
	 E_MEM: COMPONENT e_memory PORT MAP(
	 address => e_address,
	 clock => clk,
	 q => e_q
	 );
	 
	 -- Instantiate an s-memory filling FSM
	 S_ARRAY: COMPONENT s_array_fsm PORT MAP(
	 clk => clk,
	 rst => reset_n,
	 address => s_address_s_array,
	 data => s_data_s_array,
	 q => s_q,
	 wren => s_array_wren,
	 array_init_flag => s_array_init_flag
	 );
	 
	 S_ARRAY_SWAP: COMPONENT array_shuffle PORT MAP(
	 clk => clk,
	 secret_key => secret_key,
	 address => s_address,
	 data => s_data,
	 q => s_q,
	 wren => s_wren,
	 array_init_flag => s_array_init_flag,
	 swap_done_flag => swap_done_flag
	 );
	 
	 
	 ADDRESS_MUX: COMPONENT mux_3to1 PORT MAP(
	 clk		=> clk,
	 s_array	=> s_address_s_array,
	 shuffle	=> s_address_shuffle,
	 encrypt	=> s_address_encrypt,
	 to_s_mem=> s_address
	 );
	 
	 DATA_MUX: COMPONENT mux_3to1 PORT MAP(
	 clk		=> clk,
	 s_array	=> s_data_s_array,
	 shuffle	=> s_data_shuffle,
	 encrypt	=> s_data_encrypt,
	 to_s_mem=> s_data
	 );
	 
	 wrenS_OR: COMPONENT wrenOR PORT MAP(
	 clk		=> clk,
	 s_array	=> s_array_wren,
	 shuffle	=> shuffle_wren,
	 encrypt	=> encrypt_wren,
	 wren		=> s_wren
	 );
	 
	 COMP_EN: COMPONENT computeEncrypt PORT MAP(
	 clk					=> clk,
	 reset				=> s_array_init_flag,
	 s_q					=> s_q,
	 encrypt_K_q		=> e_q,
	 dencrypt_K_data	=> d_data,
	 kE_add				=> e_address,
	 kD_add				=> d_address,
	 s_data				=> s_data_encrypt,
	 s_add				=> s_address_encrypt,
	 wrenS				=> encrypt_wren,
	 wrenD				=> d_wren
	 );
	 
end RTL;


