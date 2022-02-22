-------------
-- HILBERT FIR FILTER MODULE
-- TOM WESTERLING, NOV 23, 2021
-- Modified by Lachlan Townsend 02.12.21
-------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity HILBERT_FIR_FILTER is
	generic(
		W : integer := 16;
		filterOrder : integer := 256
	);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		AUDIO_IN			: in std_logic_vector(W-1 downto 0);
		AUDIO_OUT			: out std_logic_vector(W-1 downto 0)
	);
end HILBERT_FIR_FILTER;

architecture BEHAVIOUR of HILBERT_FIR_FILTER is

type REG_TYPE is array (0 to filterOrder-1) of signed(W-1 downto 0);
type COEFF_TYPE is array (0 to filterOrder-1) of integer range -2**(W-1) to 2**(W-1)-1;

signal reg : REG_TYPE;
signal i : signed(W-1 downto 0) := (others => '0');



begin

SHIFT_REG : process(CLK)
begin
	if rising_edge(CLK) then
		if SRESETN = '0' then
			reg(0 to 255) <= (others => (others=>'0')) after 3 ns;
		elsif START_R = '1' then
			reg(1 to filterOrder-1) <= reg(0 to filterOrder-2) after 3 ns;
			reg(0) <= signed(AUDIO_IN) after 3 ns;
		end if;
	end if;
end process;

FILTER : process(CLK)
variable coeff : COEFF_TYPE := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0,-1,0,-2,0,-2,0,-2,0,-2,0,-3,0,-3,0,-4,0,-4,0,-5,0,-5,0,-6,0,-6,0,-7,0,-8,0,-9,0,-10,0,-11,0,-12,0,-13,0,-15,0,-16,0,-18,0,-20,0,-22,0,-24,0,-26,0,-29,0,-32,0,-35,0,-39,0,-44,0,-49,0,-55,0,-62,0,-71,0,-82,0,-96,0,-115,0,-142,0,-184,0,-259,0,-434,0,-1303,0,1303,0,434,0,259,0,184,0,142,0,115,0,96,0,82,0,71,0,62,0,55,0,49,0,44,0,39,0,35,0,32,0,29,0,26,0,24,0,22,0,20,0,18,0,16,0,15,0,13,0,12,0,11,0,10,0,9,0,8,0,7,0,6,0,6,0,5,0,5,0,4,0,4,0,3,0,3,0,2,0,2,0,2,0,2,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1);
variable pro : signed(2*W-1 downto 0);
variable sum : signed(W downto 0);
variable acc : signed(W-1 downto 0);

begin
	if rising_edge(CLK) and START_R = '1' then
		acc := (others=>'0');
		sum := (others=>'0');
	
		for k in 0 to filterOrder-1 loop
			pro := coeff(k)*reg(k);
			sum := sum + pro(2*W-1 downto W);
			acc := sum(W downto 1);
		end loop;

		AUDIO_OUT <= std_logic_vector(acc) after 3 ns;
		--acc := to_signed(0, 2*W) after 3 ns;
	end if;
end process;
	
end BEHAVIOUR;