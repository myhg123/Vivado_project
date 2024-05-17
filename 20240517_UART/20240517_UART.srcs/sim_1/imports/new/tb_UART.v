`timescale 1ns / 1ps


module tb_UART ();

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    reg    RX;
    wire    rx_done;
    wire [7:0]    rx_data;
    wire tx;
    wire tx_done;

    uart dut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .RX(RX),
        .rx_done(rx_done),
        .rx_data(rx_data),
        .tx(tx),
        .tx_done(tx_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        tx_start = 1'b0;
        tx_data = 0;
        RX = 0;
    end

    initial begin
        #100 reset = 1'b0;
        #100 tx_data = 8'b10101011;
        tx_start = 1'b1;
        RX = 1'b0; //startbit
        #10 tx_start = 1'b0;
        #90 RX = 1'b1; //data0
        #100 RX = 1'b0; //data1 
        #100 RX = 1'b1;//data2
        #100 RX = 1'b0;  //data3
        #100 RX = 1'b1;//data4
        #100 RX = 1'b0;  //data5
        #100 RX = 1'b1;//data6
        #100 RX = 1'b0;  //data7
        #100 RX = 1'b1;  //stopbit
    end

endmodule
