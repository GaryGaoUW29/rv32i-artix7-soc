`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 11:41:17
// Design Name: 
// Module Name: core_top
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


module core_top (
    input clk,
    input rst_n,

    // Outputs for simulation
    output [31:0] pc_wire,
    output [31:0] inst_wire,

    // Dedoded instruction fields and control signals
    output [ 6:0] opcode,
    output [ 4:0] rd,
    output [ 2:0] funct3,
    output        reg_wen,
    output [31:0] rdata1,
    output [31:0] rdata2,
    output [31:0] imm,
    output [31:0] alu_res,
    output        mem_rw,
    output [31:0] mem_rdata,
    output [31:0] wb_data
);

    wire flush = 1'b0;  // Placeholder, should be driven by control logic for branch/jump
    wire stall = 1'b0;  // Placeholder, should be driven by hazard detection

    wire        if_pc_sel;
    wire [31:0] if_jump_addr;
    wire        wb_reg_wen;
    wire [ 4:0] wb_rd;


    wire [31:0] if_pc;
    wire [31:0] if_inst;
    wire [31:0] id_pc;
    wire [31:0] id_inst;

    if_stage u_if_stage (
        .clk           (clk),
        .rst_n         (rst_n),
        .if_pc_sel_i   (if_pc_sel),
        .if_jump_addr_i(if_jump_addr),
        .if_stall_i    (stall),
        .if_pc_o       (if_pc),
        .if_inst_o     (if_inst)
    );
    pipe_if_id u_pipe_if_id (
        .clk  (clk),
        .rst_n(rst_n),
        .flush(flush),
        .stall(stall),

        .if_pc_i  (if_pc),
        .if_inst_i(if_inst),
        .id_pc_o  (id_pc),
        .id_inst_o(id_inst)
    );

    wire [ 6:0] id_opcode;
    wire [ 4:0] id_rd;
    wire [31:0] id_rdata1;
    wire [31:0] id_rdata2;
    wire [31:0] id_imm;
    wire        id_reg_wen;
    wire        id_a_sel;
    wire        id_b_sel;
    wire [ 3:0] id_alu_sel;
    wire        id_mem_rw;
    wire [ 1:0] id_wb_sel;
    wire        id_is_jump;
    wire        id_is_branch;
    wire [ 2:0] id_funct3;

    wire [31:0] ex_pc;
    wire [31:0] ex_rdata1;
    wire [31:0] ex_rdata2;
    wire [31:0] ex_imm;
    wire        ex_a_sel;
    wire        ex_b_sel;
    wire [ 3:0] ex_alu_sel;
    wire        ex_mem_rw;
    wire        ex_reg_wen;
    wire [ 4:0] ex_rd;
    wire [ 1:0] ex_wb_sel;
    wire        ex_is_jump;
    wire        ex_is_branch;
    wire [ 2:0] ex_funct3;

    id_stage u_id_stage (
        .clk      (clk),
        .rst_n    (rst_n),
        .id_inst_i(id_inst),
        .id_pc_i  (id_pc),

        // From WriteBack Stage: 
        .wb_wen_i  (wb_reg_wen),
        .wb_waddr_i(wb_rd),
        .wb_wdata_i(wb_data),

        // Outputs for internal wireing and forwarding in top
        .id_opcode_o(id_opcode),
        .id_rd_o    (id_rd),
        .id_rdata1_o(id_rdata1),
        .id_rdata2_o(id_rdata2),
        .id_imm_o   (id_imm),

        // To Control Logic and ID/EX Pipeline Register
        .id_reg_wen_o(id_reg_wen),
        .id_a_sel_o  (id_a_sel),
        .id_b_sel_o  (id_b_sel),
        .id_alu_sel_o(id_alu_sel),
        .id_mem_rw_o (id_mem_rw),
        .id_wb_sel_o (id_wb_sel),

        // For Branch and Jump in AlU/ EX Stage
        .id_is_jump_o  (id_is_jump),
        .id_is_branch_o(id_is_branch),
        .id_funct3_o   (id_funct3)
    );

    pipe_id_ex u_pipe_id_ex (
        // Every pipeline register needs clk, rst_n, flush and stall
        .clk  (clk),
        .rst_n(rst_n),
        .flush(flush),
        .stall(stall),

        // Information from ID stage for ALU to use in EX stage
        .id_pc_i    (id_pc),
        .id_rdata1_i(id_rdata1),
        .id_rdata2_i(id_rdata2),
        .id_imm_i   (id_imm),

        .ex_pc_o    (ex_pc),
        .ex_rdata1_o(ex_rdata1),
        .ex_rdata2_o(ex_rdata2),
        .ex_imm_o   (ex_imm),

        // Control signals from ID stage to EX stage
        .id_a_sel_i    (id_a_sel),
        .id_b_sel_i    (id_b_sel),
        .id_alu_sel_i  (id_alu_sel),
        .id_mem_rw_i   (id_mem_rw),
        .id_reg_wen_i  (id_reg_wen),
        .id_rd_i       (id_rd),
        .id_wb_sel_i   (id_wb_sel),
        .id_is_jump_i  (id_is_jump),
        .id_is_branch_i(id_is_branch),
        .id_funct3_i   (id_funct3),

        .ex_a_sel_o    (ex_a_sel),
        .ex_b_sel_o    (ex_b_sel),
        .ex_alu_sel_o  (ex_alu_sel),
        .ex_mem_rw_o   (ex_mem_rw),
        .ex_reg_wen_o  (ex_reg_wen),
        .ex_rd_o       (ex_rd),
        .ex_wb_sel_o   (ex_wb_sel),
        .ex_is_jump_o  (ex_is_jump),
        .ex_is_branch_o(ex_is_branch),
        .ex_funct3_o   (ex_funct3)
    );



    wire [31:0] mem_pc;
    wire [31:0] mem_wdata;
    wire        mem_mem_rw;
    wire        mem_reg_wen;
    wire [ 4:0] mem_rd;
    wire [ 1:0] mem_wb_sel;
    wire [31:0] mem_alu_res;
    wire [ 2:0] mem_funct3;
    wire [31:0] ex_alu_res;

    ex_stage u_ex_stage (
        // Inputs from IF stage
        .ex_pc_i    (ex_pc),      // pass to WB
        .ex_rdata1_i(ex_rdata1),  // used for ALU op1 and branch comp
        .ex_rdata2_i(ex_rdata2),  // used for ALU op2 and branch comp
        .ex_imm_i   (ex_imm),     // used for ALU op2

        .ex_a_sel_i    (ex_a_sel),      // used for ALU op1 selection
        .ex_b_sel_i    (ex_b_sel),      // used for ALU op2 selection
        .ex_alu_sel_i  (ex_alu_sel),    // used for ALU operation selection
        .ex_mem_rw_i   (ex_mem_rw),     // pass to M
        .ex_reg_wen_i  (ex_reg_wen),    // pass to ID 
        .ex_rd_i       (ex_rd),         // pass to ID
        .ex_wb_sel_i   (ex_wb_sel),     // pass to M and WB
        .ex_is_jump_i  (ex_is_jump),    // used to determine pc_sel in IF stage
        .ex_is_branch_i(ex_is_branch),  // used to determine pc_sel in IF stage
        .ex_funct3_i   (ex_funct3),     // pass to M and used for branch comp

        // Outputs to MEM stage (New signals)
        .ex_alu_res_o(ex_alu_res),

        // For Branch and Jump in IF stage
        .if_pc_sel_o   (if_pc_sel),
        .if_jump_addr_o(if_jump_addr)
    );

    pipe_ex_mem u_pipe_ex_mem (
        .clk  (clk),
        .rst_n(rst_n),
        .flush(flush),
        .stall(stall),

        .ex_pc_i     (ex_pc),
        .ex_wdata_i  (ex_rdata2),
        .ex_mem_rw_i (ex_mem_rw),
        .ex_reg_wen_i(ex_reg_wen),
        .ex_rd_i     (ex_rd),
        .ex_wb_sel_i (ex_wb_sel),
        .ex_alu_res_i(ex_alu_res),
        .ex_funct3_i (ex_funct3),

        .mem_pc_o     (mem_pc),
        .mem_wdata_o  (mem_wdata),
        .mem_mem_rw_o (mem_mem_rw),
        .mem_reg_wen_o(mem_reg_wen),
        .mem_rd_o     (mem_rd),
        .mem_wb_sel_o (mem_wb_sel),
        .mem_alu_res_o(mem_alu_res),
        .mem_funct3_o (mem_funct3)
    );


    wire [31:0] wb_pc;
    wire [31:0] wb_alu_res;
    wire [31:0] wb_rdata;
    wire [ 1:0] wb_wb_sel;

    mem_stage u_mem_stage (
        .clk  (clk),
        .rst_n(rst_n),

        .mem_pc_i     (mem_pc),
        .mem_wdata_i  (mem_wdata),
        .mem_mem_rw_i (mem_mem_rw),
        .mem_reg_wen_i(mem_reg_wen),
        .mem_rd_i     (mem_rd),
        .mem_wb_sel_i (mem_wb_sel),
        .mem_alu_res_i(mem_alu_res),
        .mem_funct3_i (mem_funct3),

        .mem_rdata_o  (mem_rdata)
    );

    pipe_mem_wb u_pipe_mem_wb (
        .clk  (clk),
        .rst_n(rst_n),
        .flush(flush),
        .stall(stall),

        .mem_pc_i     (mem_pc),
        .mem_alu_res_i(mem_alu_res),
        .mem_rdata_i  (mem_rdata),
        .mem_reg_wen_i(mem_reg_wen),
        .mem_rd_i     (mem_rd),
        .mem_wb_sel_i (mem_wb_sel),

        .wb_pc_o     (wb_pc),
        .wb_alu_res_o(wb_alu_res),
        .wb_rdata_o  (wb_rdata),
        .wb_reg_wen_o(wb_reg_wen),
        .wb_rd_o     (wb_rd),
        .wb_wb_sel_o (wb_wb_sel)
    );



    assign wb_data = (wb_wb_sel == 2'b00) ? wb_rdata : 
                     (wb_wb_sel == 2'b01) ? wb_alu_res   :
                     (wb_wb_sel == 2'b10) ? (wb_pc + 4) : wb_alu_res;


    assign pc_wire   = if_pc;
    assign inst_wire = if_inst;

    assign opcode    = id_opcode;
    assign rd        = id_rd;
    assign funct3    = id_funct3;
    assign reg_wen   = id_reg_wen;
    assign rdata1    = id_rdata1;
    assign rdata2    = id_rdata2;
    assign imm       = id_imm;

    assign alu_res   = ex_alu_res;
    assign mem_rw    = mem_mem_rw;

endmodule
