--
--  VIDEO_TIMING_GEN generates and initializes the pixel bitstream 
--  with correct timing of HSYNC, VSYNC and pixel coordinates X,Y
--  dviDataEn=1 indicates a new pixel in the visible region 
-- 
--  28.4.2020 LTL, M.Fürstenberg, A.Talasman
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.video_stream_pkg.all;

entity VIDEO_TIMING_GEN is
    -- generic values for 800*600 at 72 Hz resolution - 50 MHz VESA
    generic(
        X_VP : positive := 800;         -- horizontal visible pulse
        X_FP : positive := 56;          -- horizontal front porch
        X_SP : positive := 120;         -- horizontal sync pulse
        X_BP : positive := 64;          -- horizontal back porch
        Y_VP : positive := 600;         -- vertical visible pulse
        Y_FP : positive := 37;          -- vertical front porch
        Y_SP : positive := 6;           -- vertical sync pulse
        Y_BP : positive := 23           -- vertical back porch
    );
    port(
        clk       		: in  std_logic;
        sresetn   		: in  std_logic;
        clkEnable 		: in  std_logic;
        videoStream   	: out VideoStream_t := VIDEO_STREAM_IDLE
    );

end entity;

architecture RTL of VIDEO_TIMING_GEN is
    constant X_FRAME_WIDTH : positive := X_VP + X_FP + X_SP + X_BP;
    constant Y_FRAME_HEIGHT : positive := Y_VP + Y_FP + Y_SP + Y_BP;

    signal pixelPosX    : unsigned(integer(ceil(log2(real(TOTAL_FRAME_WIDTH)))) - 1 downto 0) := (others => '0');
    signal pixelPosX_dly: unsigned(integer(ceil(log2(real(TOTAL_FRAME_WIDTH)))) - 1 downto 0) := (others => '0');
    signal pixelPosY    : unsigned(integer(ceil(log2(real(TOTAL_FRAME_HEIGHT)))) - 1 downto 0) := (others => '0');
    signal pixelPosY_dly: unsigned(integer(ceil(log2(real(TOTAL_FRAME_HEIGHT)))) - 1 downto 0) := (others => '0');

    signal dviDataEn 	: std_logic := '0';
    signal hSync     	: std_logic := '0';
    signal vSync     	: std_logic := '0';
begin

    TimingGenerator_p : process(clk)
    begin
        if rising_edge(clk) then
            if sresetn = '0' then
                pixelPosX_dly 	<= (others=>'0');
                pixelPosY_dly 	<= (others=>'0');
                pixelPosX 		<= (others=>'0');
                pixelPosY 		<= (others=>'0');
                dviDataEn 	    <= '0';
            else
                -- dviDataEn=1 only when clock is enabled
                if clkEnable = '1' then
					-- pixel clock must be delayed by 1 pixelClk cycle as hysync 
					-- and vsync depend on pixelPosX,Y 
					pixelPosX_dly <= pixelPosX;
					pixelPosY_dly <= pixelPosY;

                    -- counter X and Y logic
                    pixelPosX <= pixelPosX + 1;
                    if pixelPosX = X_FRAME_WIDTH - 1 then
                        pixelPosX <= (others => '0');
                        pixelPosY <= pixelPosY + 1;
                        if pixelPosY = Y_FRAME_HEIGHT - 1 then
                            pixelPosY <= (others => '0');
                        end if;
                    end if;

                    -- dviDataEn signal
					dviDataEn <= '0';
                    if pixelPosX < X_VP and pixelPosY < Y_VP then
                        -- inside the visible area and when clk enabled
                        dviDataEn <= '1';
                    end if;

                    -- sync signals
                    hSync <= '0'; 
                    if pixelPosX > X_VP + X_FP - 1 and pixelPosX < X_VP + X_FP + X_SP then
                        hSync <= '1';
                    end if;

                    vSync <= '0';
                    if pixelPosY > Y_VP + Y_FP - 1 and pixelPosY < Y_VP + Y_FP + Y_SP then
                        vSync <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

	videoStream <= (
		frameResolution => (
            maxFrameWidthX 		=> X_FRAME_WIDTH,
            maxFrameHeightY 	=> Y_FRAME_HEIGHT,
			visibleFrameWidthX  => X_VP,
			visibleFrameHeightY => Y_VP
		),
        horizontalPos  => pixelPosX_dly,
        verticalPos    => pixelPosY_dly,
        pixelRGBData   => (others => '0'),
        dviDataEn     => dviDataEn,
        pulseHSync     => hSync,
        pulseVSync     => vSync
    );

end architecture;
