`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/29 19:22:57
// Design Name: 
// Module Name: pipe_mem_wb
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


module pipe_mem_wb (
    input clk,
    input rst_n,
    input flush,
    input stall,

    input [31:0] mem_pc_i,
    input [31:0] mem_alu_res_i,
    input [31:0] mem_rdata_i,
    input mem_reg_wen_i,
    input [4:0] mem_rd_i,
    input [1:0] mem_wb_sel_i,
    input [2:0] mem_funct3_i,

    output reg [31:0] wb_pc_o,
    output reg [31:0] wb_alu_res_o,
    output [31:0] wb_rdata_o,
    output reg wb_reg_wen_o,
    output reg [4:0] wb_rd_o,
    output reg [1:0] wb_wb_sel_o,
    output reg [2:0] wb_funct3_o  // needed by the load data extraction in WB
);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            wb_pc_o <= 32'b0;
            wb_alu_res_o <= 32'b0;
            wb_reg_wen_o <= 1'b0;
            wb_rd_o <= 5'b00000;
            wb_wb_sel_o <= 2'b00;
            wb_funct3_o <= 3'b000;
        end else if (flush) begin
            wb_pc_o <= 32'b0;
            wb_alu_res_o <= 32'b0;
            wb_reg_wen_o <= 1'b0;
            wb_rd_o <= 5'b00000;
            wb_wb_sel_o <= 2'b00;
            wb_funct3_o <= 3'b000;
        end else if (!stall) begin
            wb_pc_o <= mem_pc_i;
            wb_alu_res_o <= mem_alu_res_i;
            wb_reg_wen_o <= mem_reg_wen_i;
            wb_rd_o <= mem_rd_i;
            wb_wb_sel_o <= mem_wb_sel_i;
            wb_funct3_o <= mem_funct3_i;
        end
    end

    // Directly pass the RAW read data to WB stage, no need to store in a register
    // because BRAM inherently delays rdata by 1 cycle, matching the MEM->WB transition perfectly.
    // The byte/half-word extraction is done in WB (core_top) with the load's own
    // registered controls (wb_funct3_o / wb_alu_res_o), NOT with the controls of
    // whatever instruction currently sits in MEM.
    assign wb_rdata_o = mem_rdata_i;
endmodule
