`timescale 1ns / 1ps
module uart_test (
    input  clk,
    input  reset,
    input  btn_start,
    output txd
);
    wire w_btn_start;

    button U_btn_start (
        .clk(clk),
        .in (btn_start),
        .out(w_btn_start)
    );


    uart U_uart_TX (
        .clk(clk),
        .reset(reset),
        .start(w_btn_start),
        .tx_data(8'h41),
        .txd(txd),  //'A'
        .tx_done()
    );

endmodule
