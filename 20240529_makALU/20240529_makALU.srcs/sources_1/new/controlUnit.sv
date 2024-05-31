`timescale 1ns / 1ps


module controlUnit (
    input              clk,
    input              reset,
    output logic       RFSrcMuxSel,
    output logic [1:0] ALU_OP,
    output logic [2:0] raddr1,
    output logic [2:0] raddr2,
    output logic [2:0] waddr,
    output logic       we,
    output logic       OutLoad
);


    enum logic [3:0] { S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11 } state, state_next;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= S0;
        else state <= state_next;
    end

    always_comb begin
        state_next = state;
        case (state)
            S0: state_next = S1;
            S1: state_next = S2;
            S2: state_next = S3;
            S3: state_next = S4;
            S4: state_next = S5;
            S5: state_next = S6;
            S6: state_next = S7;
            S7: state_next = S8;
            S8: state_next = S9;
            S9: state_next = S10;
            S10: state_next = S11;
            S11: state_next = S11;
            default: state_next = state;
        endcase
    end

    always_comb begin
        RFSrcMuxSel = 1'd0;
        ALU_OP      = 2'd0;
        raddr1      = 3'd0;
        raddr2      = 3'd0;
        waddr       = 3'd0;
        we          = 1'd0;
        OutLoad     = 1'd0;

        case (state)
            S0: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd1;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S1: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd2;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S2: begin
                RFSrcMuxSel = 1'd1;
                ALU_OP      = 2'd0;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd3;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S3: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd1;
                raddr2      = 3'd3;
                waddr       = 3'd1;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S4: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd2;
                raddr2      = 3'd3;
                waddr       = 3'd2;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S5: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd1;
                raddr1      = 3'd1;
                raddr2      = 3'd2;
                waddr       = 3'd3;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S6: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd2;
                raddr1      = 3'd1;
                raddr2      = 3'd3;
                waddr       = 3'd4;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S7: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd3;
                raddr1      = 3'd2;
                raddr2      = 3'd3;
                waddr       = 3'd5;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S8: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd1;
                raddr2      = 3'd2;
                waddr       = 3'd6;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end

            S9: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd2;
                raddr2      = 3'd6;
                waddr       = 3'd7;
                we          = 1'd1;
                OutLoad     = 1'd0;
            end
            S10: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd7;
                raddr2      = 3'd0;
                waddr       = 3'd0;
                we          = 1'd0;
                OutLoad     = 1'd1;
            end

            S11: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd0;
                we          = 1'd0;
                OutLoad     = 1'd0;
            end
            default: begin
                RFSrcMuxSel = 1'd0;
                ALU_OP      = 2'd0;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd0;
                we          = 1'd0;
                OutLoad     = 1'd0;
            end
        endcase

    end


endmodule
