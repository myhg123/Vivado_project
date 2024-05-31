`timescale 1ns / 1ps

module tb_uart_fifo ();

    reg        clk;
    reg        reset;

    reg        tx_en;
    reg  [7:0] tx_data;
    wire       tx_full;

    reg        rx_en;
    wire [7:0] rx_data;
    wire       rx_empty;

    reg        RX;
    wire       TX;

    wire w_rxtx_loop;

    uart_fifo dut (
        .clk  (clk),
        .reset(reset),

        .tx_en  (tx_en),
        .tx_data(tx_data),
        .tx_full(tx_full),

        .rx_en(rx_en),
        .rx_data(rx_data),
        .rx_empty(rx_empty),

        .RX(w_rxtx_loop),
        .TX(w_rxtx_loop)
    );

    always #5 clk= ~clk;

    initial begin
        clk=0;
        reset = 1'b1;
        tx_en = 1'b0;
        tx_data =0;
        rx_en=0;
        RX =0;
    end

    initial begin
        #80 reset =1'b0;
        #1000 tx_data = 8'b11001011; tx_en = 1'b1;
        @(posedge clk) tx_en = 1'b0;
        #1000 tx_data = "3"; tx_en = 1'b1;
        @(posedge clk) tx_en = 1'b0;
        #1000 tx_data = "9"; tx_en = 1'b1;
        @(posedge clk) tx_en = 1'b0;

    end

endmodule
