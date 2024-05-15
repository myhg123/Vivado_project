`timescale 1ns / 1ps

module stopWatch_module (
    input clk,
    input reset,
    input btn1,
    input btn2,
    output [3:0]    fndCom,
    output [7:0]    fndFont
);
    wire w_timerReset, w_en, w_tick;
    wire [$clog2(10000):0] w_count;
    stopWatch_FSM U_stopWatch_FSM (
        .clk(clk),
        .btn1(btn1),
        .btn2(btn2),
        .timerReset(w_timerReset),
        .en(w_en)
    );

    clkDiv_Herz U_clkDiv_Herz (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_tick)
    );


    Upcounter_EN U_upcounter_EN (
        .clk    (clk),
        .reset  (w_timerReset),
        .tick   (w_tick),
        .en     (w_en),
        .counter(w_count)
    );

    fndController U_fndController (
        .clk(clk),
        .digit(w_count),
        .fndFont(fndFont),
        .fndCom(fndCom)
    );


endmodule

module stopWatch_FSM (
    input clk,
    input btn1,
    input btn2,
    output reg timerReset,
    output reg en
);
    parameter STOP = 2'd0, RUN = 2'd1, RESET = 2'd2;

    reg [1:0] state = STOP, next_State;

    wire w_btn1, w_btn2;
    //button driver
    button U_button1 (
        .clk(clk),
        .in (btn1),
        .out(w_btn1)
    );

    button U_button2 (
        .clk(clk),
        .in (btn2),
        .out(w_btn2)
    );

    //current state
    always @(posedge clk) begin
        state <= next_State;
    end

    //next state
    always @(state, w_btn1, w_btn2) begin
        next_State = state;
        case (state)
            STOP: begin
                if (w_btn1 == 1'b1) next_State = RUN;
                if (w_btn2 == 1'b1) next_State = RESET;
            end
            RUN: begin
                if (w_btn1 == 1'b1) next_State = STOP;
            end
            RESET: next_State = STOP;
        endcase
    end

    //output
    always @(state) begin
        en = 1'b0;
        case (state)
            STOP: begin
                en = 1'b0;
                timerReset = 1'b0;
            end
            RUN:   en = 1'b1;
            RESET: timerReset = 1'b1;
        endcase
    end
endmodule

module clkDiv_Herz #(
    parameter HERZ = 100
) (
    input  clk,
    input  reset,
    output o_clk
);

    reg [$clog2(100_000_000/HERZ)-1:0] counter;
    reg r_clk;
    assign o_clk = r_clk;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
            r_clk   <= 1'b0;
        end else begin
            if (counter == (100_000_000 / HERZ - 1)) begin
                counter <= 0;
                r_clk   <= 1'b1;
            end else begin
                counter <= counter + 1;
                r_clk   <= 1'b0;
            end
        end
    end

endmodule

module Upcounter_EN #(
    parameter MAX_NUM = 10000
) (
    input clk,  // system operation clock
    input reset,
    input tick,  // time clock ex) 100hz clk, 0.01sec
    input en,
    output [$clog2(MAX_NUM)-1:0] counter
);

    reg [$clog2(MAX_NUM)-1:0] counter_reg = 0, counter_next = 0;

    //state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
        end else begin
            counter_reg <= counter_next;
        end
    end

    //next state combinational logic
    always @(*) begin
        if (tick && en) begin
            if (counter_reg == MAX_NUM - 1) begin
                counter_next = 0;
            end else begin
                counter_next = counter_reg + 1;
            end
        end else begin
            counter_next = counter_reg;
        end
    end

    //output combinational logic
    assign counter = counter_reg;
endmodule
