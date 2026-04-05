`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 19:34:49
// Design Name: 
// Module Name: data_mem
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


module data_mem (
    input clk,
    input [3:0] we,
    input [31:0] addr,
    input [31:0] wdata,
    output [31:0] rdata
);

    reg [31:0] ram[0:1023];

    // Initialize memory to zero (To remove the 0xXXXXXXXX issue in simulation)
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            ram[i] = 32'h00000000;
        end
    end

    // Chop the lowest 2 bits to get the word-aligned address index
    // Because ram is in integer index (like 1,2,3...), means number/index of the instractions
    // but addr is the word-addressable (32 bits = 4 bytes), means the actual byte address
    // so we have to divide addr by 4, same as addr[31:2].
    assign rdata = ram[addr[31:2]];

    // Write logic with byte enables
    // we[0] controls byte 0 (bits 7:0), we[1] controls byte 1 (bits 15:8), etc.
    // This allows for byte, half-word, and word writes based on the write Enable(we) signal.
    always @(posedge clk) begin
        if (we) begin
            if (we[0]) ram[addr[31:2]][7:0] <= wdata[7:0];
            if (we[1]) ram[addr[31:2]][15:8] <= wdata[15:8];
            if (we[2]) ram[addr[31:2]][23:16] <= wdata[23:16];
            if (we[3]) ram[addr[31:2]][31:24] <= wdata[31:24];
        end
    end
endmodule
