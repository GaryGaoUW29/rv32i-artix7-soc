`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/29 19:06:25
// Design Name: 
// Module Name: mem_stage
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


module mem_stage (
    input clk,
    input rst_n,

    input [31:0] mem_wdata_i,
    input mem_mem_rw_i,
    input [31:0] mem_alu_res_i,
    input [2:0] mem_funct3_i,

    // Raw BRAM read data. Because of the 1-cycle BRAM latency it becomes valid
    // when the load instruction is already in WB, so the byte/half-word
    // extraction (mem_load_control) is done in the WB stage (see core_top),
    // using the load's own registered controls (funct3 / address offset).
    output [31:0] mem_rdata_o,

    // forwading signals
    input [31:0] wb_data_i,
    input mem_forward_wdata_sel_i
);

    wire [3:0] mem_write_ctrl;  // 4-bit control signal for byte/half/word write enables

    mem_write_control u_mem_write_control (
        .alu_res   (mem_alu_res_i),
        .is_store  (mem_mem_rw_i),
        .funct3    (mem_funct3_i),
        .write_ctrl(mem_write_ctrl)
    );

    // forwarding logic for store after load hazard
    wire [31:0] mem_wdata_final = (mem_forward_wdata_sel_i) ? wb_data_i : mem_wdata_i;

    // Shift the store data into the byte lane selected by the address offset,
    // so it lines up with the shifted byte-enable pattern from mem_write_control.
    // e.g. "sb" to addr%4 == 1 -> we = 4'b0010, and data_mem writes wdata[15:8],
    // so the store byte must be moved from wdata[7:0] up to wdata[15:8].
    wire [31:0] mem_wdata_aligned = mem_wdata_final << {mem_alu_res_i[1:0], 3'b000};

    data_mem u_data_mem (
        .clk  (clk),
        .we   (mem_write_ctrl),
        .addr (mem_alu_res_i),
        .wdata(mem_wdata_aligned),
        .rdata(mem_rdata_o)
    );

endmodule
