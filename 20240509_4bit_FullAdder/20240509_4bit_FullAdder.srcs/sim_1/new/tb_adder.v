`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 11:20:52
// Design Name: 
// Module Name: tb_adder
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


module tb_adder ();

    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] sum;
    wire co;


    Adder dut (  // dut (design under test)
        .a  (a),
        .b  (b),
        .cin(cin),
        .sum(sum),
        .co (co)
    );

    initial begin
        #00 a = 0;
        b   = 0;
        cin = 1'b0;
        #10 a = 1;
        b = 2;
        #10 a = 2;
        b = 3;
        #10 a = 10;
        b = 4;
        #10 a = 8;
        b = 7;
        #10 a = 11;
        b = 12;
        #10 $finish;
    end


endmodule
