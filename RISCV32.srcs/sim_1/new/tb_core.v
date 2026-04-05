`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 15:01:25
// Design Name: 
// Module Name: tb_core
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

module tb_core ();
    reg         clk;
    reg         rst_n;

    wire [31:0] top_pc;
    wire [31:0] top_inst;
    wire [31:0] top_alu_res;
    wire [31:0] top_mem_rdata;
    wire [31:0] top_wb_data;

    wire        top_dbg_flush;
    wire        top_dbg_stall;
    wire        top_dbg_if_pc_sel;
    wire [31:0] top_dbg_if_jump_addr;

    wire [31:0] top_dbg_id_pc;
    wire [31:0] top_dbg_id_inst;
    wire [ 6:0] top_dbg_id_opcode;
    wire [ 4:0] top_dbg_id_rd;
    wire [ 2:0] top_dbg_id_funct3;
    wire        top_dbg_id_reg_wen;
    wire [31:0] top_dbg_id_rdata1;
    wire [31:0] top_dbg_id_rdata2;
    wire [31:0] top_dbg_id_imm;

    wire [31:0] top_dbg_ex_pc;
    wire [31:0] top_dbg_ex_alu_res;
    wire [ 4:0] top_dbg_ex_rd;
    wire        top_dbg_ex_reg_wen;
    wire [ 1:0] top_dbg_ex_wb_sel;

    wire [31:0] top_dbg_mem_pc;
    wire [31:0] top_dbg_mem_alu_res;
    wire [ 4:0] top_dbg_mem_rd;
    wire        top_dbg_mem_reg_wen;
    wire [ 1:0] top_dbg_mem_wb_sel;
    wire        top_dbg_mem_rw;

    wire [31:0] top_dbg_wb_pc;
    wire [ 4:0] top_dbg_wb_rd;
    wire        top_dbg_wb_reg_wen;
    wire [ 1:0] top_dbg_wb_wb_sel;

    core_top u_core (
        .clk      (clk),
        .rst_n    (rst_n),
        .pc_wire  (top_pc),
        .inst_wire(top_inst),
        .alu_res  (top_alu_res),
        .mem_rdata(top_mem_rdata),
        .wb_data  (top_wb_data),

        .dbg_flush       (top_dbg_flush),
        .dbg_stall       (top_dbg_stall),
        .dbg_if_pc_sel   (top_dbg_if_pc_sel),
        .dbg_if_jump_addr(top_dbg_if_jump_addr),

        .dbg_id_pc     (top_dbg_id_pc),
        .dbg_id_inst   (top_dbg_id_inst),
        .dbg_id_opcode (top_dbg_id_opcode),
        .dbg_id_rd     (top_dbg_id_rd),
        .dbg_id_funct3 (top_dbg_id_funct3),
        .dbg_id_reg_wen(top_dbg_id_reg_wen),
        .dbg_id_rdata1 (top_dbg_id_rdata1),
        .dbg_id_rdata2 (top_dbg_id_rdata2),
        .dbg_id_imm    (top_dbg_id_imm),

        .dbg_ex_pc     (top_dbg_ex_pc),
        .dbg_ex_alu_res(top_dbg_ex_alu_res),
        .dbg_ex_rd     (top_dbg_ex_rd),
        .dbg_ex_reg_wen(top_dbg_ex_reg_wen),
        .dbg_ex_wb_sel (top_dbg_ex_wb_sel),

        .dbg_mem_pc     (top_dbg_mem_pc),
        .dbg_mem_alu_res(top_dbg_mem_alu_res),
        .dbg_mem_rd     (top_dbg_mem_rd),
        .dbg_mem_reg_wen(top_dbg_mem_reg_wen),
        .dbg_mem_wb_sel (top_dbg_mem_wb_sel),
        .dbg_mem_rw     (top_dbg_mem_rw),

        .dbg_wb_pc     (top_dbg_wb_pc),
        .dbg_wb_rd     (top_dbg_wb_rd),
        .dbg_wb_reg_wen(top_dbg_wb_reg_wen),
        .dbg_wb_wb_sel (top_dbg_wb_wb_sel)
    );

    // Initialation block to set up the clock and reset signals
    initial begin
        clk = 0;
    end

    // Flip the clock every 10 nanoseconds (generate a 20ns period square wave, equivalent to 50MHz)
    always begin
        #10;
        clk = ~clk;
    end

    // Simulation by reset the core, then let it run for a while before finishing
    initial begin
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;
        #2500;
        $finish;
    end

endmodule
