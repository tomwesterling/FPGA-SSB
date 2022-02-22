--------
-- TRIG FUNCTION PROCESSING ENTITY (LUT IMPLEMENTATION)
-- TOWNSEND, 11.11.21
-- Modified 02.12.21
--------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LUT_SINE_COS is
	port(	
		CLK			: in std_logic;
		START_R			: in std_logic;
		POSITION_IN		: in integer range 0 to 47;
		OUTPUT_SINE		: out integer;
		OUTPUT_COS		: out integer
		);
end LUT_SINE_COS;

architecture BEHAVIOURAL of LUT_SINE_COS is

begin
	
LUT_CASE : process (CLK) is
	begin
		if rising_edge(CLK) then
			if START_R = '1' then
			case POSITION_IN is
				when 0 =>
					OUTPUT_SINE <= 4288;
					OUTPUT_COS <= 32480;
				when 1 =>
					OUTPUT_SINE <= 8480;
					OUTPUT_COS <= 31648;
				when 2 =>
					OUTPUT_SINE <= 12544;
					OUTPUT_COS <= 30272;
				when 3 =>
					OUTPUT_SINE <= 16384;
					OUTPUT_COS <= 28384;
				when 4 =>
					OUTPUT_SINE <= 19936;
					OUTPUT_COS <= 25984;
				when 5 =>
					OUTPUT_SINE <= 23168;
					OUTPUT_COS <= 23168;
				when 6 =>
					OUTPUT_SINE <= 25984;
					OUTPUT_COS <= 19936;
				when 7 =>
					OUTPUT_SINE <= 28384;
					OUTPUT_COS <= 16384;
				when 8 =>
					OUTPUT_SINE <= 30272;
					OUTPUT_COS <= 12544;
				when 9 =>
					OUTPUT_SINE <= 31648;
					OUTPUT_COS <= 8480;
				when 10 =>
					OUTPUT_SINE <= 32480;
					OUTPUT_COS <= 4288;
				when 11 =>
					OUTPUT_SINE <= 32767;
					OUTPUT_COS <= 0;
				when 12 =>
					OUTPUT_SINE <= 32480;
					OUTPUT_COS <= -4288;
				when 13 =>
					OUTPUT_SINE <= 31648;
					OUTPUT_COS <= -8480;
				when 14 =>
					OUTPUT_SINE <= 30272;
					OUTPUT_COS <= -12544;
				when 15 =>
					OUTPUT_SINE <= 28384;
					OUTPUT_COS <= -16384;
				when 16 =>
					OUTPUT_SINE <= 25984;
					OUTPUT_COS <= -19936;
				when 17 =>
					OUTPUT_SINE <= 23168;
					OUTPUT_COS <= -23168;
				when 18 =>
					OUTPUT_SINE <= 19936;
					OUTPUT_COS <= -25984;
				when 19 =>
					OUTPUT_SINE <= 16384;
					OUTPUT_COS <= -28384;
				when 20 =>
					OUTPUT_SINE <= 12544;
					OUTPUT_COS <= -30272;
				when 21 =>
					OUTPUT_SINE <= 8480;
					OUTPUT_COS <= -31648;
				when 22 =>
					OUTPUT_SINE <= 4288;
					OUTPUT_COS <= -32480;
				when 23 =>
					OUTPUT_SINE <= 0;
					OUTPUT_COS <= -32768;
				when 24 =>
					OUTPUT_SINE <= -4288;
					OUTPUT_COS <= -32480;
				when 25 =>
					OUTPUT_SINE <= -8480;
					OUTPUT_COS <= -31648;
				when 26 =>
					OUTPUT_SINE <= -12544;
					OUTPUT_COS <= -30272;
				when 27 =>
					OUTPUT_SINE <= -16384;
					OUTPUT_COS <= -28384;
				when 28 =>
					OUTPUT_SINE <= -19936;
					OUTPUT_COS <= -25984;
				when 29 =>
					OUTPUT_SINE <= -23168;
					OUTPUT_COS <= -23168;
				when 30 =>
					OUTPUT_SINE <= -25984;
					OUTPUT_COS <= -19936;
				when 31 =>
					OUTPUT_SINE <= -28384;
					OUTPUT_COS <= -16384;
				when 32 =>
					OUTPUT_SINE <= -30272;
					OUTPUT_COS <= -12544;
				when 33 =>
					OUTPUT_SINE <= -31648;
					OUTPUT_COS <= -8480;
				when 34 =>
					OUTPUT_SINE <= -32480;
					OUTPUT_COS <= -4288;
				when 35 =>
					OUTPUT_SINE <= -32768;
					OUTPUT_COS <= 0;
				when 36 =>
					OUTPUT_SINE <= -32480;
					OUTPUT_COS <= 4288;
				when 37 =>
					OUTPUT_SINE <= -31648;
					OUTPUT_COS <= 8480;
				when 38 =>
					OUTPUT_SINE <= -30272;
					OUTPUT_COS <= 12544;
				when 39 =>
					OUTPUT_SINE <= -28384;
					OUTPUT_COS <= 16384;
				when 40 =>
					OUTPUT_SINE <= -25984;
					OUTPUT_COS <= 19936;
				when 41 =>
					OUTPUT_SINE <= -23168;
					OUTPUT_COS <= 23168;
				when 42 =>
					OUTPUT_SINE <= -19936;
					OUTPUT_COS <= 25984;
				when 43 =>
					OUTPUT_SINE <= -16384;
					OUTPUT_COS <= 28384;
				when 44 =>
					OUTPUT_SINE <= -12544;
					OUTPUT_COS <= 30272;
				when 45 =>
					OUTPUT_SINE <= -8480;
					OUTPUT_COS <= 31648;
				when 46 =>
					OUTPUT_SINE <= -4288;
					OUTPUT_COS <= 32480;
				when 47 =>
					OUTPUT_SINE <= 0;
					OUTPUT_COS <= 32767;
				when others =>
					OUTPUT_SINE <= 0;
					OUTPUT_COS <= 0;
			end case;
			end if;
		end if;
end process;
	
end BEHAVIOURAL;