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
            id_pc_o <= 32'b00000000;
        end else if (flush) begin
            id_pc_o <= 32'b00000000;
        end else if (!stall) begin
            id_pc_o <= if_pc_i;
        end
    end

    // B-RAM is already synchronous, so here we just need to passby it
    // NOP if flushed, otherwise pass the instruction through
    assign id_inst_o = (flush) ? 32'h00000013 : if_inst_i;

    // Note: We don't need to stall the instruction fetch, 
    // because when we stall, the pc address stays the same, and the B-RAM will keep outputting the same instruction.
    // Samething as we bypassed the instruction

endmodule
