`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:11:17
// Design Name: 
// Module Name: sim
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


module sim();
    // Input
    reg CLK;
    reg Reset;

    // Output
    wire [31:0] curPC;
    wire [31:0] nextPC;
    wire [31:0] instruction; 
    wire [5:0] op;
    wire [5:0] funct;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;  
    wire [31:0] ALUresult;


    CPU cpu1(CLK,Reset,op,funct,ReadData1,ReadData2,curPC,nextPC,ALUresult,instruction);
    
        initial begin
        CLK = 1;
        Reset = 0;
        #1;
        Reset = 1;
        forever #50 CLK = !CLK;
    end

endmodule
