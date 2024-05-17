`timescale 1ns / 1ps


module tb_UART ();

    reg clk;
    reg reset;
    reg start;
    reg [7:0] tx_data;
    wire txd;
    wire tx_done;

    uart dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .tx_data(tx_data),
        .txd(txd),
        .tx_done(tx_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        tx_data = 0;
    end

    initial begin
        #100 reset = 1'b0;
        #100 tx_data = 8'b11001111;
        start = 1'b1;
        #10 start = 1'b0;
    end

endmodule
