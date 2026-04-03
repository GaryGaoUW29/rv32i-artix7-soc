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
    input [31:0] ex_pc_i,     // used for ALU op1 when pc_sel is 1
    input [31:0] ex_rdata1_i, // used for ALU op1 and branch comp
    input [31:0] ex_rdata2_i, // used for ALU op2 and branch comp
    input [31:0] ex_imm_i,    // used for ALU op2

    input       ex_a_sel_i,      // used for ALU op1 selection
    input       ex_b_sel_i,      // used for ALU op2 selection
    input [3:0] ex_alu_sel_i,    // used for ALU operation selection
    input       ex_is_jump_i,    // used to determine pc_sel in IF stage
    input       ex_is_branch_i,  // used to determine pc_sel in IF stage
    input [2:0] ex_funct3_i,     // pass to M and used for branch comp

    // Outputs to MEM stage (New signals)
    output [31:0] ex_alu_res_o,
    output [31:0] ex_wdata_o,  // New signal for data to be written to memory

    // For Branch and Jump in IF stage
    output if_pc_sel_o,
    output [31:0] if_jump_addr_o,

    // forwarding signals
    input [ 1:0] ex_forward_a_sel_i,
    input [ 1:0] ex_forward_b_sel_i,
    input [31:0] mem_alu_res_i,
    input [31:0] wb_data_i,
    input [ 1:0] ex_forward_wdata_sel_i
);

    reg [31:0] ex_alu_op1;
    reg [31:0] ex_alu_op2;
    reg [31:0] ex_fresh_rdata1;
    reg [31:0] ex_fresh_rdata2;
    wire ex_br_en;

    always @(*) begin
        // Forwarding logic for ALU operand 1
        case (ex_forward_a_sel_i)
            2'b00: begin
                ex_alu_op1 = (ex_a_sel_i) ? ex_pc_i : ex_rdata1_i;  // No forwarding
                ex_fresh_rdata1 = ex_rdata1_i;
            end
            2'b01: begin
                ex_alu_op1 = (ex_a_sel_i) ? ex_pc_i : mem_alu_res_i;  // Forward from MEM stage
                ex_fresh_rdata1 = mem_alu_res_i;
            end
            2'b10: begin
                ex_alu_op1 = (ex_a_sel_i) ? ex_pc_i : wb_data_i;  // Forward from WB stage
                ex_fresh_rdata1 = wb_data_i;
            end
            default: begin
                ex_alu_op1 = (ex_a_sel_i) ? ex_pc_i : ex_rdata1_i;  // Default case
                ex_fresh_rdata1 = ex_rdata1_i;
            end
        endcase

        // Forwarding logic for ALU operand 2
        case (ex_forward_b_sel_i)
            2'b00: begin
                ex_alu_op2 = (ex_b_sel_i) ? ex_imm_i : ex_rdata2_i;  // No forwarding
                ex_fresh_rdata2 = ex_rdata2_i;
            end
            2'b01: begin
                ex_alu_op2 = (ex_b_sel_i) ? ex_imm_i : mem_alu_res_i;  // Forward from MEM stage
                ex_fresh_rdata2 = mem_alu_res_i;
            end
            2'b10: begin
                ex_alu_op2 = (ex_b_sel_i) ? ex_imm_i : wb_data_i;  // Forward from WB stage
                ex_fresh_rdata2 = wb_data_i;
            end
            default: begin
                ex_alu_op2 = (ex_b_sel_i) ? ex_imm_i : ex_rdata2_i;  // Default case
                ex_fresh_rdata2 = ex_rdata2_i;
            end
        endcase

        // Forwarding logic for data to be written to memory ex: ALU -> Store
        // Can be replaced with ex_wdata_o = ex_fresh_rdata2, bc they got the same forwarding selection
        // case (ex_forward_wdata_sel_i) 
        //     2'b00:   ex_wdata_o = ex_rdata2_i;
        //     2'b01:   ex_wdata_o = mem_alu_res_i;
        //     2'b10:   ex_wdata_o = wb_data_i; 
        //     default: ex_wdata_o = ex_rdata2_i;  // Default case
        // endcase
    end

    branch_comp u_branch_comp (
        .funct3(ex_funct3_i),
        .rdata1(ex_fresh_rdata1),  // must be the real data, not the ex_pc_i
        .rdata2(ex_fresh_rdata2),  // must be the real data, not the ex_imm_i
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
    assign if_jump_addr_o = {
        ex_alu_res_o[31:1], 1'b0
    };  // Last bit is always 0 since instructions are 2 or 4 byte aligned

    // Continuous from top, assign for ex_wdata_o, which is the data to be written to memory (for store instructions)
    assign ex_wdata_o = ex_fresh_rdata2;

endmodule
