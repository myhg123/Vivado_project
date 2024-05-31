`timescale 1ns / 1ps


module DedicatedProcessor (
    input clk,
    input reset,
    output [7:0] outPort
);

    logic [1:0] ALU_OP;
    logic [2:0] raddr1, raddr2, waddr;
    logic RFSrcMuxSel, we, OutLoad;
    controlUnit U_controlUnit (.*);

    DataPath U_DataPath (.*);

endmodule
