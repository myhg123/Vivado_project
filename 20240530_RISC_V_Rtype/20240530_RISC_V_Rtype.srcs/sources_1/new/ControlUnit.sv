`timescale 1ns / 1ps

module ControlUnit (
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       regFileWe,
    output logic [2:0] aluControl,
    output logic       AluSrcMuxSel,
    output logic       RFWriteDataSrcMuxSel,
    output logic       dataMemWe

);

    logic [5:0] controls;
    logic [1:0] w_AluOp;
    assign {regFileWe, AluSrcMuxSel, RFWriteDataSrcMuxSel, dataMemWe, w_AluOp} = controls;

    always_comb begin
        //regFileWe, AluSrcMuxSel, RFWriteDataSrcMuxSel, dataMemWe
        case (op)
            7'b0110011: controls = 6'b100010;  //R_type
            7'b0000011: controls = 6'b111000;  //ILtype
            7'b0010011: controls = 6'b0   ;  //I_type
            7'b0100011: controls = 6'b0   ;   //S_type
            7'b1100011: controls = 6'b0   ;   //B_type
            7'b0110111: controls = 6'b0   ;   //LUI_type
            7'b0010111: controls = 6'b0   ;   //AUIPC_type
            7'b1101111: controls = 6'b0   ;   //J_type
            7'b1100111: controls = 6'b0   ;   //JI_type
            default: controls = 6'bx;
        endcase
    end

    always_comb begin
        case (w_AluOp)
            2'b00: aluControl = 3'b000;  //add
            2'b01: aluControl = 3'b001;  //sub
            default: begin
                case (funct3)
                    3'b000: begin
                        if (funct7[5] & op[5]) aluControl = 3'b001;  //sub 
                        else aluControl = 3'b000;
                    end
                    3'b010:  aluControl = 3'b001;  //slt
                    3'b110:  aluControl = 3'b011;  //or
                    3'b111:  aluControl = 3'b010;  //and
                    default: aluControl = 3'bx;
                endcase
            end
        endcase
    end


endmodule
