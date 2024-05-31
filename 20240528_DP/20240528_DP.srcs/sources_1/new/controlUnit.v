`timescale 1ns / 1ps

module controlUnit (
    input      clk,
    input      reset,
    output reg ASrcMuxSel,
    output reg ALoad,
    output reg iSrcMuxSel,
    output reg iLoad,
    output reg outBufSel,
    input      iLt10

);
    localparam S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4 , S5 =3'd5;

    reg [2:0] state, state_next;

    always @(posedge clk, posedge reset) begin
        if (reset) state <= S0;
        else state <= state_next;
    end

    always @(*) begin
        state_next = state;
        case (state)
            S0: state_next = S1;
            S1: begin
                if (iLt10) state_next = S2;
                else state_next = S4;
            end
            S2: state_next = S3;
            S3: state_next = S5;
			S5: state_next =S1;
            S4: state_next = S0;
            default: state_next = S1;
        endcase
    end

    always @(*) begin
        ASrcMuxSel = 0;
        ALoad = 0;
		iSrcMuxSel = 0;
		iLoad = 0;
        outBufSel = 0;
        case (state)
            S0: begin
                ASrcMuxSel = 0;
                ALoad = 1;
				iSrcMuxSel = 0;
				iLoad = 1;
                outBufSel = 0;
            end
            S1: begin
                ASrcMuxSel = 1;
                ALoad = 0;
				iSrcMuxSel = 1;
				iLoad = 0;
                outBufSel = 0;
            end
            S2: begin
                ASrcMuxSel = 1;
                ALoad = 0;
				iSrcMuxSel = 1;
				iLoad = 0;
                outBufSel = 1;
            end
            S3: begin
                ASrcMuxSel = 0;
                ALoad = 0;
				iSrcMuxSel = 1;
				iLoad = 1;
                outBufSel = 0;
            end
            S4: begin
                ASrcMuxSel = 0;
                ALoad = 0;
				iSrcMuxSel = 0;
				iLoad = 0;
                outBufSel = 0;
            end

            S5: begin
                ASrcMuxSel = 1;
                ALoad = 1;
				iSrcMuxSel = 0;
				iLoad = 0;
                outBufSel = 0;
            end
            default: begin
                ASrcMuxSel = 0;
                ALoad = 0;
				iSrcMuxSel = 0;
				iLoad = 0;
                outBufSel = 0;
            end
        endcase
    end
endmodule
