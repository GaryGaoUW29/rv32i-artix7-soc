`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/28 19:02:48
// Design Name: 
// Module Name: pipe_id_ex
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


module pipe_id_ex (
    // Every pipeline register needs clk, rst_n, flush and stall
    input clk,
    input rst_n,
    input flush,
    input stall,

    // Information from ID stage for ALU to use in EX stage
    input [31:0] id_pc_i,
    input [31:0] id_rdata1_i,
    input [31:0] id_rdata2_i,
    input [31:0] id_imm_i,

    output reg [31:0] ex_pc_o,
    output reg [31:0] ex_rdata1_o,
    output reg [31:0] ex_rdata2_o,
    output reg [31:0] ex_imm_o,

    // Control signals from ID stage to EX stage
    input       id_a_sel_i,
    input       id_b_sel_i,
    input [3:0] id_alu_sel_i,
    input       id_mem_rw_i,
    input       id_reg_wen_i,
    input [4:0] id_rd_i,
    input [1:0] id_wb_sel_i,
    input       id_is_jump_i,
    input       id_is_branch_i,
    input [2:0] id_funct3_i,

    output reg       ex_a_sel_o,
    output reg       ex_b_sel_o,
    output reg [3:0] ex_alu_sel_o,
    output reg       ex_mem_rw_o,
    output reg       ex_reg_wen_o,
    output reg [4:0] ex_rd_o,
    output reg [1:0] ex_wb_sel_o,
    output reg       ex_is_jump_o,
    output reg       ex_is_branch_o,
    output reg [2:0] ex_funct3_o,

    // forwarding signals
    input [4:0] id_raddr1_i,
    input [4:0] id_raddr2_i,
    output reg [4:0] ex_raddr1_o,
    output reg [4:0] ex_raddr2_o
);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            ex_pc_o <= 32'b0;
            ex_rdata1_o <= 32'b0;
            ex_rdata2_o <= 32'b0;
            ex_imm_o <= 32'b0;
            ex_a_sel_o <= 1'b0;
            ex_b_sel_o <= 1'b0;
            ex_alu_sel_o <= 4'b0000;
            ex_mem_rw_o <= 1'b0;
            ex_reg_wen_o <= 1'b0;
            ex_rd_o <= 5'b00000;
            ex_wb_sel_o <= 2'b01;
            ex_is_jump_o <= 1'b0;
            ex_is_branch_o <= 1'b0;
            ex_funct3_o <= 3'b000;
            ex_raddr1_o <= 5'b00000;
            ex_raddr2_o <= 5'b00000;
        end else if (flush) begin
            ex_pc_o <= 32'b0;
            ex_rdata1_o <= 32'b0;
            ex_rdata2_o <= 32'b0;
            ex_imm_o <= 32'b0;
            ex_a_sel_o <= 1'b0;
            ex_b_sel_o <= 1'b0;
            ex_alu_sel_o <= 4'b0000;
            ex_mem_rw_o <= 1'b0;
            ex_reg_wen_o <= 1'b0;
            ex_rd_o <= 5'b00000;
            ex_wb_sel_o <= 2'b01;
            ex_is_jump_o <= 1'b0;
            ex_is_branch_o <= 1'b0;
            ex_funct3_o <= 3'b000;
            ex_raddr1_o <= 5'b00000;
            ex_raddr2_o <= 5'b00000;
        end else if (!stall) begin
            ex_pc_o <= id_pc_i;
            ex_rdata1_o <= id_rdata1_i;
            ex_rdata2_o <= id_rdata2_i;
            ex_imm_o <= id_imm_i;
            ex_a_sel_o <= id_a_sel_i;
            ex_b_sel_o <= id_b_sel_i;
            ex_alu_sel_o <= id_alu_sel_i;
            ex_mem_rw_o <= id_mem_rw_i;
            ex_reg_wen_o <= id_reg_wen_i;
            ex_rd_o <= id_rd_i;
            ex_wb_sel_o <= id_wb_sel_i;
            ex_is_jump_o <= id_is_jump_i;
            ex_is_branch_o <= id_is_branch_i;
            ex_funct3_o <= id_funct3_i;
            ex_raddr1_o <= id_raddr1_i;
            ex_raddr2_o <= id_raddr2_i;
        end
    end

endmodule
