`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 15:22:10
// Design Name: 
// Module Name: id_stage
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

module id_stage (
    input clk,
    input rst_n,
    input [31:0] inst,
    input [31:0] wdata,

    output [ 6:0] opcode,
    output [ 4:0] rd,
    output [ 2:0] funct3,
    output [31:0] rdata1,
    output [31:0] rdata2,
    output [31:0] imm,

    output       reg_wen,
    output       a_sel,
    output       b_sel,
    output [3:0] alu_sel,
    output       mem_rw,
    output [1:0] wb_sel,
    output       pc_sel
);

    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign rd = inst[11:7];
    wire [4:0] raddr1 = inst[19:15];
    wire [4:0] raddr2 = inst[24:20];
    wire br_en;

    regfile u_regfile (
        .clk   (clk),
        .rst_n (rst_n),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rdata1(rdata1),
        .rdata2(rdata2),

        .we   (reg_wen),
        .waddr(rd),
        .wdata(wdata)
    );

    branch_comp u_branch_comp (
        .funct3(funct3),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .br_en (br_en)
    );

    imm_gen u_imm_gen (
        .inst   (inst),
        .imm_sel(opcode),
        .imm    (imm)
    );

    control_logic u_control_logic (
        .inst   (inst),
        .br_en  (br_en),
        .reg_wen(reg_wen),
        .a_sel  (a_sel),
        .b_sel  (b_sel),
        .alu_sel(alu_sel),
        .mem_rw (mem_rw),
        .wb_sel (wb_sel),
        .pc_sel (pc_sel)
    );

endmodule
