library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ksa is
  port(
    CLOCK_50            : in  std_logic;  -- Clock pin
    KEY                 : in  std_logic_vector(3 downto 0);  -- push button switches
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
        ssOut : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        nIn : IN STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
    END COMPONENT;
	 
	 COMPONENT s_array_fsm IS
	 PORT(
	 clk: IN STD_LOGIC;
	 rst: IN STD_LOGIC;
	 address: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 data: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 q: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	 wren: OUT STD_LOGIC;
	 array_init_flag: OUT STD_LOGIC
	 );
	 END COMPONENT;
	 
	 COMPONENT s_memory IS
	 PORT(
	 address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 clock : IN STD_LOGIC;
	 data	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	 wren : IN STD_LOGIC ;
	 q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
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
	 	   
    -- clock and reset signals  
	 signal clk, reset_n : std_logic;
	 signal s_address, s_data, s_q : std_logic_vector (7 downto 0);
	 signal s_wren : std_logic;
	 signal s_array_init_flag : std_logic;
	 signal secret_key : std_logic_vector (23 downto 0);
	 signal swap_done_flag : std_logic;
	 signal line_select : STD_LOGIC_VECTOR (1 downto 0);
	 
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
	 
	 -- Instantiate an s-memory filling FSM
	 S_ARRAY: COMPONENT s_array_fsm PORT MAP(
	 clk => clk,
	 rst => reset_n,
	 address => s_address,
	 data => s_data,
	 q => s_q,
	 wren => s_wren,
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
	 
	 

end RTL;


