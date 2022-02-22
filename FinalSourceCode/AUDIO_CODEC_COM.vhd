-- AUDIO CODEC COMMUNICATION module
-- generates clocks SYSCLK, BCK, LRC
-- and converts data streams serial to parallel and vice versa
-- LTL, refactored 14.02.2019 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity AUDIO_CODEC_COM is
generic(W : integer := 16; -- width of audio signals
        M : integer := 2); -- 2**M is the ratio between system clock CLK and SYSCLK
port(
	CLK, SRESETN : in std_logic;
 	-- clock signals (to audio codec)
	SYSCLK, BCK, LRC: out std_logic;
	-- ADC path (from audio codec to signal processing)
	DIN: in std_logic;
	PAR_OUT_L: out std_logic_vector(W-1 downto 0);
	PAR_OUT_R: out std_logic_vector(W-1 downto 0);
	PAR_OUT_MONO: out std_logic_vector(W-1 downto 0);
	NEW_SAMPLE_L : out std_logic; -- new value on left channel
	NEW_SAMPLE_R	 : out std_logic; --           on right channel		
	-- DAC path (from signal processing to audio codec)
	PAR_IN_L: in std_logic_vector(W-1 downto 0);
	PAR_IN_R: in std_logic_vector(W-1 downto 0);
	DOUT: out std_logic
	);
end AUDIO_CODEC_COM;

architecture BEHAVIORAL of AUDIO_CODEC_COM is

signal Q, Q_NEXT : unsigned(8+M-1 downto 0);

-- single shift regs for both channels
signal SHIFT_IN_REG_NEXT, SHIFT_IN_REG  : std_logic_vector(W-1 downto 0);
signal SHIFT_OUT_REG_NEXT,SHIFT_OUT_REG : std_logic_vector(W-1 downto 0);
signal SHIFT_IN, SHIFT_OUT              : std_logic;
signal SAVE_R_LOAD_L, SAVE_L_LOAD_R     : std_logic;

begin 
-- clock divider 
CLK_DIV_REG: process(CLK)
begin
	if CLK='1' and CLK'event then
		if SRESETN = '0' then
			Q <= (others =>'0') after 2 ns; 
		else
			Q <= Q_NEXT after 2 ns;
		end if;
	end if;
end process;

CLK_DIV_COMB: process(Q)
begin
	SHIFT_IN <= '0' after 2 ns;	     SHIFT_OUT <= '0' after 2 ns;
	SAVE_R_LOAD_L <= '0' after 2 ns; SAVE_L_LOAD_R <= '0' after 2 ns;

	-- audio codec clocks (output logic)
	SYSCLK <= std_logic(Q(0+M-1)) after 2 ns;
	BCK    <= std_logic(Q(3+M-1)) after 2 ns;
	LRC    <= std_logic(Q(8+M-1)) after 2 ns;

	-- next state
	Q_NEXT <= Q + 1 after 2 ns;

	-- rising LRC edge (save right load left)
	if Q(8+M-1 downto 0) = 2**(8+M-1) then
		SAVE_R_LOAD_L <= '1' after 2 ns;
	-- falling LRC edge (save left load right)
	elsif Q(8+M-1 downto 0+M-1) = 0 then
		SAVE_L_LOAD_R <= '1' after 2 ns;
	end if;

	-- rising BCK edge (shift in)
	if Q(3+M-1 downto 0) = 2**(3+M-1) then
		SHIFT_IN <= '1' after 2 ns;
	-- falling BCK edge (shift out)
	elsif Q(3+M-1 downto 0) = 0 then
		SHIFT_OUT <= '1' after 2 ns;
	end if;
end process;

-- input and output shift regs
SHIFT_REG: process(CLK)
begin
	if CLK = '1' and CLK'event then
		if SRESETN = '0' then
			SHIFT_IN_REG   <= (others=>'0') after 2 ns;
			SHIFT_OUT_REG  <= (others=>'0') after 2 ns;
        else
			SHIFT_IN_REG   <= SHIFT_IN_REG_NEXT after 2 ns;
			SHIFT_OUT_REG  <= SHIFT_OUT_REG_NEXT after 2 ns;
		end if;
	end if;
end process;

SHIFT_COMB: process(SHIFT_IN_REG,SHIFT_OUT_REG, SHIFT_IN, SHIFT_OUT,
					SAVE_R_LOAD_L, SAVE_L_LOAD_R, PAR_IN_L, PAR_IN_R,
					DIN)
begin		
		
	-- output shift register ----------------------------------
	SHIFT_OUT_REG_NEXT <= SHIFT_OUT_REG after 2 ns;
	
	-- next value of shift register after shifting out
	if SHIFT_OUT='1' then
		SHIFT_OUT_REG_NEXT <= SHIFT_OUT_REG(W-2 downto 0) & '0' after 2 ns;
	end if;
	-- next value of shift reg after loading for current channel
	if SAVE_R_LOAD_L = '1' then
		SHIFT_OUT_REG_NEXT <=  PAR_IN_L after 2 ns;
	end if;
	if SAVE_L_LOAD_R = '1' then
		SHIFT_OUT_REG_NEXT <=  PAR_IN_R after 2 ns;
	end if;
	-- output logic: assign MSB of shift reg to DOUT
    DOUT <= SHIFT_OUT_REG(W-1) after 2 ns;
	
	-- output shift/parallel register ----------------------------------
	SHIFT_IN_REG_NEXT <= SHIFT_IN_REG after 2 ns;

    -- shift into shift register (MSB first)
	if SHIFT_IN = '1' then
	   SHIFT_IN_REG_NEXT <= SHIFT_IN_REG(W-2 downto 0) & DIN;
	end if;

	-- forward shift registers to outputs and give NEW_SAMPLE pulse
	NEW_SAMPLE_L <= '0' after 2 ns; NEW_SAMPLE_R <= '0' after 2 ns;

	if SAVE_R_LOAD_L = '1' then
		NEW_SAMPLE_R <= '1' after 2 ns;
	end if;
	if SAVE_L_LOAD_R = '1' then
		NEW_SAMPLE_L <= '1' after 2 ns;
	end if;

	-- output logic: forward parallel reg values to port outputs
	PAR_OUT_L <= SHIFT_IN_REG  after 2 ns; 
	PAR_OUT_R <= SHIFT_IN_REG  after 2 ns;
end process;

end architecture BEHAVIORAL;
