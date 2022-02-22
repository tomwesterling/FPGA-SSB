############################################################
# CONSTRAINT FILE for VIDEO ENCODER BOARD TO MODSYS SYSTEM
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
#   LTL, v1.1, 8.7.2020
#
############################################################

############################################################
# OUTPUTS OF VIDEO ENCODER BOARD                CONNECTOR 4
############################################################
#pixelRGBData[0] 
 set_property PACKAGE_PIN T4   [get_ports     {pixelRGBData[0]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[0]}] 

#pixelRGBData[1] 
 set_property PACKAGE_PIN T5   [get_ports     {pixelRGBData[1]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[1]}] 

#pixelRGBData[2] 
 set_property PACKAGE_PIN U3   [get_ports     {pixelRGBData[2]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[2]}] 

#pixelRGBData[3] 
 set_property PACKAGE_PIN U4   [get_ports     {pixelRGBData[3]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[3]}] 

#pixelRGBData[4] 
 set_property PACKAGE_PIN V6   [get_ports     {pixelRGBData[4]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[4]}] 

#pixelRGBData[5] 
 set_property PACKAGE_PIN V7   [get_ports     {pixelRGBData[5]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[5]}] 

#pixelRGBData[6] 
 set_property PACKAGE_PIN P2   [get_ports     {pixelRGBData[6]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[6]}] 

#pixelRGBData[7] 
 set_property PACKAGE_PIN R2   [get_ports     {pixelRGBData[7]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[7]}] 

#pixelRGBData[8] 
 set_property PACKAGE_PIN U7   [get_ports     {pixelRGBData[8]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[8]}] 

#pixelRGBData[9] 
 set_property PACKAGE_PIN R3   [get_ports     {pixelRGBData[9]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports  {pixelRGBData[9]}] 

#pixelRGBData[10] 
 set_property PACKAGE_PIN T3   [get_ports    {pixelRGBData[10]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[10]}] 

#pixelRGBData[11]
 set_property PACKAGE_PIN M4   [get_ports    {pixelRGBData[11]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[11]}] 

#pixelRGBData[12]
 set_property PACKAGE_PIN N4   [get_ports    {pixelRGBData[12]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[12]}] 

#pixelRGBData[13]
 set_property PACKAGE_PIN R6   [get_ports    {pixelRGBData[13]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[13]}] 

#pixelRGBData[14] 
 set_property PACKAGE_PIN R5   [get_ports    {pixelRGBData[14]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[14]}] 

#pixelRGBData[15] 
 set_property PACKAGE_PIN R7   [get_ports    {pixelRGBData[15]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[15]}] 

#pixelRGBData[16]
 set_property PACKAGE_PIN U9   [get_ports    {pixelRGBData[16]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[16]}] 

#pixelRGBData[17]
 set_property PACKAGE_PIN V5   [get_ports    {pixelRGBData[17]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[17]}] 

#pixelRGBData[18]
 set_property PACKAGE_PIN V4   [get_ports    {pixelRGBData[18]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[18]}] 

#pixelRGBData[19]
 set_property PACKAGE_PIN L4   [get_ports    {pixelRGBData[19]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[19]}] 

#pixelRGBData[20]
 set_property PACKAGE_PIN K5   [get_ports    {pixelRGBData[20]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[20]}] 

#pixelRGBData[21]
 set_property PACKAGE_PIN N6   [get_ports    {pixelRGBData[21]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[21]}] 

#pixelRGBData[22]
 set_property PACKAGE_PIN M6   [get_ports    {pixelRGBData[22]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[22]}] 

#pixelRGBData[23]
 set_property PACKAGE_PIN T8   [get_ports    {pixelRGBData[23]}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {pixelRGBData[23]}] 


#dviClk 
 set_property PACKAGE_PIN L5   [get_ports        {dviClk}] 
 set_property IOSTANDARD LVCMOS33 [get_ports     {dviClk}] 

#dviDataEn
 set_property PACKAGE_PIN E18  [get_ports    {dviDataEn}] 
 set_property IOSTANDARD LVCMOS33 [get_ports {dviDataEn}]

#hSync
 set_property PACKAGE_PIN D18 [get_ports           {hSync}] 
 set_property IOSTANDARD LVCMOS33 [get_ports       {hSync}]

#vSync
 set_property PACKAGE_PIN J18  [get_ports          {vSync}] 
 set_property IOSTANDARD LVCMOS33 [get_ports       {vSync}]

#vgaClk
 set_property PACKAGE_PIN J17 [get_ports         {vgaClk}] 
 set_property IOSTANDARD LVCMOS33 [get_ports     {vgaClk}]

#vgaNSync
 set_property PACKAGE_PIN F13 [get_ports        {vgaNSync}] 
 set_property IOSTANDARD LVCMOS33 [get_ports    {vgaNSync}]

#vgaNBlank
 set_property PACKAGE_PIN F14 [get_ports       {vgaNBlanc}] 
 set_property IOSTANDARD LVCMOS33 [get_ports   {vgaNBlanc}]

### END OF XDC FILE ########################################

