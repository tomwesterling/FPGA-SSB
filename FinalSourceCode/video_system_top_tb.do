# name of work directory
vlib work

# simulate AudioToVga_tb (entity name)
vsim VIDEO_SYSTEM_TOP_TB

# log all wave signals
log * -r

# open waveform viewer
view wave

## clock and reset
add wave -divider -height 32 Clock_and_Reset
add wave -radix default -height 32 sim:/video_system_top_tb/clk
add wave -radix default -height 32 sim:/video_system_top_tb/sresetn

## pixel stream module
#add wave -divider -height 32 PixelStream
#add wave -radix default -height 32 sim:/video_system_top_tb/dviDataEn
add wave -radix default -height 32 sim:/video_system_top_tb/vgaClk
add wave -radix default -height 32 sim:/video_system_top_tb/pixelRGBdata
add wave -radix default -height 32 sim:/video_system_top_tb/DUV_i/hSync
add wave -radix default -height 32 sim:/video_system_top_tb/DUV_i/vSync

# three frames
run 100000 ms