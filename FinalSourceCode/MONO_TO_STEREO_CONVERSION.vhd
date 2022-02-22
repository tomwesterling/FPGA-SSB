-------------
-- MONO_TO_STEREO_CONVERSION
-- TOM WESTERLING, NOV 23, 2021
-- Modified by Lachlan Townsend 02.12.21
-------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity MONO_TO_STEREO_CONVERSION is
	generic(W : integer := 16);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L			    : in std_logic;
		START_R	            : in std_logic;
		AUDIO_IN			: in std_logic_vector(W-1 downto 0);
		AUDIO_OUT_L			: out std_logic_vector(W-1 downto 0);
		AUDIO_OUT_R			: out std_logic_vector(W-1 downto 0);
		AUDIO_LINK			: out std_logic_vector(W-1 downto 0)
	);
end MONO_TO_STEREO_CONVERSION;

architecture BEHAVIOUR of MONO_TO_STEREO_CONVERSION is

signal AUDIO_REG : std_logic_vector(W-1 downto 0);

begin

AUDIO_L: process(CLK)
begin 
	if rising_edge(CLK) then
		if SRESETN = '0' then
			AUDIO_REG <= (others=>'0');
		elsif START_R = '1' then
			AUDIO_REG <= AUDIO_IN after 2 ns;
		end if;
	end	if;
end process;

-- asynchronous assignment from register to output
STEREO_L : process(CLK)
begin
	if rising_edge(CLK) and START_R = '1' then
		AUDIO_OUT_L <= AUDIO_REG after 2 ns;
		AUDIO_LINK <= AUDIO_REG after 2 ns;
	end if;
end process;

-- asynchronous assignment from register to output
STEREO_R : process(CLK)
begin
	if rising_edge(CLK) and START_R = '1' then
		AUDIO_OUT_R <= AUDIO_REG after 2 ns;
	end if;
end process;

end BEHAVIOUR;