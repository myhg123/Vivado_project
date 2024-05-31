`timescale 1ns / 1ps


module DataPath (
    input              clk,
    input              reset,
    input              RFSrcMuxSel,
    input        [1:0] ALU_OP,
    input        [2:0] raddr1,
    input        [2:0] raddr2,
    input        [2:0] waddr,
    input              we,
    input              OutLoad,
    output logic [7:0] outPort

);
    logic [7:0] w_RFSrcMuxOut, w_rdata1, w_rdata2, w_AdderResult;

    mux_2x1 U_RFSrcMux (
        .sel(RFSrcMuxSel),
        .a  (w_AdderResult),
        .b  (8'd1),
        .y  (w_RFSrcMuxOut)
    );

    RegisterFile U_RF (
        .clk   (clk),
        .we    (we),
        .waddr (waddr),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .wdata (w_RFSrcMuxOut),
        .rdata1(w_rdata1),
        .rdata2(w_rdata2)
    );
    ALU U_ALU (
        .ALU_OP(ALU_OP),
        .a     (w_rdata1),
        .b     (w_rdata2),
        .y     (w_AdderResult)
    );

    register U_outReg (
        .clk  (clk),
        .reset(reset),
        .load (OutLoad),
        .d    (w_rdata1),
        .q    (outPort)
    );

endmodule

module ALU (
    input  [1:0] ALU_OP,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] y
);

    logic [7:0] w_add, w_sub, w_and, w_or;

    adder U_adder (
        .a(a),
        .b(b),
        .y(w_add)
    );

    subStructure U_sub (
        .a(a),
        .b(b),
        .y(w_sub)
    );


    andModule U_andM (
        .a(a),
        .b(b),
        .y(w_and)
    );

    orModule U_orM (
        .a(a),
        .b(b),
        .y(w_or)
    );
    mux_4x1 U_Mux_4x1 (
        .sel(ALU_OP),
        .a0 (w_add),
        .a1 (w_sub),
        .a2 (w_and),
        .a3 (w_or),
        .y  (y)
    );


endmodule

module RegisterFile (
    input        clk,
    input        we,
    input  [2:0] waddr,
    input  [2:0] raddr1,
    input  [2:0] raddr2,
    input  [7:0] wdata,
    output [7:0] rdata1,
    output [7:0] rdata2
);

    logic [7:0] regFile[0:7];

    always_ff @(posedge clk) begin
        if (we) regFile[waddr] <= wdata;
    end

    assign rdata1 = (raddr1 != 0) ? regFile[raddr1] : 0;
    assign rdata2 = (raddr2 != 0) ? regFile[raddr2] : 0;

endmodule

module mux_4x1 (
    input [1:0] sel,
    input [7:0] a0,
    input [7:0] a1,
    input [7:0] a2,
    input [7:0] a3,
    output reg [7:0] y
);

    always_comb begin
        case (sel)
            2'b00:   y = a0;
            2'b01:   y = a1;
            2'b10:   y = a2;
            2'b11:   y = a3;
            default: y = a0;
        endcase


    end

endmodule

module mux_2x1 (
    input              sel,
    input        [7:0] a,
    input        [7:0] b,
    output logic [7:0] y
);

    always_comb begin : mux_2x1

        case (sel)
            1'b0: y = a;
            1'b1: y = b;
        endcase
    end

endmodule


module register (
    input              clk,
    input              reset,
    input              load,
    input        [7:0] d,
    output logic [7:0] q
);

    always_ff @(posedge clk, posedge reset) begin : register
        if (reset) begin
            q <= 0;
        end else begin
            if (load) q <= d;
        end
    end
endmodule

module adder (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] y
);

    assign y = a + b;

endmodule

module subStructure (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] y
);

    assign y = a - b;

endmodule

module andModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] y
);
    assign y = a & b;
endmodule

module orModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] y

);
    assign y = a | b;
endmodule
