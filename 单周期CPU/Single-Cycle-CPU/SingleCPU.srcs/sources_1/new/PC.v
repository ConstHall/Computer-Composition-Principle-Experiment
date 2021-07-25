`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:03:27
// Design Name: 
// Module Name: PC
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



module PC(
       input CLK,              
       input Reset,            
       input PCWre,       
       input [1:0] PCSrc,       
       input [31:0] nextPC,  
       output reg[31:0] curPC
    );

        initial begin  
        curPC = 0;  
    end   
    always@(posedge CLK or negedge Reset) begin
        if(Reset==0) begin
        curPC = 0;
        end
        else if(PCWre) begin
        curPC = nextPC;
        end
    end
endmodule

