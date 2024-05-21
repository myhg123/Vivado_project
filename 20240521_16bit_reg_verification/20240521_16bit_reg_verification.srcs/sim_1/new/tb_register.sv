`timescale 1ns / 1ps

interface reg_intf;

    logic        clk;
    logic [15:0] a;
    logic        reset;
    logic [15:0] b;


endinterface  //reg_intf

class transaction;

    rand logic [15:0] a;
    logic [15:0] b;

    task display(string name);
        $display("[%s] a:%d, b:%d", name, a, b);
    endtask
endclass  //transaction

class generator;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    event genNextEvent;
    function new();
        tr = new();
    endfunction  //new()

    task run();
        repeat (10) begin
            assert (tr.randomize())
            else $error("tr.randomize() error!");
            gen2drv_mbox.put(tr);
            tr.display("GEN");
            @(genNextEvent);
        end
    endtask

endclass  //generator

class driver;
    virtual reg_intf reg_if;
    mailbox #(transaction) gen2drv_mbox;
    transaction tr;
    event monNextEvent;
    function new(virtual reg_intf reg_if);
        this.reg_if = reg_if;
    endfunction  //new()

    task reset();
        reg_if.a     <= 8'd0;
        reg_if.reset <= 1'b1;
        repeat (5) @(posedge reg_if.clk);
        reg_if.reset <= 1'b0;
    endtask

    task run();
        forever begin
            gen2drv_mbox.get(tr);
            reg_if.a <= tr.a;
            reg_if.reset <= 1'b0;
            tr.display("DRV");
            repeat (2) @(posedge reg_if.clk);
            ->monNextEvent;
        end
    endtask  //reset

endclass  //driver

class monitor;
    virtual reg_intf reg_if;
    mailbox #(transaction) mon2scb_mbox;
    transaction tr;
    event monNextEvent;

    function new(virtual reg_intf reg_if);
        this.reg_if = reg_if;
        tr = new();
    endfunction  //new()

    task run();
        forever begin
            @(monNextEvent);
            tr.a = reg_if.a;
            tr.b = reg_if.b;
            mon2scb_mbox.put(tr);
            tr.display("MON");
        end
    endtask  //run

endclass  //monitor


class scoreboard;
    mailbox #(transaction) mon2scb_mbox;
    transaction tr;
    event genNextEvent;
    int total_cnt, pass_cnt, fail_cnt;

    function new();
        total_cnt = 0;
        pass_cnt  = 0;
        fail_cnt  = 0;
    endfunction  //new()

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            tr.display("SCB");
            if (tr.a == tr.b) begin
                $display("  --> SAME!!! a:%d, b:%d", tr.a, tr.b);
                pass_cnt++;
            end else begin
                $display("  --> DIFFERENT!!! a:%d, b:%d", tr.a, tr.b);
                fail_cnt++;
            end
            total_cnt++;
            ->genNextEvent;
        end
    endtask
endclass  //scoreboard




module tb_register ();

    reg_intf reg_if ();
    generator gen;
    driver    drv;
    monitor   mon;
    scoreboard scb;
    event genNextEvent;
    event monNextEvent;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    register dut (
        .clk(reg_if.clk),
        .a(reg_if.a),
        .reset(reg_if.reset),
        .b(reg_if.b)
    );

    always #5 reg_if.clk = ~reg_if.clk;

    initial begin
        reg_if.clk   = 1'b0;
        reg_if.reset = 1'b1;
    end

    initial begin
        gen2drv_mbox = new();
        mon2scb_mbox = new();

        gen = new();
        drv = new(reg_if);
        mon = new(reg_if);
        scb = new();

        gen.gen2drv_mbox = gen2drv_mbox;
        drv.gen2drv_mbox = gen2drv_mbox;
        mon.mon2scb_mbox = mon2scb_mbox;
        scb.mon2scb_mbox = mon2scb_mbox;

        gen.genNextEvent = genNextEvent;
        scb.genNextEvent = genNextEvent;
        drv.monNextEvent = monNextEvent;
        mon.monNextEvent = monNextEvent;


        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_any
        $display("===========================================");
        $display("==             Final Report              ==");
        $display("==           Total Test : %d             ==", scb.total_cnt);
        $display("==           Total SAME : %d             ==", scb.pass_cnt);
        $display("==           Total DIFF : %d             ==", scb.fail_cnt);
        $display("===========================================");
        $display("==        test bench is finished!        ==");
        $display("===========================================");
        #10 $finish;
    end
endmodule
