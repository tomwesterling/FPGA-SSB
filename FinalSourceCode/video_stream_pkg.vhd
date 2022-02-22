library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package VIDEO_STREAM_PKG is

    constant NUM_BITS_PIXEL_RGB  : positive := 24;
    constant TOTAL_FRAME_WIDTH   : positive := 1040;
    constant TOTAL_FRAME_HEIGHT  : positive := 800;

	constant NUM_BITS_FRAME_WIDTH  : positive := integer(ceil(log2(real(TOTAL_FRAME_WIDTH))));
	constant NUM_BITS_FRAME_HEIGHT : positive := integer(ceil(log2(real(TOTAL_FRAME_HEIGHT))));
	
    type FrameResolution_t is record
        maxFrameWidthX  : integer range 0 to TOTAL_FRAME_WIDTH;
        maxFrameHeightY : integer range 0 to TOTAL_FRAME_HEIGHT;
        visibleFrameWidthX  : integer range 0 to TOTAL_FRAME_WIDTH;
        visibleFrameHeightY : integer range 0 to TOTAL_FRAME_HEIGHT;
    end record;

    type VideoStream_t is record
        frameResolution : FrameResolution_t;
        horizontalPos  : unsigned(NUM_BITS_FRAME_WIDTH - 1 downto 0);
        verticalPos    : unsigned(NUM_BITS_FRAME_HEIGHT - 1 downto 0);
        pixelRGBData   : unsigned(NUM_BITS_PIXEL_RGB - 1 downto 0);
        dviDataEn      : std_logic;
        pulseHSync     : std_logic;
        pulseVSync     : std_logic;
    end record;

    constant VIDEO_STREAM_IDLE : videoStream_t := (
		frameResolution => (
            maxFrameWidthX 		=> 0,
            maxFrameHeightY 	=> 0,
			visibleFrameWidthX  => 0,
			visibleFrameHeightY => 0
		),
        horizontalPos  => (others => '0'),
        verticalPos    => (others => '0'),
        pixelRGBData   => (others => '0'),
        dviDataEn      => '0',
        pulseHSync     => '0',
        pulseVSync     => '0'
    );
end package;

package body VIDEO_STREAM_PKG is

end package body;
