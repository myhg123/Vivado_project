`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 15:27:40
// Design Name: 
// Module Name: tb_half_Adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_half_Adder();

    reg [3:0]a;
    reg [3:0]b;
    reg cin;
    wire [3:0]sum;
    wire cout;
    
        fourbitsFullAdder test_bench(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
        );
    
    initial begin
       #00 a = 4'b0001; b = 4'b0001; cin = 0;
       #10 a = 4'b0011; b = 4'b0001; cin = 0;
       #10 a = 4'b0111; b = 4'b0001; cin = 0;
       #10 a = 4'b1111; b = 4'b0001; cin = 0;
       #10 a = 4'b0001; b = 4'b0001; cin = 1;
       #10 a = 4'b0011; b = 4'b0001; cin = 1;
       #10 a = 4'b0111; b = 4'b0011; cin = 1;
       #10 a = 4'b1111; b = 4'b1111; cin = 1;
        #10 $finish;
        end

endmodule
