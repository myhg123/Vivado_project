`timescale 1ns / 1ps
module uartWithLED (
    input clk,
    input reset,
    input rx,

    output led1,
    output led2,
    output led3
);
    wire [7:0]w_rx_data;
    wire w_rx_done;
uart U_UART(
    .clk(clk),
    .reset(reset),
    .start(1'b0),
    .tx_data(8'd0),
    .tx(),
    .tx_done(),
    .rx(rx),
    .rx_data(w_rx_data),
    .rx_done(w_rx_done)
);


led_FSM U_led_FSM(
    .clk(clk),
    .reset(reset),
    .Rx_data(w_rx_data),
    .rx_done(w_rx_done),

    .led1(led1),
    .led2(led2),
    .led3(led3)
);

endmodule

module led_FSM (
    input clk,
    input reset,
    input [7:0] Rx_data,
    input rx_done,

    output reg led1,
    output reg led2,
    output reg led3
);

    localparam LED_OFF = 0, LED_ON1 = 1, LED_ON2 = 2, LED_ON3 = 3;
    localparam zero = 8'd48, one = 8'd49, two = 8'd50, three = 8'd51;


    reg [1:0] state, state_next;
    reg [7:0] data_tmp_reg, data_tmp_next;

    always @(*) begin
                led1 = 1'b0;
                led2 = 1'b0;
                led3 = 1'b0;
        case (state)
            LED_OFF: begin
                led1 = 1'b0;
                led2 = 1'b0;
                led3 = 1'b0;
            end 
            LED_ON1: begin
                led1 = 1'b1;
                led2 = 1'b0;
                led3 = 1'b0;
            end 
            LED_ON2: begin
                led1 = 1'b1;
                led2 = 1'b1;
                led3 = 1'b0;
            end 
            LED_ON3: begin
                led1 = 1'b1;
                led2 = 1'b1;
                led3 = 1'b1;
            end 
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= LED_OFF;
            data_tmp_reg <= 8'd0;
        end else begin
            state <= state_next;
            data_tmp_reg <= data_tmp_next;
        end
    end

    always @(*) begin
        state_next = state;
        data_tmp_next = data_tmp_reg;
        if (rx_done) begin
            data_tmp_next = Rx_data;
        end else begin
            case (data_tmp_reg)
                zero: state_next = LED_OFF;
                one: state_next = LED_ON1;
                two: state_next = LED_ON2;
                three: state_next = LED_ON3;
                default: state_next = LED_OFF;
            endcase
        end
    end
endmodule
