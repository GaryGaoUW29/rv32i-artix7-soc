`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 15:22:10
// Design Name: Gary Gao
// Module Name: id_stage
// Project Name: RV32I
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Finaled sigle cycle RV32I cpu, all the control signals are generated in ID stage
// Revision 0.03 - Impoved to pipelined version
//               - Moved the branch_comp to EX stage, and output is_jump, is_branch and funct3 to EX stage for branch comp
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module id_stage (
    input clk,
    input rst_n,
    input [31:0] id_inst_i,
    input [31:0] id_pc_i,

    // From WriteBack Stage: 
    input wb_wen_i,
    input [4:0] wb_waddr_i,
    input [31:0] wb_wdata_i,

    // Outputs for internal wireing and forwarding in top
    output [ 6:0] id_opcode_o,
    output [ 4:0] id_rd_o,
    output [31:0] id_rdata1_o,
    output [31:0] id_rdata2_o,
    output [31:0] id_imm_o,

    // To Control Logic and ID/EX Pipeline Register
    output       id_reg_wen_o,
    output       id_a_sel_o,
    output       id_b_sel_o,
    output [3:0] id_alu_sel_o,
    output       id_mem_rw_o,
    output [1:0] id_wb_sel_o,

    // For Branch and Jump in AlU/ EX Stage
    output id_is_jump_o,
    output id_is_branch_o,
    output [2:0] id_funct3_o

);

    assign id_opcode_o = id_inst_i[6:0];
    assign id_funct3_o = id_inst_i[14:12];
    assign id_rd_o = id_inst_i[11:7];
    wire [4:0] id_raddr1 = id_inst_i[19:15];
    wire [4:0] id_raddr2 = id_inst_i[24:20];

    regfile u_regfile (
        .clk   (clk),
        .rst_n (rst_n),
        .raddr1(id_raddr1),
        .raddr2(id_raddr2),
        .rdata1(id_rdata1_o),
        .rdata2(id_rdata2_o),

        .we   (wb_wen_i),
        .waddr(wb_waddr_i),
        .wdata(wb_wdata_i)
    );

    imm_gen u_imm_gen (
        .inst   (id_inst_i),
        .imm_sel(id_opcode_o),
        .imm    (id_imm_o)
    );

    control_logic u_control_logic (
        .inst     (id_inst_i),
        .reg_wen  (id_reg_wen_o),
        .a_sel    (id_a_sel_o),
        .b_sel    (id_b_sel_o),
        .alu_sel  (id_alu_sel_o),
        .mem_rw   (id_mem_rw_o),
        .wb_sel   (id_wb_sel_o),
        .is_jump  (id_is_jump_o),
        .is_branch(id_is_branch_o)
    );

endmodule
