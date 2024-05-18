`timescale 1ns / 1ps


module tb_UART ();

    reg clk;
    reg reset;
    reg rxd;
    wire txd;
echoProgram dut(
    .clk(clk),
    .reset(reset),
    .rxd(rxd),
    .txd(txd)
);


    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        rxd = 1'b1;
    end

    initial begin
        #200 reset =0;
        #100 rxd = 1'b0;//start
        #100 rxd = 1'b1;
        #100 rxd = 1'b0;
        #100 rxd = 1'b0;
        #100 rxd = 1'b0;
        #100 rxd = 1'b0;
        #100 rxd = 1'b0;
        #100 rxd = 1'b1;
        #100 rxd = 1'b0;
        #100 rxd = 1'b1;//stop
    end

endmodule
