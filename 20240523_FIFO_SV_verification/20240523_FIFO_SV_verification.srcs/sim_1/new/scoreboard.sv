`include "transaction.sv"

`timescale 1ns / 1ps
class scoreboard;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    event gen_next_event;

    int total_cnt, pass_cnt, fail_cnt, write_cnt;
    reg [7:0] scb_fifo[$:8];  // $ is queue (fifo)!, golden reference
    reg [7:0] scb_fifo_data;

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_event);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
        total_cnt           = 0;
        pass_cnt            = 0;
        fail_cnt            = 0;
        write_cnt           = 0;
    endfunction  //new()

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            tr.display("SCB");
            if (tr.wr_en) begin
                scb_fifo.push_back(tr.wdata);
				$display("  -->WRITE! fifo_data %x == queue size %x"
				, tr.wdata, scb_fifo.size());
				write_cnt++;
            end else if (tr.rd_en) begin
                scb_fifo_data = scb_fifo.pop_front();
                if (scb_fifo_data == tr.rdata) begin
                    $display("  --> READ PASS! fifo_data %d == rdata %d",
                             scb_fifo_data, tr.rdata);
							 pass_cnt++;
                end
				else begin
                    $display("  --> READ FAIL! fifo_data %d != rdata %d",
                             scb_fifo_data, tr.rdata);
							 fail_cnt++;
				end
            end
			total_cnt++;
			->gen_next_event;
        end
    endtask

endclass  //scoreboard
