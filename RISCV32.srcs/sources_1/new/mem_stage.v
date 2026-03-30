`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/29 19:06:25
// Design Name: 
// Module Name: mem_stage
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


module mem_stage (
    input clk,
    input rst_n,

    input [31:0] mem_pc_i,
    input [31:0] mem_wdata_i,
    input mem_mem_rw_i,
    input mem_reg_wen_i,
    input [4:0] mem_rd_i,
    input [1:0] mem_wb_sel_i,
    input [31:0] mem_alu_res_i,
    input [2:0] mem_funct3_i,

    output [31:0] mem_rdata_o
);

    wire [31:0] mem_write_ctrl;  // 4-bit control signal for byte/half/word write enables

    mem_write_control u_mem_write_control (
        .alu_res   (mem_alu_res_i),
        .is_store  (mem_mem_rw_i),
        .funct3    (mem_funct3_i),
        .write_ctrl(mem_write_ctrl)
    );

    wire [31:0] mem_rdata_unfiltered;  // raw data read from memory before applying load control

    data_mem u_data_mem (
        .clk  (clk),
        .we   (mem_write_ctrl),
        .addr (mem_alu_res_i),
        .wdata(mem_wdata_i),
        .rdata(mem_rdata_unfiltered)
    );

    mem_load_control u_mem_load_control (
        .alu_res       (mem_alu_res_i),
        .rdata         (mem_rdata_unfiltered),
        .funct3        (mem_funct3_i),
        .rdata_filtered(mem_rdata_o)
    );

endmodule
