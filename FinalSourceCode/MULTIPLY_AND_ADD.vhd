--------
-- MULTIPLY_AND_ADD
-- TOWNSEND, 11.11.21
-- Modified 02.12.21
--------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity MULTIPLY_AND_ADD is
	generic(
		SIGNAL_WIDTH : integer := 16);
	port(
		CLK				: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		SINE_VALUE			: in integer;
		COS_VALUE			: in integer;
		DELAYED_IN			: in std_logic_vector(SIGNAL_WIDTH-1 downto 0);
		FILTERED_IN			: in std_logic_vector(SIGNAL_WIDTH-1 downto 0);
		MODULATED_OUT			: out std_logic_vector(SIGNAL_WIDTH-1 downto 0)
	);
end MULTIPLY_AND_ADD;

architecture BEHAVIOURAL of MULTIPLY_AND_ADD is

begin

CALCULATE : process(CLK)

variable DELAY_LINE: signed(2*SIGNAL_WIDTH-1 downto 0); --32 bits
variable FILTER_LINE: signed(2*SIGNAL_WIDTH-1 downto 0); -- 32 bits
variable SUM: signed(2*SIGNAL_WIDTH-1 downto 0); --32 bits

begin
	if rising_edge(CLK) then
		if SRESETN = '0' then
			MODULATED_OUT <= (others => '0');
		elsif START_R = '1' then
			DELAY_LINE := signed(to_signed(COS_VALUE, 16) * signed(DELAYED_IN)); -- 16 bits * 16 bits = 32 bits
			FILTER_LINE := signed(to_signed(SINE_VALUE, 16) * signed(FILTERED_IN)); -- 16 bits * 16 bits = 32 bits
			SUM := signed(DELAY_LINE + FILTER_LINE); -- 32 bits + 32 bits = 33 bits
			MODULATED_OUT <= std_logic_vector(SUM(2*SIGNAL_WIDTH-2 downto SIGNAL_WIDTH-1)); -- take bits 31 downto 16
		end if;
		
	end if;
end process;
	
end BEHAVIOURAL;