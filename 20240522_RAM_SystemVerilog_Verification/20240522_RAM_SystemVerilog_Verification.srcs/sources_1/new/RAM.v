`timescale 1ns / 1ps

module RAM(
    input clk,
    input [9:0] address,
    input [7:0] wdata,
    input wr_en,
    output [7:0] rdata
    );
    reg [7:0] mem[0:2**10-1];
    integer i;
    initial begin
        for (i=0;i < 2**10 ; i=i+1)mem[i] = 0;
    end

    always @(posedge clk) begin
        if(!wr_en) begin
            mem[address] <=wdata;
        end
    end

    assign rdata= mem[address];

endmodule
