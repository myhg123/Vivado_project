`timescale 1ns / 1ps

module controller_unit (
    input  btn_run_stop,
    input  btn_clear,
    input reset,
    input clk,
    output run_stop,
    output clear,
    output led0,
    output led1,
    output led2
);

    parameter STOP = 2'd0, RUN = 2'D1, CLEAR = 2'D2;
    reg [1:0] state, state_next;
    reg run_stop_reg, run_stop_next, clear_reg, clear_next;
    reg led0_reg, led1_reg, led2_reg;

    assign run_stop = run_stop_reg;
    assign clear = clear_reg;
    assign led0 = led0_reg;
    assign led1 = led1_reg;
    assign led2 = led2_reg;

    //state register
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= STOP;
            run_stop_reg <= 1'b0;
            clear_reg <= 1'b0;
        end else begin
            state <= state_next;
            run_stop_reg <= run_stop_next;
            clear_reg <= clear_next;
        end
    end

    //next state combinational logic
    always @(*) begin
        state_next = state;
        case (state)
            STOP: begin
                if (btn_run_stop) state_next = RUN;
                else if (btn_clear) state_next = CLEAR;
                else state_next = STOP;
            end
            RUN: begin
                if (btn_run_stop) state_next = STOP;
                else state_next = RUN;
            end
            CLEAR: begin
                state_next = STOP;
            end
        endcase
    end

    //output combinational logic
    always @(*) begin
        case (state)
            STOP: begin
                run_stop_next = 1'b0;
                clear_next = 1'b0;
                led0_reg = 1'b1;
                led1_reg = 1'b0;
                led2_reg = 1'b0;
            end

            RUN: begin
                run_stop_next = 1'b1;
                clear_next = 1'b0;
                led1_reg = 1'b1;
                led0_reg = 1'b0;
                led2_reg = 1'b0;
            end
            CLEAR: begin
                run_stop_next = 1'b0;
               
                led2_reg = 1'b1;
                led0_reg = 1'b0;
                led1_reg = 1'b0;
            end
    endcase
    end
    endmodule 