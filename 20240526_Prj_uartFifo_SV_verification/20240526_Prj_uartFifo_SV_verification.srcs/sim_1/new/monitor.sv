`include "transaction.sv"

class monitor;
    transaction tr, tr_rx;
    virtual uartFifo_interface u_fifo_intf;
    mailbox #(transaction) mon2scb_mbox;
	mailbox #(transaction) gen2scb_mbox;
    function new(virtual uartFifo_interface u_fifo_intf,
                 mailbox#(transaction) mon2scb_mbox);
        this.u_fifo_intf  = u_fifo_intf;
        this.mon2scb_mbox = mon2scb_mbox;
    endfunction  //new()

    task run();
        forever begin
			@ (!u_fifo_intf.TX);
		tr = new();
			get_tx_data();
			mon2scb_mbox.put(tr);
			tr.display("MON");
        end
    endtask

	task get_tx_data();
		#960 tr.tx_data[0] = u_fifo_intf.TX;
		#640 tr.tx_data[1] = u_fifo_intf.TX;
		#640 tr.tx_data[2] = u_fifo_intf.TX;
		#640 tr.tx_data[3] = u_fifo_intf.TX;
		#640 tr.tx_data[4] = u_fifo_intf.TX;
		#640 tr.tx_data[5] = u_fifo_intf.TX;
		#640 tr.tx_data[6] = u_fifo_intf.TX;
		#640 tr.tx_data[7] = u_fifo_intf.TX;
	endtask

endclass  //monitor
