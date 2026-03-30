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

    wire [ 6:0] top_opcode;
    wire [ 4:0] top_rd;
    wire [ 2:0] top_funct3;
    wire        top_reg_wen;
    wire        top_mem_rw;

    wire [31:0] top_rdata1;
    wire [31:0] top_rdata2;
    wire [31:0] top_imm;
    wire [31:0] top_alu_res;
    wire [31:0] top_mem_rdata;
    wire [31:0] top_wb_data;

    core_top u_core (
        .clk      (clk),
        .rst_n    (rst_n),
        .pc_wire  (top_pc),
        .inst_wire(top_inst),
        .opcode   (top_opcode),
        .rd       (top_rd),
        .funct3   (top_funct3),
        .reg_wen  (top_reg_wen),
        .mem_rw   (top_mem_rw),
        .rdata1   (top_rdata1),
        .rdata2   (top_rdata2),
        .imm      (top_imm),
        .alu_res  (top_alu_res),
        .mem_rdata(top_mem_rdata),
        .wb_data  (top_wb_data)
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
        #20000;
        $finish;
    end

endmodule
