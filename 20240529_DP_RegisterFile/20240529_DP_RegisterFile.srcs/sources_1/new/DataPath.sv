`timescale 1ns / 1ps

module DataPath (
    input        clk,
    input        reset,
    input        RFSrcMuxSel,
    input  [1:0] raddr1,
    input  [1:0] raddr2,
    input  [1:0] waddr,
    input        we,
    input        OutLoad,
    output logic      LE10,
    output logic [7:0] outPort
);

    logic [7:0] w_AdderResult, w_RFSrcMuxOut, w_rdata1, w_rdata2;

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
    adder U_adder (
        .a(w_rdata1),
        .b(w_rdata2),
        .y(w_AdderResult)
    );
    comparator U_Comp (
        .a (w_rdata1),
        .b (8'd10),
        .le(LE10)
    );
    register U_outReg (
        .clk  (clk),
        .reset(reset),
        .load (OutLoad),
        .d    (w_rdata1),
        .q    (outPort)
    );

endmodule

module RegisterFile (
    input        clk,
    input        we,
    input  [1:0] waddr,
    input  [1:0] raddr1,
    input  [1:0] raddr2,
    input  [7:0] wdata,
    output [7:0] rdata1,
    output [7:0] rdata2
);

    logic [7:0] regFile[0:3];

    always_ff @(posedge clk) begin
        if (we) regFile[waddr] <= wdata;
    end

    assign rdata1 = (raddr1 != 0) ? regFile[raddr1] : 0;
    assign rdata2 = (raddr2 != 0) ? regFile[raddr2] : 0;

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

module comparator (
    input [7:0] a,
    input [7:0] b,
    output le
);

    assign le = (a <= b);


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
