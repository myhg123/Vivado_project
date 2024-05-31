`timescale 1ns / 1ps


module tb_processor ();

    reg        clk;
    reg        reset;
    wire [7:0] out;
    wire [3:0] fndCom;
    wire [7:0] fndFont;

    DP dut (
        .clk(clk),
        .reset(reset),
        .out(out),
        .fndCom(fndCom),
        .fndFont(fndFont)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        #30 reset = 0;
    end


endmodule
