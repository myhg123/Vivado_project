`timescale 1ns / 1ps



module Clock (
    input clk,
    input reset,
    input tick,
    input selMode,
    input btn1Tick,
    input btn2Tick,

    output [$clog2(60)-1:0] mincnt,
    output [$clog2(60)-1:0] seccnt
);

    reg [$clog2(60)-1:0] mincnt_reg, mincnt_next, seccnt_reg, seccnt_next;

    assign mincnt = mincnt_reg;
    assign seccnt = seccnt_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            mincnt_reg <= 0;
            seccnt_reg <= 0;
        end else begin
            mincnt_reg <= mincnt_next;
            seccnt_reg <= seccnt_next;
        end
    end

    always @(*) begin
        if (tick) begin
            if(mincnt_reg == 60) begin
                mincnt_next = 0;
            end else begin
                if (seccnt_reg == 60) begin
                    seccnt_next = 0;
                    mincnt_next = mincnt_reg+1;
                end else begin
                    seccnt_next = seccnt_reg+1;
                end
            end
        end
        else if(!selMode)begin
            if(btn1Tick) mincnt_next = mincnt_reg+1;
            else if(btn2Tick) seccnt_next = seccnt_reg+1;
        end

    end

endmodule


module clkDiv_Herz #(
    parameter HERZ = 100
) (
    input  clk,
    input  reset,
    output o_clk
);

    reg [$clog2(100_000_000/HERZ)-1:0] counter;
    reg r_clk;
    assign o_clk = r_clk;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
            r_clk   <= 1'b0;
        end else begin
            if (counter == (100_000_000 / HERZ - 1)) begin
                counter <= 0;
                r_clk   <= 1'b1;
            end else begin
                counter <= counter + 1;
                r_clk   <= 1'b0;
            end
        end
    end

endmodule
