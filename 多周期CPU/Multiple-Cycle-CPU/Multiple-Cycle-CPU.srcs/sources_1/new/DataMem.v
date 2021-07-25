`timescale 1ns / 1ps

module DataMem(    
    input [31:0] DAddr,
    input [31:0] DataIn,
    input CLK,
    input mRD,
    input mWR,
    output reg[31:0] DataOut
    );
    
    reg[7:0] dataMemory[255:0];
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) dataMemory[i] <= 0;
    end
    
    always@(mRD or DAddr) begin
        DataOut[31:24] = mRD ? dataMemory[DAddr] : 8'bz;
        DataOut[23:16] = mRD ? dataMemory[DAddr + 1] : 8'bz;  
        DataOut[15:8] = mRD ? dataMemory[DAddr + 2] : 8'bz; 
        DataOut[7:0] = mRD ? dataMemory[DAddr + 3] : 8'bz;
        end
    
    always@(negedge CLK) begin
        if (mWR == 1) begin
            dataMemory[DAddr] = DataIn[31:24];
            dataMemory[DAddr+1] = DataIn[23:16];
            dataMemory[DAddr+2] = DataIn[15:8];
            dataMemory[DAddr+3] = DataIn[7:0];
        end 
    end
endmodule
