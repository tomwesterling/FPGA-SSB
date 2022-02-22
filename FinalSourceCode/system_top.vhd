library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.video_stream_pkg.all;

entity SYSTEM_TOP is 
	port( 	CLK	 				: in std_logic;
			SRESETN 			: in std_logic;
		    DIN					: in std_logic;
		    SWITCH_VEC			: in std_logic_vector(1 downto 0);
		    SYSCLK, BCK, LRC	: out std_logic;
		    DOUT				: out std_logic;
			hSync				: out std_logic;
			vSync 				: out std_logic;
			dviClk  			: out std_logic;
			dviDataEn			: out std_logic;
			vgaClk  			: out std_logic;
			vgaNSync, vgaNBlanc : out std_logic;
			pixelRGBData	 	: out unsigned(23 downto 0)

	);
end entity SYSTEM_TOP;


architecture STRUCTURAL of SYSTEM_TOP is

component AUDIO_SYSTEM_TOP is
	generic(W : integer := 16);
	port(
		CLK, SRESETN : in std_logic;
		DIN: in std_logic;
		SWITCH_VEC			: in std_logic_vector(1 downto 0);
		SYSCLK, BCK, LRC: out std_logic;
		DOUT: out std_logic;
		AUDIO_LINK : out std_logic_vector(15 downto 0)
		);
end component AUDIO_SYSTEM_TOP;

component VIDEO_SYSTEM_TOP is 
	port( 	clk	 				: in std_logic;
			sresetn 			: in std_logic;
			AUDIO_FOR_VIDEO		: in std_logic_vector(15 downto 0);
			hSync				: out std_logic;
			vSync 				: out std_logic;
			dviClk  			: out std_logic;
			dviDataEn			: out std_logic;
			vgaClk  			: out std_logic;
			vgaNSync, vgaNBlanc : out std_logic;
			pixelRGBData	 	: out unsigned(23 downto 0)
	);
end component VIDEO_SYSTEM_TOP;


signal AUDIO_FOR_VIDEO : std_logic_vector(15 downto 0);

begin

INST_AUDIO_SYSTEM_TOP : AUDIO_SYSTEM_TOP
	port map(
		CLK					=> CLK,
		SRESETN				=> SRESETN,
		DIN					=> DIN,
		SWITCH_VEC			=> SWITCH_VEC,
		SYSCLK				=> SYSCLK,
		BCK					=> BCK,
		LRC					=> LRC,
		DOUT				=> DOUT,
		AUDIO_LINK          => AUDIO_FOR_VIDEO
		);

INST_VIDEO_SYSTEM_TOP : VIDEO_SYSTEM_TOP
	port map ( 	
			clk	 			=> clk,
			sresetn 		=> sresetn,
			AUDIO_FOR_VIDEO	=> AUDIO_FOR_VIDEO,
			hSync			=> hSync,
			vSync 			=> vSync,
			dviClk  		=> dviClk,
			dviDataEn		=> dviDataEn,
			vgaClk  		=> vgaClk,
			vgaNSync		=> vgaNSync,
			vgaNBlanc		=> vgaNBlanc,
			pixelRGBData 	=> pixelRGBData
	);

end STRUCTURAL;

