`timescale 1ns / 1ps

module counter #(parameter MAX_COUNT = 4) (
	input clk,
	input reset,
	output [$clog2(MAX_COUNT)-1 :0] count	
);
	reg [$clog2(MAX_COUNT)-1:0] counter = 0;
	
	assign count = counter;

	always @(posedge clk, posedge reset) begin
		if(reset == 1'b1) begin
			counter <= 0;
		end	else begin
			if (counter == MAX_COUNT) begin
				counter <= 0;	
			end else begin
				counter <=  counter + 1;
			end
		end 
	end	
endmodule