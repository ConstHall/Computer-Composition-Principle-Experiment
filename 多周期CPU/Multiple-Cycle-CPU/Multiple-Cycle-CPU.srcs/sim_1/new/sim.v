`timescale 1ns / 1ps

module sim;
    reg CLK;
    reg Reset;
    wire[31:0] curPC, nextPC, instruction, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, WriteData, ReadData1, ReadData2, ALU_Input_A, ALU_Input_B;
    wire[4:0] WriteReg;
    wire[2:0] state;
    CPU CPU(CLK, Reset, curPC, nextPC, instruction, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, ReadData1, ReadData2, ALU_Input_A, ALU_Input_B, WriteData,WriteReg,state);
    initial begin
        CLK = 1;
        Reset = 0;
        #1;
        Reset = 1;
        forever #50 CLK = !CLK;
    end
endmodule
