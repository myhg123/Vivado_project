`include "transaction.sv"

class scoreboard;
    transaction tr, tr_rand;
    mailbox #(transaction) mon2scb_mbox;
    mailbox #(transaction) gen2scb_mbox;
    event gen_next_event;
    int pass_cnt, fail_cnt, total_cnt;
    reg [7:0] rand_fifo_data;
    reg [7:0] tx_fifo_data;

    function new(mailbox#(transaction) mon2scb_mbox,
                 mailbox#(transaction) gen2scb_mbox, event gen_next_event);
        this.mon2scb_mbox = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
        this.gen2scb_mbox = gen2scb_mbox;
        pass_cnt = 0;
        fail_cnt = 0;
        total_cnt = 0;
    endfunction  //new()

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            gen2scb_mbox.get(tr_rand);
			
            $display("[SCB] Random Data = %d, Dut Tx Data = %d",
                     tr_rand.rx_data, tr.tx_data);

            if (tr_rand.rx_data == tr.tx_data) begin
                $display("  --> PASS!!!");
                pass_cnt++;
            end else begin
                $display("  --> FAIL!!!");
                fail_cnt++;
            end
            total_cnt++;
            ->gen_next_event;
        end
    endtask

endclass  //scoreboard
