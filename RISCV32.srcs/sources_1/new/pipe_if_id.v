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
    output reg [31:0] id_inst_o
);

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            id_inst_o <= 32'h00000033;
            id_pc_o   <= 32'b00000000;
        end else if (flush) begin
            id_inst_o <= 32'h00000033;
            id_pc_o   <= 32'b00000000;
        end else if (!stall) begin
            id_pc_o   <= if_pc_i;
            id_inst_o <= if_inst_i;
        end
    end
endmodule
