#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/yonn/Xilinx/Vivado/2020.2/ids_lite/ISE/bin/lin64:/home/yonn/Xilinx/Vivado/2020.2/bin
else
  PATH=/home/yonn/Xilinx/Vivado/2020.2/ids_lite/ISE/bin/lin64:/home/yonn/Xilinx/Vivado/2020.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/yonn/vivado_project/20240517_UART/20240517_UART.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
<<<<<<< HEAD
/bin/touch .write_bitstream.begin.rst
=======
/bin/touch .init_design.begin.rst
>>>>>>> 31010376d39b32aadad9f9e19a18ab00f82e6334
EAStep vivado -log top.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source top.tcl -notrace


