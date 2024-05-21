`timescale 1ns / 1ps

interface adder_intf;

    logic       clk;
    logic       vaild;
    logic [3:0] a;
    logic [3:0] b;
    logic       reset;
    logic [3:0] sum;
    logic       carry;

endinterface  //adder_intf


class transaction;

    rand logic [3:0] a;
    rand logic [3:0] b;
    logic [3:0] sum;
    logic carry;
    //    rand logic vaild;

    task display(string name);

        $display("[%s] a:%d, b:%d, sum:%d, carry:%d", name, a, b, sum, carry);

    endtask
endclass  //transaction

class generator;
    transaction tr;
    mailbox #(transaction) gen2drv_mbox;
    event genNextEvent1;

    function new();
        tr = new(); // new를 해줘야 실체화를 해줄 수 있다. reference 값을 준다고 볼 수 있다. 
    endfunction  //new()

    task run();
        repeat (10000) begin
            assert (tr.randomize())
            else $error("tr.randomize() error!");
            gen2drv_mbox.put(tr);
            tr.display("GEN");
            @(genNextEvent1);
        end

    endtask

endclass  //generater

class driver;
    virtual adder_intf adder_if;                    //virtual 을 넣어주면 가상 인터페이스가 된다. 실제 인터페이스는 tb에다가 넣기때문에 실제 인터페이스는 tb 함수에 넣어야한다.
    mailbox #(transaction) gen2drv_mbox;
    transaction tr;
    //event genNextEvent2;
    event monNextEvent;

    function new(virtual adder_intf adder_if);
        this.adder_if = adder_if;
    endfunction  //new()
    task reset();
        adder_if.a     <= 0;
        adder_if.b     <= 0;
        adder_if.vaild <= 1'b0;
        adder_if.reset <= 1'b1;
        repeat (5) @(posedge adder_if.clk);
        adder_if.reset <= 1'b0;
    endtask

    task run();
        forever begin
            gen2drv_mbox.get(
                tr);  //blocking code 이다. 값이 올때까지 계속 대기
            adder_if.a     <= tr.a;
            adder_if.b     <= tr.b;
            adder_if.vaild <= 1'b1;
            tr.display("DRV");
            @(posedge adder_if.clk);
            adder_if.vaild <= 1'b0;
            @(posedge adder_if.clk);
            //->genNextEvent2;
            ->monNextEvent;
        end
    endtask
endclass  //driver

class monitor;
    virtual adder_intf adder_if;
    mailbox #(transaction) mon2scb_mbox;
    transaction tr;
    event monNextEvent;

    function new(virtual adder_intf adder_if);
        this.adder_if = adder_if;
        tr = new();
    endfunction  //new()

    task run();
        forever begin
            @(monNextEvent);
            tr.a     = adder_if.a;
            tr.b     = adder_if.b;
            tr.sum   = adder_if.sum;
            tr.carry = adder_if.carry;
            mon2scb_mbox.put(tr);
            tr.display("MON");
        end
    endtask

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
    endfunction

    task run();
        forever begin
            mon2scb_mbox.get(tr);
            tr.display("SCB");
            if((tr.a + tr.b) == {tr.carry, tr.sum})begin // (tr.a + tr.b) <-- reference model, golden reference 
                $display("  --> PASS!!! %d + %d = %d", tr.a, tr.b, {tr.carry,
                                                                    tr.sum});
                pass_cnt++;
            end else begin
                $display("  --> FAIL!!! %d + %d = %d", tr.a, tr.b, {tr.carry,
                                                                    tr.sum});
                fail_cnt++;
            end
            total_cnt++;
            ->genNextEvent;
        end
    endtask

endclass  //scoreboard


module tb_adder ();

    adder_intf adder_if ();  //실체화
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;
    event genNextEvent;
    event monNextEvent;

    mailbox #(transaction) gen2drv_mbox;
    mailbox #(transaction) mon2scb_mbox;

    adder dut (
        .clk(adder_if.clk),
        .vaild(adder_if.vaild),
        .a(adder_if.a),
        .b(adder_if.b),
        .reset(adder_if.reset),
        .sum(adder_if.sum),
        .carry(adder_if.carry)
    );

    always #5 adder_if.clk = ~adder_if.clk;

    initial begin
        adder_if.clk   = 1'b0;
        adder_if.reset = 1'b1;
    end


    initial begin
        gen2drv_mbox      = new();
        mon2scb_mbox      = new();

        gen               = new();
        drv               = new(adder_if);
        mon               = new(adder_if);
        scb               = new();

        gen.genNextEvent1 = genNextEvent;
        scb.genNextEvent  = genNextEvent;
        mon.monNextEvent  = monNextEvent;
        drv.monNextEvent  = monNextEvent;

        gen.gen2drv_mbox  = gen2drv_mbox;
        drv.gen2drv_mbox  = gen2drv_mbox;
        mon.mon2scb_mbox  = mon2scb_mbox;
        scb.mon2scb_mbox  = mon2scb_mbox;

        drv.reset();
        fork
            drv.run();
            gen.run();
            mon.run();
            scb.run();
        join_any
        $display("=================================");
        $display("==         Final Report        ==");
        $display("Total Test : %d", scb.total_cnt);
        $display("Pass count : %d", scb.pass_cnt);
        $display("Fail count : %d", scb.fail_cnt);
        $display("=================================");
        $display("==   test bench is finished!!  ==");
        $display("=================================");
        #10 $finish;
    end

endmodule
