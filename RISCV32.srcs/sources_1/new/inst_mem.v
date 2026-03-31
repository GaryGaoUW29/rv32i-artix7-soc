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
            rom[i] = 32'h00000013; // Fill with nop natively
        end

        rom[0] = 32'h01100093; // addi x1, x0, 17
        rom[1] = 32'h02200113; // addi x2, x0, 34
        rom[2] = 32'h03300193; // addi x3, x0, 51
        rom[3] = 32'h04400213; // addi x4, x0, 68
        rom[4] = 32'h05500293; // addi x5, x0, 85
        rom[5] = 32'h06600313; // addi x6, x0, 102
        rom[6] = 32'h07700393; // addi x7, x0, 119
        rom[7] = 32'h07f00413; // addi x8, x0, 127
        rom[8] = 32'h123454b7; // lui x9, 0x12345
        rom[9] = 32'h00001517; // auipc x10, 0x1
        rom[10] = 32'h00000013; // nop
        rom[11] = 32'h00000013; // nop
        rom[12] = 32'h00000013; // nop
        rom[13] = 32'h002085b3; // add x11, x1, x2
        rom[14] = 32'h40320633; // sub x12, x4, x3
        rom[15] = 32'h0062f6b3; // and x13, x5, x6
        rom[16] = 32'h00736733; // or x14, x6, x7
        rom[17] = 32'h0083c7b3; // xor x15, x7, x8
        rom[18] = 32'h00111833; // sll x16, x2, x1
        rom[19] = 32'h001458b3; // srl x17, x8, x1
        rom[20] = 32'h40145933; // sra x18, x8, x1
        rom[21] = 32'h0020a9b3; // slt x19, x1, x2
        rom[22] = 32'h00113a33; // sltu x20, x2, x1
        rom[23] = 32'h00000013; // nop
        rom[24] = 32'h00000013; // nop
        rom[25] = 32'h00000013; // nop
        rom[26] = 32'h00558a93; // addi x21, x11, 5
        rom[27] = 32'h03f77b13; // andi x22, x14, 63
        rom[28] = 32'h0807eb93; // ori x23, x15, 128
        rom[29] = 32'h05584c13; // xori x24, x16, 85
        rom[30] = 32'h00062c93; // slti x25, x12, 0
        rom[31] = 32'h06463d13; // sltiu x26, x12, 100
        rom[32] = 32'h00309d93; // slli x27, x1, 3
        rom[33] = 32'h00245e13; // srli x28, x8, 2
        rom[34] = 32'h40245e93; // srai x29, x8, 2
        rom[35] = 32'h00148f13; // addi x30, x9, 1
        rom[36] = 32'h00450f93; // addi x31, x10, 4
        rom[37] = 32'h00b02023; // sw x11, 0(x0)
        rom[38] = 32'h00c01223; // sh x12, 4(x0)
        rom[39] = 32'h00d00323; // sb x13, 6(x0)
        rom[40] = 32'h00e02423; // sw x14, 8(x0)
        rom[41] = 32'h00f01623; // sh x15, 12(x0)
        rom[42] = 32'h01000723; // sb x16, 14(x0)
        rom[43] = 32'h00000013; // nop
        rom[44] = 32'h00000013; // nop
        rom[45] = 32'h00000013; // nop
        rom[46] = 32'h00002283; // lw x5, 0(x0)
        rom[47] = 32'h00401303; // lh x6, 4(x0)
        rom[48] = 32'h00600383; // lb x7, 6(x0)
        rom[49] = 32'h00405403; // lhu x8, 4(x0)
        rom[50] = 32'h00604483; // lbu x9, 6(x0)
        rom[51] = 32'h00802503; // lw x10, 8(x0)
        rom[52] = 32'h00c01583; // lh x11, 12(x0)
        rom[53] = 32'h00e00603; // lb x12, 14(x0)
        rom[54] = 32'h00208463; // beq x1, x2, +8
        rom[55] = 32'h00319463; // bne x3, x3, +8
        rom[56] = 32'h00124463; // blt x4, x1, +8
        rom[57] = 32'h0020d463; // bge x1, x2, +8
        rom[58] = 32'h00116463; // bltu x2, x1, +8
        rom[59] = 32'h0020f463; // bgeu x1, x2, +8
        rom[60] = 32'h00a286b3; // add x13, x5, x10
        rom[61] = 32'h40c58733; // sub x14, x11, x12
        rom[62] = 32'h008377b3; // and x15, x6, x8
        rom[63] = 32'h0093e833; // or x16, x7, x9
        rom[64] = 32'h0062c8b3; // xor x17, x5, x6
        rom[65] = 32'h00129933; // sll x18, x5, x1
        rom[66] = 32'h001559b3; // srl x19, x10, x1
        rom[67] = 32'h00c5aa33; // slt x20, x11, x12
        rom[68] = 32'h00d02823; // sw x13, 16(x0)
        rom[69] = 32'h00e02a23; // sw x14, 20(x0)
        rom[70] = 32'h00f02c23; // sw x15, 24(x0)
        rom[71] = 32'h01002e23; // sw x16, 28(x0)
        rom[72] = 32'h00000013; // nop
        rom[73] = 32'h00000013; // nop
        rom[74] = 32'h00000013; // nop
        rom[75] = 32'h01002a83; // lw x21, 16(x0)
        rom[76] = 32'h01402b03; // lw x22, 20(x0)
        rom[77] = 32'h01802b83; // lw x23, 24(x0)
        rom[78] = 32'h01c02c03; // lw x24, 28(x0)
        rom[79] = 32'h00000013; // nop
        rom[80] = 32'h00000013; // nop
        rom[81] = 32'h00000013; // nop
        rom[82] = 32'h001a8c93; // addi x25, x21, 1
        rom[83] = 32'h0ffb7d13; // andi x26, x22, 255
        rom[84] = 32'h001bed93; // ori x27, x23, 1
        rom[85] = 32'h003c4e13; // xori x28, x24, 3
        rom[86] = 32'h000aae93; // slti x29, x21, 0
        rom[87] = 32'h0c8b3f13; // sltiu x30, x22, 200
        rom[88] = 32'h001a9f93; // slli x31, x21, 1
        rom[89] = 32'h001b5293; // srli x5, x22, 1
        rom[90] = 32'h401bd313; // srai x6, x23, 1
        rom[91] = 32'h01ac8463; // beq x25, x26, +8
        rom[92] = 32'h01bd9463; // bne x27, x27, +8
        rom[93] = 32'h0010c463; // blt x1, x1, +8
        rom[94] = 32'h00315463; // bge x2, x3, +8
        rom[95] = 32'h00426463; // bltu x4, x4, +8
        rom[96] = 32'h0020f463; // bgeu x1, x2, +8
        rom[97] = 32'h00100093; // addi x1, x0, 1
        rom[98] = 32'h00200113; // addi x2, x0, 2
        rom[99] = 32'h00000013; // nop
    end

    assign inst = rom[pc_addr[31:2]];
endmodule
