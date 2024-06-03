`timescale 1ns / 1ps

module CPU_core (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] machineCode,
    output logic        dataMemWe,
    output logic [31:0] instrMemRAddr,
    output logic [31:0] dataMemAddr,
    input  logic [31:0] dataMemRData,
    output logic [31:0] dataMemWData
);

    logic [3:0] w_aluControl;
    logic [2:0] w_extType;
    logic w_regFileWe, w_aluSrcMuxSel, w_branch, w_aluSrcPCMuxSel,w_JalPCMuxSel;
    logic [1:0]  w_RFWDataSrcMuxSel;
    ControlUnit U_CU (
        .op           (machineCode[6:0]),
        .funct3       (machineCode[14:12]),
        .funct7       (machineCode[31:25]),
        .regFileWe    (w_regFileWe),
        .aluControl   (w_aluControl),
        .extType      (w_extType),
        .aluSrcMuxSel (w_aluSrcMuxSel),
        .RFWDataMuxSel(w_RFWDataSrcMuxSel),
        .dataMemWe    (dataMemWe),
        .branch       (w_branch),
        .aluSrcPCMuxSel(w_aluSrcPCMuxSel),
        .JalPCMuxSel(w_JalPCMuxSel)

    );


    DataPath U_DP (
        .clk          (clk),
        .reset        (reset),
        .machineCode  (machineCode),
        .aluControl   (w_aluControl),
        .regFileWe    (w_regFileWe),
        .instrMemRAddr(instrMemRAddr),
        .extType      (w_extType),
        .aluSrcMuxSel (w_aluSrcMuxSel),
        .RFWDataMuxSel(w_RFWDataSrcMuxSel),
        .dataMemRData (dataMemRData),
        .dataMemAddr  (dataMemAddr),
        .dataMemWData (dataMemWData),
        .branch       (w_branch),
        .aluSrcPCMuxSel(w_aluSrcPCMuxSel),

        .JalPCMuxSel(w_JalPCMuxSel)

    );

endmodule
