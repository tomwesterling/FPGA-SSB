-------------
-- STEREO_TO_MONO_CONVERSION
-- TOM WESTERLING, NOV 23, 2021
-- Modified by Lachlan Townsend 02.12.21
-------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity STEREO_TO_MONO_CONVERSION is
	generic(W : integer := 16);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L			    : in std_logic;
		START_R	            : in std_logic;
		AUDIO_IN_L			: in std_logic_vector(W-1 downto 0);
		AUDIO_IN_R			: in std_logic_vector(W-1 downto 0);
		AUDIO_OUT			: out std_logic_vector(W-1 downto 0)
	);
end STEREO_TO_MONO_CONVERSION;

architecture BEHAVIOUR of STEREO_TO_MONO_CONVERSION is

signal AUDIO_REG_L, AUDIO_REG_R : std_logic_vector(W-1 downto 0);
signal MONO_SUM : signed(W-1 downto 0);
signal MONO_SUM16 : signed(W-1 downto 0);

begin

-- 1-process VHDL modeling of register (left channel)
AUDIO_L: process(CLK)
begin 
	if rising_edge(CLK) then
		if SRESETN = '0' then
			AUDIO_REG_L <= (others=>'0');
		elsif START_R = '1' then
			AUDIO_REG_L <= AUDIO_IN_L after 2 ns;
		end if;
	end	if;
end process;

-- 1-process VHDL modeling of register (right channel)
AUDIO_R: process(CLK)
begin 
	if falling_edge(CLK) then
		if SRESETN = '0' then
			AUDIO_REG_R <= (others=>'0');
		elsif START_R = '1' then
			AUDIO_REG_R <= AUDIO_IN_R after 2 ns;
		end if;
	end	if;
end process;

-- asynchronous assignment from register to output
MONO : process(CLK)
begin
	if rising_edge(CLK) and START_R = '1'then
		MONO_SUM <= signed(AUDIO_REG_L)/2 + signed(AUDIO_REG_R)/2;
		AUDIO_OUT <= std_logic_vector(MONO_SUM(W-1 downto 0)) after 2 ns;
	end if;
end process;


end BEHAVIOUR;
