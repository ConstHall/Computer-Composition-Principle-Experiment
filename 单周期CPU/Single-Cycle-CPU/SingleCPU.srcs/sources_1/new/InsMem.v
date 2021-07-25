`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:04:05
// Design Name: 
// Module Name: InsMem
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


module InsMem(
        input InsMemRW,
        input [31:0] IAddr,
        output reg[31:0] IDataOut
    );
    
    reg [7:0] rom[0:127];
    initial $readmemb("C:\\Users\\93508\\Desktop\\instruction.txt", rom);
    //C:\Users\93508\Desktop\single-cycle-mips-cpu\single-cycle-mips-cpu
    always@(IAddr or InsMemRW) begin
        if(InsMemRW) begin
            IDataOut[7:0] = rom[IAddr + 3];
            IDataOut[15:8] = rom[IAddr + 2];
            IDataOut[23:16] = rom[IAddr + 1];
            IDataOut[31:24] = rom[IAddr];
        end 
    end
endmodule
