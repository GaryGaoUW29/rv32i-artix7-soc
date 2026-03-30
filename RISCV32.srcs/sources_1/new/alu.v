`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/22 17:28:19
// Design Name: 
// Module Name: alu
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


module alu (
    input [31:0] op1,
    input [31:0] op2,
    input [3:0] alu_sel,
    output reg [31:0] alu_res
);

    always @(*) begin
        case (alu_sel)
            4'b0000: alu_res = op1 + op2;  // add, addi (lw, sw, auipc, jal, jalr)
            4'b1000: alu_res = op1 - op2;  // sub

            4'b0001: alu_res = op1 << op2[4:0];  // sll, slli
            4'b0101: alu_res = op1 >> op2[4:0];  // srl, srli
            4'b1101: alu_res = $signed(op1) >>> op2[4:0];  // sra, srai

            4'b0010: alu_res = $signed(op1) < $signed(op2) ? 32'b1 : 32'b0;  // slt, slti
            4'b0011: alu_res = op1 < op2 ? 32'b1 : 32'b0;  // sltu, sltiu

            4'b0111: alu_res = op1 & op2;  // and, andi
            4'b0110: alu_res = op1 | op2;  // or, ori
            4'b0100: alu_res = op1 ^ op2;  // xor, xori

            4'b1111: alu_res = op2;  // Pass B for lui
            default: alu_res = 32'h00000000;
        endcase
    end
endmodule
