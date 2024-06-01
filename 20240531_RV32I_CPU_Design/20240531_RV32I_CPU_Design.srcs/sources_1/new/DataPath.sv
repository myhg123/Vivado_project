`timescale 1ns / 1ps
`include "defines.sv"

module DataPath (
    input clk,
    input reset,
    input [31:0] machineCode,
    input [3:0] aluControl,
    input we,
    output [31:0] instrMemRAddr


);



endmodule

module RegisterFile (
    input  logic        clk,
    input  logic        we,
    input  logic [ 4:0] RAddr1,
    input  logic [ 4:0] RAddr2,
    input  logic [ 4:0] WAddr,
    input  logic [31:0] WData,
    output logic [31:0] RData1,
    output logic [31:0] RData2
);

    logic [31:0] RegFile[0:31];
    initial begin
        RegFile[0] = 32'd0;
        RegFile[1] = 32'd1;
        RegFile[2] = 32'd2;
        RegFile[3] = 32'd3;
        RegFile[4] = 32'd4;
        RegFile[5] = 32'd5;
    end
    always_ff @(posedge clk) begin
        if (we) RegFile[WAddr] <= WData;
    end

    assign RData1 = (RAddr1 != 0) ? RegFile[RAddr1] : 0;
    assign RData2 = (RAddr2 != 0) ? RegFile[RAddr2] : 0;

endmodule

module ALU (
    input  logic [ 3:0] aluControl,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] Result
);

    always_comb begin
        case (aluControl)
            `ADD: Result = a + b;
            `SUB: Result = a - b;
            `SLL: Result = a << b;
            `SRL: Result = a >> b;
            `SRA: Result = a >>> b;
            `SLT: Result = (a < b) ? 1 : 0;
            `SLTU: Result = (a < b) ? 1 : 0;
            `XOR: Result = a ^ b;
            `OR: Result = a | b;
            `AND: Result = a & b;
            default: Result = 31'bx;
        endcase
    end

endmodule

module Register (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] d,
    output logic [31:0] q
);

    always_ff @(posedge clk, posedge reset) begin
        if (reset) q <= 0;
        else q <= d;
    end

endmodule

module adder (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] y
);

    assign y = a + b;

endmodule

module mux_2x1 (
    input  logic        sel,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] y
);

    always_comb begin 
        case (sel)
            1'b0: y=a;
            1'b1: y=b;
            default: y= 32'bx;
        endcase
    end

endmodule

