`timescale 1ns / 1ps

module fndSelect(
    input [1:0] a,
    output reg [3:0] seg
    );
    
always@(a)begin
    case(a)
    2'b00: seg = 4'b1110;
    2'b01: seg = 4'b1101;
    2'b10: seg = 4'b1011;
    2'b11: seg = 4'b0111;
    default: seg = 4'b1111;
    endcase
end

endmodule
