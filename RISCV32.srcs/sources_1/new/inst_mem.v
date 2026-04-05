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
            rom[i] = 32'h00000013;  // Fill with nop natively
        end

        rom[0]  = 32'h00100093;  // addi x1, x0, 1     (x1=1)
        rom[1]  = 32'h00200113;  // addi x2, x0, 2     (x2=2)
        rom[2]  = 32'h00300193;  // addi x3, x0, 3     (x3=3)
        rom[3]  = 32'h00400213;  // addi x4, x0, 4     (x4=4)
        rom[4]  = 32'h002082b3;  // add x5, x1, x2     (EX-to-EX FW: x5=3)
        rom[5]  = 32'h40428333;  // sub x6, x5, x4     (EX-to-EX FW: x6=-1)
        rom[6]  = 32'h005303b3;  // add x7, x6, x5     (EX FW Op1&Op2: x7=2)
        rom[7]  = 32'h00000013;  // nop
        rom[8]  = 32'h00538433;  // add x8, x7, x5     (MEM/WB FW: x8=5)
        rom[9]  = 32'h00000013;  // nop
        rom[10] = 32'h00500013;  // addi x0, x0, 5     (Write x0 ignored)
        rom[11] = 32'h002004b3;  // add x9, x0, x2     (Must not FW 5! x9=2)
        rom[12] = 32'h00902023;  // sw x9, 0(x0)       (mem[0]=2)
        rom[13] = 32'h00002503;  // lw x10, 0(x0)      (x10=2)
        rom[14] = 32'h00a105b3;  // add x11, x2, x10   (Load-Use STALL! x11=4)
        rom[15] = 32'h00002603;  // lw x12, 0(x0)      (x12=2)
        rom[16] = 32'h00c02223;  // sw x12, 4(x0)      (MEM FW no stall! mem[4]=2)
        rom[17] = 32'h00b00693;  // addi x13, x0, 11
        rom[18] = 32'h00c00713;  // addi x14, x0, 12
        rom[19] = 32'h00e68463;  // beq x13, x14, +8   (11!=12 Not Taken)
        rom[20] = 32'h00100793;  // addi x15, x0, 1    (Executed)
        rom[21] = 32'h00d68663;  // beq x13, x13, +12  (11==11 Taken!)
        rom[22] = 32'h00000013;  // nop                (Flushed)
        rom[23] = 32'h00000013;  // nop                (Flushed)
        rom[24] = 32'h00200813;  // addi x16, x0, 2    (Executed via jump)
        rom[25] = 32'h00c000ef;  // jal x1, +12        (Absolute Jump)
        rom[26] = 32'h00000013;  // nop                (Flushed)
        rom[27] = 32'h00000013;  // nop                (Flushed)
        rom[28] = 32'h00000013;  // nop                (Executed)
        rom[29] = 32'h08400893;  // addi x17, x0, 132  (Target ADDR)
        rom[30] = 32'h00088967;  // jalr x18, 0(x17)   (JALR!)
        rom[31] = 32'h00000013;  // nop                (Flushed)
        rom[32] = 32'h00000013;  // nop                (Flushed)
        rom[33] = 32'h00000013;  // nop                (Flushed)
        rom[34] = 32'h00100993;  // addi x19, x0, 1    (Executed @ PC=132)

        
        rom[35] = 32'h00000013;  // nop                (Filler)
        rom[36] = 32'h00000013;  // nop                (Filler)
        rom[37] = 32'h00000013;  // nop                (Filler)
        rom[38] = 32'h00000013;  // nop                (Filler)
        rom[39] = 32'h00000013;  // nop                (Filler)
        rom[40] = 32'h00000013;  // nop                (Filler)
        rom[41] = 32'h00000013;  // nop                (Filler)
        rom[42] = 32'h00000013;  // nop                (Filler)
        rom[43] = 32'h00000013;  // nop                (Filler)
        rom[44] = 32'h00000013;  // nop                (Filler)
        rom[45] = 32'h00000013;  // nop                (Filler)
        rom[46] = 32'h00000013;  // nop                (Filler)
        rom[47] = 32'h00000013;  // nop                (Filler)
        rom[48] = 32'h00000013;  // nop                (Filler)
        rom[49] = 32'h00000013;  // nop                (Filler)
        rom[50] = 32'h00000013;  // nop                (Filler)
        rom[51] = 32'h00000013;  // nop                (Filler)
        rom[52] = 32'h00000013;  // nop                (Filler)
        rom[53] = 32'h00000013;  // nop                (Filler)
        rom[54] = 32'h00000013;  // nop                (Filler)
        rom[55] = 32'h00000013;  // nop                (Filler)
        rom[56] = 32'h00000013;  // nop                (Filler)
        rom[57] = 32'h00000013;  // nop                (Filler)
        rom[58] = 32'h00000013;  // nop                (Filler)
        rom[59] = 32'h00000013;  // nop                (Filler)
        rom[60] = 32'h00000013;  // nop                (Filler)
        rom[61] = 32'h00000013;  // nop                (Filler)
        rom[62] = 32'h00000013;  // nop                (Filler)
        rom[63] = 32'h00000013;  // nop                (Filler)
        rom[64] = 32'h00000013;  // nop                (Filler)
        rom[65] = 32'h00000013;  // nop                (Filler)
        rom[66] = 32'h00000013;  // nop                (Filler)
        rom[67] = 32'h00000013;  // nop                (Filler)
        rom[68] = 32'h00000013;  // nop                (Filler)
        rom[69] = 32'h00000013;  // nop                (Filler)
        rom[70] = 32'h00000013;  // nop                (Filler)
        rom[71] = 32'h00000013;  // nop                (Filler)
        rom[72] = 32'h00000013;  // nop                (Filler)
        rom[73] = 32'h00000013;  // nop                (Filler)
        rom[74] = 32'h00000013;  // nop                (Filler)
        rom[75] = 32'h00000013;  // nop                (Filler)
        rom[76] = 32'h00000013;  // nop                (Filler)
        rom[77] = 32'h00000013;  // nop                (Filler)
        rom[78] = 32'h00000013;  // nop                (Filler)
        rom[79] = 32'h00000013;  // nop                (Filler)
        rom[80] = 32'h00000013;  // nop                (Filler)
        rom[81] = 32'h00000013;  // nop                (Filler)
        rom[82] = 32'h00000013;  // nop                (Filler)
        rom[83] = 32'h00000013;  // nop                (Filler)
        rom[84] = 32'h00000013;  // nop                (Filler)
        rom[85] = 32'h00000013;  // nop                (Filler)
        rom[86] = 32'h00000013;  // nop                (Filler)
        rom[87] = 32'h00000013;  // nop                (Filler)
        rom[88] = 32'h00000013;  // nop                (Filler)
        rom[89] = 32'h00000013;  // nop                (Filler)
        rom[90] = 32'h00000013;  // nop                (Filler)
        rom[91] = 32'h00000013;  // nop                (Filler)
        rom[92] = 32'h00000013;  // nop                (Filler)
        rom[93] = 32'h00000013;  // nop                (Filler)
        rom[94] = 32'h00000013;  // nop                (Filler)
        rom[95] = 32'h00000013;  // nop                (Filler)
        rom[96] = 32'h00000013;  // nop                (Filler)
        rom[97] = 32'h00000013;  // nop                (Filler)
        rom[98] = 32'h00000013;  // nop                (Filler)
        rom[99] = 32'h00000013;  // nop                (Filler)
    end

    assign inst = rom[pc_addr[31:2]];
endmodule

