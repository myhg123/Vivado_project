`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 15:24:05
// Design Name: 
// Module Name: Half_Adder
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

module fourbitsFullAdder(
    a,
    b,
    cin,
    sum,
    cout
);

    input [3:0]a;
    input [3:0]b;
    input cin;
    output [3:0]sum;
    output cout;
wire w_carry1, w_carry2, w_carry3;
fullAdder u_FA1(
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .carry(w_carry1)
);
fullAdder u_FA2(
    .a(a[1]),
    .b(b[1]),
    .cin(w_carry1),
    .sum(sum[1]),
    .carry(w_carry2)
);
fullAdder u_FA3(
    .a(a[2]),
    .b(b[2]),
    .cin(w_carry2),
    .sum(sum[2]),
    .carry(w_carry3)
);
fullAdder u_FA4(
    .a(a[3]),
    .b(b[3]),
    .cin(w_carry3),
    .sum(sum[3]),
    .carry(cout)
);

endmodule


module fullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output carry
);
wire w_sum1, w_carry1, w_carry2;

HA u_HA1(
   .x0(a),
   .x1(b),
    .sum(w_sum1),
    .carry(w_carry1) 
    );

HA u_HA2(
  .x0(w_sum1),
  .x1(cin),
  .sum(sum),
  .carry(w_carry2)
 );
 assign carry = w_carry1 | w_carry2;
endmodule


module HA(
    input x0,
    input x1,
    output sum,
    output carry 

    );
        assign sum = x0 ^ x1;
        assign carry = x0 & x1; 
endmodule
