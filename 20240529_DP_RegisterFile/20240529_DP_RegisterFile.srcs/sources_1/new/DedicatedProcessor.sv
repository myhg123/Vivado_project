`timescale 1ns / 1ps

module DedicatedProcessor(
    input clk,
    input reset,
    output [7:0] outPort
    );

    logic [1:0] raddr1, raddr2, waddr;
    logic RFSrcMuxSel, we, OutLoad, LE10;

controlUnit U_CU(
.*);

DataPath U_DP(
.*);

endmodule
