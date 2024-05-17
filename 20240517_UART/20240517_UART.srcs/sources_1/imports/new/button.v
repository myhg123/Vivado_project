`timescale 1ns / 1ps

module button(
    input clk,
    input in,
    output out
    );

    localparam N = 64;
    
    reg [N-1 : 0] q_reg, q_next;
    wire w_debounce_out;
    reg [1:0] dff_reg, dff_next;

    // debounce circuit
    always @(*) begin
        q_next = {q_reg[N-2:0], in}; // left shift
    end 

    //current state register
    always @(posedge clk) begin
        q_reg <= q_next;
    end

    //current state register
    always @(posedge clk) begin
        dff_reg <= dff_next;
    end


    assign w_debounce_out = &q_reg; 

    always @(*) begin
        dff_next[0] = w_debounce_out;
        dff_next[1] = dff_reg[0];
    end

    assign out = ~dff_reg[0] & dff_reg[1];

endmodule
