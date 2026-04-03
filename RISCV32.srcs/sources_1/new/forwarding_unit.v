`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/01 21:05:16
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit (
    input [4:0] ex_raddr1_i,
    input [4:0] ex_raddr2_i,

    input [4:0] mem_rd_i,
    input mem_reg_wen_i,

    input [4:0] wb_rd_i,
    input wb_reg_wen_i,

    output reg [1:0] ex_forward_a_sel_o,
    output reg [1:0] ex_forward_b_sel_o,

    input ex_mem_rw_i,
    output reg [1:0] ex_wdata_sel_o,

    // for store after load hazard
    input [4:0] mem_raddr2_i,
    output reg mem_forward_wdata_sel_o

);

    always @(*) begin
        ex_forward_a_sel_o = 2'b00;
        ex_forward_b_sel_o = 2'b00;
        ex_wdata_sel_o = 2'b00;
        mem_forward_wdata_sel_o = 1'b0;

        if (ex_raddr1_i != 5'b0) begin
            if (ex_raddr1_i == mem_rd_i && mem_reg_wen_i) begin
                ex_forward_a_sel_o = 2'b01;
            end else if (ex_raddr1_i == wb_rd_i && wb_reg_wen_i) begin
                ex_forward_a_sel_o = 2'b10;
            end else begin
                ex_forward_a_sel_o = 2'b00;
            end
        end

        if (ex_raddr2_i != 5'b0) begin
            if (ex_raddr2_i == mem_rd_i && mem_reg_wen_i) begin
                ex_forward_b_sel_o = 2'b01;
            end else if (ex_raddr2_i == wb_rd_i && wb_reg_wen_i) begin
                ex_forward_b_sel_o = 2'b10;
            end else begin
                ex_forward_b_sel_o = 2'b00;
            end

            if (ex_mem_rw_i && mem_reg_wen_i && ex_raddr2_i == mem_rd_i) begin
                ex_wdata_sel_o = 2'b01;
            end else if (ex_mem_rw_i && wb_reg_wen_i && ex_raddr2_i == wb_rd_i) begin
                ex_wdata_sel_o = 2'b10;
            end else begin
                ex_wdata_sel_o = 2'b00;
            end
        end

        if (mem_raddr2_i != 5'b0) begin
            if (wb_reg_wen_i && mem_raddr2_i == wb_rd_i) begin
                mem_forward_wdata_sel_o = 1'b1;
            end else begin
                mem_forward_wdata_sel_o = 1'b0;
            end
        end

    end
endmodule
