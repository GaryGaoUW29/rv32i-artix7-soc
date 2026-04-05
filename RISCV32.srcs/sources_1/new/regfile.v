`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 15:35:10
// Design Name: 
// Module Name: regfile
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


module regfile (
    input clk,
    input rst_n,
    input [4:0] raddr1,
    input [4:0] raddr2,
    output [31:0] rdata1,
    output [31:0] rdata2,

    input we,
    input [4:0] waddr,
    input [31:0] wdata
);

    // Use the distributed RAM style of register file implementation
    // which is more efficient for small register files like 32 registers.
    // Can be read and written in the same cycle
    reg [31:0] regs[0:31];

    // Internal Forwarding (Write-First): 
    // If reading the same register that is currently being written, 
    // bypass the operation to the register file array and directly forward the wdata to read.
    assign rdata1 = (raddr1 == 5'b00000) ? 32'h00000000 : 
                    ((we == 1'b1) && (waddr == raddr1)) ? wdata : 
                    regs[raddr1];

    assign rdata2 = (raddr2 == 5'b00000) ? 32'h00000000 : 
                    ((we == 1'b1) && (waddr == raddr2)) ? wdata : 
                    regs[raddr2];

    integer i;
    always @(posedge clk) begin
        if (!rst_n) begin
            // On reset, initialize all registers to 0. Good to have a known state for simulation and debugging.
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end else begin
            if (we == 1'b1 && waddr != 5'b00000) begin
                regs[waddr] <= wdata;
            end
        end
    end

endmodule
