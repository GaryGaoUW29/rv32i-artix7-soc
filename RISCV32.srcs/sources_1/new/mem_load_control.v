`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 21:28:49
// Design Name: 
// Module Name: mem_load_control
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


module mem_load_control (
    input [31:0] alu_res,
    input [31:0] rdata,
    input [2:0] funct3,
    output reg [31:0] rdata_filtered
);

    reg  [31:0] shifted_data;
    wire [ 1:0] offset = alu_res[1:0];

    always @(*) begin
        shifted_data = rdata >> {offset, 3'b000};

        case (funct3)
            3'b000:  rdata_filtered = {{24{shifted_data[7]}}, shifted_data[7:0]};  // lb
            3'b001:  rdata_filtered = {{16{shifted_data[15]}}, shifted_data[15:0]};  // lh
            3'b010:  rdata_filtered = rdata;  // lw
            3'b100:  rdata_filtered = {24'b0, shifted_data[7:0]};  // lbu
            3'b101:  rdata_filtered = {16'b0, shifted_data[15:0]};  // lhu
            default: rdata_filtered = 32'b0;
        endcase
    end
endmodule
