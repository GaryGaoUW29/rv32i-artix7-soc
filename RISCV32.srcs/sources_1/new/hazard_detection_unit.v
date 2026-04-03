`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/03 12:57:40
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    input ex_reg_wen_i,
    input ex_wb_sel_i,
    input ex_rd_i,
    input id_raddr1_i,
    input id_raddr2_i,

    output stall_o
    );

    assign stall_o = (ex_reg_wen_i == 1'b1) && 
                    ((ex_wb_sel_i == 2'b00) && (ex_rd_i != 5'b0) && 
                    ((ex_rd_i == id_raddr1_i) || (ex_rd_i == id_raddr2_i)));
endmodule
