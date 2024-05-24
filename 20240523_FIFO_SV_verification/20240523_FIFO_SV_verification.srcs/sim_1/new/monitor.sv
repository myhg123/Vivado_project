`include "transaction.sv"
`include "interface.sv"

`timescale 1ns / 1ps
class monitor;
    transaction tr;
    virtual fifo_interface fifo_intf;
    mailbox #(transaction) mon2scb_mbox;

    function new(virtual fifo_interface fifo_intf,
                 mailbox#(transaction) mon2scb_mbox);
        this.mon2scb_mbox = mon2scb_mbox;
        this.fifo_intf = fifo_intf;
    endfunction  //new()

    task run();
        forever begin
            tr = new();
			#1;
            tr.wr_en = fifo_intf.wr_en;
            tr.wdata = fifo_intf.wdata;
            tr.rd_en = fifo_intf.rd_en;
            tr.rdata = fifo_intf.rdata;
            @(posedge fifo_intf.clk);
            tr.full  = fifo_intf.full;
            tr.empty = fifo_intf.empty;
            mon2scb_mbox.put(tr);
            tr.display("MON");
        end
    endtask

endclass  //monitor
