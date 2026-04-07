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


module hazard_detection_unit (
    input ex_reg_wen_i,
    input [1:0] ex_wb_sel_i,
    input [4:0] ex_rd_i,
    input [4:0] id_raddr1_i,
    input [4:0] id_raddr2_i,
    input id_mem_rw_i,

    output stall_o
);

    // Load-use hazard detection logic
    assign stall_o = (ex_reg_wen_i == 1'b1) && 
                    ((ex_wb_sel_i == 2'b00) && (ex_rd_i != 5'b0) && 
                    ((ex_rd_i == id_raddr1_i) || (ex_rd_i == id_raddr2_i)));

    // Note 1:
    // (ex_rd_i == id_raddr2_i)) && ~id_mem_rw_i) is for store after load hazard, 
    // we only need to stall when the instruction in EX stage is a load instruction 
    // and the destination register is the same as the source register of the store instruction in ID stage

    // Note 2:
    // Since we changed the distribution DREM to BRAM, the store afte load hazard needs to stall for 1 cycle
    // because the lw need a postive edge to get the data from BRAM, 
    // need to wait a cycle, then the sw can get the correct data to write into memory
    // Change back to (ex_rd_i == id_raddr1_i) || (ex_rd_i == id_raddr2_i))
endmodule
