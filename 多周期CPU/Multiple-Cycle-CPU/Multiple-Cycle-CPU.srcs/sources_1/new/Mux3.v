`timescale 1ns / 1ps

module Mux3(
    input[1:0] Select,
    input[31:0] in1,
    input[31:0] in2,
    input[31:0] in3,
    output[31:0] out
    );
    
    assign out = Select == 2'b00 ? in1 : Select == 2'b01 ? in2 : in3;
    
endmodule
