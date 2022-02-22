--------
-- SINE and COS implementation (uses LUT)
-- TOWNSEND, 11.11.21
-- Modified by Lachlan Townsend 02.12.21
--------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity MODULATION_SPECIFIC_LUT is
	generic(
		TABLE_SIZE : integer := 47);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		MODULATION_IN		: in std_logic_vector(1 downto 0);
		POSITION_OUT		: out integer range 0 to 47
	);
end MODULATION_SPECIFIC_LUT;

architecture BEHAVIOURAL of MODULATION_SPECIFIC_LUT is

signal COUNTER: integer range 0 to 47;
signal MODULATED_COUNTER: integer;

begin

CALCULATE : process(CLK)
begin

	if SRESETN = '0' then
		COUNTER <= 0;
	elsif rising_edge(CLK) then
		if START_R = '1' then
		
			if MODULATION_IN = "00" then
				POSITION_OUT <= COUNTER; -- Standard modulation
			elsif MODULATION_IN = "01" then
				POSITION_OUT <= (COUNTER*2) mod TABLE_SIZE; -- Double modulation
			elsif MODULATION_IN = "10" then
				POSITION_OUT <= (COUNTER*4) mod TABLE_SIZE; -- Quadruple modulation
			end if;
		
			if COUNTER < 47 then
				COUNTER <= COUNTER + 1;
			else
				COUNTER <= 0;
			end if;
		end if;
	end if;
end process;
	
end BEHAVIOURAL;