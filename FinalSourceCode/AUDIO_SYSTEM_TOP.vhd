-- AUDIO SYSTEM TOP level module
-- includes clock generation, audio codec communication module 
-- and signal processing module
-- LTL, 16.07.2018 
-- Modified by Lachlan Townsend 02.12.21

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity AUDIO_SYSTEM_TOP is
	generic(W : integer := 16);
	port(
		CLK, SRESETN : in std_logic;
		DIN: in std_logic;
		SWITCH_VEC			: in std_logic_vector(1 downto 0);
		SYSCLK, BCK, LRC: out std_logic;
		DOUT: out std_logic;
		AUDIO_LINK : out std_logic_vector(15 downto 0)
		);
end AUDIO_SYSTEM_TOP;

architecture COMPONENTS of AUDIO_SYSTEM_TOP is

component AUDIO_CODEC_COM 
	generic(W : integer := 16);
	port(
		CLK, SRESETN : in std_logic;
		-- clock signals (to audio codec)
		SYSCLK, BCK, LRC: out std_logic;
		-- ADC path (from audio codec to signal processing)
		DIN: in std_logic;
		PAR_OUT_L: out std_logic_vector(W-1 downto 0);
		PAR_OUT_R: out std_logic_vector(W-1 downto 0);
		NEW_SAMPLE_L  : out std_logic; -- new value on left channel
		NEW_SAMPLE_R  : out std_logic; --           on right channel		
		-- DAC path (from signal processing to audio codec)
		PAR_IN_L: in std_logic_vector(W-1 downto 0);
		PAR_IN_R: in std_logic_vector(W-1 downto 0);
		DOUT: out std_logic
		);
end component AUDIO_CODEC_COM;

component AUDIO_PROCESSING
	generic(W : integer := 16);
	port(
		CLK				: in std_logic;
		SRESETN			: in std_logic;
		START_L			: in std_logic;
		START_R			: in std_logic;
		AUDIO_IN_L		: in std_logic_vector(W-1 downto 0);
		AUDIO_IN_R		: in std_logic_vector(W-1 downto 0);
		AUDIO_OUT_L		: out std_logic_vector(W-1 downto 0);
		AUDIO_OUT_R		: out std_logic_vector(W-1 downto 0);
		AUDIO_LINK      : out std_logic_vector(W-1 downto 0);
		SWITCH_VEC		: in std_logic_vector(1 downto 0)
	);
end component AUDIO_PROCESSING;

signal AUDIO_PAR_IN_L, AUDIO_PAR_IN_R, AUDIO_PAR_OUT_L, AUDIO_PAR_OUT_R: std_logic_vector(W-1 downto 0);
signal START_L, START_R: std_logic;


begin
INST_AUDIO_CODEC_COM : AUDIO_CODEC_COM
	port map (CLK,SRESETN,SYSCLK,BCK,LRC,DIN,AUDIO_PAR_IN_L,AUDIO_PAR_IN_R,START_L,START_R,AUDIO_PAR_OUT_L,AUDIO_PAR_OUT_R,DOUT);

INST_AUDIO_PROCESSING : AUDIO_PROCESSING 
    port map(CLK,SRESETN,START_L, START_R,
	         AUDIO_PAR_IN_L,AUDIO_PAR_IN_R,AUDIO_PAR_OUT_L,AUDIO_PAR_OUT_R, AUDIO_LINK, SWITCH_VEC);
		
end COMPONENTS;