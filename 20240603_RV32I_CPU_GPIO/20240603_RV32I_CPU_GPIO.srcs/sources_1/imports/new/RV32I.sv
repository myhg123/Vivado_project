`timescale 1ns / 1ps

module RV32I (
    input logic clk,
    input logic reset,
    inout logic [15:0] IOPortA,
    // inout  logic [15:0] IOPortB,
    inout logic [15:0] IOPortC,
    // inout  logic [15:0] IOPortD,
    // inout  logic [15:0] IOPortE,
    // inout  logic [15:0] IOPortH
    input logic UART_RX1,
    output logic UART_TX1
);

    logic [31:0]
        w_InstrMemAddr,
        w_InstrMemData,
        w_Addr,
        w_MasterRData,
        w_WData,
        w_dataMemRData,
        w_GPIORData,
        w_UARTRData;
    logic [2:0] w_slave_sel;
    logic w_We;

    CPU_core U_CPU_core (
        .clk          (clk),
        .reset        (reset),
        .machineCode  (w_InstrMemData),
        .instrMemRAddr(w_InstrMemAddr),
        .dataMemWe    (w_We),
        .dataMemAddr  (w_Addr),
        .dataMemRData (w_MasterRData),
        .dataMemWData (w_WData)
    );

    Instruction_Memory U_instrROM (
        .addr(w_InstrMemAddr),
        .data(w_InstrMemData)
    );

    Data_RAM U_Data_RAM (
        .clk  (clk),
        .ce   (w_slave_sel[0]),
        .we   (w_We),
        .addr (w_Addr[7:0]),
        .wdata( w_WData),
        .rdata(w_dataMemRData)
    );
    BUS_interconntor U_BUS_InterConn (
        .address     (w_Addr),
        .slave_sel   (w_slave_sel),
        .slave_rdata1(w_dataMemRData),
        .slave_rdata2(w_GPIORData),
        .slave_rdata3(w_UARTRData),
        .master_rdata(w_MasterRData)
    );
    GPIO U_GPIO (
        .clk    (clk),
        .reset  (reset),
        .cs     (w_slave_sel[1]),
        .we     (w_We),
        .addr   (w_Addr[11:0]),
        .wdata  (w_WData),
        .rdata  (w_GPIORData),
        .IOPortA(IOPortA),
        .IOPortB(),
        .IOPortC(IOPortC),
        .IOPortD(),
        .IOPortE(),
        .IOPortH()

        // .IOPortB(),
        // .IOPortD(),
        // .IOPortE(),
        // .IOPortH()
    );
    UART_Bus U_UART_Bus (
        .clk     (clk),
        .reset   (reset),
        .cs      (w_slave_sel[2]),
        .we      (w_We),
        .addr    (w_Addr[11:0]),
        .wdata   (w_WData),
        .rdata   (w_UARTRData),
        .UART_RX1(UART_RX1),
        .UART_TX1(UART_TX1),
        .UART_RX2(),
        .UART_TX2()
    );


endmodule

// module clkDiv #(
//     parameter MAX_COUNT = 100
// ) (
//     input  clk,
//     output o_clk
// );
//     reg [$clog2(MAX_COUNT)-1:0] counter = 0;
//     reg r_tick = 0;

//     assign o_clk = r_tick;

//     always @(posedge clk) begin
//         if (counter == (MAX_COUNT - 1)) begin
//             counter <= 0;
//             r_tick  <= 1'b1;
//         end else begin
//             counter <= counter + 1;
//             r_tick  <= 1'b0;
//         end
//     end

// endmodule
