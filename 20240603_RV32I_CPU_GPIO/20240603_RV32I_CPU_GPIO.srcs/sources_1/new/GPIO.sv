`timescale 1ns / 1ps
module GPIO_Bus (
    input  logic        clk,
    input  logic        reset,
    input  logic        cs,
    input  logic        we,
    input  logic [11:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    inout  logic [15:0] IOPortA,
    inout  logic [15:0] IOPortB,
    inout  logic [15:0] IOPortC,
    inout  logic [15:0] IOPortD,
    inout  logic [15:0] IOPortE,
    inout  logic [15:0] IOPortH
);
    logic [5:0] csPort;
    logic [31:0] w_rDataA,
     w_rDataB,
     w_rDataC,
     w_rDataD,
     w_rDataE,
     w_rDataH;
    always_comb begin  //CS Port
        if (cs) begin
            case (addr[11:8])
                4'h0: csPort = 6'b000001;
                4'h2: csPort = 6'b000010;
                4'h4: csPort = 6'b000100;
                4'h6: csPort = 6'b001000;
                4'h8: csPort = 6'b010000;
                4'ha: csPort = 6'b100000;
                default: csPort = 6'bx;
            endcase
        end
    end

    always_comb begin
        rdata = 32'bx;
        if (cs) begin
            case (addr[11:8])
                4'h0: rdata = w_rDataA;
                4'h2: rdata = w_rDataB;
                4'h4: rdata = w_rDataC;
                4'h6: rdata = w_rDataD;
                4'h8: rdata = w_rDataE;
                4'ha: rdata = w_rDataH;
                default: rdata = 32'bx;
            endcase
        end
    end

    GPIOx GPIOA (
        .clk(clk),
        .reset(reset),
        .cs(csPort[0]),
        .we(we),
        .addr(addr[7:0]),
        .wdata(wdata),
        .rdata(w_rDataA),
        .IOPort(IOPortA)
    );

    GPIOx GPIOB (
        .clk(clk),
        .reset(reset),
        .cs(csPort[1]),
        .we(we),
        .addr(addr[7:0]),
        .wdata(wdata),
        .rdata(w_rDataB),
        .IOPort(IOPortB)
    );


    GPIOx GPIOC (
        .clk(clk),
        .reset(reset),
        .cs(csPort[2]),
        .we(we),
        .addr(addr[7:0]),
        .wdata(wdata),
        .rdata(w_rDataC),
        .IOPort(IOPortC)
    );


    GPIOx GPIOD (
        .clk(clk),
        .reset(reset),
        .cs(csPort[3]),
        .we(we),
        .addr(addr[7:0]),
        .wdata(wdata),
        .rdata(w_rDataD),
        .IOPort(IOPortD)
    );


    GPIOx GPIOE (
        .clk(clk),
        .reset(reset),
        .cs(csPort[4]),
        .we(we),
        .addr(addr[7:0]),
        .wdata(wdata),
        .rdata(w_rDataE),
        .IOPort(IOPortE)
    );


    GPIOx GPIOH (
        .clk(clk),
        .reset(reset),
        .cs(csPort[5]),
        .we(we),
        .addr(addr[7:0]),
        .wdata(wdata),
        .rdata(w_rDataH),
        .IOPort(IOPortH)
    );
endmodule

module GPIOx (
    input  logic        clk,
    input  logic        reset,
    input  logic        cs,
    input  logic        we,
    input  logic [ 7:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata,
    inout  logic [15:0] IOPort
);

    logic [31:0] MODER, IDR, ODR;
    logic [31:0] IOPort_reg;


    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            MODER <= 0;
            ODR   <= 0;
        end else begin
            if (cs & we) begin
                case (addr[3:2])
                    2'b00: MODER <= wdata;  //MODER
                    2'b01: ODR <= wdata;  //ODR
                endcase
            end
        end
    end

    always_comb begin
        rdata = 32'bx;
        if (cs) begin
            case (addr[3:2])
                2'b00:   rdata = MODER;  //address 0x00 => 4'b0000
                2'b01:   rdata = IDR;  //address 0x04 => 4'b0100
                2'b10:   rdata = ODR;  //address 0x08 => 4'b1000
                default: rdata = 32'bx;
            endcase
        end
    end


    always_comb begin
        IDR[0]  = MODER[0] ? 1'bz : IOPort[0];
        IDR[1]  = MODER[1] ? 1'bz : IOPort[1];
        IDR[2]  = MODER[2] ? 1'bz : IOPort[2];
        IDR[3]  = MODER[3] ? 1'bz : IOPort[3];
        IDR[4]  = MODER[4] ? 1'bz : IOPort[4];
        IDR[5]  = MODER[5] ? 1'bz : IOPort[5];
        IDR[6]  = MODER[6] ? 1'bz : IOPort[6];
        IDR[7]  = MODER[7] ? 1'bz : IOPort[7];
        IDR[8]  = MODER[8] ? 1'bz : IOPort[8];
        IDR[9]  = MODER[9] ? 1'bz : IOPort[9];
        IDR[10] = MODER[10] ? 1'bz : IOPort[10];
        IDR[11] = MODER[11] ? 1'bz : IOPort[11];
        IDR[12] = MODER[12] ? 1'bz : IOPort[12];
        IDR[13] = MODER[13] ? 1'bz : IOPort[13];
        IDR[14] = MODER[14] ? 1'bz : IOPort[14];
        IDR[15] = MODER[15] ? 1'bz : IOPort[15];
    end

    assign IOPort[0]  = MODER[0] ? ODR[0] : 1'bz;
    assign IOPort[1]  = MODER[1] ? ODR[1] : 1'bz;
    assign IOPort[2]  = MODER[2] ? ODR[2] : 1'bz;
    assign IOPort[3]  = MODER[3] ? ODR[3] : 1'bz;
    assign IOPort[4]  = MODER[4] ? ODR[4] : 1'bz;
    assign IOPort[5]  = MODER[5] ? ODR[5] : 1'bz;
    assign IOPort[6]  = MODER[6] ? ODR[6] : 1'bz;
    assign IOPort[7]  = MODER[7] ? ODR[7] : 1'bz;
    assign IOPort[8]  = MODER[8] ? ODR[8] : 1'bz;
    assign IOPort[9]  = MODER[9] ? ODR[9] : 1'bz;
    assign IOPort[10] = MODER[10] ? ODR[10] : 1'bz;
    assign IOPort[11] = MODER[11] ? ODR[11] : 1'bz;
    assign IOPort[12] = MODER[12] ? ODR[12] : 1'bz;
    assign IOPort[13] = MODER[13] ? ODR[13] : 1'bz;
    assign IOPort[14] = MODER[14] ? ODR[14] : 1'bz;
    assign IOPort[15] = MODER[15] ? ODR[15] : 1'bz;

endmodule
