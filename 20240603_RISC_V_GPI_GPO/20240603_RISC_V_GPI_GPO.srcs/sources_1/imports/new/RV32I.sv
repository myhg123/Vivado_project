`timescale 1ns / 1ps

module RV32I (
    input logic clk,
    input logic reset
);

    logic [31:0] w_InstrMemAddr, w_InstrMemData, w_dataMemAddr, w_dataMemRData, w_dataMemWData;
    logic w_dataMemWe;

    CPU_core U_CPU_core (
        .clk          (clk),
        .reset        (reset),
        .machineCode  (w_InstrMemData),
        .instrMemRAddr(w_InstrMemAddr),
        .dataMemWe    (w_dataMemWe),
        .dataMemAddr  (w_dataMemAddr),
        .dataMemRData (w_dataMemRData),
        .dataMemWData (w_dataMemWData)
    );

    Instruction_Memory U_instrROM (
        .addr(w_InstrMemAddr),
        .data(w_InstrMemData)
    );

    Data_RAM U_Data_RAM (
        .clk  (clk),
        .we   (w_dataMemWe),
        .addr (w_dataMemAddr),
        .wdata(w_dataMemWData),
        .rdata(w_dataMemRData)
    );


endmodule
