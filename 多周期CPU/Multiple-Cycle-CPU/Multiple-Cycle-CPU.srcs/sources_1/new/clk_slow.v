`timescale 1ns / 1ps

module clk_slow(input CLK, input Reset, output reg[3:0] AN);
	reg[16:0] hide;
	parameter DIVISION = 100000;
    initial begin
		hide <= 0;
		AN <= 4'b0111;
	end
	//����ܿ�ʼˢ��
	always@(posedge CLK) begin
		if(Reset == 0)begin
            hide <= 0;
            AN <= 4'b0000;

		end 
		else begin
			hide <= hide + 1;//��Ƶ����
			if(hide == DIVISION) begin
                hide <= 0;
                case(AN)
                    4'b1110:begin
                        AN <= 4'b1101;
                    end
                    4'b0000:begin
                        AN <= 4'b1101;
                    end
                    4'b1101:begin
                        AN <= 4'b1011;
                    end
                    4'b1011: begin
                        AN <= 4'b0111;
                    end
                    4'b0111: begin
                        AN <= 4'b1110;
                    end
                endcase
            end
        end
    end
endmodule
