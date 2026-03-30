`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 11:23:44
// Design Name: 
// Module Name: inst_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module inst_mem (
    input  [31:0] pc_addr,
    output [31:0] inst
);

    reg [31:0] rom[0:1023];
    
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            rom[i] = 32'h00000013; 
        end

        rom[0]  = 32'h00000093; // addi x1, x0, 0
        rom[1]  = 32'h00100113; // addi x2, x0, 1
        rom[2]  = 32'h00200193; // addi x3, x0, 2
        rom[3]  = 32'h00300213; // addi x4, x0, 3
        rom[4]  = 32'h00400293; // addi x5, x0, 4
        rom[5]  = 32'h00500313; // addi x6, x0, 5
        rom[6]  = 32'h00600393; // addi x7, x0, 6
        rom[7]  = 32'h00700413; // addi x8, x0, 7
        rom[8]  = 32'h00800493; // addi x9, x0, 8
        rom[9]  = 32'h00900513; // addi x10, x0, 9
        
        rom[10] = 32'h00208a33; // add x20, x1, x2  
        rom[11] = 32'h014a8ab3; // add x21, x21, x20 
        rom[12] = 32'h015b0b33; // add x22, x22, x21 
        rom[13] = 32'h401b0bb3; // sub x23, x22, x1  
        rom[14] = 32'h017b7c33; // and x24, x22, x23
        rom[15] = 32'h018c6cb3; // or  x25, x24, x24
        rom[16] = 32'h019ccfb3; // xor x26, x25, x25
        rom[17] = 32'h002d1d33; // sll x26, x26, x2
        rom[18] = 32'h002d5db3; // srl x27, x26, x2
        rom[19] = 32'h402dddb3; // sra x27, x27, x2
        rom[20] = 32'h01bc2e33; // slt x28, x24, x28
        rom[21] = 32'h01bd3eb3; // sltu x29, x26, x29


        rom[22] = 32'h0ff00093; // addi x1, x0, 255
        rom[23] = 32'h7ff00113; // addi x2, x0, 2047
        rom[24] = 32'h80000193; // addi x3, x0, -2048 (Sign-Ext Edge Case)
        rom[25] = 32'h12345637; // lui x12, 0x12345
        rom[26] = 32'h67860613; // addi x12, x12, 0x678
        rom[27] = 32'h00000697; // auipc x13, 0 (x13 = PC)
        rom[28] = 32'h01068693; // addi x13, x13, 16

        rom[29] = 32'h00000713; // li x14, 0
        rom[30] = 32'h00172023; // sw x1, 0(x14)    (mem[0] = 255)
        rom[31] = 32'h00272223; // sw x2, 4(x14)    (mem[4] = 2047)
        rom[32] = 32'h00072783; // lw x15, 0(x14)   (x15 = 255)
        rom[33] = 32'h00f78833; // add x16, x15, x15 
        rom[34] = 32'h00472883; // lw x17, 4(x14)   (x17 = 2047)
        rom[35] = 32'hfe172ae3; // sw x1, -4(x14)   (Negative offset address calc)

        rom[36] = 32'h00000813; // li x16, 0
        rom[37] = 32'h00100893; // li x17, 1
        rom[38] = 32'h01180463; // beq x16, x17, 8   (False: Next)
        rom[39] = 32'h00180813; // addi x16, x16, 1  (x16 = 1)
        rom[40] = 32'h01180463; // beq x16, x17, 8   (True: Jump to PC+8)
        rom[41] = 32'hdeadb0b7; // lui x1, 0xdeadb   (Poison: Should be skipped)
        rom[42] = 32'h00181893; // slli x17, x16, 1  (Landing Site)
        rom[43] = 32'h00a000ef; // jal x1, 10        (Jump forward, save PC in x1)
        rom[44] = 32'hdeadb0b7; // lui x1, 0xdeadb   (Poison: Should be skipped)
        rom[45] = 32'h00008067; // jalr x0, 0(x1)    (Return jump)

        rom[46] = 32'h0000006f; // jal x0, 0         (Infinite Loop/Trap)
    end

    assign inst = rom[pc_addr[31:2]];

endmodule