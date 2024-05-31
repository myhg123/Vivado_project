`timescale 1ns / 1ps


module controlUnit (
    input              clk,
    input              reset,
    output logic       RFSrcMuxSel,
    output logic [1:0] raddr1,
    output logic [1:0] raddr2,
    output logic [1:0] waddr,
    output logic       we,
    output logic       OutLoad,
    input              LE10
);

    enum logic [2:0] {
        S0,
        S1,
        S2,
        S3,
        S4,
        S5,
        S6,
        S7
    }
        state, state_next;

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
            S3: begin
                if (LE10) state_next = S4;
                else state_next = S7;
            end
            S4: state_next = S5;
            S5: state_next = S6;
            S6: state_next = S3;
            S7: state_next = S7;
            default: state_next = state;
        endcase
    end

    always_comb begin
        RFSrcMuxSel = 0;
        raddr1      = 2'd0;
        raddr2      = 2'd0;
        waddr       = 2'd0;
        we          = 0;
        OutLoad     = 0;

        case (state)
            S0: begin
                RFSrcMuxSel = 0;
                raddr1      = 2'd0;
                raddr2      = 2'd0;
                waddr       = 2'd1;
                we          = 1;
                OutLoad     = 0;
            end

            S1: begin
                RFSrcMuxSel = 0;
                raddr1      = 2'd0;
                raddr2      = 2'd0;
                waddr       = 2'd2;
                we          = 1;
                OutLoad     = 0;
            end

            S2: begin
                RFSrcMuxSel = 1;
                raddr1      = 2'd0;
                raddr2      = 2'd0;
                waddr       = 2'd3;
                we          = 1;
                OutLoad     = 0;
            end

            S3: begin
                RFSrcMuxSel = 0;
                raddr1      = 2'd1;
                raddr2      = 2'd0;
                waddr       = 2'd0;
                we          = 0;
                OutLoad     = 0;
            end


            S4: begin
                RFSrcMuxSel = 0;
                raddr1      = 2'd1;
                raddr2      = 2'd2;
                waddr       = 2'd2;
                we          = 1;
                OutLoad     = 0;
            end



            S5: begin
                RFSrcMuxSel = 0;
                raddr1      = 2'd1;
                raddr2      = 2'd3;
                waddr       = 2'd1;
                we          = 1;
                OutLoad     = 0;
            end

            S6: begin
                RFSrcMuxSel = 0;
                raddr1      = 2'd2;
                raddr2      = 2'd0;
                waddr       = 2'd0;
                we          = 0;
                OutLoad     = 1;
            end

            S7: begin
                RFSrcMuxSel = 0;
                raddr1      = 2'd0;
                raddr2      = 2'd0;
                waddr       = 2'd0;
                we          = 0;
                OutLoad     = 0;
            end
            default: begin
                RFSrcMuxSel = 0;
                raddr1      = 2'd0;
                raddr2      = 2'd0;
                waddr       = 2'd0;
                we          = 0;
                OutLoad     = 0;
            end

        endcase

    end

endmodule
