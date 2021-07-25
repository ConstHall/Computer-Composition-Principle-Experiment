`timescale 1ns / 1ps

module Mux2(
    input Select,
    input[31:0] in1,
    input[31:0] in2,
    output[31:0] out
    );
    assign out = Select ? in2 : in1;
endmodule
