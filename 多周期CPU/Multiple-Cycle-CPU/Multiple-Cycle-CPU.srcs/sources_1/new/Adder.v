`timescale 1ns / 1ps

module Adder(
    input[31:0] old1,
    input[31:0] old2,
    output[31:0] res
    );
    assign res = old1 + old2;
endmodule
