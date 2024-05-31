`timescale 1ns / 1ps


module CPUCore (
    input clk,
    input reset,
    input [31:0] machineCode,
    output [31:0] instrMemRAddr,
    output logic dataMemWe,
    output logic [31:0] dataMemRAddr,
    input logic [31:0] dataMemRData

);

    logic [2:0] w_aluControl;
    logic w_regFileWe, w_AluSrcMuxSel, w_RFWriteDataSrcMuxSel;
    
    ControlUnit U_CU (
        .op(machineCode[6:0]),
        .funct3(machineCode[14:12]),
        .funct7(machineCode[31:25]),
        .regFileWe(w_regFileWe),
        .aluControl(w_aluControl),
        .AluSrcMuxSel(w_AluSrcMuxSel),
        .RFWriteDataSrcMuxSel(w_RFWriteDataSrcMuxSel),
        .dataMemWe(dataMemWe)

    );

    DataPath U_DP (
        .clk(clk),
        .reset(reset),
        .machineCode(machineCode),
        .regFileWe(w_regFileWe),
        .aluControl(w_aluControl),
        .dataMemRAddr(dataMemRAddr),
        .instrMemRAddr(instrMemRAddr),
        .dataMemRData(dataMemRData),
        .AluSrcMuxSel(w_AluSrcMuxSel),
        .RFWriteDataSrcMuxSel(w_RFWriteDataSrcMuxSel)
    );
endmodule
