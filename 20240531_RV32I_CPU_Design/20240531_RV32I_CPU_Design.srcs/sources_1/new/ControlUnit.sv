`timescale 1ns / 1ps
`include "defines.sv"

module ControlUnit (
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       regFileWe,
    output logic [3:0] aluControl
);

    logic controls;
    assign regFileWe = controls;

    always_comb begin : main_decoder
        case (op)
            `OP_TYPE_R:  controls = 1'b1;
            `OP_TYPE_IL: controls = 1'b1;
            `OP_TYPE_I:  controls = 1'b1;
            `OP_TYPE_S:  controls = 1'b1;
            `OP_TYPE_B:  controls = 1'b1;
            `OP_TYPE_U:  controls = 1'b1;
            `OP_TYPE_UA: controls = 1'b1;
            `OP_TYPE_J:  controls = 1'b1;
            `OP_TYPE_JI: controls = 1'b1;
            default:     controls = 1'bx;
        endcase
    end

    always_comb begin : alu_control_signal
        case (op)
            `OP_TYPE_R:  aluControl = {funct7[5], funct3};
            `OP_TYPE_IL: aluControl = {1'b0, 3'b000};
            `OP_TYPE_I:  aluControl = {funct7[5], funct3};
            `OP_TYPE_S:  aluControl = {1'b0, 3'b000};
            `OP_TYPE_B:  aluControl = {1'b0, funct3};
        endcase
    end


endmodule
