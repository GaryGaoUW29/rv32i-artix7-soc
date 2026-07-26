`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/28 11:21:49
// Design Name: 
// Module Name: pipe_if_id
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


module pipe_if_id (
    input clk,
    input rst_n,
    input flush,
    input stall,

    input [31:0] if_pc_i,
    input [31:0] if_inst_i,
    output reg [31:0] id_pc_o,
    output [31:0] id_inst_o
);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            id_pc_o <= 32'h00000000;
        end else if (flush) begin
            id_pc_o <= 32'h00000000;
        end else if (!stall) begin
            id_pc_o <= if_pc_i;
        end
    end

    // A taken branch/jump (resolved in EX) leaves TWO wrong-path instructions
    // in flight: one already in ID, and one still inside the synchronous BRAM
    // output register (fetch has 1 cycle of latency).
    // `flush` kills the first one, `flush_d` (flush delayed by one cycle)
    // kills the second one when it comes out of the BRAM.
    reg flush_d;
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            flush_d <= 1'b0;
        end else begin
            flush_d <= flush;
        end
    end

    // The BRAM output register inside inst_mem already acts as the IF/ID
    // instruction register, so the instruction is just passed through here.
    // Insert a NOP while flushing the two wrong-path slots.
    assign id_inst_o = (flush || flush_d) ? 32'h00000013 : if_inst_i;

    // Note: on a stall both the PC and the BRAM output register are frozen
    // (see inst_mem), so the instruction sitting in ID is naturally held.

endmodule
