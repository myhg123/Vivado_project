`timescale 1ns / 1ps

module RV32I (
    input logic clk,
    input logic reset,
    output logic [3:0] outPortA
);

    logic [31:0]
        w_InstrMemAddr,
        w_InstrMemData,
        w_Addr,
        w_MasterRData,
        w_WData,
        w_dataMemRData,
        w_GpoRData;
    logic [2:0] w_slave_sel;
    logic w_We;

    CPU_core U_CPU_core (
        .clk          (clk),
        .reset        (reset),
        .machineCode  (w_InstrMemData),
        .instrMemRAddr(w_InstrMemAddr),
        .dataMemWe    (w_We),
        .dataMemAddr  (w_Addr),
        .dataMemRData (w_MasterRData),
        .dataMemWData (w_WData)
    );

    Instruction_Memory U_instrROM (
        .addr(w_InstrMemAddr),
        .data(w_InstrMemData)
    );

    Data_RAM U_Data_RAM (
        .clk  (clk),
        .ce   (w_slave_sel[0]),
        .we   (w_We),
        .addr (w_Addr[7:0]),
        .wdata( w_WData),
        .rdata(w_dataMemRData)
    );
    BUS_interconntor U_BUS_InterConn (
        .address     (w_Addr),
        .slave_sel   (w_slave_sel),
        .slave_rdata1(w_dataMemRData),
        .slave_rdata2(w_GpoRData),
        .slave_rdata3(),
        .master_rdata(w_MasterRData)
    );
    GPO U_GPO (
        .clk    (clk),
        .reset  (reset),
        .ce     (w_slave_sel[1]),
        .we     (w_We),
        .addr   (w_Addr[1:0]),
        .wdata  (w_WData),
        .rdata  (w_GpoRData),
        .outPort(outPortA)
    );


endmodule
