`include "transaction.sv"
`include "interface.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
	generator gen;
	driver drv;
	monitor mon;
	scoreboard scb;

	event gen_next_event;

	mailbox #(transaction) gen2drv_mbox;
	mailbox #(transaction) gen2scb_mbox;
	mailbox #(transaction) mon2scb_mbox;

	function new(virtual uartFifo_interface u_fifo_intf);
		gen2drv_mbox = new();
		gen2scb_mbox = new();
		mon2scb_mbox = new();

		gen = new(gen2drv_mbox, gen_next_event, gen2scb_mbox);
		drv = new(u_fifo_intf, gen2drv_mbox);
		mon = new(u_fifo_intf, mon2scb_mbox);
		scb = new(mon2scb_mbox, gen2scb_mbox, gen_next_event);
	endfunction //new()

    task report();
        $display("=================================");
        $display("==         Final Report        ==");
        $display("Total Test : %d", scb.total_cnt);
        $display("Pass count : %d", scb.pass_cnt);
        $display("Fail count : %d", scb.fail_cnt);
        $display("=================================");
        $display("==   test bench is finished!!  ==");
        $display("=================================");
    endtask

	task pre_run();
		drv.reset();
	endtask

	task run(int count);
		fork
			gen.run(count);
			drv.run();
			mon.run();
			scb.run();
		join_any
		report();
		#10 $finish;
	endtask

	task run_test(int count);
		pre_run();
		run(count);
	endtask

	
endclass //environment