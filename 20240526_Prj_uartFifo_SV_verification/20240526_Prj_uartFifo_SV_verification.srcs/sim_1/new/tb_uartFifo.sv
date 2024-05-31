`timescale 1ns / 1ps
`include "environment.sv"
module tb_uartFifo ();

    environment env;
    uartFifo_interface u_fifo_intf();


    uart_loop dut (
        .clk  (u_fifo_intf.clk),
        .reset(u_fifo_intf.reset),

        .RX(u_fifo_intf.RX),
        .TX(u_fifo_intf.TX)
    );

    always #5 u_fifo_intf.clk = ~u_fifo_intf.clk;
    initial begin
        u_fifo_intf.clk = 0;
    end

    initial begin
        env = new(u_fifo_intf);
        env.run_test(10000);
    end


endmodule

//////////////////////////////////////////////////////////////////
//아래는 uart 간단한 테스트벤치
// module tb_uartFifo ();
//     reg  clk;
//     reg  reset;

//     reg  RX;
//     wire TX;

//     uart_loop dut (
//         .clk  (clk),
//         .reset(reset),

//         .RX(RX),
//         .TX(TX)

//     );

//     always #5 clk = ~clk;

//     initial begin
//         clk=0;
//         reset=1;
//         RX=1;
//     end

//     initial begin
//         #30 reset=0;
//         #100 RX =0;
//         #640 RX = 1;
//         #640 RX = 0;
//         #640 RX = 0;
//         #640 RX = 0;
//         #640 RX = 1;
//         #640 RX = 0;
//         #640 RX = 1;
//         #640 RX = 0;
//         #640 RX = 1;
//     end



// endmodule
