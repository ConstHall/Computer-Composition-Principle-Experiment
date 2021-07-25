`timescale 1ns / 1ps

module Adder(
        input CLK,    
        input Reset,          
        input [1:0] PCSrc,            
        input [31:0] immediate, 
        input [25:0] addr,
        input [31:0] curPC,
        output reg[31:0] nextPC
    );
    
    reg [31:0] newPC;
    initial newPC = 0 ;
    
    always@(negedge CLK or negedge Reset) begin
        if(Reset == 0) begin
            nextPC = 0;
        end
        else begin
            newPC = curPC + 4;
            case(PCSrc)
                2'b00: nextPC = curPC + 4;
                2'b01: nextPC = curPC + 4 + immediate * 4;
                2'b10: nextPC = {newPC[31:28],addr,2'b00};
                2'b11: nextPC = nextPC;
            endcase
        end
    end
endmodule

