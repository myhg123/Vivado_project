`timescale 1ns / 1ps

module controlUnit (
	input clk,
	input btn1,
	input btn2,
	input btn3,
	input reset,
	input [7:0] rx_data,
	input rx_done,


	output reg btn1Set,
	output reg btn2Set,
	output reg btn3Set
);


	always @(posedge clk, posedge btn1, posedge btn2, posedge btn3) begin
		if(btn1)btn1Set <= 1'b1;
		else btn1Set <= 1'b0;
		if(btn2)btn2Set<= 1'b1;
		else btn2Set<= 1'b0;
		if(btn3)btn3Set<=1'b1;
		else btn3Set<=1'b0;
	end


	reg [7:0]	data_tmp_reg, data_tmp_next;

	always @(posedge clk, posedge reset) begin
		if(reset) begin
			data_tmp_reg <= 0;
		end else begin
			data_tmp_reg <= data_tmp_next;
		end
	end

	always @(*) begin
		
		if (rx_done) begin
			data_tmp_next = rx_data;
		end else begin
			case (data_tmp_reg)
				
				default: 
			endcase
		end
	end

	

	
endmodule