`timescale 1ns / 1ps

module CPU(
        input CLK,
        input Reset,
        output [5:0] op,
        output [5:0] funct,
        output [31:0] ReadData1,
        output [31:0] ReadData2,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] ALUresult,
        output [31:0] instruction,
        output [31:0] DB
    );
    
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] immediate;
    wire [25:0] addr;
    wire [31:0] extended;
    wire [4:0] sa;
    wire [31:0] DataOut;

    //control_unit
    wire PCWre, InsMemRW, RegDst, RegWre, ALUSrcA, ALUSrcB, mRD, mWR, DBDataSrc, ExtSel;
    wire [2:0] ALUop;
    wire [1:0] PCSrc;
    wire ALU_zero, ALU_sign;
    Adder Adder(CLK,Reset,PCSrc,extended,addr,curPC,nextPC);
    PC PC(CLK,Reset,PCWre,PCSrc,nextPC,curPC);
    InsMem InsMem(InsMemRW,curPC,instruction);
    InsSelect InsSelect(instruction,op,funct,rs,rt,rd,sa,immediate,addr);
    ControlUnit ControlUnit(ALU_zero,ALU_sign,op,funct,InsMemRW,RegDst,RegWre,ALUop,PCSrc,ALUSrcA,ALUSrcB,mRD,mWR,DBDataSrc,ExtSel,PCWre);
    RegisterFile RegisterFile(.CLK(CLK),
                              .RegWre(RegWre),
                              .ReadReg1(rs),
                              .ReadReg2(rt),
                              .WriteReg(RegDst ? rd : rt),
                              .WriteData(DB),
                              .ReadData1(ReadData1),
                              .ReadData2(ReadData2)
    );
    ALU ALU(ReadData1,ReadData2,sa,extended,ALUSrcA,ALUSrcB,ALUop,ALU_sign,ALU_zero,ALUresult);
    DataMem DataMem(ALUresult,ReadData2,CLK,mRD,mWR,DBDataSrc,DataOut,DB);
    sign_zero_extend sign_zero_extend(immediate,ExtSel,extended);
endmodule
