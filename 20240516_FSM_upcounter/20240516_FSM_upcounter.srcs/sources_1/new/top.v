`timescale 1ns / 1ps

module top (
    input clk,
    input reset,
    input btn_run_stop,
    input btn_clear,
    output [3:0]    fndCom,
    output [7:0]    fndFont,
    output led0,
    output led1,
    output led2
);

    wire w_clk_10hz;
    wire [13:0] w_digit;
    wire w_btn_clear, w_btn_run_stop;
    wire w_run_stop, w_clear;
    clkDiv_Herz #(
        .HERZ(10)
    ) U_clkDiv_10hz (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk_10hz)
    );

    up_counter U_up_counter (
        .clk(clk),
        .reset(reset),
        .tick(w_clk_10hz),
        .run_stop(w_run_stop),
        .clear(w_clear),
        .count(w_digit)
    );
    fndController U_fndController (
        .clk(clk),
        .digit(w_digit),
        .fndFont(fndFont),
        .fndCom(fndCom)
    );
    controller_unit U_countroller_unit (
        .clk(clk),
        .reset(reset),
        .btn_run_stop(w_btn_run_stop),
        .btn_clear(w_btn_clear),
        .run_stop(w_run_stop),
        .clear(w_clear),
        .led0(led0),
        .led1(led1),
        .led2(led2)
    );

    button U_btn_Run_Stop (
        .clk(clk),
        .in (btn_run_stop),
        .out(w_btn_run_stop)
    );

    button U_btn_Clear (
        .clk(clk),
        .in (btn_clear),
        .out(w_btn_clear)
    );


ila_0 U_ILA(
	.clk(clk), // input wire clk
	.probe0(w_btn_run_stop), // input wire [0:0]  probe0  
	.probe1(w_btn_clear), // input wire [0:0]  probe1 
	.probe2(w_run_stop), // input wire [0:0]  probe2 
	.probe3(w_clear), // input wire [0:0]  probe3 
	.probe4(w_digit), // input wire [13:0]  probe4 
	.probe5(fndCom) // input wire [3:0]  probe5
);

endmodule

