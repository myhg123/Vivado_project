`timescale 1ns / 1ps


module Instruction_Memory (
    input  logic [31:0] addr,
    output logic [31:0] data
);

    logic [31:0] rom[0:63];

    initial begin
        // rom[0]  = 32'h00520333;  // add x6, x4, x5
        // rom[1]  = 32'h401183b3;  // sub x7, x3, x1
        // rom[2]  = 32'h0020f433;  // and x8, x1, x2 =>0
        // rom[3]  = 32'h0020e4b3;  // or x9, x1, x2 =>0
        // rom[4]  = 32'h00329533;  // sll x10, x5, x3
        // rom[5]  = 32'h0012d5b3;  // srl x11, x5, x1
        // rom[6]  = 32'h40355633;  // sra x12, x10, x3
        // rom[7]  = 32'h004126b3;  // slt x13, x2, x4
        // rom[8]  = 32'h00223733;  // sltu x14, x4, x2
        // rom[9]  = 32'h002247b3;  // xor x15, x4, x2
        // ///////////////////////////////////////////////
        // rom[10] = 32'h01e02803;  // lw x16, 30(x0)
        // ///////////////////////////////////////////////
        // rom[11] = 32'h0c818893;  // addi x17, x3, 200
        // rom[12] = 32'h06d82913;  // slti x18, x16, 109
        // rom[13] = 32'h06a83993;  // sltiu x19, x16, 106
        // rom[14] = 32'h02e84a13;  // xori x20, x16, 46
        // rom[15] = 32'h06636a93;  // ori x21, x6, 102
        // rom[16] = 32'h00637b13;  // andi x22, x6, 6
        // rom[17] = 32'h01909b93;  // slli x23, x1, 25
        // rom[18] = 32'h00485c13;  // srli x24, x16, 4
        // rom[19] = 32'h40485c93;  // srai x25, x16, 4
        // //////////////////////////////////////////////
        // rom[20] = 32'h09702023;  // sw x23, 128(x0)
        // //////////////////////////////////////////////
        // rom[21] = 32'h00710663;  // beq x2, x7, 12  3pc jump
        // rom[24] = 32'h00711663;  // bne x2, x7, 12
        // rom[25] = 32'h00314663;  // blt x2, x3, 12  3pc jump
        // rom[28] = 32'h0021d663;  // bge x3, x2, 12 
        // rom[31] = 32'h0021e663;  // bltu x3, x2, 12
        // rom[32] = 32'h00317663;  // bgeu x2, x3, 12
        // rom[33] = 32'h00fffd37;  // lui x26, 4095
        // rom[34] = 32'h00003d97;  // auipc x27, 3
        // //////////////////////////////////////////////
        // rom[35] = 32'h00c00e6f;  // jal x28, 12
        // rom[38] = 32'h00c00ee7;  // jalr x29, 12(x0)
        
       $readmemh("inst.mem", rom);// instruction hexa 
    end

    assign data = rom[addr[31:2]];

endmodule
