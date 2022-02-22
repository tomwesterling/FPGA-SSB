--
--  VIDEO_CLK_GEN derives clkEnable and vgaClk and dviClk
--  from system clock clk
--
--  29.4.2020 LTL
--  11.12.2020 update LTL 50 MHz
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity VIDEO_CLK_GEN is
    generic (
		RATIO_CLK_TO_VGA_CLK : positive := 1 
		-- must be power of 2
	);
	port(
        clk       : in  std_logic;
        sresetn   : in  std_logic;
	   clkEnable : out std_logic;
        vgaClk    : out std_logic;
        dviClk    : out std_logic
    );
end entity;

architecture RTL of VIDEO_CLK_GEN is

constant FRQ_DIV_TAP : integer := integer(ceil(log2(real(RATIO_CLK_TO_VGA_CLK))-1.0));
signal   frqDividerOut  : unsigned(FRQ_DIV_TAP downto 0) := (others => '0');
signal   vgaClkInt,dviClkInt : std_logic := '0'; 

begin 
GenerateClkEnable_p: process(CLK)
	begin
		if rising_edge(clk) then 
			if sresetn = '0' then
				frqDividerOut <= (others=>'0') after 2 ns;
				clkEnable <= '0' after 2 ns;
			else
				frqDividerOut <= frqDividerOut + 1 after 2 ns;
				clkEnable <= '0' after 2 ns;
				if RATIO_CLK_TO_VGA_CLK = 1 then
					clkEnable <= '1' after 2 ns;
				elsif frqDividerOut = 0 then
					clkEnable <= '1' after 2 ns;
				end if;
			end if;
		end if;
	end process;

GenerateVideoClocks_p: process(CLK)
	begin
	-- timing might be critical and require constraints
		if RATIO_CLK_TO_VGA_CLK = 1 then
			vgaClk <=  clk after 2 ns;
			dviClk <=  clk after 2 ns;
		else
			vgaClk <= frqDividerOut(FRQ_DIV_TAP);
			dviClk <= frqDividerOut(FRQ_DIV_TAP);
		end if;
	end process;

	
end architecture RTL;
