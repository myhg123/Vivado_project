`timescale 1ns / 1ps

module RV32I (
    input logic clk,
    input logic reset
);

    logic [31:0] w_InstrMemAddr, w_InstrMemData, w_Addr, w_dataMemRData, w_WData;
    logic [2:0]  w_slave_sel;
    logic w_We;

    CPU_core U_CPU_core (
        .clk          (clk),
        .reset        (reset),
        .machineCode  (w_InstrMemData),
        .instrMemRAddr(w_InstrMemAddr),
        .dataMemWe    (w_We),
        .dataMemAddr  (w_Addr),
        .dataMemRData (w_dataMemRData),
        .dataMemWData ( w_WData)
    );

    Instruction_Memory U_instrROM (
        .addr(w_InstrMemAddr),
        .data(w_InstrMemData)
    );

    Data_RAM U_Data_RAM (
        .clk  (clk),
        .we   (w_We),
        .addr (w_Addr),
        .wdata( w_WData),
        .rdata(w_dataMemRData)
    );


endmodule
