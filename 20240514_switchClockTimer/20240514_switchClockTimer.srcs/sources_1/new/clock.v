`timescale 1ns / 1ps

module clkDiv #(parameter MAX_COUNT = 100_000) (
	input clk,
	input reset,
	output o_clk	
);
	reg [$clog2(MAX_COUNT)-1:0] count = 0;
	reg r_tick = 0;

	assign o_clk = r_tick;

	always @(posedge clk, posedge reset) begin
		if(reset == 1'b1)begin
			count <= 0;
		end else begin
			if(count == MAX_COUNT-1) begin
				count <=0;
				r_tick <= 1'b1;
			end else begin
				count <= count + 1;
				r_tick <= 1'b0;
			end
		end
	end

endmodule