`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/29 08:38:59
// Design Name: 
// Module Name: ex_stage
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


module ex_stage (
    // Inputs from IF stage
    input [31:0] ex_pc_i,     // pass to WB
    input [31:0] ex_rdata1_i, // used for ALU op1 and branch comp
    input [31:0] ex_rdata2_i, // used for ALU op2 and branch comp
    input [31:0] ex_imm_i,    // used for ALU op2

    input       ex_a_sel_i,      // used for ALU op1 selection
    input       ex_b_sel_i,      // used for ALU op2 selection
    input [3:0] ex_alu_sel_i,    // used for ALU operation selection
    input       ex_mem_rw_i,     // pass to M
    input       ex_reg_wen_i,    // pass to ID 
    input [4:0] ex_rd_i,         // pass to ID
    input [1:0] ex_wb_sel_i,     // pass to M and WB
    input       ex_is_jump_i,    // used to determine pc_sel in IF stage
    input       ex_is_branch_i,  // used to determine pc_sel in IF stage
    input [2:0] ex_funct3_i,     // pass to M and used for branch comp

    // Outputs to MEM stage (New signals)
    output [31:0] ex_alu_res_o,

    // For Branch and Jump in IF stage
    output if_pc_sel_o,
    output [31:0] if_jump_addr_o
);

    wire [31:0] ex_alu_op1 = (ex_a_sel_i) ? ex_pc_i : ex_rdata1_i;
    wire [31:0] ex_alu_op2 = (ex_b_sel_i) ? ex_imm_i : ex_rdata2_i;
    wire ex_br_en;

    branch_comp u_branch_comp (
        .funct3(ex_funct3_i),
        .rdata1(ex_rdata1_i),
        .rdata2(ex_rdata2_i),
        .br_en (ex_br_en)
    );

    alu u_alu (
        .op1    (ex_alu_op1),
        .op2    (ex_alu_op2),
        .alu_sel(ex_alu_sel_i),
        .alu_res(ex_alu_res_o)
    );

    // Determine the next PC in IF stage
    // The if_pc_sel_flush will also be used as flush signal for IF/ID pipeline register, 
    // to flush the wrong path instruction when branch taken or jump
    assign if_pc_sel_o = (ex_is_jump_i || (ex_is_branch_i && ex_br_en)) ? 1'b1 : 1'b0;
    assign if_jump_addr_o = {ex_alu_res_o[31:1], 1'b0}; // Last bit is always 0 since instructions are 2 or 4 byte aligned

endmodule
