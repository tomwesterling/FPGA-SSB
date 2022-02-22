--------
-- TOP LEVEL ENTITY DUMMY MODULE
-- LTL, 26.4.2020
-- Modified by Lachlan Townsend 02.12.21
--------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity AUDIO_PROCESSING is
	generic(W : integer := 16);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		AUDIO_IN_L			: in std_logic_vector(W-1 downto 0);
		AUDIO_IN_R			: in std_logic_vector(W-1 downto 0);
		AUDIO_OUT_L			: out std_logic_vector(W-1 downto 0);
		AUDIO_OUT_R			: out std_logic_vector(W-1 downto 0);
		AUDIO_LINK			: out std_logic_vector(W-1 downto 0);
		SWITCH_VEC			: in std_logic_vector(1 downto 0)
		);
end AUDIO_PROCESSING;

architecture COMPONENTS of AUDIO_PROCESSING is

component STEREO_TO_MONO_CONVERSION is
	generic(W : integer := 16);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		AUDIO_IN_L			: in std_logic_vector(W-1 downto 0);
		AUDIO_IN_R			: in std_logic_vector(W-1 downto 0);
		AUDIO_OUT			: out std_logic_vector(W-1 downto 0)
		);
end component STEREO_TO_MONO_CONVERSION;

component DELAY_LINE is
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
end component DELAY_LINE;

component HILBERT_FIR_FILTER is
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
end component HILBERT_FIR_FILTER;

component MONO_TO_STEREO_CONVERSION is
	generic(W : integer := 16);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		AUDIO_IN			: in std_logic_vector(W-1 downto 0);
		AUDIO_OUT_L			: out std_logic_vector(W-1 downto 0);
		AUDIO_OUT_R			: out std_logic_vector(W-1 downto 0);
		AUDIO_LINK          : out std_logic_vector(W-1 downto 0)
		);
end component MONO_TO_STEREO_CONVERSION;

component MODULATION_SPECIFIC_LUT is
	generic(
		TABLE_SIZE 		: integer := 47);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		MODULATION_IN		: in std_logic_vector(1 downto 0);
		POSITION_OUT		: out integer range 0 to 47
	     );
end component MODULATION_SPECIFIC_LUT;

component LUT_SINE_COS is
	port(	
		CLK			: in std_logic;
		START_R			: in std_logic;
		POSITION_IN		: in integer range 0 to 47;
		OUTPUT_SINE		: out integer;
		OUTPUT_COS		: out integer
		);
end component LUT_SINE_COS;

component MULTIPLY_AND_ADD is
	generic(
		SIGNAL_WIDTH : integer := 16);
	port(
		CLK					: in std_logic;
		SRESETN				: in std_logic;
		START_L				: in std_logic;
		START_R				: in std_logic;
		SINE_VALUE			: in integer;
		COS_VALUE			: in integer;
		DELAYED_IN			: in std_logic_vector(SIGNAL_WIDTH-1 downto 0);
		FILTERED_IN			: in std_logic_vector(SIGNAL_WIDTH-1 downto 0);
		MODULATED_OUT		: out std_logic_vector(SIGNAL_WIDTH-1 downto 0)
		);
end component MULTIPLY_AND_ADD;



signal AUDIO_MONO, AUDIO_DELAYED, AUDIO_HILBERT, AUDIO_SSB : std_logic_vector(W-1 downto 0);
signal LUT_POSITION : integer range 0 to 47;
signal OUTPUT_SINE, OUTPUT_COS : integer;
signal MODULATED_OUT : std_logic_vector(W-1 downto 0);

begin
INST_STEREO_TO_MONO_CONVERSION : STEREO_TO_MONO_CONVERSION -- CHECKED OK
	port map (CLK,SRESETN,START_L,START_R,AUDIO_IN_L,AUDIO_IN_R,AUDIO_MONO);

INST_DELAY_LINE : DELAY_LINE -- CHECKED OK
	port map (CLK,SRESETN,START_L,START_R,AUDIO_MONO,AUDIO_DELAYED);
	
INST_HILBERT_FIRFILTER : HILBERT_FIR_FILTER -- CHECKED OK
	port map (CLK,SRESETN,START_L,START_R,AUDIO_MONO,AUDIO_HILBERT);
		

INST_MODULATION_SPECIFIC_LUT : MODULATION_SPECIFIC_LUT -- CHECKED OK NOTE 2 CLK CYCLES DELAY
	port map (CLK, SRESETN,START_L,START_R, SWITCH_VEC, LUT_POSITION); -- Temporarily locking modulaiton to STD via "00" value for MODULATION_IN

INST_LUT_SINE_COS : LUT_SINE_COS -- CHECKED OKAY, SEE NOTE ABOVE REGARDING CLK DELAY
	port map (CLK, START_R, LUT_POSITION, OUTPUT_SINE, OUTPUT_COS);

INST_MULTIPLY_AND_ADD : MULTIPLY_AND_ADD
	port map (CLK, SRESETN, START_L, START_R, OUTPUT_SINE, OUTPUT_COS, AUDIO_DELAYED, AUDIO_HILBERT, MODULATED_OUT);

INST_MONO_TO_STEREO_CONVERSION : MONO_TO_STEREO_CONVERSION -- CHECKED OKAY
	port map (CLK,SRESETN,START_L,START_R,MODULATED_OUT,AUDIO_OUT_L,AUDIO_OUT_R, AUDIO_LINK);
	



end COMPONENTS;
