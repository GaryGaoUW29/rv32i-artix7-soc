`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 16:13:51
// Design Name: 
// Module Name: fpga_top
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


module fpga_top (
    input i_clk_25m,
    input i_rst_n,
    output [3:0] debug_pc
);

    wire [31:0] internal_pc;

    core_top u_cpu (
        .clk    (i_clk_25m),
        .rst_n  (i_rst_n),
        .pc_wire(internal_pc)
    );

    // 把内部PC的4根线接到输出引脚（窗户）
    assign debug_pc = internal_pc[5:2];

endmodule
