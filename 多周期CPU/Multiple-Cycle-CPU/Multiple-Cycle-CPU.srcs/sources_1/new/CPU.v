`timescale 1ns / 1ps

module CPU(
    input CLK,
	input Reset,
	output[31:0] curPC, nextPC, instruction, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, ReadData1, ReadData2, ALU_Input_A, ALU_Input_B, WriteData,
	output[4:0] WriteReg,
	output[2:0] state
);
	wire ExtSel, PCWre, InsMemRW, ALUSrcA, ALUSrcB, mRD, mWR, DBDataSrc, zero, sign, IRWre, WrRegDSrc, RegWre;
	wire[2:0] ALUop;
	wire[5:0] funct;
	wire[1:0] PCSrc, RegDst;
	wire[31:0] MemOut, PC4, InsSrcImm, InsSrc1, InsSrc3, ALU_Out, WBData;
	
	PC PC(CLK, Reset, PCWre, nextPC, curPC);
	InsMem InsMem(InsMemRW, curPC, instruction);
	SameRegister IR(CLK, instruction, IRWre, IRInstruction);
	Adder PC4_Adder(curPC, 32'b00000000000000000000000000000100, PC4);
	Mux3 WriteReg_Choose(RegDst, 5'b11111, IRInstruction[20:16],IRInstruction[15:11], WriteReg);
	Mux2 WriteData_Choose(WrRegDSrc, PC4, DBDROut, WriteData);
	RegisterFile RegisterFile(IRInstruction[25:21], IRInstruction[20:16], WriteReg, WriteData, CLK, RegWre, ReadData1, ReadData2);
	SameRegister ADR(CLK, ReadData1, 1'b1, ADROut);
    SameRegister BDR(CLK, ReadData2, 1'b1, BDROut);
    sign_zero_extend sign_zero_extend(IRInstruction[15:0], ExtSel, Ext_Imm);
	Mux2 ALU_A_Choose(ALUSrcA, ADROut, {27'b000000000000000000000000000,IRInstruction[10:6]}, ALU_Input_A);
    Mux2 ALU_B_Choose(ALUSrcB, BDROut, Ext_Imm, ALU_Input_B);
	ALU ALU(ALUop, ALU_Input_A, ALU_Input_B, sign, zero, ALU_Out);
	SameRegister ALUoutDR(CLK, ALU_Out, 1'b1, ALUoutDROut);
    SameRegister DBDR(CLK, WBData, 1'b1, DBDROut);
	DataMem DataMem(ALUoutDROut, BDROut, CLK, mRD, mWR, MemOut);
	Mux2 DB_choose(DBDataSrc, ALU_Out, MemOut, WBData);
    LeftShift2 after_imm_extend(Ext_Imm, InsSrcImm);
	LeftShift2 Address_shift({2'b00, PC4[31:28], IRInstruction[25:0]}, InsSrc3);
	Adder next_PC1(InsSrcImm, PC4, InsSrc1);
	Mux4 nextPC_Choose(PCSrc, PC4, InsSrc1, ReadData1,InsSrc3, nextPC);
	ControlUnit ControlUnit(CLK,Reset,IRInstruction[31:26],IRInstruction[5:0],zero,sign,state,PCWre,InsMemRW,IRWre,WrRegDSrc,RegDst,RegWre,ALUop,ALUSrcA,ALUSrcB,PCSrc,mRD,mWR,DBDataSrc,ExtSel);
endmodule
