`timescale 1ns / 1ps

module tb_RV32I();

    logic       clk;
    logic       reset;
    logic [3:0] outPortA;

    RV32I dut (
        .clk(clk),
        .reset(reset),
        .outPortA(outPortA)
    );

always #5 clk = ~clk;

initial begin
    clk =0;
    reset = 1'b1;
    #40 reset  = 1'b0;
end




endmodule
