`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/23 23:02:17
// Design Name: 
// Module Name: imm_gen
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


module imm_gen (
    input [31:0] inst,
    input [6:0] imm_sel,
    output reg [31:0] imm
);

    always @(*) begin
        imm = 32'b0; //Dafault value to avoid latches

        case (imm_sel)
            //I type
            7'b0010011, 7'b0000011, 7'b1100111: begin
                imm = {{20{inst[31]}}, inst[31:20]};
            end

            // S type
            7'b0100011: begin
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end

            // B type
            7'b1100011: begin
                imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            end

            // U type
            7'b0110111, 7'b0010111: begin
                imm = {inst[31:12], 12'b0};
            end

            // J type
            7'b1101111: begin
                imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            end
        endcase
    end
endmodule
