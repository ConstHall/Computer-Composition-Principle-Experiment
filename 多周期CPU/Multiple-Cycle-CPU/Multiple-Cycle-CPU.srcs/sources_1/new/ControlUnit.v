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
    
    parameter R_type = 6'b000000;//���ڹ鲢��������ͬ��ָ��
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
    //�ù���������R��ָ��
    parameter add = 6'b100000;
    parameter sub = 6'b100010;
    parameter And = 6'b100100;
    parameter Or = 6'b100101;
    parameter sll = 6'b000000;
    parameter slt = 6'b101010;
    parameter jr = 6'b001000;
    
     initial begin
           state <= 3'b000;//����ָ��ĳ�ʼ״̬����000��ʼ
       end
       always @(posedge CLK) begin
           if(Reset==0)    state <= 3'b000;//״̬����
           else case(state)
               3'b000:  if(op!=6'b111111) state <= 3'b001;
                        else              state <= state;
                        //����ͣ��������000��������ת��001
               3'b001: begin
                           case(op)
                                6'b000000: begin
                                    if(funct==6'b001000)    state<=3'b000; //jr
                                    else                    state<=3'b110; //R��ָ��
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
               //�������о�����״̬ת��ͼд��
               3'b011: begin
                           case(op)//sw��lw������
                               6'b100011: state<=3'b100;//lw
                               6'b101011: state<=3'b000;//sw
                           endcase
                       end
               3'b100: state<=3'b000;
               3'b111: state<=3'b000;
               //�������о�����״̬ת��ͼд��
           endcase
       end
    //���ݱ�1д��ÿ�������źŵĲ������ʽ
    assign WrRegDSrc = !(op==jal); 
    //д�Ĵ���������ѡ���źţ�jalָ��ʱѡ��PC4��Ϊд�Ĵ��������ݣ��������ѡ��DB��������
    assign RegDst = op==jal? 2'b00 : (op==R_type? 2'b10:2'b01);
    //д�Ĵ������ַѡ���źţ�jalָ��ѡ��31�żĴ�����R��ָ��ѡ��rd�Σ�I��ָ��ѡ��rt��
    assign InsMemRW = 1;
    //ָ��洢��дʹ���źţ���Ϊ1
    assign PCWre = (state==3'b001 & (op==j | op==jal | (op==R_type & funct==jr))) | (state==3'b111) | (state==3'b101) | (state==3'b100) | (state==3'b011 & op==sw);
    //PC�Ĵ���дʹ���źţ�ȡָ�׶�Ϊ0������Ϊ1
    assign IRWre = (state==3'b000);
    //IR�Ĵ���дʹ���źţ�ȡָ�׶�Ϊ1������Ϊ0
    assign RegWre = (state==3'b111 || state==3'b100 || (state==3'b001 && op==jal));
    //�Ĵ�����дʹ���źţ���WB�׶�Ϊ1������Ϊ0
    assign ALUSrcA = (op==R_type & funct==sll);
    //ALU A����˿�ѡ���źţ�sllָ��Ϊ1��ѡ��sa��ΪALU��A���룩������Ϊ0��ѡ��Ĵ�����A�����ΪALU��A���룩
    assign ALUSrcB = !(op==R_type || op==beq || op==bne || op==bltz);
    //ALU B����˿�ѡ���źţ�R��ָ��Ϊ0��ѡ��Ĵ�����B�����ΪALU��B���룩������Ϊ1��ѡ����������չ��Ԫ�����ΪALU��B���룩
    assign mRD = (op==lw && state==3'b011);
    //���ݴ洢����ʹ���źţ�ֻ����lwָ���MEM�׶�Ϊ1
    assign mWR = (op==sw && state==3'b011);
    //���ݴ洢��дʹ���źţ�ֻ����swָ���MEM�׶�Ϊ1
    assign DBDataSrc = (op==lw);
    //DB����ѡ���źţ�lwָ��ѡ�����ݴ洢�������Ϊд�Ĵ��������ݣ�����ѡ��ALU���
    assign ExtSel = (op==addiu || op==slti || op==sw || op==lw || op==beq || op== bne || op==bltz);
    //��չ��Ԫ�����źţ�addiu,slti,sw,lw,beq,bne,bltzָ��������λ��չ��ExtSelΪ1����������0��չ
    always @(*) begin
        if(op==j || op==jal) PCSrc=2'b11;
        else if(op==R_type && funct==jr) PCSrc = 2'b10;
        else if( (op==beq && zero) || (op==bne && !zero) || (op==bltz && sign) ) PCSrc = 2'b01;
        else    PCSrc=2'b00;
        //PC�Ĵ�����������ѡ���źţ�11��jָ�10��jrָ�01����ָ֧����������00���������
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
        //ALU���㹦�ܣ�����ָ������ѡ��ALU�Ĳ�����
    end
    
endmodule
