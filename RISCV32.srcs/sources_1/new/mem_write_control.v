`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 21:28:49
// Design Name: 
// Module Name: mem_write_control
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


module mem_write_control (
    input [31:0] alu_res,
    input is_store,
    input [2:0] funct3,
    output reg [3:0] write_ctrl
);

    always @(*) begin
        if (is_store) begin
            case (funct3)
                3'b000:
                write_ctrl = 4'b0001 << alu_res[1:0]; // only need the last 2 bits for offset within the word
                3'b001:
                write_ctrl = 4'b0011 << alu_res[1:0]; // only need the last 2 bits for offset within the word
                3'b010: write_ctrl = 4'b1111;
                default: write_ctrl = 4'b0000;
            endcase
        end else write_ctrl = 4'b0000;
    end
endmodule
