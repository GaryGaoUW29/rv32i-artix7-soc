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

    input [31:0] mem_wdata_i,
    input mem_mem_rw_i,
    input mem_reg_wen_i,
    input [1:0] mem_wb_sel_i,
    input [31:0] mem_alu_res_i,
    input [2:0] mem_funct3_i,

    output [31:0] mem_rdata_o
);

    wire [3:0] mem_write_ctrl;  // 4-bit control signal for byte/half/word write enables

    mem_write_control u_mem_write_control (
        .alu_res   (mem_alu_res_i),
        .is_store  (mem_mem_rw_i),
        .funct3    (mem_funct3_i),
        .write_ctrl(mem_write_ctrl)
    );

    wire [31:0] mem_rdata_unfiltered;  // raw data read from memory before applying load control
    // Determine if the current instruction is a load that needs special handling for byte/half-word loads
    wire mem_is_load = (mem_reg_wen_i == 1'b1) && (mem_mem_rw_i == 1'b0) && (mem_wb_sel_i == 2'b00);

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
        .is_load       (mem_is_load),
        .funct3        (mem_funct3_i),
        .rdata_filtered(mem_rdata_o)
    );

endmodule
