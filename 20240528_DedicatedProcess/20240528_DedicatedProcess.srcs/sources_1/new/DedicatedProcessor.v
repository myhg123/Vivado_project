`timescale 1ns / 1ps

module DedicatedProcessor (
    input        clk,
    input        reset,
    output [7:0] out,
    output [3:0] fndCom,
    output [7:0] fndFont
);
    wire w_ASrcMuxSel, w_Aload, w_OutBufSel, w_ALt10;
    reg r_clk;
    reg[31:0] counter;
    wire [7:0] w_out;
    assign out = w_out;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            counter <=0;
        end else begin
            if(counter == 100_000_00 -1) begin
                counter <= 0;
                r_clk<= 1'b1;
            end
            else begin
                counter <= counter +1;
                r_clk<= 1'b0;
            end
        end
    end

    controlUnit U_controlUnit (
        .clk(r_clk),
        .reset(reset),
        .ASrcMuxSel(w_ASrcMuxSel),
        .ALoad(w_Aload),
        .outBufSel(w_OutBufSel),
        .ALt10(w_ALt10)

    );
    dataPath U_dataPath (
        .clk(r_clk),
        .reset(reset),
        .ASrcMuxSel(w_ASrcMuxSel),
        .ALoad(w_Aload),
        .outBufSel(w_OutBufSel),
        .ALt10(w_ALt10),
        .out(w_out)
    );
    wire [13:0] w_digit;
    assign w_digit = {6'b0,w_out};
    fndController U_fndController(
    .clk(clk),
    .digit(w_digit),
    .fndFont(fndFont),
    .fndCom(fndCom)
);

endmodule
