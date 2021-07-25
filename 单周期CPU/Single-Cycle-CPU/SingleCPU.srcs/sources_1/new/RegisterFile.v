`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:08:06
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
        input [4:0] ReadReg1,
        input [4:0] ReadReg2,
        input [4:0] WriteReg,
        input [31:0] WriteData,
        input CLK,
        input RegWre,
        output [31:0] ReadData1,
        output [31:0] ReadData2
    );
    
    reg [31:0] registers[0:31];
    integer i;
    initial begin
        for(i = 0; i < 32; i = i + 1) registers[i] <= 0;
    end 
    
    assign ReadData1 = registers[ReadReg1];
    assign ReadData2 = registers[ReadReg2];
  
    always@(negedge CLK) begin
        if(WriteReg!=0 && RegWre) registers[WriteReg] <= WriteData;
    end
endmodule
