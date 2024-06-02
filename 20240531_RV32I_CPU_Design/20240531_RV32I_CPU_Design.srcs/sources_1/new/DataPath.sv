`timescale 1ns / 1ps
`include "defines.sv"

module DataPath (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] machineCode,
    input  logic [ 3:0] aluControl,
    input  logic        regFileWe,
    input  logic [ 2:0] extType,
    input  logic        aluSrcMuxSel,
    input  logic [ 1:0] RFWDataMuxSel,
    input  logic [31:0] dataMemRData,
    input  logic        branch,
    output logic [31:0] instrMemRAddr,
    output logic [31:0] dataMemAddr,
    output logic [31:0] dataMemWData,
    input  logic        aluSrcPCMuxSel
);

    logic [31:0]
        w_aluResult,
        w_RFRData1,
        w_RFRData2,
        w_PC_Data,
        w_AluSrcMuxOut,
        w_extendOut,
        w_RFWriteDataSrcMuxOut,
        w_PCAdderSrcMuxOut,
        w_PCadder_WRFMuxOut,
        w_aluSrcPCMuxOut;
    logic w_btaken;
    assign dataMemAddr  = w_aluResult;
    assign dataMemWData = w_RFRData2;
    RegisterFile U_RegFile (
        .clk      (clk),
        .regFileWe(regFileWe),
        .RAddr1   (machineCode[19:15]),
        .RAddr2   (machineCode[24:20]),
        .WAddr    (machineCode[11:7]),
        .WData    (w_RFWriteDataSrcMuxOut),
        .RData1   (w_RFRData1),
        .RData2   (w_RFRData2)
    );

    mux_2x1 U_aluSrcMux (
        .sel(aluSrcMuxSel),
        .a  (w_RFRData2),
        .b  (w_extendOut),
        .y  (w_AluSrcMuxOut)
    );

    mux_2x1 U_aluSrcPCMux(
        .sel(aluSrcPCMuxSel),
        .a  (w_RFRData1),
        .b  (w_PC_Data),
        .y  (w_aluSrcPCMuxOut)
    );

    ALU U_ALU (
        .aluControl(aluControl),
        .a         (w_aluSrcPCMuxOut),
        .b         (w_AluSrcMuxOut),
        .Result    (w_aluResult),
        .btaken    (w_btaken)
    );

    mux_4x1 U_RFWDataSrcMux (
        .sel(RFWDataMuxSel),
        .a0 (w_aluResult),
        .a1 (dataMemRData),
        .a2 (w_extendOut),
        .a3 (),
        .y  (w_RFWriteDataSrcMuxOut)
    );

    extend U_Extend (
        .extType(extType),
        .instr  (machineCode[31:7]),
        .immext (w_extendOut)

    );

    Register U_PC (
        .clk  (clk),
        .reset(reset),
        .d    (w_PC_Data),
        .q    (instrMemRAddr)
    );

    mux_2x1 U_PCAdderSrcMux (
        .sel(branch & w_btaken),
        .a  (32'd4),
        .b  (w_extendOut),
        .y  (w_PCAdderSrcMuxOut)
    );
   adder U_PCadder_WRF (
        .a(w_extendOut),
        .b(instrMemRAddr),
        .y(w_PCadder_WRFMuxOut)
    );


    adder U_PC_adder (
        .a(w_PCAdderSrcMuxOut),
        .b(instrMemRAddr),
        .y(w_PC_Data)
    );

endmodule

module RegisterFile (
    input  logic        clk,
    input  logic        regFileWe,
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
        if (regFileWe) RegFile[WAddr] <= WData;
    end

    assign RData1 = (RAddr1 != 0) ? RegFile[RAddr1] : 0;
    assign RData2 = (RAddr2 != 0) ? RegFile[RAddr2] : 0;

endmodule

module ALU (
    input logic [3:0] aluControl,
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] Result,
    output logic btaken
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

    always_comb begin
        case (aluControl[2:0])
            `BEQ: btaken = (a == b);
            `BNE: btaken = (a != b);
            `BLT: btaken = (a < b);
            `BGE: btaken = (a >= b);
            `BLTU: btaken = (a < b);
            `BGEU: btaken = (a >= b);
            default: btaken = 1'bx;
        endcase
    end

endmodule

module extend (
    input  logic [ 2:0] extType,
    input  logic [31:7] instr,
    output logic [31:0] immext

);

    always_comb begin
        case (extType)
            `EXT_TYPE_R: immext = {{21{instr[31]}}, instr[30:20]};
            `EXT_TYPE_I: immext = {{27{instr[31]}}, instr[24:20]};
            `EXT_TYPE_S: immext = {{21{instr[31]}}, instr[30:25], instr[11:7]};
            `EXT_TYPE_B:
            immext = {
                {19{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0
            };
            `EXT_TYPE_U:
            immext = {instr[31], instr[30:20], instr[19:12], 12'd0};
            default: immext = 32'bx;
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
            1'b0: y = a;
            1'b1: y = b;
            default: y = 32'bx;
        endcase
    end

endmodule

module mux_4x1 (
    input  logic [ 1:0] sel,
    input  logic [31:0] a0,
    input  logic [31:0] a1,
    input  logic [31:0] a2,
    input  logic [31:0] a3,
    output logic [31:0] y
);
    always_comb begin
        case (sel)
            2'b00:  y = a0;
            2'b01:  y = a1;
            2'b10:  y = a2;
            2'b11:  y = a3;
            default: y = 32'bx;
        endcase
    end

endmodule
