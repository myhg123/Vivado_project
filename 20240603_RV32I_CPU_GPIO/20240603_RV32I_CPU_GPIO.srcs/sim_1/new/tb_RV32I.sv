`timescale 1ns / 1ps

module tb_RV32I ();

    logic        clk;
    logic        reset;
    tri   [15:0] IOPortA;
    // tri [15:0] IOPortB;
    tri   [15:0] IOPortC;
    // tri [15:0] IOPortD;
    // tri [15:0] IOPortE;
    // tri [15:0] IOPortH;
    logic       UART_RX1;
    logic       UART_TX1;
    logic [15:0] ioC;

    assign IOPortC = ioC;

    RV32I dut (
        .clk(clk),
        .reset(reset),
        .IOPortA(IOPortA),
        // .IOPortB(),
        .IOPortC(IOPortC),
        // .IOPortD(),
        // .IOPortE(),
        // .IOPortH()
        .UART_RX1(UART_RX1),
        .UART_TX1(UART_TX1)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1'b1;
        UART_RX1 = 1;
        #40 reset = 1'b0;
        #2000 UART_RX1 = 0;
        #640  UART_RX1 = 1;
        #640  UART_RX1 = 0;
		#640  UART_RX1 = 0;
        #640  UART_RX1 = 0;
        #640  UART_RX1 = 0;
        #640  UART_RX1 = 0;
        #640  UART_RX1 = 1;
        #640  UART_RX1 = 1;
    end




endmodule
