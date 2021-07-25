#include<iostream>
#include<fstream>
#include<sstream>
#include<unordered_map>
#include<string>
#include<vector>
#include<bitset>
using namespace std;
#define BINSTR(str, len) (bitset<len>(stoi(str, nullptr, 0)).to_string())
//bitset���������ڴ��01λ�� 
//to_string():ת��Ϊ�ַ��� 
//stoi�����ַ���ת��Ϊʮ�������� 
//BINSTR����ÿ�л������е����֣��ַ���ʽ��ת��Ϊʮ������������ͨ��bitset��������ת��Ϊ������λ�����������У����������е������ٴ�ת��Ϊ�ַ���
//��Ϊbitset������������һ��bool���͵����� 
string transform(string str);

int main() {
	ifstream fin("test.asm"); //����Ҫת���Ļ����� 
	ofstream fout("instruction.txt");//�����д������ 
	string str;
	int i;
	while(getline(fin,str)){ //��������ȡ������ 
		str=transform(str);
		for(i=0;i<str.size();i++) {//������ ÿ8λ��һ�񣬸��г�������������ӡ�س�����һ�� 
			fout<<str[i];
			if(i%8==7){
				fout<< ' ';
			}
		}
		fout<<'\n';
	}
	return 0;
}

string transform(string str){
	unordered_map<string, string> ins{//��ָ���������һһƥ�� 
		{"add","000000"},
		{"sub","000000"},
		{"addiu","001001"},
		{"and","000000"},
		{"andi","001100"},
		{"ori","001101"},
		{"xori","001110"},
		{"sll","000000"},
		{"slti","001010"},
		{"slt","000000"},
		{"sw","101011"},
		{"lw","100011"},
		{"beq","000100"},
		{"bne","000101"},
		{"bltz","000001"},
		{"j","000010"},
		{"jr","000000"},
		{"jal","000011"},
		{"halt","111111"}
	};
	for(auto & c : str){
		if(c=='$'||c=='('||c==')'||c==','){
			c=' ';
		}//���������ת��Ϊ�ո������Ϳ��Խ������룬rs��rt��rd��imm(������)�ָ��� 
	}
	vector<string> vec_str;
	istringstream iss(str);
	while (iss>>str){
		vec_str.push_back(str);//������ע�Ϳ�֪��������,rs,rt,rd,imm(������)���ǵ�������������еģ���Ϊ�пո� 
	}
	switch(vec_str.size()){//����������С����������ָ�� 
		case 0:
			return "";
			break;
		case 1://������СΪ1��ֻ����halt 
			str=ins[vec_str[0]]+string(26,'0');
			break;
		case 2://������СΪ2��ΪJ��ָ�jr,jal,j 
			str=ins[vec_str[0]];
			if(vec_str[0]=="jr"){//jr
				str+=BINSTR(vec_str[1],5)+string(15,'0')+"001000";
			}
			else{//j��jal 
				str+=bitset<26>(stoi(vec_str[1], nullptr,0)>>2).to_string();//����ĿҪ���֪��ת�ĵ�ַ��Ҫ������λ��д�루�������addr[27:2]�� 
			//����MIPS32��ָ����볤��ռ4���ֽڣ�����ָ���ַ�����������2λ��Ϊ0����ָ���ַ�Ž�ָ�������ʱ����ʡ����
			}
			break;
		case 3://bltz
			str=ins[vec_str[0]]+BINSTR(vec_str[1],5)+string(5,'0')+BINSTR(vec_str[2],16);
			break;
		case 4:
			str=ins[vec_str[0]];
			if(vec_str[0]=="sw"||vec_str[0]=="lw"){//sw��lw 
				str+=BINSTR(vec_str[3],5)+BINSTR(vec_str[1],5)+BINSTR(vec_str[2],16);
			}
			else if(vec_str[0]=="sll"){//sll
				str+=string(5,'0')+BINSTR(vec_str[2],5)+BINSTR(vec_str[1],5)+BINSTR(vec_str[3],5)+string(6,'0');
			}
			else if(vec_str[0]=="beq"||vec_str[0]=="bne"){//beq��bne 
				str += BINSTR(vec_str[1], 5) + BINSTR(vec_str[2], 5) + BINSTR(vec_str[3], 16);
			}
			else if(vec_str[0].find('i')!=vec_str[0].npos){//���ָ���г���i������addiu��andi��ori��xori��slti 
				str+=BINSTR(vec_str[2],5)+BINSTR(vec_str[1],5)+BINSTR(vec_str[3],16);
			}
			else{
				if(vec_str[0]=="add"){//add
					str+=BINSTR(vec_str[2],5)+BINSTR(vec_str[3],5)+BINSTR(vec_str[1],5)+string(5,'0')+"100000";
				}
				if(vec_str[0]=="sub"){//sub
					str+=BINSTR(vec_str[2],5)+BINSTR(vec_str[3],5)+BINSTR(vec_str[1],5)+string(5,'0')+"100010";
				}
				if(vec_str[0]=="and"){//and
					str+=BINSTR(vec_str[2],5)+BINSTR(vec_str[3],5)+BINSTR(vec_str[1],5)+string(5,'0')+"100100";
				}
				if(vec_str[0]=="or"){//or
					str+=BINSTR(vec_str[2],5)+BINSTR(vec_str[3],5)+BINSTR(vec_str[1],5)+string(5,'0')+"100101";
				}
				if(vec_str[0]=="slt"){//slt
					str+=BINSTR(vec_str[2],5)+BINSTR(vec_str[3],5)+BINSTR(vec_str[1],5)+string(5,'0')+"101010";
				}
			}
		default:
			break;
		}
	return str;
}


