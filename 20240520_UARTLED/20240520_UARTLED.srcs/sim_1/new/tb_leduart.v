`timescale 1ns / 1ps
module tb_leduart();


    reg clk;
    reg reset;
    reg rx;
    reg rx_done;
    wire led1;
    wire led2;
    wire led3;


uartWithLED dut(
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .rx_done(rx_done),
    . led1(led1),
    . led2(led2),
    . led3(led3)
);

    initial begin
        clk = 0;
        reset = 1;
    end


endmodule
