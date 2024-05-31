`include "transaction.sv"
class generator;
	transaction tr;
	mailbox #(transaction) gen2drv_mbox;
	mailbox #(transaction) gen2scb_mbox;
	event gen_next_event;

	function new(mailbox #(transaction) gen2drv_mbox,
	event gen_next_event, mailbox #(transaction) gen2scb_mbox);
	tr = new();	
	this.gen2drv_mbox = gen2drv_mbox;
	this.gen_next_event = gen_next_event;	
	this.gen2scb_mbox = gen2scb_mbox;
	endfunction //new()

	task run(int count);
	repeat (count)begin
		assert (tr.randomize()) 
		else   $error("[GEN] tr.randomize() error!");
		gen2drv_mbox.put(tr);
		gen2scb_mbox.put(tr);
		tr.display("GEN");
		@ (gen_next_event);
	end
	endtask
endclass //generator