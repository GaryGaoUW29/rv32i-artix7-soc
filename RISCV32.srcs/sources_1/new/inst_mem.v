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

    initial begin
        // Test Instructions
        // 1. I-Type and R-Type ALU Operations
        rom[0] = 32'h00a00093;  // addi x1, x0, 10   (x1 = 10)
        rom[1] = 32'h01400113;  // addi x2, x0, 20   (x2 = 20)
        rom[2] = 32'h002081b3;  // add  x3, x1, x2   (x3 = 10 + 20 = 30)
        rom[3] = 32'h40110233;  // sub  x4, x2, x1   (x4 = 20 - 10 = 10)
        rom[4] = 32'h0041f2b3;  // and  x5, x3, x4   (x5 = 30 & 10 = 10)

        // 2. Memory Operations (Load/Store)
        rom[5] = 32'h00502023;  // sw   x5, 0(x0)    (mem[0] = x5 = 10)
        rom[6] = 32'h00002303;  // lw   x6, 0(x0)    (x6 = mem[0] = 10)

        // 3. Branch Operations
        rom[7] = 32'h00620463;  // beq  x4, x6, 8    (Branch if x4 == x6 to PC+8. 10 == 10, so jump to rom[9])
        rom[8] = 32'h00100393;  // addi x7, x0, 1    (This instruction should be skipped!)

        // 4. Branch Target & End Loop
        rom[9] = 32'h00200413;  // addi x8, x0, 2    (Branch landed successfully: x8 = 2)
        rom[10] = 32'hfe000ee3; // beq  x0, x0, -4   (Infinite loop: PC = PC - 4 -> Jump back to rom[9])
    end

    assign inst = rom[pc_addr[31:2]];
endmodule
