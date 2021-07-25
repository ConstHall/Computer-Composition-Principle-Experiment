`timescale 1ns / 1ps

module SameRegister(
        input CLK,
        input [31:0] IData,
        input write,
        output reg[31:0] OData
    );

    initial begin 
        OData = 0;
    end

    always@(posedge CLK) begin
        if (write == 1) OData <= IData;
    end
endmodule
