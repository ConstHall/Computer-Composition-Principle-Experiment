`timescale 1ns / 1ps

module remove_shake(
    input clk, key_in,
    output key_out);
	parameter SAMPLE_TIME = 20000;
	reg[21:0] count_low;
	reg[21:0] count_high;
	reg key_out_reg;

	always@(posedge clk) begin
		count_low <= !key_in ? 0 : count_low + 1;
		count_high <= key_in ? 0 : count_high + 1;
		if(count_high == SAMPLE_TIME)
			key_out_reg <= 1;
		else if(count_low == SAMPLE_TIME)
			key_out_reg <= 0;
	end
	assign key_out = !key_out_reg;
endmodule
