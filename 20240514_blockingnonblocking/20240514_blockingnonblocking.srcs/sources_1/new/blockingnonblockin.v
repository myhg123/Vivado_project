`timescale 1ns / 1ps

module buttonLed(
    input clk,
    input btnC,
    output led[0]
);

    parameter   LED_off = 1'b0,
                LED_on = 1'b1,
                IDLE = 1'b0;
    reg     state, next;

    always @(posedge clk, posedge btnC) begin
       if(btnC == 1'b0) begin
             state <= IDLE;
       end else begin
            state <= next;
       end
    end

    always @(state) begin
        next = 1'b0;
        case (state)
            IDLE: if(LED_off) next <=LED_on;
                  else next <= LED_off;
                  
            default: 
        endcase 
    end


endmodule
