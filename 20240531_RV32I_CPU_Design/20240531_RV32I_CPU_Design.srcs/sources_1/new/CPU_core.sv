`timescale 1ns / 1ps

module CPU_core (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] machineCode,
    output logic [31:0] instrMemRAddr
);

    logic [3:0] w_aluControl;
    logic w_regFileWe;
    ControlUnit U_CU (
        .op        (machineCode[6:0]),
        .funct3    (machineCode[14:12]),
        .funct7    (machineCode[31:25]),
        .regFileWe (w_regFileWe),
        .aluControl(w_aluControl)
    );


    DataPath U_DP (
        .clk          (clk),
        .reset        (reset),
        .machineCode  (machineCode),
        .aluControl   (w_aluControl),
        .regFileWe    (w_regFileWe),
        .instrMemRAddr(instrMemRAddr)
    );

endmodule
