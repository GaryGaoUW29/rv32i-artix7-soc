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
    output [6:0] opcode,
    output [4:0] rd,
    output [2:0] funct3,
    output       reg_wen,
    output       mem_rw,

    // Datapath outputs for verification
    output [31:0] rdata1,
    output [31:0] rdata2,
    output [31:0] imm,
    output [31:0] alu_res,
    output [31:0] mem_rdata,
    output [31:0] wb_data
);
    // Internal wires for control signals
    wire        a_sel;
    wire        b_sel;
    wire [ 3:0] alu_sel;
    wire [ 1:0] wb_sel;
    wire        pc_sel;

    wire [31:0] alu_op1;
    wire [31:0] alu_op2;
    wire [31:0] next_pc;

    // 1. IF Stage
    // pc_sel=1 when branch taken, next_pc=alu_res (branch target), 
    // else next_pc=pc_wire+4
    assign next_pc = (pc_sel) ? alu_res : (pc_wire + 4);

    pc_reg u_pc (
        .clk   (clk),
        .rst_n (rst_n),
        .pc_in (next_pc),
        .pc_out(pc_wire)
    );

    inst_mem u_mem (
        .pc_addr(pc_wire),
        .inst   (inst_wire)
    );

    // 2. ID Stage
    // Packed Register File, Imm Gen, and Control Logic into ID Stage
    id_stage u_id (
        .clk  (clk),
        .rst_n(rst_n),
        .inst (inst_wire),
        .wdata(wb_data),

        .opcode(opcode),
        .rd    (rd),
        .funct3(funct3),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .imm   (imm),

        .reg_wen(reg_wen),
        .a_sel  (a_sel),
        .b_sel  (b_sel),
        .alu_sel(alu_sel),
        .mem_rw (mem_rw),
        .wb_sel (wb_sel),
        .pc_sel (pc_sel)
    );

    // 3. EX Stage
    // Choose ALU operands based on control signals
    assign alu_op1 = (a_sel) ? pc_wire : rdata1;
    assign alu_op2 = (b_sel) ? imm : rdata2;
    wire [3:0] write_ctrl;

    alu u_alu (
        .op1     (alu_op1),
        .op2     (alu_op2),
        .alu_ctrl(alu_sel),
        .alu_res (alu_res)
    );

    // Decode store instruction type to generate byte/half/word write enables
    mem_write_control u_mem_write_control (
        .alu_res   (alu_res),
        .is_store  (mem_rw),
        .funct3    (funct3),
        .write_ctrl(write_ctrl)
    );

    // 4. MEM Stage
    wire [31:0] rdata_filtered;

    data_mem u_dmem (
        .clk  (clk),
        .we   (write_ctrl),
        .addr (alu_res),
        .wdata(rdata2),
        .rdata(mem_rdata)
    );

    mem_load_control u_mem_load_control (
        .alu_res       (alu_res),
        .rdata         (mem_rdata),
        .funct3        (funct3),
        .rdata_filtered(rdata_filtered)
    );

    // 5. WB Stage
    /* wb_sel:  2'b00 -> DMEM read data,
                2'b01 -> ALU result, 
                2'b10 -> PC+4 (for JAL) 
    */
    assign wb_data = (wb_sel == 2'b00) ? rdata_filtered : 
                     (wb_sel == 2'b01) ? alu_res   :
                     (wb_sel == 2'b10) ? (pc_wire + 4) : alu_res;

endmodule
