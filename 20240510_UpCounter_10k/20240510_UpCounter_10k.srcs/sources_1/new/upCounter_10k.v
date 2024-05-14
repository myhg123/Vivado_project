`timescale 1ns / 1ps

module upCounter_10k (
    input clk,
    input reset,
    output [3:0] fndCom,
    output [7:0] fndFont
);
    wire w_clk_10hz;
    wire [13:0] w_count_10k;
    fndController U_fndController (
        .clk(clk),
        .digit(w_count_10k),
        .fndFont(fndFont),
        .reset(reset),
        .fndCom(fndCom)
    );
    clkDiv #(
        .MAX_COUNT(10_000_000)
    ) U_ClkDiv_10Hz (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk_10hz)
    );


    counter #(
        .MAX_COUNT(10000)
    ) U_Counter_10k (
        .clk  (w_clk_10hz),
        .count(w_count_10k),
        .reset(reset)
    );

endmodule
