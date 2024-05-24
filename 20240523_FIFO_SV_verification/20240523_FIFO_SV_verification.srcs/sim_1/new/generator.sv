`timescale 1ns / 1ps
`include "transaction.sv"
class generator;
	transaction tr;
	mailbox #(transaction) gen2drv_mbox;
	event gen_next_event;

	function new(mailbox#(transaction) gen2drv_mbox, event gen_next_event);
		this.gen2drv_mbox = gen2drv_mbox;
		this.gen_next_event = gen_next_event;	
	endfunction //new()

	task run(int count);

		repeat (count) begin
			tr = new();
			assert (tr.randomize()) 
			else $error("[GEN] tr.randomize() error!");
			gen2drv_mbox.put(tr);
			tr.display("GEN");
			@(gen_next_event);
		end

	endtask

endclass //generator