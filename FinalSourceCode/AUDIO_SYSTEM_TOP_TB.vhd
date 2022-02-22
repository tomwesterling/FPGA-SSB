
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity AUDIO_SYSTEM_TOP_TB is
end AUDIO_SYSTEM_TOP_TB;

architecture BEHAVIORAL of AUDIO_SYSTEM_TOP_TB is

-- component under test
component AUDIO_SYSTEM_TOP is
	generic(W : integer := 16);
	port(
		CLK, SRESETN : in std_logic;
		-- clock signals (to audio codec)
		SYSCLK, BCK, LRC: out std_logic;
		-- serial data in
		DIN: in std_logic;
		-- serial data out
		DOUT: out std_logic
		);
end component AUDIO_SYSTEM_TOP;

-- Testbench Internal Signals
file FILE_AUDIO_IN  : text;
file FILE_AUDIO_OUT : text;

constant CLK_PERIOD: time := 10 ns; -- clock period (1/100 MHz)
constant SYSCTL_PERIOD: time := 80 ns; -- bit clock (8/100 MHz)
constant BCK_PERIOD: time := 640 ns; -- bit clock (8*8/100 MHz)
constant LRC_PERIOD: time := 20480 ns; -- LRC period (32*8*8/100MHz = approx 1/48kHz, 20.08333... would be accurate)
constant CDELAY : time :=  2 ns;    -- combinational delay

signal CLK : std_logic :='1';
signal SRESETN 	: std_logic;
signal BCK, LRC : std_logic;
signal DIN, DOUT : std_logic;

begin

-- CLK and SRESETN generation by unconditional assignement 
	CLK <= not CLK after CLK_PERIOD / 2 ; -- actually a combinational loop -> oscillator 
	SRESETN <= '0', '1' after 21 ns;      -- non periodic, giving values directly like in force instruction
	
 -- Instantiate and Map DUT
 -- (output signals not used in TB are to be declared open, otherwise cannot be waveform viewed  
DUT : AUDIO_SYSTEM_TOP 
      port map(CLK, SRESETN, open, BCK, open, DIN, DOUT);
  
    -- emulation of the audio codec 
    process
    -- variable declarations
    constant W : integer := 16;  -- audio resolution
    variable ILINE       : line; -- line read in
    variable OLINE       : line; -- line write out
 	variable AUDIO_IN_INT_L,AUDIO_IN_INT_R : integer range -2**(W-1) to 2**(W-1)-1;
	variable AUDIO_OUT_INT_L,AUDIO_OUT_INT_R: integer range -2**(W-1) to 2**(W-1)-1;
    variable AUDIO_IN_STD_L,AUDIO_IN_STD_R : std_logic_vector(W-1 downto 0);
    variable AUDIO_OUT_STD_L,AUDIO_OUT_STD_R: std_logic_vector(W-1 downto 0);
	variable SPACE : character; -- read delimiter space
	
    begin
    file_open(FILE_AUDIO_IN,  "audio_input.txt",  read_mode);
    file_open(FILE_AUDIO_OUT, "audio_output.txt", write_mode);
	
	wait until SRESETN='1'; -- start generating input after reset is gone
	
	while not endfile(FILE_AUDIO_IN) loop
		readline(FILE_AUDIO_IN, ILINE);
		read(ILINE, AUDIO_IN_INT_L);
		read(ILINE, SPACE);
		read(ILINE, AUDIO_IN_INT_R);
		
		-- right channel (comes first after reset)
		AUDIO_IN_STD_R := std_logic_vector(to_signed(AUDIO_IN_INT_R,W));
		for I in AUDIO_IN_STD_R'range loop
			-- input path (model of audio codec)
			DIN <= AUDIO_IN_STD_R(I) after CDELAY;
			-- output path
			wait until rising_edge(BCK);   -- sample bit at rising edge
			AUDIO_OUT_STD_R(I) := DOUT; 				
			wait until falling_edge(BCK); -- output new bit at falling edge
		end loop;
		AUDIO_OUT_INT_R := to_integer(signed(AUDIO_OUT_STD_R));

		-- left channel 
		AUDIO_IN_STD_L := std_logic_vector(to_signed(AUDIO_IN_INT_L,W));
		for I in AUDIO_IN_STD_L'range loop
			-- input path (model of audio codec)
			DIN <= AUDIO_IN_STD_L(I) after CDELAY;
			-- output path
			wait until rising_edge(BCK);   -- sample bit at rising edge
			AUDIO_OUT_STD_L(I) := DOUT; 				
			wait until falling_edge(BCK);  -- output new bit at falling edge
		end loop;
		AUDIO_OUT_INT_L := to_integer(signed(AUDIO_OUT_STD_L));		

		-- compose output line
		write(OLINE,AUDIO_OUT_INT_L, right,6);
		write(OLINE,SPACE, right, 1);
		write(OLINE,AUDIO_OUT_INT_R, right,6);
        writeline(FILE_AUDIO_OUT, OLINE);
		
	end loop;

    file_close(FILE_AUDIO_IN);
    file_close(FILE_AUDIO_OUT);
    
    assert (false) report "Simulation finished successfully." severity failure;

  end process;

end BEHAVIORAL;

