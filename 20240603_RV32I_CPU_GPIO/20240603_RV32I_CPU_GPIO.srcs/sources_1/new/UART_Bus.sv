`timescale 1ns / 1ps

module UART_Bus (
    input  logic        clk,
    input  logic        reset,
    input  logic        cs,
    input  logic        we,
    input  logic [11:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    input  logic        UART_RX1,
    output logic        UART_TX1,
    input  logic        UART_RX2,
    output logic        UART_TX2
);

    logic [1:0] csPort;
    logic [31:0] w_rxData1, w_rxData2;

    BUS_UART U_Bus_uart (
        .address(addr),
        .ce(cs),
        .slave_sel(csPort),
        .slave_rdata1(w_rxData1),
        .slave_rdata2(w_rxData2),
        .master_rdata(rdata)
    );

    uartx U_UART1 (
        .clk  (clk),
        .reset(reset),

        .RX(UART_RX1),
        .TX(UART_TX1),
        .cs(csPort[0]),
        .we(we),
        .addr(addr[7:0]),
        .wdata(wdata),
        .rdata(w_rxData1)
    );

    uartx U_UART2 (
        .clk  (clk),
        .reset(reset),

        .RX(UART_RX2),
        .TX(UART_TX2),
        .cs(csPort[1]),
        .we(we),
        .addr(addr[7:0]),
        .wdata(wdata),
        .rdata(w_rxData2)
    );

endmodule

module BUS_UART (
    input  logic [11:0] address,
    input  logic        ce,
    output logic [ 1:0] slave_sel,
    input  logic [31:0] slave_rdata1,
    input  logic [31:0] slave_rdata2,
    output logic [31:0] master_rdata
);

    decoder_UART U_UART_Decoder (
        .x (address),
        .ce(ce),
        .y (slave_sel)
    );


    mux_UART U_MUX_UART_rdata (
        .sel(address),
        .ce (ce),
        .a  (slave_rdata1),
        .b  (slave_rdata2),
        .y  (master_rdata)
    );


endmodule

module decoder_UART (
    input logic [11:0] x,
    input logic ce,
    output logic [1:0] y
);

    always_comb begin : decoder
        if (ce) begin
            case (x[11:8])  //Address
                4'h4: y = 2'b01;
                4'h6: y = 2'b10;
                default: y = 2'bx;
            endcase
        end
    end

endmodule

module mux_UART (
    input  logic [11:0] sel,
    input  logic        ce,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] y
);
    always_comb begin : decoder
        if (ce) begin
            case (sel[11:8])  //Address
                4'h4: y = a;
                4'h6: y = b;
                default: y = 32'bx;
            endcase
        end
    end

endmodule


module uartx (
    input logic clk,
    input logic reset,

    input  logic RX,
    output logic TX,

    input  logic        cs,
    input  logic        we,
    input  logic [ 7:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);

    logic [31:0] UART_SR, UART_RDR, UART_TDR, UART_BRR, UART_CR;
    logic rx_empty, rx_en, tx_en;


    assign UART_SR[1] = ~rx_empty;


    always_ff @(posedge clk, posedge reset) begin : UART_REG
        if (reset) begin
            UART_RDR <= 32'bx;
            UART_TDR <= 32'bx;
            UART_BRR <= 32'd1;
            UART_CR  <= 32'd0;
        end else begin
            if (cs & we) begin
                case (addr[7:0])
                    8'h08: UART_TDR <= wdata;
                    8'h0c: UART_BRR <= wdata;
                    8'h10: UART_CR <= wdata;
                endcase
            end
        end
    end

    always_comb begin
        rdata = 32'bx;
        rx_en = 1'b0;
        tx_en = 1'b0;
        if (cs) begin
            case (addr[7:0])
                8'h00:   rdata = UART_SR;
                8'h04: begin
                    if (UART_SR[1]) begin
                        rdata = UART_RDR;
                        rx_en = 1'b1;
                    end else rdata = 32'bx;
                end
                8'h08: begin
                    rdata = UART_TDR;
                    tx_en = 1'b1;
                end
                8'h0c:   rdata = UART_BRR;
                8'h10:   rdata = UART_CR;
                default: rdata = 32'bx;
            endcase
        end
    end


    uart_fifo U_UART_fifo (
        .clk  (clk),
        .reset(reset),

        .UART_CR (UART_CR[16:0]),
        .UART_BRR(UART_BRR[4:0]),

        .tx_en  (tx_en),
        .tx_data(UART_TDR[7:0]),
        .tx_full(),

        .rx_en(rx_en),
        .rx_data(UART_RDR[7:0]),
        .rx_empty(rx_empty),

        .RX(RX),
        .TX(TX)
    );


endmodule
