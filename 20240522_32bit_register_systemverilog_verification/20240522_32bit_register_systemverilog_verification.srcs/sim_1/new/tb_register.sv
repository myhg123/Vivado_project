`timescale 1ns / 1ps

interface reg_interface;

    logic        clk;
    logic        reset;
    logic [31:0] d;
    logic [31:0] q;

endinterface  //reg_interface

class transaction;

    rand logic [31:0] data;
    logic [31:0] out;

    task display(string name);
        $display("[%s] data: %x, out: %x", name, data, out);
    endtask  //display
endclass  //transaction

class generator;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    event gen_next_event;

    function new(mailbox#(transaction) gen2drv_mbox, event gen_next_event);
        this.gen2drv_mbox   = gen2drv_mbox;
        this.gen_next_event = gen_next_event;
    endfunction  //new()

    task run(int count);
        repeat (count) begin
            tr = new();
            assert (tr.randomize())
            else $error("[GEN] tr.randomize() error!!");
            gen2drv_mbox.put(tr);
            tr.display("GEN");
            @(gen_next_event);
        end
    endtask
endclass  //generator

class driver;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    virtual reg_interface reg_intf;

    function new(virtual reg_interface reg_intf,
                 mailbox#(transaction) gen2drv_mbox );
        this.reg_intf = reg_intf;
        this.gen2drv_mbox = gen2drv_mbox;
    endfunction  //new()

    task reset();
        reg_intf.d <= 0;
        reg_intf.reset <= 1'b1;
        repeat (5) @(posedge reg_intf.clk);
        reg_intf.reset <= 1'b0;
    endtask  //

    task run();
        forever begin
            gen2drv_mbox.get(tr);
            reg_intf.d <= tr.data;
            tr.display("DRV");
            @(posedge reg_intf.clk);
        end
    endtask  //run
endclass  //driver

class monitor;
    virtual reg_interface reg_intf;
    mailbox #(transaction) mon2scb_mbox;
    transaction tr;
    function new(virtual reg_interface reg_intf,
                 mailbox#(transaction) mon2scb_mbox);
        this.reg_intf = reg_intf;
        this.mon2scb_mbox = mon2scb_mbox;
    endfunction  //new()

    task run();
        forever begin
            tr = new();
            tr.data = reg_intf.d;
            @(posedge reg_intf.clk);
            tr.out = reg_intf.q;
            mon2scb_mbox.put(tr);
            tr.display("MON");
        end
    endtask

endclass  //monitor

class scoreboard;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    event gen_next_event;
    int total_cnt, pass_cnt, fail_cnt;
    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_event);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
        total_cnt           = 0;
        pass_cnt            = 0;
        fail_cnt            = 0;

    endfunction  //new()

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            tr.display("SRV");
            if (tr.data == tr.out) begin
                $display("  --> PASS! %d == %d", tr.data, tr.out);
                pass_cnt++;
            end else begin
                $display("  --> FAIL! %d == %d", tr.data, tr.out);
                fail_cnt++;
            end
            total_cnt++;
            ->gen_next_event;
        end

    endtask
endclass  //scoreboard

class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    event gen_next_event;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;


    function new(virtual reg_interface reg_intf);
        gen2drv_mbox = new();
        mon2scb_mbox = new();

        gen          = new(gen2drv_mbox, gen_next_event);
        drv          = new(reg_intf, gen2drv_mbox);
        mon          = new(reg_intf, mon2scb_mbox);
        scb          = new(mon2scb_mbox, gen_next_event);
    endfunction  //new()

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

    task run();
        fork
            gen.run(10000);
            drv.run();
            mon.run();
            scb.run();
        join_any
        report();
        #10 $finish;
    endtask

    task run_test();
        pre_run();
        run();
    endtask

endclass  //environment

module tb_register ();
    
    environment   env;

    reg_interface reg_intf();

    register dut (
        .clk(reg_intf.clk),
        .reset(reg_intf.reset),
        .d(reg_intf.d),
        .q(reg_intf.q)
    );

    always #5 reg_intf.clk = ~reg_intf.clk;

    initial begin
        reg_intf.clk = 0;
    end

    initial begin
        env = new(reg_intf);
        env.run_test();  
    end

endmodule
