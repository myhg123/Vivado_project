#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Tue Jun 04 10:22:57 KST 2024
# SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto fd49bfdbebea4932be48269f09a8d42e --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot RV32I_MCU_behav xil_defaultlib.RV32I_MCU xil_defaultlib.glbl -log elaborate.log"
xelab -wto fd49bfdbebea4932be48269f09a8d42e --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot RV32I_MCU_behav xil_defaultlib.RV32I_MCU xil_defaultlib.glbl -log elaborate.log

