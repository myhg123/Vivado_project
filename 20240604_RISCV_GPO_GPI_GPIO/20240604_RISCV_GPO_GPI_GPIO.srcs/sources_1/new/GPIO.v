`timescale 1ns / 1ps

module GPIO (
    input clk,
    input reset,
    input address,
    input moder,
    input cs,
    input we,
    input [31:0] wData,
    output [31:0] rData,
    inout [3:0] IOPort
);



    GPO U_GPO (
        .clk    (clk),
        .reset  (reset),
        .sel    (cs),
        .we     (we),
        .address(address),
        .wData  (wData),
        .rData  (rData),
        .outPort(IOPort)
    );


    GPI U_GPI (
        .clk   (clk),
        .addr  (address),
        .cs    (cs),
        .we    (we),
        .inPort(IOPort),
        .rdata (rData)
    );

endmodule
