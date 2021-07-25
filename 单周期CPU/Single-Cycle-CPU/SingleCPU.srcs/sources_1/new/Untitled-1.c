`timescale 1ns / 1ps

module Basy3(
	input[1:0] display_mode,
	input CLK, Reset, Button,
	output[3:0] AN,
	output[7:0] Out	
);

	wire[31:0] ALUresult, curPC, WriteData,ReadData1,ReadData2,instruction,nextPC;
	wire myCLK, myReset;
	reg[3:0] store;
	
	CPU cpu(myCLK,myReset,op,funct,ReadData1,ReadData2,curPC,nextPC,ALUresult,instruction,WriteData);
	remove_shake remove_shake_clk(CLK, Button, myCLK);
    remove_shake remove_shake_reset(CLK, Reset, myReset);
    clk_slow slowclk(CLK, myReset, AN);
	display show_in_7segment(store, myReset, Out);
	
	always@(myCLK)begin
	   case(AN)
			4'b1110:begin
				case(display_mode)
					2'b00: store <= nextPC[3:0];
					2'b01: store <= ReadData1[3:0];
					2'b10: store <= ReadData2[3:0];
					2'b11: store <= WriteData[3:0];
				endcase
			end
			4'b1101:begin
				case(display_mode)
					2'b00: store <= nextPC[7:4];
					2'b01: store <= ReadData1[7:4];
					2'b10: store <= ReadData2[7:4];
					2'b11: store <= WriteData[7:4];
				endcase
			end
			4'b1011:begin
				case(display_mode)
					2'b00: store <= curPC[3:0];
					2'b01: store <= instruction[24:21];
					2'b10: store <= instruction[19:16];
					2'b11: store <= ALUresult[3:0];
				endcase
			end
			4'b0111:begin
				case(display_mode)
					2'b00: store<= curPC[7:4];
					2'b01: store <= {3'b000,instruction[25]};
					2'b10: store <= {3'b000,instruction[20]};
					2'b11: store <= ALUresult[7:4];
				endcase
			end
		endcase
	end
endmodule
