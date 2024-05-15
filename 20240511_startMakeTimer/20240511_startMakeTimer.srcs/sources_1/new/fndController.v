`timescale 1ns / 1ps

module fndController(
    input clk,
    input [$clog2(10000)-1:0] digit,
    output [3:0] fndSel,
    output [7:0] fndData
    );
    counter #(.MAX_COUNT(4) U_counter)
endmodule

module counter #(parameter MAX_COUNT = 4)(
    input clk,
    output [$clog2(MAX_COUNT)-1:0] count
);
    reg [$clog2(MAX_COUNT)-1:0] counter = 0;
    assign count = counter;
    always @(posedge clk) begin
       if(counter == MAX_COUNT) begin
        counter <=0;
       end else begin
        counter <= counter +1;
       end 
    end
endmodule

module preScaler #(parameter MAX_COUNT = 100_000)(
    input clk,
    output o_clk
);
    reg [$clog2(MAX_COUNT)-1:0] counter;
    reg r_tick;
    assign o_clk = r_tick;
    always @(posedge clk) begin
        if(counter == (MAX_COUNT-1)) begin
            counter <= 0;
            r_tick <= 1'b1;
        end else begin
            counter <= counter +1;
            r_tick <= 1'b0;
        end
       end
endmodule

module mux (
    input [3:0] x0, 
    input [3:0] x1, 
    input [3:0] x2, 
    input [3:0] x3, 
    input [1:0] sel,   
    output reg[3:0] y
);

    always @(*) begin
        case (sel)
            2'b00: y = x0; 
            2'b01: y = x1; 
            2'b10: y = x2; 
            2'b11: y = x3; 
            default: y = x0; 
        endcase
    end
    
endmodule

module digitSpliter (
    input [$clog2(10000):0] i_digit,
    output      [3:0]       o_digit_1,
    output      [3:0]       o_digit_10,
    output      [3:0]       o_digit_100,
    output      [3:0]       o_digit_1000
);
    assign o_digit_1 = i_digit % 10;
    assign o_digit_10 = i_digit / 10 % 10;
    assign o_digit_100 = i_digit / 100 % 10;
    assign o_digit_1000 = i_digit / 1000 % 10;

endmodule

module decoder (
   input [1:0] sel,
   output reg [3:0] fndSel 
);
   always @(sel) begin
        case (sel)
            2'b00:fndSel = 4'b1110; 
            2'b01:fndSel = 4'b1101; 
            2'b10:fndSel = 4'b1011; 
            2'b11:fndSel = 4'b0111; 
            default:fndSel = 4'b1110; 
        endcase
   end 
endmodule

module BCDtoSeg (
   input  [3:0]      bcd,
   output reg[7:0]      seg 
);
   always @(bcd) begin
        case (bcd)
            4'h0: seg = 8'hc0; 
            4'h1: seg = 8'hf9; 
            4'h2: seg = 8'ha4; 
            4'h3: seg = 8'hb0; 
            4'h4: seg = 8'h99; 
            4'h5: seg = 8'h92; 
            4'h6: seg = 8'h82; 
            4'h7: seg = 8'hf8; 
            4'h8: seg = 8'h80; 
            4'h9: seg = 8'h90; 
            4'ha: seg = 8'h88; 
            4'hb: seg = 8'h83; 
            4'hc: seg = 8'hc6; 
            4'hd: seg = 8'ha1; 
            4'he: seg = 8'h86; 
            4'hf: seg = 8'h8e; 
            default: seg = 8'hc0;
        endcase 
   end 
endmodule

