`timescale 1ns / 1ps
`include "transaction.sv"
class driver;
	transaction tr;
	virtual uartFifo_interface u_fifo_intf;
	mailbox #(transaction) gen2drv_mbox;

	function new(virtual uartFifo_interface u_fifo_intf,
	mailbox #(transaction) gen2drv_mbox);
	this.u_fifo_intf = u_fifo_intf;
	this.gen2drv_mbox =  gen2drv_mbox;	
	endfunction //new()

	task reset();
		u_fifo_intf.RX <= 1'b1;
		u_fifo_intf.reset <= 1'b1;
		repeat (5) @(posedge u_fifo_intf.clk);
		u_fifo_intf.reset <= 1'b0;
	endtask

	task run();
		forever begin
			gen2drv_mbox.get(tr);
			rxdata_tx();
			tr.display("DRV");
			repeat (2000)@(posedge u_fifo_intf.clk);
		end
	endtask

	task rxdata_tx();
		u_fifo_intf.RX = 1'b0;
		#640 u_fifo_intf.RX = tr.rx_data[0];
		#640 u_fifo_intf.RX = tr.rx_data[1];
		#640 u_fifo_intf.RX = tr.rx_data[2];
		#640 u_fifo_intf.RX = tr.rx_data[3];
		#640 u_fifo_intf.RX = tr.rx_data[4];
		#640 u_fifo_intf.RX = tr.rx_data[5];
		#640 u_fifo_intf.RX = tr.rx_data[6];
		#640 u_fifo_intf.RX = tr.rx_data[7];
		#640 u_fifo_intf.RX = 1'b1;
	endtask

endclass //driver