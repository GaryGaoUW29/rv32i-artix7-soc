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
    wire [9:0] ram_addr = addr[11:2];
    always @(posedge clk) begin

        if (we[0]) ram[ram_addr][7:0] <= wdata[7:0];
        if (we[1]) ram[ram_addr][15:8] <= wdata[15:8];
        if (we[2]) ram[ram_addr][23:16] <= wdata[23:16];
        if (we[3]) ram[ram_addr][31:24] <= wdata[31:24];

        // Synchronous read (1 clock cycle latency)
        rdata <= ram[ram_addr];

        // Note 1:
        // Chop the lowest 2 bits to get the word-aligned address index
        // Because ram is in integer index (like 1,2,3...), means number/index of the instructions
        // but addr is the word-addressable (32 bits = 4 bytes), means the actual byte address
        // so we have to divide addr by 4, same as addr[31:2].

        // Note 2:
        // With non-blocking assignments in the same always block, a same-cycle
        // read of a written address returns the OLD value (read-first behavior).
        // This never matters here: only one instruction occupies MEM per cycle,
        // and a store followed by a load to the same address commits its write
        // one full cycle before the load's read data is registered.

        // Note 3:
        // Because rdata is registered (BRAM behavior), the read data belongs to
        // the address presented in the PREVIOUS cycle, i.e. the load instruction
        // that has meanwhile moved on to WB. That's why the load byte/half-word
        // extraction is done in the WB stage with the load's own registered
        // controls (see core_top / pipe_mem_wb).
    end
endmodule
