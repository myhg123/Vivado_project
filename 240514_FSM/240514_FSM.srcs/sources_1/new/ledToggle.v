`timescale 1ns / 1ps
module led_toggle (
    input  clk,
    input  reset,
    input  button,
    output led
);
    wire w_button;
    
    button U_Btn (
        .clk(clk),
        .in (button),
        .out(w_button)
    );

    led_FSM_practice U_FSM (
        .clk(clk),
        .reset(reset),
        .button(w_button),
        .led(led)
    );

endmodule


module led_FSM(
    input clk,
    input reset,
    input button,
    output reg led
    );

    parameter LED_OFF = 1'b0, LED_ON = 1'b1;

    reg state, state_next;

    //state register, 현재상태 저장
    always @(posedge clk, posedge reset) begin
       if (reset) begin
            state <= LED_OFF;  
       end else begin
            state <= state_next;        
       end  
    end

    //Next state combinational Logic Circuit
    always @(state, button) begin
        state_next = state; //default를 자기자신을 받는걸로 만들어 놓음
        case (state)
            LED_OFF: begin
                if(button == 1'b1) state_next = LED_ON; // 버튼 신호가 들어 왔을때
                else state_next = state; // 버튼 신호가 들어오지 않았을때
            end
            LED_ON: begin
                if(button == 1'b1) state_next = LED_OFF;
                else state_next = state;
            end
        endcase
    end

    //Output combinational Logic Circuit
    //Moore Machine
    always @(state) begin
        led = 1'b0;
        case (state)
            LED_OFF: led = 1'b0;
            LED_ON: led = 1'b1;
        endcase
    end

    // //Output combinational Logic Circuit
    // //Mealy Machine
    // always @(state, button) begin
    //     led = 1'b0;
    //     case (state)
    //         LED_OFF: begin
    //             if(button == 1'b1) led =1'b1;
    //             else led = 1'b0;
    //         end
    //         LED_ON: begin
    //             if(button == 1'b1) led =1'b0;
    //             else led = 1'b1;
    //         end 

    //     endcase
    // end
endmodule

module led_FSM_practice (
    input clk,
    input button,
    input reset,
    output reg led
);

    parameter LED_ON = 1'b1, LED_OFF = 1'b0;

    reg state, next_state;

    //Current state Mechine
    always @(posedge clk, posedge reset) begin
        if(reset == 1'b1) begin
            state <= LED_OFF;
        end else begin
            state <= next_state;
        end
    end     

    //Next state logic
    always @(state, button) begin
        next_state = state;
        case (state)
            LED_OFF: begin
            if(button == 1'b1) next_state = LED_ON;
            else next_state = state; 
            end
            LED_ON: begin
                if(button == 1'b1) next_state = LED_OFF;
                else next_state =  state;
            end
        endcase
    end

    //output logic
    always @(state) begin
        led = 1'b0;
        case (state)
            LED_ON: led = 1'b1;
            LED_OFF: led  =  1'b0;
        endcase
    end

endmodule