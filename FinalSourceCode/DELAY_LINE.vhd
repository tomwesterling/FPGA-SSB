-------------
-- DELAY LINE MODULE
-- TOM WESTERLING, NOV 23, 2021
-- Modified by Lachlan Townsend 02.12.21
-------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity DELAY_LINE is
	generic(
		W : integer := 16;
		filterOrder : integer := 256);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		AUDIO_IN			: in std_logic_vector(W-1 downto 0);
		AUDIO_OUT			: out std_logic_vector(W-1 downto 0)
	);
end DELAY_LINE;

architecture BEHAVIOUR of DELAY_LINE is

type REG_TYPE is array (0 to 127) of std_logic_vector(W-1 downto 0);

signal reg: REG_TYPE;

begin

SHIFT_REG : process(CLK)
begin
	if rising_edge(CLK) then
		if SRESETN = '0' then
			reg(0 to 127) <= (others => (others=>'0'));
		elsif START_R = '1' then
			reg(1 to 127) <= reg(0 to 126);
			reg(0) <= AUDIO_IN;
		end if;
		AUDIO_OUT <= reg(127);
	end if;


end process;
	
end BEHAVIOUR;