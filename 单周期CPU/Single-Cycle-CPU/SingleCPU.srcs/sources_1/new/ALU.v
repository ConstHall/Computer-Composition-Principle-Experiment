`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:08:51
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [4:0] sa,
    input [31:0] extend,
    input ALUSrcA,
    input ALUSrcB,
    input [2:0] ALUop,
    output reg sign,
    output reg zero,
    output reg [31:0] result
    );
    
    reg [31:0] A;
    reg [31:0] B;

    always@(*) begin
        A = (ALUSrcA == 0) ? ReadData1 : sa;
        B = (ALUSrcB == 0) ? ReadData2 : extend;
        case(ALUop)
            3'b000: result = A + B;
            3'b001: result = A - B;
            3'b010: result = B << A;
            3'b011: result = A | B;
            3'b100: result = A & B;
            3'b101: result = (A < B) ? 1 : 0;
            3'b110: result = ((A < B) && (A[31] == B[31]))||(((A[31] == 1) && (B[31] == 0)) ? 1 : 0);
            3'b111: result = A ^ B;
        endcase
        zero = (result == 0) ? 1 : 0;
        sign = result[31];
    end
endmodule
