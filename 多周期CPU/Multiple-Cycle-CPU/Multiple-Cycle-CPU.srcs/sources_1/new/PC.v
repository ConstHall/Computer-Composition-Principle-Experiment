`timescale 1ns / 1ps

module PC(
    input CLK,
    input Reset,
    input PCWre,
    input [31:0] nextPC,
    output reg [31:0] curPC
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
