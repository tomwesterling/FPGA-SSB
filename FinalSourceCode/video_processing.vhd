--
--  VIDEO_PROCESSING outputs a moving square moving in spiral
--  with changing colors, requires VIDEO_TIMING_GEN
--
--  13.12.2020 LTL
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.video_stream_pkg.all;

entity VIDEO_PROCESSING is
    port(
        clk       		: in  std_logic;
        sresetn   		: in  std_logic;
        videoStreamIn   : in  VideoStream_t;
        AUDIO_FOR_VIDEO : in std_logic_vector(15 downto 0);
        videoStreamOut  : out VideoStream_t
    );

end entity;

architecture RTL of VIDEO_PROCESSING is

-- video parameters ----------------------------------
	-- screen size in pixels incl. blank region
	constant X_FULL : natural := 1040; 
	constant Y_FULL : natural :=  666;      

	-- visable screen size in pixels
	constant X_VISIBLE : natural := 800; 
	constant Y_VISIBLE : natural := 600;
 
-- constants -------------------------------
	constant colBackground : integer := 0;
	constant colDrivers : integer := 0;
	constant colVinyl :integer :=  5263440;
	constant colVinylCenter : integer := 11842740;
	constant colVinylLogo : integer := 5260910;
	constant colSpeakerChassy : integer := 14329120;
	constant colVinylArm : integer := 13158600;
	constant colVinylCase : integer := 9699539;
	constant colEQlow : integer := 16724787;
	constant colEQmid : integer:= 10092339;
	constant colEQhigh :integer := 3407871;
	
-- signals ---------------------------------
signal videoStreamOutTemp : VideoStream_t := VIDEO_STREAM_IDLE;

	function isInCircle (xCenter : in integer ; yCenter : in integer ;
						xPos : in integer ; yPos : in integer ; radius : in integer)
		return boolean is variable result : boolean;
		variable a : integer;
		variable b : integer;
		variable x : integer;
		variable y : integer;
		variable t1 : integer;
		variable t2 : integer;
		variable t3 : integer;
		variable t4 : integer;
		variable t5 : integer;
		variable t6 : integer;
		variable t7 : integer;
	begin
		a := xPos - xCenter;
		b := yPos - yCenter;
		t1 := abs(a);
		t2 := abs(b);
		
		-- Assign max value to x
		if t1 > t2 then
			x := t1;
		else
			x := t2;
		end if;

		-- Assign min value to y
		if t1 < t2 then
			y := t1;
		else
			y := t2;
		end if;
		
		t3 := to_integer(shift_right(to_unsigned(x, 16), 3));        -- bit-vectors: t3 >> 3
		t4 := to_integer(shift_right(to_unsigned(y, 16), 1));          -- bit-vectors: t4 >> 1
		t5 := x - t3;
		t6 := t4 + t5;

		-- Assign max value to t7
		if t6 > x then
			t7 := t6;
		else
			t7 := x;
		end if;
	
		if t7 <= radius then
			result := true;
		else
			result := false;
		end if;
		
		return result;
	end function isInCircle;

signal frameCtr : natural range 0 to 1000;
signal animationStep : natural range 0 to 1000;

begin

videoStreamOut <= videoStreamOutTemp; -- Output fully calculated frame
-- sequential process with registers
generateVideo : process (clk)
	variable lowChannelUpperBound : natural;
	variable midChannelUpperBound : natural;
	variable highChannelUpperBound : natural;
	variable lowDriverRadius : natural;
	variable midDriverRadius : natural;
	variable highDriverRadius : natural;
	variable vinylLogoPosX : natural;
	variable vinylLogoPosY : natural;
	
	variable xPos : natural range 0 to X_FULL-1 := 0; 
	variable yPos : natural range 0 to Y_FULL-1 := 0;
	
	variable amplitude : signed(15 downto 0);
	variable loudness : integer;
	 

begin
if sresetn = '0' then
    frameCtr <= 0;
elsif rising_edge(CLK)then
	-- X,Y cursor position
	yPos := to_integer(videoStreamIn.verticalPos);
	xPos := to_integer(videoStreamIn.horizontalPos);
	
	-- Default assignmanets
	videoStreamOutTemp <= videoStreamIn after 2 ns;

	-- Modulo 1000 counter for randomisation of animations
	if (yPos = Y_FULL-1) and (xPos = X_FULL-1)then
		frameCtr <= frameCtr + 1;
	elsif (frameCtr = 1000) then
		frameCtr <= 0;
	end if;
	
	-- animationStep: slower step counter compared to frameCtr
	animationStep <= to_integer(shift_right(to_unsigned(frameCtr, 16), 3)); -- divide frameCtr by 8
	
	-- link audio
	amplitude := signed(AUDIO_FOR_VIDEO);
	
	------------------- determine loudness levels ----------------------------
	
	
	if (amplitude < 500) then
		loudness := 1;
	elsif (amplitude < 1000) then
		loudness := 2;
	elsif (amplitude < 2000) then
		loudness := 3;
	elsif (amplitude < 5000) then
		loudness := 4;
	elsif (amplitude < 8000) then
		loudness := 5;
	elsif (amplitude < 12000) then
		loudness := 6;
	elsif (amplitude < 16000) then
		loudness := 7;
	elsif (amplitude < 20000) then
		loudness := 8;
	elsif (amplitude < 24000) then
		loudness := 9;
	elsif (amplitude < 30000) then
		loudness := 10;
    else
        loudness := 0;
	end if;

	------------------------------Begin dynamic position calculations------------------------------
	
	------------------------------EQ display levels------------------------------
	-- low channel
	case (animationStep mod 10) is
		when 1 =>
			lowChannelUpperBound := 180;
		when 2 =>
			lowChannelUpperBound := 140;
		when 3 =>
			lowChannelUpperBound := 100;
		when 4 =>
			lowChannelUpperBound := 80;
		when 5 =>
			lowChannelUpperBound := 160;
		when 6 =>
			lowChannelUpperBound := 120;
		when 7 =>
			lowChannelUpperBound := 90;
		when 8 =>
			lowChannelUpperBound := 110;
		when 9 =>
			lowChannelUpperBound := 130;
		when others =>
			lowChannelUpperBound := 200;
	end case;


-- mid channel
	case (animationStep mod 13) is
		when 1 =>
			midChannelUpperBound := 180;
		when 2 =>
			lowChannelUpperBound := 140;
		when 3 =>
			midChannelUpperBound := 100;
		when 4 =>
			midChannelUpperBound := 80;
		when 5 =>
			lowChannelUpperBound := 160;
		when 6 =>
			midChannelUpperBound := 120;
		when 7 =>
			midChannelUpperBound := 90;
		when 8 =>
			midChannelUpperBound := 110;
		when 9 =>
			midChannelUpperBound := 130;
		when others =>
			midChannelUpperBound := 200;
	end case;

	-- high channel
	case (animationStep mod 8) is
		when 1 =>
			highChannelUpperBound := 180;
		when 2 =>
			highChannelUpperBound := 140;
		when 3 =>
			highChannelUpperBound := 100;
		when 4 =>
			highChannelUpperBound := 80;
		when 5 =>
			highChannelUpperBound := 160;
		when 6 =>
			highChannelUpperBound := 120;
		when 7 =>
			highChannelUpperBound := 90;
		when others =>
			highChannelUpperBound := 200;
	end case;

	------------------------------speaker driver radius------------------------------
	-- low driver (60 to 95)
	case loudness is
		when 1 =>
			lowDriverRadius := 60;
		when 2 =>
			lowDriverRadius := 63;
		when 3 =>
			lowDriverRadius := 67;
		when 4 =>
			lowDriverRadius := 72;
		when 5 =>
			lowDriverRadius := 78;
		when 6 =>
			lowDriverRadius := 85;
		when 7 =>
			lowDriverRadius := 90;
		when 8 =>
			lowDriverRadius := 92;
		when 9 =>
			lowDriverRadius := 94;
		when 10 =>
			lowDriverRadius := 95;
		when others =>
			lowDriverRadius := 60;
	end case;

	-- mid driver (40 to 70)
	case loudness is
		when 1 =>
			midDriverRadius := 41;
		when 2 =>
			midDriverRadius := 43;
		when 3 =>
			midDriverRadius := 46;
		when 4 =>
			midDriverRadius := 49;
		when 5 =>
			midDriverRadius := 52;
		when 6 =>
			midDriverRadius := 55;
		when 7 =>
			midDriverRadius := 60;
		when 8 =>
			midDriverRadius := 64;
		when 9 =>
			midDriverRadius := 67;
		when 10 =>
			midDriverRadius := 70;
		when others =>
			midDriverRadius := 40;
	end case;

	-- high driver (20 to 30)
	case loudness is
		when 1 =>
			highDriverRadius := 21;
		when 2 =>
			highDriverRadius := 22;
		when 3 =>
			highDriverRadius := 23;
		when 4 =>
			highDriverRadius := 24;
		when 5 =>
			highDriverRadius := 25;
		when 6 =>
			highDriverRadius := 26;
		when 7 =>
			highDriverRadius := 27;
		when 8 =>
			highDriverRadius := 28;
		when 9 =>
			highDriverRadius := 29;
		when 10 =>
			highDriverRadius := 30;
		when others =>
			highDriverRadius := 20;
	end case;

	------------------------------VINYL LOGO POSITION------------------------------
	case (animationStep mod 8) is
		when 1 =>
			vinylLogoPosX := 414;
			vinylLogoPosY := 424;
		when 2 =>
			vinylLogoPosX := 400;
			vinylLogoPosY := 430;
		when 3 =>
			vinylLogoPosX := 386;
			vinylLogoPosY := 424;
		when 4 =>
			vinylLogoPosX := 380;
			vinylLogoPosY := 410;
		when 5 =>
			vinylLogoPosX := 386;
			vinylLogoPosY := 396;
		when 6 =>
			vinylLogoPosX := 400;
			vinylLogoPosY := 390;
		when 7 =>
			vinylLogoPosX := 414;
			vinylLogoPosY := 396;
		when others =>
			vinylLogoPosX := 420;
			vinylLogoPosY := 410;
	end case;

	------------------------------Begin frame drawing------------------------------
	
	if (yPos <= Y_VISIBLE) and (xPos <= X_VISIBLE) then
		------------------------------SPEAKERS------------------------------
		--draw left speaker chasse
		if (yPos >= 60) and (yPos <= 560) and (xPos >= 40) and (xPos <= 240) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colSpeakerChassy,NUM_BITS_PIXEL_RGB);
		end if;

		--draw left low driver
		if isInCircle(140, 450, xPos, yPos, lowDriverRadius) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colDrivers,NUM_BITS_PIXEL_RGB);
		end if;

		--draw left mid driver
		if isInCircle(140, 280, xPos, yPos, midDriverRadius) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colDrivers,NUM_BITS_PIXEL_RGB);
		end if;

		--draw left top driver
		if isInCircle(140, 140, xPos, yPos, highDriverRadius) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colDrivers,NUM_BITS_PIXEL_RGB);
		end if;

		--draw right speaker chasse
		if (yPos >= 60) and (yPos <= 560) and (xPos >= 560) and (xPos <= 760) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colSpeakerChassy,NUM_BITS_PIXEL_RGB);
		end if;

		--draw right low driver
		if isInCircle(660, 450, xPos, yPos, lowDriverRadius) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colDrivers,NUM_BITS_PIXEL_RGB);
		end if;

		--draw right mid driver
		if isInCircle(660, 280, xPos, yPos, midDriverRadius) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colDrivers,NUM_BITS_PIXEL_RGB);
		end if;

		--draw right top driver
		if isInCircle(660, 140, xPos, yPos, highDriverRadius) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colDrivers,NUM_BITS_PIXEL_RGB);
		end if;

		------------------------------VINYL PLAYER------------------------------
		--draw vinyl player case
		if (xPos >= 260) and (xPos <= 540) and (yPos >= 260) and (yPos <= 560) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinylCase,NUM_BITS_PIXEL_RGB);
		end if;

		--draw vinyl
		if isInCircle(400, 410, xPos, yPos, 120) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinyl,NUM_BITS_PIXEL_RGB);
		end if;

		--draw vinyl center
		if isInCircle(400, 410, xPos, yPos, 35) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinylCenter,NUM_BITS_PIXEL_RGB);
		end if;

		--draw vinyl hole
		if isInCircle(400, 410, xPos, yPos, 10) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colBackground,NUM_BITS_PIXEL_RGB);
		end if;

		--draw vinyl logo
		if isInCircle(vinylLogoPosX, vinylLogoPosY, xPos, yPos, 5) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colEQhigh,NUM_BITS_PIXEL_RGB);
		end if;

		--draw vinyl player arm
		if (xPos >= 475) and (xPos <= 485) and (yPos >= 290) and (yPos <= 410) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinylArm,NUM_BITS_PIXEL_RGB);
		end if;

		--draw vinyl player arm end
		if (xPos >= 470) and (xPos <= 490) and (yPos >= 390) and (yPos <= 420) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinylArm,NUM_BITS_PIXEL_RGB);
		end if;

		------------------------------draw UV-meter------------------------------
		--UV-meter background
		if (xPos >= 260) and (xPos <= 540) and (yPos >= 60) and (yPos <= 220) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinylCase,NUM_BITS_PIXEL_RGB);
		end if;

		--lows channel background
		if (xPos >= 290) and (xPos <= 350) and (yPos >= 80) and (yPos <= 200) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinylArm,NUM_BITS_PIXEL_RGB);
		end if;

		--low channel display
		if (xPos >= 290) and (xPos <= 350) and (yPos >= lowChannelUpperBound) and (yPos <= 200) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colEQlow,NUM_BITS_PIXEL_RGB);
		end if;

		--mid channel background
		if (xPos >= 370) and (xPos <= 430) and (yPos >= 80) and (yPos <= 200) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinylArm,NUM_BITS_PIXEL_RGB);
		end if;

		--mid channel display
		if (xPos >= 370) and (xPos <= 430) and (yPos >= midChannelUpperBound) and (yPos <= 200) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colEQmid,NUM_BITS_PIXEL_RGB);
		end if;

		--high channel background
		if (xPos >= 450) and (xPos <= 510) and (yPos >= 80) and (yPos <= 200) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colVinylArm,NUM_BITS_PIXEL_RGB);
		end if;

		--high channel display
		if (xPos >= 450) and (xPos <= 510) and (yPos >= highChannelUpperBound) and (yPos <= 200) then
			videoStreamOutTemp.pixelRGBData <= to_unsigned(colEQhigh,NUM_BITS_PIXEL_RGB);
		end if;

	end if;
end if;

end process;
 
end architecture RTL;
