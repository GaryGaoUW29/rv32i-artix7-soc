`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/23 23:49:02
// Design Name: 
// Module Name: branch_comp
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


module branch_comp (
    input [2:0] funct3,
    input [31:0] rdata1,
    input [31:0] rdata2,
    output reg br_en
);

    always @(*) begin
        br_en = 1'b0;  // By default don't jump

        case (funct3)
            3'b000: br_en = (rdata1 == rdata2);  // beq
            3'b001: br_en = (rdata1 != rdata2);  // bne
            3'b100: br_en = ($signed(rdata1) < $signed(rdata2));  // blt
            3'b101: br_en = ($signed(rdata1) >= $signed(rdata2));  // bge
            3'b110: br_en = (rdata1 < rdata2);  // bltu
            3'b111: br_en = (rdata1 >= rdata2);  // bgeu
        endcase
    end
endmodule
