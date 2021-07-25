`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/25 08:25:21
// Design Name: 
// Module Name: display
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


module display(
    input[3:0] Store,
	input Reset,
	output reg[7:0] Out
    );
    always@(Store or Reset)begin
        if(Reset == 0) begin
            Out = 8'b01111111;
        end
        else begin
            case(Store)
                4'b0000 : Out = 8'b1100_0000; //0
                4'b0001 : Out = 8'b1111_1001; //1
                4'b0010 : Out = 8'b1010_0100; //2
                4'b0011 : Out = 8'b1011_0000; //3
                4'b0100 : Out = 8'b1001_1001; //4
                4'b0101 : Out = 8'b1001_0010; //5
                4'b0110 : Out = 8'b1000_0010; //6
                4'b0111 : Out = 8'b1101_1000; //7
                4'b1000 : Out = 8'b1000_0000; //8
                4'b1001 : Out = 8'b1001_0000; //9
                4'b1010 : Out = 8'b1000_1000; //A
                4'b1011 : Out = 8'b1000_0011; //b
                4'b1100 : Out = 8'b1100_0110; //C
                4'b1101 : Out = 8'b1010_0001; //d
                4'b1110 : Out = 8'b1000_0110; //E
                4'b1111 : Out = 8'b1000_1110; //F
                default : Out = 8'b0000_0000; 
            endcase
        end
    end
endmodule
