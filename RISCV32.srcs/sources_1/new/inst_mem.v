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

        // --- 终极无冒险数据通路测试 (Ultimate Hazard-Free Datapath Test) ---
        // 严格遵循 3-NOP 间距隔离，测试 I-Type, R-Type, Load/Store 和 Branch!

        // 1. 初始化寄存器 (I-Type)
        rom[0]  = 32'h01100093; // addi x1, x0, 0x11 (17)
        rom[1]  = 32'h02200113; // addi x2, x0, 0x22 (34)
        rom[2]  = 32'h00000013; // nop
        rom[3]  = 32'h00000013; // nop
        rom[4]  = 32'h00000013; // nop
        
        // 2. 算术运算 (R-Type) ---> 读取 x1, x2，此时它们早就在 WB 写完了
        rom[5]  = 32'h002081b3; // add  x3, x1, x2   (x3 应为 0x11 + 0x22 = 0x33)
        rom[6]  = 32'h00000013; // nop
        rom[7]  = 32'h00000013; // nop
        rom[8]  = 32'h00000013; // nop

        // 3. 内存写入 (S-Type) ---> 将 x3 存入门牌号为 4 的内存
        rom[9]  = 32'h00302223; // sw   x3, 4(x0)    (DataMem[4] 应为 0x33)
        rom[10] = 32'h00000013; // nop
        rom[11] = 32'h00000013; // nop
        rom[12] = 32'h00000013; // nop

        // 4. 内存读取 (I-Type Load) ---> 从门牌号为 4 的内存取出数据到 x4
        rom[13] = 32'h00402203; // lw   x4, 4(x0)    (x4 应为 0x33)
        rom[14] = 32'h00000013; // nop
        rom[15] = 32'h00000013; // nop
        rom[16] = 32'h00000013; // nop

        // 5. 综合混合测试 (R-Type Sub) ---> x5 = x4(0x33) - x1(0x11)
        rom[17] = 32'h401202b3; // sub  x5, x4, x1   (x5 应为 0x22)
        rom[18] = 32'h00000013; // nop
        rom[19] = 32'h00000013; // nop
        rom[20] = 32'h00000013; // nop

        // 6. 安全驻留 (B-Type) ---> 死循环，避开分支预测污染
        rom[21] = 32'h00000063; // beq  x0, x0, 0    (原地转圈 PC=84)
    end

    assign inst = rom[pc_addr[31:2]];
endmodule
