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

    // Basic outputs for simulation
    output [31:0] pc_wire,
    output [31:0] inst_wire,
    output [31:0] alu_res,
    output [31:0] mem_rdata,
    output [31:0] wb_data,

    // Stage-level debug outputs for pipeline tracing
    output dbg_flush,
    output dbg_stall,

    output        dbg_if_pc_sel,
    output [31:0] dbg_if_jump_addr,

    output [31:0] dbg_id_pc,
    output [31:0] dbg_id_inst,
    output [ 6:0] dbg_id_opcode,
    output [ 4:0] dbg_id_rd,
    output [ 2:0] dbg_id_funct3,
    output        dbg_id_reg_wen,
    output [31:0] dbg_id_rdata1,
    output [31:0] dbg_id_rdata2,
    output [31:0] dbg_id_imm,

    output [31:0] dbg_ex_pc,
    output [31:0] dbg_ex_alu_res,
    output [ 4:0] dbg_ex_rd,
    output        dbg_ex_reg_wen,
    output [ 1:0] dbg_ex_wb_sel,

    output [31:0] dbg_mem_pc,
    output [31:0] dbg_mem_alu_res,
    output [ 4:0] dbg_mem_rd,
    output        dbg_mem_reg_wen,
    output [ 1:0] dbg_mem_wb_sel,
    output        dbg_mem_rw,

    output [31:0] dbg_wb_pc,
    output [ 4:0] dbg_wb_rd,
    output        dbg_wb_reg_wen,
    output [ 1:0] dbg_wb_wb_sel
);

    wire        if_pc_sel;
    wire [31:0] if_jump_addr;
    wire        wb_reg_wen;
    wire [ 4:0] wb_rd;


    wire [31:0] if_pc;
    wire [31:0] if_inst;
    wire [31:0] id_pc;
    wire [31:0] id_inst;

    // forwarding signals
    wire        flush = if_pc_sel;  // flush the pipeline when there's a branch taken or jump
    wire        stall;

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

    wire [ 4:0] id_raddr1;
    wire [ 4:0] id_raddr2;
    wire [ 4:0] ex_raddr1;
    wire [ 4:0] ex_raddr2;

    id_stage u_id_stage (
        .clk      (clk),
        .rst_n    (rst_n),
        .id_inst_i(id_inst),

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
        .id_funct3_o   (id_funct3),

        // forwarding signals
        .id_raddr1_o(id_raddr1),
        .id_raddr2_o(id_raddr2)
    );

    pipe_id_ex u_pipe_id_ex (
        // Every pipeline register needs clk, rst_n, flush and stall
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush || stall),   // Flush the pipeline when there's a branch taken or jump, also flush when stalling to avoid executing wrong instructions
        .stall(1'b0),  // No stall for ID/EX, stalling happens in IF and EX stage

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
        .ex_funct3_o   (ex_funct3),

        // forwarding signals
        .id_raddr1_i(id_raddr1),
        .id_raddr2_i(id_raddr2),
        .ex_raddr1_o(ex_raddr1),
        .ex_raddr2_o(ex_raddr2)
    );



    wire [31:0] mem_pc;
    wire [31:0] mem_wdata;
    wire        mem_mem_rw;
    wire        mem_reg_wen;
    wire [ 4:0] mem_rd;
    wire [ 1:0] mem_wb_sel;
    wire [31:0] mem_alu_res;
    wire [ 2:0] mem_funct3;
    wire [31:0] ex_wdata;
    wire [31:0] ex_alu_res;
    wire [ 1:0] ex_forward_a_sel;
    wire [ 1:0] ex_forward_b_sel;
    wire [ 1:0] ex_forward_wdata_sel;

    // forwarding signals
    wire [ 4:0] mem_raddr2;
    wire        mem_forward_wdata_sel;


    ex_stage u_ex_stage (
        // Inputs from IF stage
        .ex_pc_i    (ex_pc),      // pass to WB
        .ex_rdata1_i(ex_rdata1),  // used for ALU op1 and branch comp
        .ex_rdata2_i(ex_rdata2),  // used for ALU op2 and branch comp
        .ex_imm_i   (ex_imm),     // used for ALU op2

        .ex_a_sel_i    (ex_a_sel),      // used for ALU op1 selection
        .ex_b_sel_i    (ex_b_sel),      // used for ALU op2 selection
        .ex_alu_sel_i  (ex_alu_sel),    // used for ALU operation selection
        .ex_is_jump_i  (ex_is_jump),    // used to determine pc_sel in IF stage
        .ex_is_branch_i(ex_is_branch),  // used to determine pc_sel in IF stage
        .ex_funct3_i   (ex_funct3),     // pass to M and used for branch comp

        // Outputs to MEM stage (New signals)
        .ex_alu_res_o(ex_alu_res),
        .ex_wdata_o  (ex_wdata),

        // For Branch and Jump in IF stage
        .if_pc_sel_o   (if_pc_sel),
        .if_jump_addr_o(if_jump_addr),

        // forwarding signals
        .ex_forward_a_sel_i    (ex_forward_a_sel),
        .ex_forward_b_sel_i    (ex_forward_b_sel),
        .mem_alu_res_i         (mem_alu_res),
        .wb_data_i             (wb_data),
        .ex_forward_wdata_sel_i(ex_forward_wdata_sel)
    );

    pipe_ex_mem u_pipe_ex_mem (
        .clk  (clk),
        .rst_n(rst_n),
        .flush(1'b0),   // No flush for EX/MEM
        .stall(1'b0),   // No stall for EX/MEM, stalling happens in IF and EX stage

        .ex_pc_i     (ex_pc),
        .ex_wdata_i  (ex_wdata),
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
        .mem_funct3_o (mem_funct3),

        // forwarding signals
        .ex_raddr2_i (ex_raddr2),
        .mem_raddr2_o(mem_raddr2)
    );


    wire [31:0] wb_pc;
    wire [31:0] wb_alu_res;
    wire [31:0] wb_rdata;
    wire [ 1:0] wb_wb_sel;

    mem_stage u_mem_stage (
        .clk  (clk),
        .rst_n(rst_n),

        .mem_wdata_i  (mem_wdata),
        .mem_mem_rw_i (mem_mem_rw),
        .mem_reg_wen_i(mem_reg_wen),
        .mem_wb_sel_i (mem_wb_sel),
        .mem_alu_res_i(mem_alu_res),
        .mem_funct3_i (mem_funct3),

        .mem_rdata_o(mem_rdata),

        // forwarding signals
        .wb_data_i              (wb_data),
        .mem_forward_wdata_sel_i(mem_forward_wdata_sel)
    );

    pipe_mem_wb u_pipe_mem_wb (
        .clk  (clk),
        .rst_n(rst_n),
        .flush(1'b0),   // No flush for MEM/WB
        .stall(1'b0),   // No stall for EX/MEM, stalling happens in IF and EX stage

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

    forwarding_unit u_forwarding_unit (
        .ex_raddr1_i  (ex_raddr1),   // ID/EX.rs1
        .ex_raddr2_i  (ex_raddr2),   // ID/EX.rs2
        .mem_rd_i     (mem_rd),      // EX/MEM.rd
        .mem_reg_wen_i(mem_reg_wen), // EX/MEM.reg_wen

        .wb_rd_i     (wb_rd),      // MEM/WB.rd
        .wb_reg_wen_i(wb_reg_wen), // MEM/WB.reg_wen

        .ex_forward_a_sel_o(ex_forward_a_sel),
        .ex_forward_b_sel_o(ex_forward_b_sel),

        .ex_mem_rw_i   (ex_mem_rw),
        .ex_wdata_sel_o(ex_forward_wdata_sel),

        .mem_raddr2_i           (mem_raddr2),
        .mem_forward_wdata_sel_o(mem_forward_wdata_sel)
    );

    hazard_detection_unit u_hazard_detection_unit (
        .ex_reg_wen_i(ex_reg_wen),
        .ex_wb_sel_i (ex_wb_sel),
        .ex_rd_i     (ex_rd),
        .id_raddr1_i (id_raddr1),
        .id_raddr2_i (id_raddr2),
        .id_mem_rw_i (id_mem_rw),

        .stall_o(stall)
    );


    assign pc_wire = if_pc;
    assign inst_wire = if_inst;

    assign alu_res = ex_alu_res;

    assign dbg_flush = flush;
    assign dbg_stall = stall;
    assign dbg_if_pc_sel = if_pc_sel;
    assign dbg_if_jump_addr = if_jump_addr;

    assign dbg_id_pc = id_pc;
    assign dbg_id_inst = id_inst;
    assign dbg_id_opcode = id_opcode;
    assign dbg_id_rd = id_rd;
    assign dbg_id_funct3 = id_funct3;
    assign dbg_id_reg_wen = id_reg_wen;
    assign dbg_id_rdata1 = id_rdata1;
    assign dbg_id_rdata2 = id_rdata2;
    assign dbg_id_imm = id_imm;

    assign dbg_ex_pc = ex_pc;
    assign dbg_ex_alu_res = ex_alu_res;
    assign dbg_ex_rd = ex_rd;
    assign dbg_ex_reg_wen = ex_reg_wen;
    assign dbg_ex_wb_sel = ex_wb_sel;

    assign dbg_mem_pc = mem_pc;
    assign dbg_mem_alu_res = mem_alu_res;
    assign dbg_mem_rd = mem_rd;
    assign dbg_mem_reg_wen = mem_reg_wen;
    assign dbg_mem_wb_sel = mem_wb_sel;
    assign dbg_mem_rw = mem_mem_rw;

    assign dbg_wb_pc = wb_pc;
    assign dbg_wb_rd = wb_rd;
    assign dbg_wb_reg_wen = wb_reg_wen;
    assign dbg_wb_wb_sel = wb_wb_sel;

endmodule
