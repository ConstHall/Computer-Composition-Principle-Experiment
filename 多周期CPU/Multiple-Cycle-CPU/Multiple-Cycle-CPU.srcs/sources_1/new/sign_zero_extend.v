`timescale 1ns / 1ps

module sign_zero_extend(
    input [15:0] immediate,
    input ExtSel,
    output [31:0] extendImmediate
    );
    
    assign extendImmediate = {ExtSel && immediate[15] ? 16'hffff : 16'h0000, immediate};
    
endmodule
