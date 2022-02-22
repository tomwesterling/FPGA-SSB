############################################################
# CONSTRAINT FILE for AUDIO CODEC BOARD TO MODSYS SYSTEM
#
# Instructions for use:
# - for every IO pin there are two lines of code and a label
# - one line sets the IO voltage, the other the assignment
#     between VHDL signal name and FPGA pin name 
# - uncomment only the lines with the extension board IO 
#     in use
# - insert the current VHDL signal name in curly brackets
# - bit_vector resp. std_logic_vector are assigned component
#     by component which are index with square brackets
#     e.g. data[3]
# 
#
#   LTL, v1.1, 8.7.2020
#
############################################################

############################################################
# INPUTS OF AUDIO CODEC BOARD      CONNECTOR 3
############################################################

#DIN 
 set_property PACKAGE_PIN A11  [get_ports            {DIN}] 
 set_property IOSTANDARD LVCMOS33 [get_ports         {DIN}] 

############################################################
# OUTPUTS OF AUDIO CODEC BOARD     CONNECTOR 3
############################################################

#DOUT:
 set_property PACKAGE_PIN K15  [get_ports           {DOUT}] 
 set_property IOSTANDARD LVCMOS33 [get_ports        {DOUT}]

#SYSCLK: 
 set_property PACKAGE_PIN C12 [get_ports          {SYSCLK}] 
 set_property IOSTANDARD LVCMOS33 [get_ports      {SYSCLK}]

#BCK: 
 set_property PACKAGE_PIN D14  [get_ports            {BCK}] 
 set_property IOSTANDARD LVCMOS33 [get_ports         {BCK}]

#LRC:
 set_property PACKAGE_PIN B14 [get_ports             {LRC}] 
 set_property IOSTANDARD LVCMOS33 [get_ports         {LRC}]

### END OF XDC FILE ########################################
