`timescale 1ns / 1ps


module tx_rx_loop (

    input  clk,
    input  reset,
    // transmitter
    output tx,
    //Receiver
    input  rx
);


    wire [7:0] w_rx_data;
    wire w_rx_done;

    uart U_uart (
        .clk(clk),
        .reset(reset),
        .start(w_rx_done),
        .tx_data(w_rx_data),
        .tx(tx),
        .tx_done(),
        .rx(rx),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done)
    );


endmodule
