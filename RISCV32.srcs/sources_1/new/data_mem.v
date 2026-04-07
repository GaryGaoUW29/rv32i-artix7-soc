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
    output reg [31:0] rdata
);

    // Use ram_syle = "block" to infer block RAM on FPGA
    (* ram_style = "block" *) reg [31:0] ram[0:1023];

    // Initialize memory to zero (To remove the 0xXXXXXXXX issue in simulation)
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            ram[i] = 32'h00000000;
        end
    end

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

        // Synchronous read (1 clock cycle latency)
        rdata <= ram[addr[31:2]];

        // Note 1:
        // Chop the lowest 2 bits to get the word-aligned address index
        // Because ram is in integer index (like 1,2,3...), means number/index of the instructions
        // but addr is the word-addressable (32 bits = 4 bytes), means the actual byte address
        // so we have to divide addr by 4, same as addr[31:2].

        // Note 2:
        // Don't need to worry about the read/write conflict in the same cycle 
        // because the synthesizer will handle it by giving priority to the write operation, 
        // So write-first

        // Note 3:
        // No need to change anything for the load-use hazard in hazard detection unit, 
        // because the load-use hazard will stall the pipeline for 1 cycle, 
        // due to the hold-up time of the changes in address, the BRAM will read the NOP data in the next cycle
        // even though the n+2 cycle BRAM will output the data from 0x00000000(NOP), 
        // but the stall already set the write enable to 0, so the data in BRAM will not be overwritten
        // "In Digital IC, it's fine if the bus carries trash, but it's a nightmare if the control logic has a glitch."
    end
endmodule
