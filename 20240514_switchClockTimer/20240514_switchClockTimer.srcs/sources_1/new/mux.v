`timescale 1ns / 1ps

module Mux_4x1( 
	input [1:0] sel,
	input [3:0] x0,
	input [3:0] x1,
	input [3:0] x2,
	input [3:0] x3,
	output reg [3:0] y
);
	always @(sel) begin
		case (sel)
			2'b00: y = x0; 
			2'b01: y = x1; 
			2'b10: y = x2; 
			2'b11: y = x3; 
			default: y = x0; 
		endcase	
	end	
endmodule

module Mux_2x1 (
	input sel,
	input [3:0] x0,
	input [3:0] x1,
	output reg [3:0] y
);
	always @(sel) begin
		case (sel)
			1'b0: y = x0;
			1'b1; y = x1; 
			default: y = x0;
		endcase
	end	
endmodule