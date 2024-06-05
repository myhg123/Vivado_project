`timescale 1ns / 1ps

module tb_RV32I ();

    logic        clk;
    logic        reset;
    wire [15:0] IOPortA;
    // wire [15:0] IOPortB;
    wire [15:0] IOPortC;
    // wire [15:0] IOPortD;
    // wire [15:0] IOPortE;
    // wire [15:0] IOPortH;

    logic [15:0] ioC;

    assign IOPortC = ioC;

    RV32I dut (
        .clk(clk),
        .reset(reset),
        .IOPortA(IOPortA),
        // .IOPortB(IOPortB),
        .IOPortC(IOPortC)
        // .IOPortD(IOPortD),
        // .IOPortE(IOPortE),
        // .IOPortH(IOPortH)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1'b1;
        #40 reset = 1'b0;
        #2000 ioC = 16'b1111000011110000;
        #2000 ioC = 16'b0000000011111111;
        #2000 ioC = 16'b1111000011111111;
    end




endmodule
