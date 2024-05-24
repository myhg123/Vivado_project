`timescale 1ns / 1ps
interface ram_interface;

    logic       clk;
    logic       wr_en;
    logic [9:0] addr;
    logic [7:0] wdata;
    logic [7:0] rdata;


endinterface  //ram_interface

class transaction;

    rand bit       wr_en;
    rand bit [9:0] addr;
    rand bit [7:0] wdata;
    bit      [7:0] rdata;

    task display(string name);
        $display("[%s] wr_en: %x, addr: %x, wdata: %x, rdata: %x", name, wr_en,
                 addr, wdata, rdata);
    endtask  //display

    constraint c_addr {addr<10;}
    constraint c_wdata1 {wdata<100;}
    constraint c_wdata2 {wdata>10;}
    //constraint c_wr_en {wr_en dist {0:=100, 1:=110};}//dist 는 분배한다는 의미로 사용
     constraint c_wr_en {wr_en dist {0:/60, 1:/40};}



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
    virtual ram_interface ram_intf;

    function new(virtual ram_interface ram_intf,
                 mailbox#(transaction) gen2drv_mbox);
        this.ram_intf = ram_intf;
        this.gen2drv_mbox = gen2drv_mbox;
    endfunction  //new()

    task reset();
        ram_intf.wr_en <= 0;
        ram_intf.addr  <= 0;
        ram_intf.wdata <= 0;
        repeat (5) @(posedge ram_intf.clk);
    endtask  //

    task run();
        forever begin
            gen2drv_mbox.get(tr);
            ram_intf.wr_en <= tr.wr_en;
            ram_intf.addr  <= tr.addr;
            ram_intf.wdata <= tr.wdata;

/*            if (tr.wr_en) begin  //read
                ram_intf.wr_en <= tr.wr_en;
                ram_intf.addr  <= tr.addr;
            end else begin  //write
                ram_intf.wr_en <= tr.wr_en;
                ram_intf.addr  <= tr.addr;
                ram_intf.wdata <= tr.wdata;
            end
*/            tr.display("DRV");
            @(posedge ram_intf.clk);
        end
    endtask  //run
endclass  //driver

class monitor;
    virtual ram_interface ram_intf;
    mailbox #(transaction) mon2scb_mbox;
    transaction tr;
    function new(virtual ram_interface ram_intf,
                 mailbox#(transaction) mon2scb_mbox);
        this.ram_intf = ram_intf;
        this.mon2scb_mbox = mon2scb_mbox;
    endfunction  //new()

    task run();
        forever begin
            tr       = new();
            tr.wr_en = ram_intf.wr_en;
            tr.addr  = ram_intf.addr;
            tr.wdata = ram_intf.wdata;
            tr.rdata = ram_intf.rdata;
            mon2scb_mbox.put(tr);
            tr.display("MON");
            @(posedge ram_intf.clk);
        end
    endtask

endclass  //monitor

class scoreboard;
    transaction tr;
    mailbox #(transaction) mon2scb_mbox;
    event gen_next_event;
    int total_cnt, pass_cnt, fail_cnt, write_cnt;
    logic [7:0] mem[0:2**10-1];

    function new(mailbox#(transaction) mon2scb_mbox, event gen_next_event);
        this.mon2scb_mbox   = mon2scb_mbox;
        this.gen_next_event = gen_next_event;
        total_cnt           = 0;
        pass_cnt            = 0;
        fail_cnt            = 0;
        write_cnt           = 0;
        for (int i = 0; i < 2 ** 10; i++) begin
            mem[i] = 0;
        end

    endfunction  //new()

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            tr.display("SRV");
            if (tr.wr_en) begin
                if (mem[tr.addr] == tr.rdata) begin
                    $display("  --> READ PASS! mem[%x] == %x", tr.addr,
                             tr.rdata);
                    pass_cnt++;
                end else begin
                    $display("  --> READ FAIL! mem[%x] == %x", tr.addr,
                             tr.rdata);
                    fail_cnt++;
                end
            end else begin
                mem[tr.addr] = tr.wdata;
                $display("  --> WRITE! mem[%x] == %x", tr.addr, tr.wdata);
                write_cnt++;
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


    function new(virtual ram_interface ram_intf);
        gen2drv_mbox = new();
        mon2scb_mbox = new();

        gen          = new(gen2drv_mbox, gen_next_event);
        drv          = new(ram_intf, gen2drv_mbox);
        mon          = new(ram_intf, mon2scb_mbox);
        scb          = new(mon2scb_mbox, gen_next_event);
    endfunction  //new()

    task report();
        $display("=================================");
        $display("==         Final Report        ==");
        $display("Total Test : %d", scb.total_cnt);
        $display("Pass count : %d", scb.pass_cnt);
        $display("Fail count : %d", scb.fail_cnt);
        $display("write count : %d", scb.write_cnt);
        $display("=================================");
        $display("==   test bench is finished!!  ==");
        $display("=================================");

    endtask

    task pre_run();
        drv.reset();
    endtask

    task run();
        fork
            gen.run(100000);
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

module tb_RAM ();

    environment env;

    ram_interface ram_intf ();

    RAM dut (
        .clk(ram_intf.clk),
        .address(ram_intf.addr),
        .wdata(ram_intf.wdata),
        .wr_en(ram_intf.wr_en),
        .rdata(ram_intf.rdata)
    );


    always #5 ram_intf.clk = ~ram_intf.clk;

    initial begin
        ram_intf.clk = 0;
    end

    initial begin
        env = new(ram_intf);
        env.run_test();
    end


endmodule
