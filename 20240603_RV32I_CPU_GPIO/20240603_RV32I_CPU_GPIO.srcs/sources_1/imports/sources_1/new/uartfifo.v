`timescale 1ns / 1ps
module uart_loop (
    input clk,
    input reset,

    input  RX,
    output TX

);
    wire [7:0] w_rx_data;
    wire w_rx_empty;

    uart_fifo U_uart_fifo (
        .clk  (clk),
        .reset(reset),

        .tx_en  (~w_rx_empty),
        .tx_data(w_rx_data),
        .tx_full(),

        .rx_en(~w_rx_empty),
        .rx_data(w_rx_data),
        .rx_empty(w_rx_empty),

        .RX(RX),
        .TX(TX)
    );


endmodule

module uart_fifo (
    input clk,
    input reset,

    input  [16:0] UART_CR,
    input  [4:0] UART_BRR,


    input tx_en,
    input [7:0] tx_data,
    output tx_full,

    input rx_en,
    output [7:0] rx_data,
    output rx_empty,

    input  RX,
    output TX
);

    wire w_tx_empty;
    wire [7:0] w_tx_data;
    wire w_tx_done;
    wire [7:0] w_rx_data;
    wire w_rx_done;
    assign tx_done = w_tx_done;

    FIFO #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(8)
    ) U_txfifo (
        .clk  (clk),
        .reset(reset),
        .wr_en(tx_en),
        .full (tx_full),
        .wdata(tx_data),
        .rd_en(w_tx_done),
        .empty(w_tx_empty),
        .rdata(w_tx_data)
    );


    FIFO #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(8)
    ) U_rxfifo (
        .clk  (clk),
        .reset(reset),
        .wr_en(w_rx_done),
        .full (),
        .wdata(w_rx_data),
        .rd_en(rx_en),
        .empty(rx_empty),
        .rdata(rx_data)
    );


    uart U_uart (
        .clk(clk),
        .reset(reset),
        .UE     (UART_CR[0]),
        .RE     (UART_CR[1]),
        .TE     (UART_CR[2]),
        .BRR    (UART_BRR[4:0]),
        .start(~w_tx_empty),
        .tx_data(w_tx_data),
        .tx(TX),
        .tx_done(w_tx_done),
        .rx(RX),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done)
    );

endmodule

