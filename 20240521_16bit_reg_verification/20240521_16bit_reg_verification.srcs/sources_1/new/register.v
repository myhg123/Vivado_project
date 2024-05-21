`timescale 1ns / 1ps

module register(
    input clk,
    input [15:0] a,
    input reset, 
    output [15:0] b
    );

    reg [15:0] b_reg, b_next;

    assign b = b_reg;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            b_reg <= 16'd0;             
        end else begin
            b_reg <= b_next;
        end
    end    

    always @(*) begin
       b_next = a; 
    end

endmodule
