`timescale 1ns / 1ps


module Instruction_Memory (
    input  logic [31:0] addr,
    output logic [31:0] data
);

    logic [31:0] rom[0:63];

    initial begin
        rom[0] = 32'h00520333;  // add x6, x4, x5
        rom[1] = 32'h401183b3;  // sub x7, x3, x1
        rom[2] = 32'h0020f433;  // and x8, x1, x2 =>0
        rom[3] = 32'h0020e4b3;  // or x9, x1, x2 =>0
    end

    assign data = rom[addr[31:2]];

endmodule
