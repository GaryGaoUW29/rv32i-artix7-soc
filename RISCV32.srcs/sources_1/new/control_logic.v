`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/24 22:48:05
// Design Name: 
// Module Name: control_logic
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

module control_logic (
    input [31:0] inst,
    output reg reg_wen,
    output reg a_sel,
    output reg b_sel,
    output reg [3:0] alu_sel,
    output reg mem_rw,
    output reg [1:0] wb_sel,
    output reg is_jump,
    output reg is_branch
);

    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire [6:0] funct7 = inst[31:25];

    always @(*) begin
        reg_wen = 1'b0;
        mem_rw = 1'b0;
        a_sel = 1'b0;
        b_sel = 1'b0;
        alu_sel = 4'b0000;
        wb_sel = 2'b00;
        is_branch = 1'b0;
        is_jump = 1'b0;

        case (opcode)
            // R-Type
            7'b0110011: begin
                reg_wen = 1'b1;
                a_sel   = 1'b0;
                b_sel   = 1'b0;
                wb_sel  = 2'b01;

                case (funct3)
                    3'h0: alu_sel = (funct7[5]) ? 4'b1000 : 4'b0000;  // sub or add
                    3'h4: alu_sel = 4'b0100;  // xor
                    3'h6: alu_sel = 4'b0110;  // or
                    3'h7: alu_sel = 4'b0111;  //and
                    3'h1: alu_sel = 4'b0001;  // sll
                    3'h5: alu_sel = (funct7[5]) ? 4'b1101 : 4'b0101;  // sra or srl
                    3'h2: alu_sel = 4'b0010;  // slt
                    3'h3: alu_sel = 4'b0011;  // sltu
                endcase
            end

            // I-Type
            7'b0010011: begin
                reg_wen = 1'b1;
                a_sel   = 1'b0;
                b_sel   = 1'b1;
                wb_sel  = 2'b01;

                case (funct3)
                    3'h0: alu_sel = 4'b0000;  // add
                    3'h4: alu_sel = 4'b0100;  // xor
                    3'h6: alu_sel = 4'b0110;  // or
                    3'h7: alu_sel = 4'b0111;  //and
                    3'h1: alu_sel = 4'b0001;  // sll
                    3'h5: alu_sel = (funct7[5]) ? 4'b1101 : 4'b0101;  // sra or srl
                    3'h2: alu_sel = 4'b0010;  // slt
                    3'h3: alu_sel = 4'b0011;  // sltu
                endcase
            end

            // I-Type-Load
            7'b0000011: begin
                reg_wen = 1'b1;
                a_sel   = 1'b0;
                b_sel   = 1'b1;
                alu_sel = 4'b0000;
                mem_rw  = 1'b0;
                wb_sel  = 2'b00;
            end

            // S-Type
            7'b0100011: begin
                reg_wen = 1'b0;
                a_sel   = 1'b0;
                b_sel   = 1'b1;
                alu_sel = 4'b0000;
                mem_rw  = 1'b1;
                wb_sel  = 2'b00;  // don't care
            end

            // B-Type
            7'b1100011: begin
                reg_wen = 1'b0;
                a_sel = 1'b1;
                b_sel = 1'b1;
                alu_sel = 4'b0000;
                mem_rw = 1'b0;
                wb_sel = 2'b01;  // don't care
                is_branch = 1'b1;
            end

            // U-Type-lui
            7'b0110111: begin
                reg_wen = 1'b1;
                a_sel   = 1'b1;  // don't care
                b_sel   = 1'b1;
                wb_sel  = 2'b01;
                alu_sel = 4'b1111;  // output shifted imm directly
            end

            // U-Type-auipc
            7'b0010111: begin
                reg_wen = 1'b1;
                a_sel   = 1'b1;  // care this time, choose pc
                b_sel   = 1'b1;
                wb_sel  = 2'b01;
                alu_sel = 4'b0000;  // output imm + pc 
            end

            // J-Type-jal (rd = PC+4; PC += imm)
            7'b1101111: begin
                reg_wen = 1'b1;
                mem_rw  = 1'b0;
                a_sel   = 1'b1;
                b_sel   = 1'b1;
                alu_sel = 4'b0000;
                wb_sel  = 2'b10;
                is_jump = 1'b1;
            end

            // I-Type-jalr
            7'b1100111: begin
                reg_wen = 1'b1;
                mem_rw  = 1'b0;
                a_sel   = 1'b0;  // only change: choose the rs1 instead of the pc
                b_sel   = 1'b1;
                alu_sel = 4'b0000;
                wb_sel  = 2'b10;
                is_jump = 1'b1;
            end

            default: begin
            end
        endcase
    end
endmodule
