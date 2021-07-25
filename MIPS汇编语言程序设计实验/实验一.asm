.data
  array: .space  400  # ÿ����������4���ֽڵĿռ�,400���ֽ������ɶ�100�����ֽ�������
  seperate: .asciiz " " # ���ʱÿ������֮����Ҫ����ո����
  UI: .asciiz "Please enter the numbers of elements you want to sort:\n" # ������ʾ

.text
.globl main
main:
  la $a0, UI # ��ӡUI�е���ʾ�����ַ���
  li $v0, 4  # ����print_string����ӡ�ַ���
  syscall
  li $v0, 5  # ����read_int,��ȡ���������
  syscall
  move $t6,$v0  # �����ָ����洢��t6��
  la $t0, array  # �������׵�ַ�洢��t0��
  move $t1, $zero  # ѭ������i��ʼ��Ϊ0���洢��t1��
  move $t2, $zero  # ѭ������j��ʼ��Ϊ0���洢��t1��
  move $t5, $t0  # �������ͷָ��洢��t5��
  subi $t7, $t6, 1  # t7��ֵΪ����ĳ��ȼ�1����Ϊ��������һ��Ԫ��Ϊarray[t6-1]��
  # Ϊ�ƺ���㣬���µ����鳤�Ⱦ����Ϊlen

inputNumber:
  li $v0, 5  # ��ȡÿ������Ԫ��
  syscall
  sw $v0, 0($t0)  # ��v0����t0�еĵ�ַָ������浥Ԫ�С�
  addi $t0, $t0, 4  # ָ����һ��������4�ֽڵ�ַ���ڴ洢�µ���������
  addi $t1, $t1, 1  # i++
  blt $t1, $t6, inputNumber # ��i<���鳤��
  move $t1, $zero  # ��������blt����i==len������i=0����i�ܼ���������outerLoopѭ�����ڽ���outerLoop֮ǰ���i�ĳ�ʼ����
  subi $t8, $t6, 1 # �����ڲ�ѭ������ֹ��������j<len-1-i��(t8==len-1)

outerLoop:
  la $t5, array # t5=array[0]
  move $t2, $zero  # j=0
  blt $t1, $t6, innerLoop  # ��i<len�������innerLoop
  beq $t1, $t6, init  # ��i==len�������init
  
innerLoop:
  
  beq $t2, $t7, nextLoop  # ��j==len-1-i�����ս��ڲ�ѭ��������nextLoop,׼�����½������ѭ��
  lw $t3, 0($t5)  # ��t5�еĵ�ַ��ָ������浥Ԫ(��array[j])����t3
  lw $t4, 4($t5)  # ��t5��ַ+4���õĵ�ַ��ָ������浥Ԫ����array[j+1]������t4
  bgt $t3 $t4 swap  # ��t4�е�ֵС��t3����array[j]>array[j+1]����t4��t3���н���������array[j]��array[j+1]���н�����
  addi $t5, $t5, 4  # ��������bgt����array[j]<=array[j+1]��,�������ͷָ��ƫ��4���ֽڣ���ָ��λ��+1��
  addi $t2, $t2, 1 # j++
  j innerLoop  # �ٴν���innerѭ��

nextLoop:
  addi $t1, $t1, 1  # i++
  j outerLoop  # �ڲ�ѭ����innerLoop�����������»ص��ⲿѭ����outerLoop��

swap:
  sw $t3, 4($t5)  # ��t3����t5�еĵ�ַ+4��array[j+1]����ָ������浥Ԫ�С�
  sw $t4, 0($t5)  # ��t4����t5�еĵ�ַ��array[j]����ָ������浥Ԫ�С�
  addi $t5, $t5, 4  # �����ͷָ��ƫ��4���ֽڣ���ָ��λ��+1��
  addi $t2, $t2, 1 # j++
  j innerLoop  #�ٴν���innerѭ��

init:
  la $t0, array  # t0=array[0]
  addi $t1, $zero, 0  # i=0��ʹ��i�ܼ�������printResultѭ�����ڽ���printResult֮ǰ���i�ĳ�ʼ����

printResult:
  # ��˳���ӡ����Ԫ��
  lw $a0, 0($t0)  # ��t0�еĵ�ַ����ʼֵΪ����ͷ��ַarray[0]����ָ������浥Ԫ����a0
  li $v0, 1  # ����print_int����ӡ����
  syscall
  #��ӡ�ո��������Ԫ��
  la $a0, seperate  #��seperate�е��ַ�������a0��
  li $v0, 4  # ����print_string����ӡ�ַ���
  syscall
  addi $t0, $t0, 4  # t0��ַƫ��4���ֽڣ���t0ָ�������Ԫ��λ��+1��
  addi $t1, $t1, 1  # i++
  blt $t1, $t6, printResult  #��i�Դ��������±귶Χ�ڣ�0��(���鳤��-1)�������ٴ����½���printResult����ѭ��

  li $v0, 10  # ����exit���������
  syscall
