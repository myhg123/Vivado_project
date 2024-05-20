#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Mon May 20 14:47:30 KST 2024
# SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto 1f57055b01e140daabb45eb8a7176822 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_uart_behav xil_defaultlib.tb_uart xil_defaultlib.glbl -log elaborate.log"
xelab -wto 1f57055b01e140daabb45eb8a7176822 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_uart_behav xil_defaultlib.tb_uart xil_defaultlib.glbl -log elaborate.log

