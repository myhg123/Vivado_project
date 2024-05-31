`timescale 1ns / 1ps

module RV32I (
    input logic clk,
    input logic reset
);

    logic [31:0] w_InstrMemAddr, w_InstrMemData, w_dataMemRAddr, w_dataMemRData;
    logic w_dataMemWe;

    CPUCore U_CPU_core (
        .clk(clk),
        .reset(reset),
        .machineCode(w_InstrMemData),
        .instrMemRAddr(w_InstrMemAddr),
        .dataMemWe(w_dataMemWe),
        .dataMemRAddr(w_dataMemRAddr),
        .dataMemRData(w_dataMemRData)


    );
    DataMemory U_RAM (
        .clk(clk),
        .we(w_dataMemWe),
        .addr(w_dataMemRAddr),
        .wdata(),
        .rdata(w_dataMemRData)
    );

    InstructionMemory U_ROM (
        .addr(w_InstrMemAddr),
        .data(w_InstrMemData)
    );



endmodule
