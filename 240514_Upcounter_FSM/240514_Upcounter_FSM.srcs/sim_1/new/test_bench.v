`timescale 1ns / 1ps

module test_bench();

reg clk;
reg btn1;
reg btn2;
wire en;
wire reset;

always #3 clk =~clk;
 

stopWatch_FSM U_stopWatch_FSM(
    .clk(clk),
    .btn1(btn1),
    .btn2(btn1),
    .timerReset(reset),
    .en(en)
);

    initial begin
        clk = 0;
        btn1 = 0;
        btn2 = 0;
        #10 btn1 =1'b1;
        #5 btn1 =  1'b0;
        #50 btn1 =1'b1;
        #5 btn1 =  1'b0;
        #30 btn2 = 1'b1;
        #5 btn2 = 1'b0;
    end

    


endmodule
