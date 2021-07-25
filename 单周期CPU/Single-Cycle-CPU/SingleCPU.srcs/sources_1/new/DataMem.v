`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:09:43
// Design Name: 
// Module Name: DataMem
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


module DataMem(
        input [31:0] DAddr,
        input [31:0] DataIn,
        input CLK,
        input mRD,
        input mWR,
        input DBDataSrc,
        output reg[31:0] DataOut,
        output reg[31:0] DB
    );
    reg [7:0] dataMemory[0:255];
    integer i;
    initial begin
        DB <= 16'b0;
        DataOut <= 16'b0;
        for(i = 0;i < 256; i = i + 1) dataMemory[i] <= 0;
    end
    
    always@(mRD or DAddr or DBDataSrc) begin
        DataOut[31:24] = mRD ? dataMemory[DAddr] : 8'bz;
        DataOut[23:16] = mRD ? dataMemory[DAddr + 1] : 8'bz;  
        DataOut[15:8] = mRD ? dataMemory[DAddr + 2] : 8'bz; 
        DataOut[7:0] = mRD ? dataMemory[DAddr + 3] : 8'bz;
        DB = DBDataSrc ? DataOut : DAddr;
    end
     
    always@(negedge CLK) begin   
        if(mWR == 1) begin
            dataMemory[DAddr] = DataIn[31:24];
            dataMemory[DAddr + 1] = DataIn[23:16]; 
            dataMemory[DAddr + 2] = DataIn[15:8]; 
            dataMemory[DAddr + 3] = DataIn[7:0];
        end
    end
endmodule

