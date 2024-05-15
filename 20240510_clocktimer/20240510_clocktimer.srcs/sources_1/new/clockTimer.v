`timescale 1ns / 1ps

module clockTimer(
    input clk,
    input reset,
    output [3:0]fndCom,
    output [7:0]fndFont
    );

    wire [6:0] w_minCounter, w_secCounter;
    
    clockCircuit U_clockCircuit(
    .clk(clk),
    .reset(reset),
    .min_Count(w_minCounter),
    .sec_Count(w_secCounter)
    );

 fndController U_fndController(
    .clk(clk),
    .digitmin(w_minCounter),
    .digitsec(w_secCounter),
    .reset(reset),
    .fndFont(fndFont),
    .fndCom(fndCom)
);

endmodule

module clockCircuit #(parameter MAX_MINSEC = 60)(
    input clk,
    input reset,
    output [$clog2(MAX_MINSEC)-1:0] min_Count,
    output [$clog2(MAX_MINSEC)-1:0] sec_Count
);
    wire w_clk_1hz;
        clkDiv #(
        .MAX_COUNT(100_000_000)
        ) U_ClkDiv_clock (
        .clk  (clk),
        .o_clk(w_clk_1hz),
        .reset(reset)
    );

    reg [$clog2(MAX_MINSEC)-1:0] r_minCounter = 0;
    reg [$clog2(MAX_MINSEC)-1:0] r_secCounter = 0;
   

    assign min_Count = r_minCounter;
    assign sec_Count = r_secCounter;

    always @(posedge w_clk_1hz, posedge reset) begin
        if(reset ==1'b1)begin
            r_minCounter <= 0;
            r_secCounter <= 0;
        end else begin
            if(r_minCounter == MAX_MINSEC-1)begin
                r_minCounter <= 0;
            end 
            else if(r_secCounter == MAX_MINSEC-1) begin
                r_secCounter <= 0;
                r_minCounter <= r_minCounter+1;
            end else begin
                r_secCounter <= r_secCounter+1;
            end       
        end
    end

endmodule