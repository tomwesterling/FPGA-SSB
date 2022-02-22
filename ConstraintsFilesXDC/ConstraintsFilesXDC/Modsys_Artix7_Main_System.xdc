#############################################################
# CONSTRAINT FILE for MAIN MODSYS SYSTEM
#
# Instructions for use:
# This file contains 
# - pin assignments of CLK and RESET input
# - timing constraints for CLK and RESET
#
#   LTL, v1.0, 8.7.2020
#
#############################################################

#############################################################
# CLK and RESET related constraints
#############################################################

# CLK EXT1 (WITH SELECTOR: EXT1, INTERNAL, SINGLE EDGE)
 set_property PACKAGE_PIN N5 [get_ports              {CLK}]				
 set_property IOSTANDARD LVCMOS33 [get_ports         {CLK}]

## CLK EXT2

## RESET 
set_property PACKAGE_PIN P5 [get_ports          {SRESETN}]						
set_property IOSTANDARD LVCMOS33 [get_ports     {SRESETN}]	

## USER LED ON TRENTZ BOARD  	
# set_property PACKAGE_PIN M16 [get_ports          {SYSLED}]
# set_property IOSTANDARD LVCMOS33 [get_ports      {SYSLED}]

## TIMING CONSTRAINTS

# main FPGA clock 100 MHz
create_clock -period 10 [get_ports CLK]

# false path on reset path
set_false_path -from [get_ports SRESETN]

#############################################################
