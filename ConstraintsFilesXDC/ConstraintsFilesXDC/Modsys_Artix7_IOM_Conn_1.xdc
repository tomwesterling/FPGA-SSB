#############################################################
# CONSTRAINT FILE for IOM EXTENSION BOARD TO MODSYS SYSTEM
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
#   LTL, v1.2, 8.7.2020
#
#############################################################

#############################################################
# INPUTS OF IOM BOARD              CONNECTOR 1
#############################################################

##IN0: 
set_property PACKAGE_PIN D3  [get_ports       {SWITCH_VEC[0]}] 
set_property IOSTANDARD LVCMOS33 [get_ports   {SWITCH_VEC[0]}] 

##IN1:
set_property PACKAGE_PIN H1  [get_ports       {SWITCH_VEC[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports   {SWITCH_VEC[1]}]

##IN2:
# set_property PACKAGE_PIN G1  [get_ports       {IOM_IN[2]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports   {IOM_IN[2]}]

##IN3: 
# set_property PACKAGE_PIN F1  [get_ports       {IOM_IN[3]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports   {IOM_IN[3]}]

##IN4:
# set_property PACKAGE_PIN  E1   [get_ports     {IOM_IN[4]}]
# set_property IOSTANDARD LVCMOS33 [get_ports   {IOM_IN[4]}]

##IN5: 
# set_property PACKAGE_PIN C1  [get_ports       {IOM_IN[5]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports   {IOM_IN[5]}]

##IN6:
# set_property PACKAGE_PIN C2  [get_ports       {IOM_IN[6]}]
# set_property IOSTANDARD LVCMOS33 [get_ports   {IOM_IN[6]}]

##IN7: 
# set_property PACKAGE_PIN B1 [ get_ports       {IOM_IN[7]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports   {IOM_IN[7]}]

#IN8:
# set_property PACKAGE_PIN B3  [get_ports       {IOM_IN[8]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports   {IOM_IN[8]}]

##IN9:
# set_property PACKAGE_PIN A3  [get_ports       {IOM_IN[9]}]
# set_property IOSTANDARD LVCMOS33 [get_ports   {IOM_IN[9]}]


##############################################################
# OUTPUTS OF IOM BOARD             CONNECTOR 1
##############################################################

##OUT0:
# set_property PACKAGE_PIN D5  [get_ports      {IOM_OUT[0]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[0]}]

##OUT1: 
# set_property PACKAGE_PIN F5 [get_ports       {IOM_OUT[1]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[1]}]

##OUT2:
# set_property PACKAGE_PIN D8 [get_ports       {IOM_OUT[2]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[2]}]

##OUT3: 
# set_property PACKAGE_PIN C7  [get_ports      {IOM_OUT[3]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[3]}]

##OUT4:
# set_property PACKAGE_PIN C6 [get_ports       {IOM_OUT[4]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[4]}]

##OUT5: 
# set_property PACKAGE_PIN  C5  [get_ports     {IOM_OUT[5]}] 
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[5]}]

##OUT6:
# set_property PACKAGE_PIN  B4  [get_ports     {IOM_OUT[6]}]
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[6]}]

##OUT7:
# set_property PACKAGE_PIN  C4  [get_ports     {IOM_OUT[7]}]
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[7]}]

##OUT8:
# set_property PACKAGE_PIN  F6  [get_ports     {IOM_OUT[8]}]
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[8]}]

##OUT9:
# set_property PACKAGE_PIN  G6  [get_ports     {IOM_OUT[9]}]
# set_property IOSTANDARD LVCMOS33 [get_ports  {IOM_OUT[9]}]

### END OF XDC FILE ########################################
