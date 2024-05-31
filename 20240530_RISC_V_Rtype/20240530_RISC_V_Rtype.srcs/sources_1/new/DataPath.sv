`timescale 1ns / 1ps

module DataPath (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] machineCode,
    input  logic        regFileWe,
    input  logic [ 2:0] aluControl,
    output logic [31:0] dataMemRAddr,
    output logic [31:0] instrMemRAddr,
    input  logic [31:0] dataMemRData,
    input  logic        AluSrcMuxSel,
    input  logic        RFWriteDataSrcMuxSel
);
    logic [31:0] w_aluResult, w_RegFileRData1, w_RegFileRData2, w_PC_Data;
    logic [31:0] w_extendOut, w_AluSrcMuxOut, w_RFWriteDataSrcMuxOut;

    assign dataMemRAddr = w_aluResult;
    adder U_Adder_PC (
        .a(instrMemRAddr),
        .b(32'd4),
        .y(w_PC_Data)
    );
    Register U_PC (
        .clk  (clk),
        .reset(reset),
        .d    (w_PC_Data),
        .q    (instrMemRAddr)
    );

    RegisterFile U_RegisterFile (
        .clk   (clk),
        .we    (regFileWe),
        .RAddr1(machineCode[19:15]),
        .RAddr2(machineCode[24:20]),
        .WAddr (machineCode[11:7]),
        .WData (w_RFWriteDataSrcMuxOut),
        .RData1(w_RegFileRData1),
        .RData2(w_RegFileRData2)
    );


    mux_2x1 U_ALUSrcMux (
        .sel(AluSrcMuxSel),
        .a  (w_RegFileRData2),
        .b  (w_extendOut),
        .y  (w_AluSrcMuxOut)
    );


    ALU U_ALU (
        .a         (w_RegFileRData1),
        .b         (w_AluSrcMuxOut),
        .aluControl(aluControl),
        .result    (w_aluResult)
    );

    extend U_Extend (
        .instr (machineCode[31:7]),
        .immext(w_extendOut)
    );
    mux_2x1 U_RFWriteDataSrcMux (
        .sel(RFWriteDataSrcMuxSel),
        .a  (w_aluResult),
        .b  (dataMemRData),
        .y  (w_RFWriteDataSrcMuxOut)
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

module ALU (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [ 2:0] aluControl,
    output logic [31:0] result
);
    always_comb begin
        case (aluControl)
            3'b000:  result = a + b;
            3'b001:  result = a - b;
            3'b010:  result = a & b;
            3'b011:  result = a | b;
            default: result = 32'bx;
        endcase
    end
endmodule


module adder (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] y
);

    assign y = a + b;

endmodule

module extend (
    input  logic [31:7] instr,
    output logic [31:0] immext
);

    assign immext = {{20{instr[31]}}, instr[31:20]};

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
