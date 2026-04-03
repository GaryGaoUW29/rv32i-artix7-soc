`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/29 18:23:26
// Design Name: 
// Module Name: pipe_ex_mem
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


module pipe_ex_mem (
    input clk,
    input rst_n,
    input flush,
    input stall,

    input [31:0] ex_pc_i,
    input [31:0] ex_wdata_i,
    input ex_mem_rw_i,
    input ex_reg_wen_i,
    input [4:0] ex_rd_i,
    input [1:0] ex_wb_sel_i,
    input [31:0] ex_alu_res_i,
    input [2:0] ex_funct3_i,

    output reg [31:0] mem_pc_o,
    output reg [31:0] mem_wdata_o,
    output reg mem_mem_rw_o,
    output reg mem_reg_wen_o,
    output reg [4:0] mem_rd_o,
    output reg [1:0] mem_wb_sel_o,
    output reg [31:0] mem_alu_res_o,
    output reg [2:0] mem_funct3_o,

    // frwarding signals
    input [4:0] ex_raddr2_i,
    output reg [4:0] mem_raddr2_o
);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            mem_pc_o <= 32'b0;
            mem_wdata_o <= 32'b0;
            mem_mem_rw_o <= 1'b0;
            mem_reg_wen_o <= 1'b0;
            mem_rd_o <= 5'b00000;
            mem_wb_sel_o <= 2'b00;
            mem_alu_res_o <= 32'b0;
            mem_funct3_o <= 3'b000;
            mem_raddr2_o <= 5'b00000;
        end else if (flush) begin
            mem_pc_o <= 32'b0;
            mem_wdata_o <= 32'b0;
            mem_mem_rw_o <= 1'b0;
            mem_reg_wen_o <= 1'b0;
            mem_rd_o <= 5'b00000;
            mem_wb_sel_o <= 2'b00;
            mem_alu_res_o <= 32'b0;
            mem_funct3_o <= 3'b000;
            mem_raddr2_o <= 5'b00000;
        end else if (!stall) begin
            mem_pc_o <= ex_pc_i;
            mem_wdata_o <= ex_wdata_i;
            mem_mem_rw_o <= ex_mem_rw_i;
            mem_reg_wen_o <= ex_reg_wen_i;
            mem_rd_o <= ex_rd_i;
            mem_wb_sel_o <= ex_wb_sel_i;
            mem_alu_res_o <= ex_alu_res_i;
            mem_funct3_o <= ex_funct3_i;
            mem_raddr2_o <= ex_raddr2_i;
        end
    end
endmodule
