`timescale 1ns / 1ps

module uart (
    input clk,
    input reset,
    input start,
    input [7:0] tx_data,
    output tx_done,
    output txd
);
    wire w_br_tick;

    baudrate_generator U_BR_Gen (
        .clk(clk),
        .reset(reset),
        .br_tick(w_br_tick)
    );

    Transmitter_Repeat U_Transmitter_Repeat (
        .clk(clk),
        .reset(reset),
        .br_tick(w_br_tick),
        .start(start),
        .data(tx_data),
        .tx_done(tx_done),
        .tx(txd)
    );

endmodule

module baudrate_generator (
    input  clk,
    input  reset,
    output br_tick
);
    reg [$clog2(100_000_000 / 9600)-1:0] counter_reg, counter_next;
    reg tick_next, tick_reg;

    assign br_tick = tick_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
            tick_reg <= 1'b0;
        end else begin
            counter_reg <= counter_next;
            tick_reg <= tick_next;
        end
    end

    always @(*) begin
        counter_next = counter_reg;
      //  if (counter_reg == 10 - 1) begin
             if (counter_reg == 100_000_000 / 9600 - 1) begin
            counter_next = 0;
            tick_next = 1'b1;
        end else begin
            counter_next = counter_reg + 1;
            tick_next = 1'b0;
        end
    end

endmodule
module Transmitter_Repeat (
    input clk,
    input reset,
    input br_tick,
    input start,
    input [7:0] data,
    output tx_done,
    output tx
);

    localparam IDLE = 0, START = 1, DATATX = 2, STOP = 3;

    reg [1:0] state, state_next;
    reg [7:0] r_data;

    reg tx_reg, tx_next;
    reg tx_done_reg, tx_done_next;
    reg tx_dataTxDone_reg;
    reg [2:0] index;
    assign tx = tx_reg;
    assign tx_done = tx_done_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx_reg <= 1'b0;
            tx_done_reg <= 1'b0;
            tx_dataTxDone_reg <= 1'b0;
            index <= 3'd0;
        end else begin
            state <= state_next;
            tx_reg <= tx_next;
            tx_done_reg <= tx_done_next;
        end
    end


    always @(*) begin
        state_next = state;
        case (state)
            IDLE:  if (start) state_next = START;
            START: if (br_tick) state_next = DATATX;
            DATATX: begin
                if (br_tick) begin
                    if (tx_dataTxDone_reg == 1'b1) begin
                        tx_dataTxDone_reg = 1'b0;
                        state_next = STOP;
                    end else state_next = state;
                end
            end
            STOP:  if (br_tick) state_next = IDLE;
        endcase
    end

    always @(*) begin
        tx_next = tx_reg;
        tx_done_next = 1'b0;
        tx_dataTxDone_reg = 1'b0;
        case (state)
            IDLE: tx_next = 1'b1;
            START: begin
                tx_next = 1'b0;
                r_data  = data;
            end
            DATATX: begin
                if (br_tick) begin
                    if (index == 3'D7) begin
                        index = 3'd0;
                        tx_dataTxDone_reg = 1'b1;
                    end else begin
                        tx_next = r_data[index];
                        index   = index + 1;
                    end
                end
            end
            STOP: begin
                tx_next = 1'b1;
                if (state_next == IDLE) tx_done_next = 1'b1;
            end
        endcase
    end

endmodule

module Transmitter_class (
    input clk,
    input reset,
    input br_tick,
    input start,
    input [7:0] data,
    output tx_done,
    output tx
);

    localparam IDLE = 0, START = 1, D0 = 2, D1 = 3, D2 = 4, D3 = 5, D4 = 6, D5 = 7, D6 = 8, D7 = 9, STOP = 10;

    reg [3:0] state, state_next;
    reg [7:0] r_data;

    reg tx_reg, tx_next;
    reg tx_done_reg, tx_done_next;

    assign tx = tx_reg;
    assign tx_done = tx_done_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx_reg <= 1'b0;
            tx_done_reg <= 1'b0;
        end else begin
            state <= state_next;
            tx_reg <= tx_next;
            tx_done_reg <= tx_done_next;
        end
    end


    always @(*) begin
        state_next = state;
        case (state)
            IDLE: if (start) state_next = START;
            START: if (br_tick) state_next = D0;
            D0: if (br_tick) state_next = D1;
            D1: if (br_tick) state_next = D2;
            D2: if (br_tick) state_next = D3;
            D3: if (br_tick) state_next = D4;
            D4: if (br_tick) state_next = D5;
            D5: if (br_tick) state_next = D6;
            D6: if (br_tick) state_next = D7;
            D7: if (br_tick) state_next = STOP;
            STOP: if (br_tick) state_next = IDLE;
        endcase
    end

    always @(*) begin
        tx_next = tx_reg;
        tx_done_next = 1'b0;
        case (state)
            IDLE: tx_next = 1'b1;
            START: begin
                tx_next = 1'b0;
                r_data  = data;
            end
            D0:   tx_next = r_data[0];
            D1:   tx_next = r_data[1];
            D2:   tx_next = r_data[2];
            D3:   tx_next = r_data[3];
            D4:   tx_next = r_data[4];
            D5:   tx_next = r_data[5];
            D6:   tx_next = r_data[6];
            D7:   tx_next = r_data[7];
            STOP: begin
                tx_next = 1'b1;
                if (state_next == IDLE) tx_done_next = 1'b1;
            end
        endcase
    end

endmodule

module Transmitter (
    input [7:0] Data,
    input start,
    input baudrate,
    input reset,
    output TX
);

    parameter IDLE = 4'd0, STARTBIT = 4'D1, DATA1 = 4'D2,DATA2 = 4'D3,DATA3 = 4'D4,DATA4 = 4'D5,DATA5 = 4'D6,DATA6 = 4'D7,DATA7 = 4'D8,DATA8 = 4'D9,
    STOPBIT = 4'D10;

    reg [3:0] state, next_state;
    reg r_TX;
    assign TX = r_TX;

    //current state
    always @(posedge baudrate, posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end


    //next state module
    always @(state, start) begin
        next_state = state;
        case (state)
            IDLE: if (start) next_state = STARTBIT;
            STARTBIT: next_state = DATA1;
            DATA1: next_state = DATA2;
            DATA2: next_state = DATA3;
            DATA3: next_state = DATA4;
            DATA4: next_state = DATA5;
            DATA5: next_state = DATA6;
            DATA6: next_state = DATA7;
            DATA7: next_state = DATA8;
            DATA8: next_state = STOPBIT;
            STOPBIT: next_state = IDLE;
        endcase
    end

    //output module

    always @(*) begin
        r_TX = 1'b1;
        case (state)
            IDLE:     r_TX = 1'b1;
            STARTBIT: r_TX = 1'b0;
            DATA1:    r_TX = Data[0];
            DATA2:    r_TX = Data[1];
            DATA3:    r_TX = Data[2];
            DATA4:    r_TX = Data[3];
            DATA5:    r_TX = Data[4];
            DATA6:    r_TX = Data[5];
            DATA7:    r_TX = Data[6];
            DATA8:    r_TX = Data[7];
            STOPBIT:  r_TX = 1'b1;
        endcase
    end

endmodule
