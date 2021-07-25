`timescale 1ns / 1ps

module TOP_CPU(
	input[2:0] display_mode,
	input CLK, Reset, Button,
	output[3:0] AN,	//数码管位选择信号
	output[7:0] Out	
);

	wire[31:0] ALU_Out, curPC, WriteData, ReadData1, ReadData2, instruction, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, ALU_Input_A, ALU_Input_B, nextPC, WriteReg;
	wire myCLK, myReset;
	reg[3:0] store;	//记录当前要显示位的值
	wire[2:0] state;
	
	CPU CPU(myCLK, myReset, curPC, nextPC, instruction, IRInstruction, ADROut, BDROut, DBDROut, ALUoutDROut, Ext_Imm, ReadData1, ReadData2, ALU_Input_A, ALU_Input_B, WriteData, WriteReg,state);
	remove_shake remove_shake_clk(CLK, Button, myCLK);
    remove_shake remove_shake_reset(CLK, Reset, myReset);
    clk_slow slowclk(CLK, myReset, AN);
	display show_in_7segment(store, myReset, Out);
	
	always@(myCLK)begin
	   case(AN)
			4'b1110:begin
				case(display_mode)
					3'b000: store <= nextPC[3:0];
					3'b010: store <= ADROut[3:0];
					3'b100: store <= BDROut[3:0];
					3'b110: store <= WriteData[3:0];
					default: store <= {3'b000,state[0]};
				endcase
			end
			4'b1101:begin
				case(display_mode)
					3'b000: store <= nextPC[7:4];
					3'b010: store <= ADROut[7:4];
					3'b100: store <= BDROut[7:4];
					3'b110: store <= WriteData[7:4];
                    default: store <= {3'b000,state[1]};
				endcase
			end
			4'b1011:begin
				case(display_mode)
					3'b000: store <= curPC[3:0];
					3'b010: store <= IRInstruction[24:21];
					3'b100: store <= IRInstruction[19:16];
					3'b110: store <= ALUoutDROut[3:0];
                    default: store <= {3'b000,state[2]};
				endcase
			end
			4'b0111:begin
				case(display_mode)
					3'b000: store<= curPC[7:4];
					3'b010: store <= {3'b000,IRInstruction[25]};
					3'b100: store <= {3'b000,IRInstruction[20]};
					3'b110: store <= ALUoutDROut[7:4];
					default: store <= 4'b0000;
				endcase
			end
		endcase
	end
endmodule