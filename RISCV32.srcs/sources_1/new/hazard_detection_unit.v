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

    // Load-use hazard detection logic:
    // Stall when the instruction in EX is a load (reg_wen && wb_sel == 2'b00)
    // and the instruction in ID reads the load's destination register.
    //
    // Exception (store-after-load through rs2 only): if the ID instruction is a
    // store (id_mem_rw_i == 1) and the dependence is only through rs2 (the store
    // DATA, not the address in rs1), no stall is needed. The store data is
    // forwarded later in the MEM stage (mem_forward_wdata_sel in the forwarding
    // unit) when the store is in MEM and the load's data arrives in WB.
    assign stall_o = (ex_reg_wen_i == 1'b1) && 
                    ((ex_wb_sel_i == 2'b00) && (ex_rd_i != 5'b0) && 
                    ((ex_rd_i == id_raddr1_i) || ((ex_rd_i == id_raddr2_i) && ~id_mem_rw_i)));
endmodule
