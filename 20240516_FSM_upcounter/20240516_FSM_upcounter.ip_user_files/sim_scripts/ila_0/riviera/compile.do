vlib work
vlib riviera

vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../../20240516_FSM_upcounter.gen/sources_1/ip/ila_0/hdl/verilog" \
"/home/yonn/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/yonn/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"/home/yonn/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../20240516_FSM_upcounter.gen/sources_1/ip/ila_0/hdl/verilog" \
"../../../../20240516_FSM_upcounter.gen/sources_1/ip/ila_0/sim/ila_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

