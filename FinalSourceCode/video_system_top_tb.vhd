library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity VIDEO_SYSTEM_TOP_TB is
end VIDEO_SYSTEM_TOP_TB;

architecture BEHAVIORAL of VIDEO_SYSTEM_TOP_TB is

-- component under test
component VIDEO_SYSTEM_TOP 
	port(	clk	 				: in std_logic;
			sresetn 			: in std_logic;
			hSync				: out std_logic;
			vSync 				: out std_logic;
			dviclk  			: out std_logic;
			dviDataEn			: out std_logic;
			vgaclk  			: out std_logic;
			vgaNSync, vgaNBlanc : out std_logic;
			pixelRGBData	 	: out unsigned(23 downto 0)
	);
end component VIDEO_SYSTEM_TOP;

-- Testbench Internal Signals
file fidVideoOut : text;
		
constant CLK_PERIOD: time := 20 ns; -- clock period (1/50 MHz)
constant CDELAY : time :=  2 ns;    -- combinational delay
constant MAX_FRMCOUNT : positive range 1 to 999 := 720; -- number of frames to be processed

signal clk : std_logic :='1';
signal sresetn 	: std_logic := '0';
-- signal HSYNC, VSYNC		: std_logic;
--signal dviClk  		: std_logic;
signal dviDataEn		: std_logic;
signal vgaClk  		    : std_logic;
signal pixelRGBdata	 		: unsigned(23 downto 0);
signal idxPixel  : natural range 0 to 800*600-1;

begin

	-- create stimuli 
	clk <= not clk after CLK_PERIOD / 2 ; 
	sresetn <= '0', '1' after 105 ns;      
	
	-- instantiate and map DUV
	DUV_i : VIDEO_SYSTEM_TOP 
	port map( 	sresetn 		=> sresetn,
				clk	 			=> clk,
				hSync			=> open,
				vSync 			=> open,
				dviclk  		=> open,
				dviDataEn		=> dviDataEn,
				vgaclk  		=> vgaClk,
				vgaNSync 		=> open,
				vgaNBlanc 		=> open,
				pixelRGBData	=> pixelRGBData
	);
  
	-- write response to file  
    frameWriter_p : process
--		constant W : integer := 16;  -- audio resolution
		constant HEADER1 : string(1 to 69) := "% Modelsim video frames output. Execute directly as script in Matlab.";
		constant HEADER2 : string(1 to 20) := "frame_mds = uint32([";
		constant PIXEL_DELIM : string(1 to 1) := " ";
		constant LINE_DELIM : string(1 to 1) := ";";
		constant TRAILER1 : string(1 to 4) := " ]);";
		variable fileName : string(1 to 20);
		variable vline       : line; -- line write out

		variable RGB_TMP : natural range 0 to 2**24-1;
		
		begin
	
			wait until sresetn='1'; 			-- start writing output after reset is gone
			wait until rising_edge(vgaClk);   		

	
			for frmCount in 1 to MAX_FRMCOUNT loop			-- write predefined number of frames 
				if frmCount < 10 then
					fileName := "FRM/VIDEO_OUT_000" & integer'image(frmCount) & ".m";
				elsif frmCount < 100 then
					fileName := "FRM/VIDEO_OUT_00"  & integer'image(frmCount) & ".m";
				elsif frmCount < 1000 then
					fileName := "FRM/VIDEO_OUT_0"   & integer'image(frmCount) & ".m";
				else 
					fileName := "FRM/VIDEO_OUT_"    & integer'image(frmCount) & ".m";
				end if;
				
				file_open(fidVideoOut, fileName, write_mode);
				write(vline,HEADER1);
				writeline(fidVideoOut, vline);

				write(vline,HEADER2);
				writeline(fidVideoOut, vline);
	
				for Y in 0 to 599 loop  					-- frame rows
					for X in 0 to 799 loop  				-- frame columns
					    idxPixel <= Y * 600 + X;
						wait until rising_edge(vgaClk);   	-- sample pixelRGBdata at rising edge of video out	
						write (vline,to_integer(pixelRGBdata),right,8);
						write (vline,PIXEL_DELIM);
					end loop;
					if Y < 599 then
						write (vline,LINE_DELIM);
					end if;
					writeline(fidVideoOut, vline);
					wait until dviDataEn ='1'; 
				end loop;
				write(vline,TRAILER1);
				writeline(fidVideoOut, vline);
				file_close(fidVideoOut);
			end loop;

			assert (false) report "Simulation successful." severity failure;

			wait;
	end process;

end BEHAVIORAL;

