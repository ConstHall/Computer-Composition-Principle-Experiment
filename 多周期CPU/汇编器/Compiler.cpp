#include<iostream>
#include<fstream>
#include<sstream>
#include<unordered_map>
#include<string>
#include<vector>
#include<bitset>
using namespace std;
#define BINSTR(str, len) (bitset<len>(stoi(str, nullptr, 0)).to_string())
//bitset容器：用于存放01位串 
//to_string():转化为字符串 
//stoi：将字符串转化为十进制整数 
//BINSTR：将每行汇编程序中的数字（字符形式）转化为十进制整数，再通过bitset容器将其转化为二进制位串并存入其中，并将容器中的内容再次转化为字符串
//因为bitset容器本质上是一个bool类型的数组 
string transform(string str);

int main() {
	ifstream fin("test.asm"); //打开需要转换的汇编程序 
	ofstream fout("instruction.txt");//将结果写入其中 
	string str;
	int i;
	while(getline(fin,str)){ //按行来读取汇编程序 
		str=transform(str);
		for(i=0;i<str.size();i++) {//输出结果 每8位空一格，该行程序输出结束后打印回车另起一行 
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
	unordered_map<string, string> ins{//将指令与操作码一一匹配 
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
		}//将特殊符号转化为空格，这样就可以将操作码，rs，rt，rd，imm(立即数)分隔开 
	}
	vector<string> vec_str;
	istringstream iss(str);
	while (iss>>str){
		vec_str.push_back(str);//由上面注释可知，操作码,rs,rt,rd,imm(立即数)都是单独存放在容器中的（因为有空格） 
	}
	switch(vec_str.size()){//根据容器大小来初步区分指令 
		case 0:
			return "";
			break;
		case 1://容器大小为1的只能是halt 
			str=ins[vec_str[0]]+string(26,'0');
			break;
		case 2://容器大小为2的为J型指令：jr,jal,j 
			str=ins[vec_str[0]];
			if(vec_str[0]=="jr"){//jr
				str+=BINSTR(vec_str[1],5)+string(15,'0')+"001000";
			}
			else{//j或jal 
				str+=bitset<26>(stoi(vec_str[1], nullptr,0)>>2).to_string();//由题目要求可知跳转的地址需要右移两位再写入（存入的是addr[27:2]） 
			//由于MIPS32的指令代码长度占4个字节，所以指令地址二进制数最低2位均为0，将指令地址放进指令代码中时，可省掉！
			}
			break;
		case 3://bltz
			str=ins[vec_str[0]]+BINSTR(vec_str[1],5)+string(5,'0')+BINSTR(vec_str[2],16);
			break;
		case 4:
			str=ins[vec_str[0]];
			if(vec_str[0]=="sw"||vec_str[0]=="lw"){//sw或lw 
				str+=BINSTR(vec_str[3],5)+BINSTR(vec_str[1],5)+BINSTR(vec_str[2],16);
			}
			else if(vec_str[0]=="sll"){//sll
				str+=string(5,'0')+BINSTR(vec_str[2],5)+BINSTR(vec_str[1],5)+BINSTR(vec_str[3],5)+string(6,'0');
			}
			else if(vec_str[0]=="beq"||vec_str[0]=="bne"){//beq或bne 
				str += BINSTR(vec_str[1], 5) + BINSTR(vec_str[2], 5) + BINSTR(vec_str[3], 16);
			}
			else if(vec_str[0].find('i')!=vec_str[0].npos){//如果指令中出现i，则是addiu或andi或ori或xori或slti 
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


