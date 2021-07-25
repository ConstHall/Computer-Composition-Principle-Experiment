`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:10:25
// Design Name: 
// Module Name: sign_zero_extend
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


module sign_zero_extend(
        input [15:0] immediate,   
        input ExtSel,                 
        output [31:0] extendImmediate
    );
    
    assign extendImmediate = {ExtSel && immediate[15] ? 16'hffff : 16'h0000, immediate};
    
endmodule
