`timescale 1ns / 1ps
module top (
    input  clk,
    input  reset,
    input  rxd,
    output txd
);

    echoProgram U_echoProgram (
        .clk  (clk),
        .reset(reset),
        .rxd  (rxd),
        .txd  (txd)
    );

endmodule


module echoProgram (
    input  clk,
    input  reset,
    input  rxd,
    output txd
);
    wire w_rx_done;
    wire [7:0] w_rx_data;
    wire w_tx_done;

    uart_RX U_UART_RX (
        .clk(clk),
        .reset(reset),
        .RX(rxd),

        .rx_data(w_rx_data),
        .rx_done(w_rx_done)
    );
    uart_TX U_UART_TX (
        .clk(clk),
        .reset(reset),
        .tx_start(w_rx_done),
        .tx_data( w_rx_data),

        .tx(txd),
        .tx_done(w_tx_done)
    );


endmodule
