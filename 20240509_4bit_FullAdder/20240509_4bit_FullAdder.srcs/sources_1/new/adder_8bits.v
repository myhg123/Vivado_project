`timescale 1ns / 1ps

module adder_8bits (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output co
);
    wire w_carry[6:0];
    fullAdder U_FA0 (
        .a  (a[0]),
        .b  (b[0]),
        .cin(cin),
        .sum(sum[0]),
        .co (w_carry[0])
    );
    fullAdder U_FA1 (
        .a  (a[1]),
        .b  (b[1]),
        .cin(w_carry[0]),
        .sum(sum[1]),
        .co (w_carry[1])
    );
    fullAdder U_FA2 (
        .a  (a[2]),
        .b  (b[2]),
        .cin(w_carry[1]),
        .sum(sum[2]),
        .co (w_carry[2])
    );
    fullAdder U_FA3 (
        .a  (a[3]),
        .b  (b[3]),
        .cin(w_carry[2]),
        .sum(sum[3]),
        .co (w_carry[3])
    );
    fullAdder U_FA4 (
        .a  (a[4]),
        .b  (b[4]),
        .cin(w_carry[3]),
        .sum(sum[4]),
        .co (w_carry[4])
    );
    fullAdder U_FA5 (
        .a  (a[5]),
        .b  (b[5]),
        .cin(w_carry[4]),
        .sum(sum[5]),
        .co (w_carry[5])
    );
    fullAdder U_FA6 (
        .a  (a[6]),
        .b  (b[6]),
        .cin(w_carry[5]),
        .sum(sum[6]),
        .co (w_carry[6])
    );
    fullAdder U_FA7 (
        .a  (a[7]),
        .b  (b[7]),
        .cin(w_carry[6]),
        .sum(sum[7]),
        .co (co)
    );

endmodule
