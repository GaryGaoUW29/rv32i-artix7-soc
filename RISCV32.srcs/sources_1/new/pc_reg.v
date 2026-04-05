`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 11:06:42
// Design Name: 
// Module Name: pc_reg
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


module pc_reg (
    input clk,
    input rst_n,
    input stall,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);

    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset the pc to 0, aka standard RISCV starting address
            // Also help the simulation to start with a known value instead of x's
            pc_out <= 32'h00000000;
        end else if (!stall) begin
            // When staling, freeze the PC address
            // In another word, only update the PC when we are not stalling
            pc_out <= pc_in;
        end
    end
endmodule
