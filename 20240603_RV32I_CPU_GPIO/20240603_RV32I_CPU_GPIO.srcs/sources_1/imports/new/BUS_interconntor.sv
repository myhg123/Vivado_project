`timescale 1ns / 1ps

module BUS_interconntor (
    input  logic [31:0] address,
    output logic [ 2:0] slave_sel,
    input  logic [31:0] slave_rdata1,
    input  logic [31:0] slave_rdata2,
    input  logic [31:0] slave_rdata3,
    output logic [31:0] master_rdata
);

    decoder U_Decoder (
        .x(address),
        .y(slave_sel)
    );
    mux U_MUX (
        .sel(address),
        .a  (slave_rdata1),
        .b  (slave_rdata2),
        .c  (slave_rdata3),
        .y  (master_rdata)
    );

endmodule

module decoder (
    input  logic [31:0] x,
    output logic [ 2:0] y
);

    always_comb begin : decoder
        case (x[31:12])  //Address
            20'h0000_0: begin
                if (x[11:8] == 4'd0) y = 3'b001;
                else y = 3'bx;
            end
            20'h0000_1: y = 3'b010;
            20'h0000_2: begin
                if(x[11:8]<4'h4) y = 3'bx;
                else if(x[11:8]<4'h8) y = 3'b100;
                else y=3'bx;
            end
            default: y = 3'bx;
        endcase
    end

endmodule

module mux (
    input  logic [31:0] sel,
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,
    output logic [31:0] y
);
    always_comb begin : decoder
        case (sel[31:12])  //Address
            20'h0000_0: begin
                if (sel[11:8] == 0) y = a;
                else y = 32'bx;
            end
            20'h0000_1: y = b;
            20'h0000_2: begin
                if(sel[11:8]<4'h4) y=3'bx;
                else if(sel[11:8] < 4'h8) y = c;
                else y=3'bx;
            end
            default: y = 32'bx;
        endcase
    end

endmodule
