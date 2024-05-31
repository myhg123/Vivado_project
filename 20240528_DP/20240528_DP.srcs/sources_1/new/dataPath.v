`timescale 1ns / 1ps

module dataPath (
    input clk,
    input reset,
    input ASrcMuxSel,
    input ALoad,
	input iSrcMuxSel,
	input iLoad,
    input outBufSel,
    output iLt10,
    output [7:0] out
);
    wire [7:0] w_A_adderResult, w_i_adderResult, w_A_muxOut, w_i_muxOut, w_AregOut, w_iregOut, w_out;
    mux_2x1 U_A_mux2x1 (
        .sel(ASrcMuxSel),
        .a  (8'd0),
        .b  (w_A_adderResult),
        .y  (w_A_muxOut)
    );

    mux_2x1 U_i_mux2x1 (
        .sel(iSrcMuxSel),
        .a  (8'd0),
        .b  (w_i_adderResult),
        .y  (w_i_muxOut)
    );
    register U_A_reg (
        .clk(clk),
        .reset(reset),
        .load(ALoad),
        .d(w_A_muxOut),
        .q(w_AregOut)
    );

    register U_i_reg (
        .clk(clk),
        .reset(reset),
        .load(iLoad),
        .d(w_i_muxOut),
        .q(w_iregOut)
    );
    comparator U_Comp (
        .a (w_iregOut),
        .b (8'd11),
        .lt(iLt10)
    );

    adder U_i_Adder (
        .a(w_iregOut),
        .b(8'd1),
        .y(w_i_adderResult)
    );

    adder U_A_Adder (
        .a(w_AregOut),
        .b(w_iregOut),
        .y(w_A_adderResult)
    );
    // outBuff U_outBuff (
    //     .en(outBufSel),
    //     .a (w_AregOut),
    //     .y (w_out)
    // );
register U_outRegister(
    .clk(clk),
    .reset(reset),
    .load(outBufSel),
    .d(w_AregOut),
    .q(out)
);


endmodule

module mux_2x1 (
    input            sel,
    input      [7:0] a,
    input      [7:0] b,
    output reg [7:0] y
);
    always @(*) begin
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
        endcase
    end
endmodule

module register (
    input        clk,
    input        reset,
    input        load,
    input  [7:0] d,
    output [7:0] q
);
    reg [7:0] d_reg, d_next;
    assign q = d_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) d_reg <= 0;
        else d_reg <= d_next;
    end
    always @(*) begin
        if (load) d_next = d;
        else d_next = d_reg;
    end

endmodule

module comparator (
    input [7:0] a,
    input [7:0] b,
    output lt
);

    assign lt = a < b;  // a가 b보다 작으면 1 아니면 0

endmodule

module adder (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] y
);
    assign y = a + b;
endmodule

module outBuff (
    input en,
    input [7:0] a,
    output [7:0] y
);

    assign y = en ? a : 8'dz;

endmodule
