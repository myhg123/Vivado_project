`timescale 1ns / 1ps

module DataPath ();
endmodule

module RegisterFile (
    input         clk,
    input         we,
    input  [ 4:0] RAddr1,
    input  [ 4:0] RAddr2,
    input  [ 4:0] WAddr,
    input  [31:0] WData,
    output [31:0] RData1,
    output [31:0] RData2
);

    logic [31:0] RegFile[0:31];

    always_ff @(posedge clk) begin
        if (we) RegFile[WAddr] <= WData;
    end

    assign RData1 = (RAddr1 != 0) ? RegFile[RAddr1] : 0;
    assign RData2 = (RAddr2 != 0) ? RegFile[RAddr2] : 0;

endmodule
