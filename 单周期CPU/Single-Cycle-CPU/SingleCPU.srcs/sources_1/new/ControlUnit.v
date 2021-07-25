`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 22:05:54
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
        input zero,
        input sign,
        input [5:0] op,
        input [5:0] funct,
        output reg InsMemRW,
        output reg RegDst,
        output reg RegWre,
        output reg [2:0] ALUop,
        output reg [1:0] PCSrc,
        output reg ALUSrcA,
        output reg ALUSrcB,
        output reg mRD,
        output reg mWR,
        output reg DBDataSrc,
        output reg ExtSel,
        output reg PCWre
    );
    
    always@(op or zero or sign or funct) begin
        case(op)
            6'b000000: begin //R type
                case(funct)
                    6'b100000:begin     //add
                        PCWre = 1;
                        {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000110010;
                        PCSrc[1:0] = 2'b00;
                        ALUop[2:0] = 3'b000;                           
                    end
                    6'b100010:begin     //sub
                        PCWre = 1;
                        {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000110011;
                        PCSrc[1:0] = 2'b00;
                        ALUop[2:0] = 3'b001;
                    end
                    6'b100100:begin     //and
                        PCWre = 1;
                        {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000110010;
                        PCSrc[1:0] = 2'b00;
                        ALUop[2:0] = 3'b100;
                    end
                    6'b100101:begin     //or
                        PCWre = 1;
                        {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000110010;
                        PCSrc[1:0] <= 2'b00;
                        ALUop[2:0] <= 3'b011;
                    end
                    6'b000000:begin     //sll
                        PCWre = 1;
                        {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b100110010;
                        PCSrc[1:0] = 2'b00;
                        ALUop[2:0] = 3'b010;
                    end
               endcase     
            end
            6'b001001: begin    //addi
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010110001;
                PCSrc[1:0] = 2'b00;
                ALUop[2:0] = 3'b000;
            end
            6'b001100: begin    // andi
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010110000;
                PCSrc[1:0] = 2'b00;
                ALUop[2:0] = 3'b100;
            end
            6'b001101: begin    //ori
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010110001;
                PCSrc[1:0] = 2'b00;
                ALUop[2:0] = 3'b011;
            end
            6'b001010: begin    //slti
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010110001;
                PCSrc[1:0] = 2'b00;
                ALUop[2:0] = 3'b101;
            end
            6'b101011: begin    //sw
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010010101;
                PCSrc[1:0] = 2'b00;
                ALUop[2:0] = 3'b000;
            end
            6'b100011: begin    //lw
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b011111001;
                PCSrc[1:0] = 2'b00;
                ALUop[2:0] = 3'b000;
            end
            6'b000100: begin    //beq
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010001;
                PCSrc[1:0] = (zero == 1 ? 2'b01 : 2'b00);
                ALUop[2:0] = 3'b001;
            end
            6'b000101: begin    //bne
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010001;
                PCSrc[1:0] = (zero == 1 ? 2'b00 : 2'b01);
                ALUop[2:0] = 3'b001;
            end
            6'b000001: begin    //bltz
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010001;
                PCSrc[1:0] = (sign == 1 ? 2'b01 : 2'b00);
                ALUop[2:0] = 3'b000;
            end
            6'b000010: begin    //j
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010000;
                PCSrc[1:0] = 2'b10;
                ALUop[2:0] = 3'b000;
            end
            6'b111111: begin    //halt
                PCWre = 0;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010000;
                PCSrc[1:0] = 2'b11;
                ALUop[2:0] = 3'b000;
            end
        endcase
        end 
endmodule
