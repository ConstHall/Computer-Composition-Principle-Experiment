`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:04:58
// Design Name: 
// Module Name: InsSelect
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


module InsSelect(
        input [31:0] instruction,
        output reg[5:0] op,
        output reg[5:0] funct,
        output reg[4:0] rs,
        output reg[4:0] rt,
        output reg[4:0] rd,
        output reg[4:0] sa,
        output reg[15:0] immediate,
        output reg[25:0] addr
    );
    
    initial begin
        op = 5'b00000;
        rs = 5'b00000;
        rt = 5'b00000;
        rd = 5'b00000;
        funct=5'b00000;
    end
    
    always@(instruction) begin
        // R type instruction
        op = instruction[31:26];
        funct=instruction[5:0];
        rs = instruction[25:21];
        rt = instruction[20:16];
        rd = instruction[15:11];
        sa = instruction[10:6];
        // I type instruction
        immediate = instruction[15:0];
        // J type instruction
        addr = instruction[25:0];
    end
endmodule
