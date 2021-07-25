module ControlUnit(
    input CLK,
    input Reset,
    input [5:0] op,
    input [5:0] funct,
    input zero,
    input sign,
    output reg[2:0] state,
    output PCWre,
    output InsMemRW,
    output IRWre,
    output WrRegDSrc,
    output [1:0] RegDst,
    output RegWre,
    output reg [2:0] ALUop,
    output ALUSrcA,
    output ALUSrcB,
    output reg [1:0] PCSrc,
    output mRD,
    output mWR,
    output DBDataSrc,
    output ExtSel
    );
    
    parameter R_type = 6'b000000;//用于归并操作码相同的指令
    parameter addiu = 6'b001001;
    parameter andi = 6'b001100;
    parameter ori = 6'b001101;
    parameter xori = 6'b001110;
    parameter slti = 6'b001010;
    parameter sw = 6'b101011;
    parameter lw = 6'b100011;
    parameter beq = 6'b000100;
    parameter bne = 6'b000101;
    parameter bltz = 6'b000001;
    parameter j = 6'b000010;
    parameter jal = 6'b000011;
    parameter halt = 6'b111111;
    //用功能码区分R型指令
    parameter add = 6'b100000;
    parameter sub = 6'b100010;
    parameter And = 6'b100100;
    parameter Or = 6'b100101;
    parameter sll = 6'b000000;
    parameter slt = 6'b101010;
    parameter jr = 6'b001000;
    
     initial begin
           state <= 3'b000;//所有指令的初始状态均从000开始
       end
       always @(posedge CLK) begin
           if(Reset==0)    state <= 3'b000;//状态重置
           else case(state)
               3'b000:  if(op!=6'b111111) state <= 3'b001;
                        else              state <= state;
                        //除非停机，否则000无条件跳转至001
               3'b001: begin
                           case(op)
                                6'b000000: begin
                                    if(funct==6'b001000)    state<=3'b000; //jr
                                    else                    state<=3'b110; //R型指令
                                           end
                                6'b001001: state<=3'b110; //addiu
                                6'b001100: state<=3'b110; //andi
                                6'b001101: state<=3'b110; //ori
                                6'b001110: state<=3'b110; //xori
                                6'b001010: state<=3'b110; //slti
                                6'b000100: state<=3'b101; //beq
                                6'b000101: state<=3'b101; //bne
                                6'b000001: state<=3'b101; //bltz
                                6'b101011: state<=3'b010; //sw
                                6'b100011: state<=3'b010; //lw
                                6'b000010: state<=3'b000; //j
                                6'b000011: state<=3'b000; //jal
                                6'b111111: state<=3'b000; //halt
                           endcase
                       end
               3'b110: state <= 3'b111;
               3'b101: state <= 3'b000;
               3'b010: state <= 3'b011;
               //以上三行均根据状态转移图写出
               3'b011: begin
                           case(op)//sw和lw的区分
                               6'b100011: state<=3'b100;//lw
                               6'b101011: state<=3'b000;//sw
                           endcase
                       end
               3'b100: state<=3'b000;
               3'b111: state<=3'b000;
               //以上两行均根据状态转移图写出
           endcase
       end
    //根据表1写出每个控制信号的布尔表达式
    assign WrRegDSrc = !(op==jal); 
    //写寄存器组数据选择信号，jal指令时选择PC4作为写寄存器组数据，其余情况选择DB总线数据
    assign RegDst = op==jal? 2'b00 : (op==R_type? 2'b10:2'b01);
    //写寄存器组地址选择信号，jal指令选择31号寄存器，R型指令选择rd段，I型指令选择rt段
    assign InsMemRW = 1;
    //指令存储器写使能信号，恒为1
    assign PCWre = (state==3'b001 & (op==j | op==jal | (op==R_type & funct==jr))) | (state==3'b111) | (state==3'b101) | (state==3'b100) | (state==3'b011 & op==sw);
    //PC寄存器写使能信号，取指阶段为0，其余为1
    assign IRWre = (state==3'b000);
    //IR寄存器写使能信号，取指阶段为1，其余为0
    assign RegWre = (state==3'b111 || state==3'b100 || (state==3'b001 && op==jal));
    //寄存器组写使能信号，在WB阶段为1，其余为0
    assign ALUSrcA = (op==R_type & funct==sll);
    //ALU A输入端口选择信号，sll指令为1（选择sa作为ALU的A输入），其余为0（选择寄存器组A输出作为ALU的A输入）
    assign ALUSrcB = !(op==R_type || op==beq || op==bne || op==bltz);
    //ALU B输入端口选择信号，R型指令为0（选择寄存器组B输出作为ALU的B输入），其余为1（选择立即数拓展单元输出作为ALU的B输入）
    assign mRD = (op==lw && state==3'b011);
    //数据存储器读使能信号，只有在lw指令的MEM阶段为1
    assign mWR = (op==sw && state==3'b011);
    //数据存储器写使能信号，只有在sw指令的MEM阶段为1
    assign DBDataSrc = (op==lw);
    //DB总线选择信号，lw指令选择数据存储器输出作为写寄存器组数据，其余选择ALU输出
    assign ExtSel = (op==addiu || op==slti || op==sw || op==lw || op==beq || op== bne || op==bltz);
    //扩展单元控制信号，addiu,slti,sw,lw,beq,bne,bltz指令作符号位扩展（ExtSel为1），其余作0扩展
    always @(*) begin
        if(op==j || op==jal) PCSrc=2'b11;
        else if(op==R_type && funct==jr) PCSrc = 2'b10;
        else if( (op==beq && zero) || (op==bne && !zero) || (op==bltz && sign) ) PCSrc = 2'b01;
        else    PCSrc=2'b00;
        //PC寄存器输入数据选择信号，11：j指令，10：jr指令，01：分支指令达成条件，00：正常情况
        if((op==R_type && funct==add) || (op==addiu) || (op==sw) || (op==lw)) 
            ALUop=3'b000;
        else if((op==R_type && funct==sub) || (op==beq) || (op==bne) || (op==bltz))
            ALUop=3'b001;
        else if((op==R_type && funct==sll))
            ALUop=3'b010;
        else if((op==R_type && funct==Or) || (op==ori))
            ALUop=3'b011;
        else if((op==R_type && funct==And) || (op==andi))
            ALUop=3'b100;
        else if((op==R_type && funct==slt) || (op==slti))
            ALUop=3'b110;
        else if(op==xori)   
            ALUop=3'b111;
        //ALU运算功能，根据指令类型选择ALU的操作码
    end
    
endmodule
