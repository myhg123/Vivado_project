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

    reg  [31:0] Moder; 
    

endmodule
