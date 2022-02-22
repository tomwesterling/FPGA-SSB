# compile project AUDIO_SYSTEM_TOP
#vlib work
#vcom -93 -work work AUDIO_SYSTEM_TOP_TB.vhd

# simulate AUDIO_SYSTEM_TOP
vopt +acc AUDIO_SYSTEM_TOP_TB -o AUDIO_SYSTEM_TOP_TB_OPT
vsim AUDIO_SYSTEM_TOP_TB_OPT
view wave
radix dec 

# display clocks
add wave -divider -height 32 CLOCKS
add wave -height 32 -radix default  sim:/audio_system_top_tb/CLK
#add wave -height 120 -radix default sim:/audio_system_top_tb/DUT/START_L
#add wave -height 120 -radix default sim:/audio_system_top_tb/DUT/START_R
add wave -height 32 -radix default  sim:/audio_system_top_tb/SRESETN
add wave -height 32 -radix default  sim:/audio_system_top_tb/DUT/SYSCLK
add wave -height 32 -radix default  sim:/audio_system_top_tb/BCK
# add wave -height 32 -radix default  sim:/audio_system_top_tb/DUT/SAMPLING_CLK

# display ADC path
add wave -divider -height 32 ADC_PATH
add wave -height 32 -radix default  sim:/audio_system_top_tb/DIN
add wave -height 32 -radix decimal  sim:/audio_system_top_tb/DUT/AUDIO_PAR_IN_L
add wave -height 32 -radix decimal  sim:/audio_system_top_tb/DUT/AUDIO_PAR_IN_R

add wave -height 32 -radix default sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_STEREO_TO_MONO_CONVERSION/MONO_SUM
#add wave -height 32 -radix default sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_DELAY_LINE/AUDIO_IN
#add wave -height 32 -radix default sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_DELAY_LINE/reg
#add wave -height 32 -radix default sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/AUDIO_DELAYED

#add wave -height 32 -radix default sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_HILBERT_FIRFILTER/acc

#add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_MULTIPLY_AND_ADD/SUM
add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/AUDIO_DELAYED

#add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_MULTIPLY_AND_ADD/DELAY_LINE
#add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_MULTIPLY_AND_ADD/FILTER_LINE
add wave -height 120 -radix default   sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/AUDIO_HILBERT

add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_MODULATION_SPECIFIC_LUT/COUNTER

add wave -height 120 -radix default sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/OUTPUT_SINE
add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/OUTPUT_COS

add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/MODULATED_OUT

#add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_MULTIPLY_AND_ADD/DELAY_LINE33
#add wave -height 120 -radix default  sim:/audio_system_top_tb/DUT/INST_AUDIO_PROCESSING/INST_MULTIPLY_AND_ADD/_LINE33

run 1000 ms