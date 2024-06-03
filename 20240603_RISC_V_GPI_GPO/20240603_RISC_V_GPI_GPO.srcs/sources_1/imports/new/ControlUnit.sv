`timescale 1ns / 1ps
`include "defines.sv"

module ControlUnit (
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       regFileWe,
    output logic [3:0] aluControl,
    output logic       dataMemWe,
    output logic [ 2:0] extType,
    output logic        aluSrcMuxSel,
    output logic [ 1:0] RFWDataMuxSel,
    output logic        branch,
    output logic        aluSrcPCMuxSel

);

    logic [9:0] controls;
    assign {regFileWe, aluSrcMuxSel, RFWDataMuxSel,dataMemWe, extType, branch,aluSrcPCMuxSel} = controls;

    always_comb begin : main_decoder
        case (op)
            `OP_TYPE_R:  controls = 10'b1_0_00_0_xxx_0_0;
            `OP_TYPE_IL: controls = 10'b1_0_01_0_000_0_0;
            `OP_TYPE_I:  begin if(funct7[5])controls = 10'b1_1_00_0_001_0_0;
                else controls = 10'b1_1_00_0_000_0_0;
            end
            `OP_TYPE_S:  controls = 10'b0_1_xx_1_010_0_0;
            `OP_TYPE_B:  controls = 10'b0_0_xx_0_011_1_0;
            `OP_TYPE_U:  controls = 10'b1_x_10_0_100_0_x;
            `OP_TYPE_UA: controls = 10'b1_1_00_0_100_0_1;
            `OP_TYPE_J:  controls = 10'b1___;
            `OP_TYPE_JI: controls = 10'b1___;
            default:     controls = 10'bx;
        endcase
    end

    always_comb begin : alu_control_signal
        case (op)
            `OP_TYPE_R:  aluControl = {funct7[5], funct3};
            `OP_TYPE_IL: aluControl = {1'b0, 3'b000};
            `OP_TYPE_I:  aluControl = {funct7[5], funct3};
            `OP_TYPE_S:  aluControl = {1'b0, 3'b000};
            `OP_TYPE_B:  aluControl = {1'b0, funct3};
            `OP_TYPE_U:  aluControl = {1'b0, 3'b000};
            `OP_TYPE_UA: aluControl = {1'b0, 3'b000};
        endcase
    end


endmodule
