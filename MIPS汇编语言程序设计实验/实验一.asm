.data
  array: .space  400  # 每个整数给予4个字节的空间,400个字节则最多可对100个数字进行排序
  seperate: .asciiz " " # 输出时每个数字之间需要输出空格隔开
  UI: .asciiz "Please enter the numbers of elements you want to sort:\n" # 输入提示

.text
.globl main
main:
  la $a0, UI # 打印UI中的提示输入字符串
  li $v0, 4  # 调用print_string，打印字符串
  syscall
  li $v0, 5  # 调用read_int,读取输入的整数
  syscall
  move $t6,$v0  # 将数字个数存储到t6中
  la $t0, array  # 将数组首地址存储到t0中
  move $t1, $zero  # 循环变量i初始化为0并存储到t1中
  move $t2, $zero  # 循环变量j初始化为0并存储到t1中
  move $t5, $t0  # 将数组的头指针存储到t5中
  subi $t7, $t6, 1  # t7的值为数组的长度减1（因为数组的最后一个元素为array[t6-1]）
  # 为称呼简便，以下的数组长度均简称为len

inputNumber:
  li $v0, 5  # 读取每个数组元素
  syscall
  sw $v0, 0($t0)  # 将v0存入t0中的地址指向的主存单元中。
  addi $t0, $t0, 4  # 指向下一个连续的4字节地址用于存储新的输入整数
  addi $t1, $t1, 1  # i++
  blt $t1, $t6, inputNumber # 若i<数组长度
  move $t1, $zero  # 若不满足blt（即i==len），则i=0，让i能继续被用于outerLoop循环（在进入outerLoop之前完成i的初始化）
  subi $t8, $t6, 1 # 用于内部循环的终止条件（即j<len-1-i）(t8==len-1)

outerLoop:
  la $t5, array # t5=array[0]
  move $t2, $zero  # j=0
  blt $t1, $t6, innerLoop  # 若i<len，则进入innerLoop
  beq $t1, $t6, init  # 若i==len，则进入init
  
innerLoop:
  
  beq $t2, $t7, nextLoop  # 若j==len-1-i，则终结内层循环，进入nextLoop,准备重新进入外层循环
  lw $t3, 0($t5)  # 将t5中的地址所指向的主存单元(即array[j])存入t3
  lw $t4, 4($t5)  # 将t5地址+4所得的地址所指向的主存单元（即array[j+1]）存入t4
  bgt $t3 $t4 swap  # 若t4中的值小于t3（即array[j]>array[j+1]）将t4和t3进行交换（即将array[j]和array[j+1]进行交换）
  addi $t5, $t5, 4  # 若不满足bgt（即array[j]<=array[j+1]）,则数组的头指针偏移4个字节（即指向位置+1）
  addi $t2, $t2, 1 # j++
  j innerLoop  # 再次进入inner循环

nextLoop:
  addi $t1, $t1, 1  # i++
  j outerLoop  # 内部循环（innerLoop）结束，重新回到外部循环（outerLoop）

swap:
  sw $t3, 4($t5)  # 将t3存入t5中的地址+4（array[j+1]）所指向的主存单元中。
  sw $t4, 0($t5)  # 将t4存入t5中的地址（array[j]）所指向的主存单元中。
  addi $t5, $t5, 4  # 数组的头指针偏移4个字节（即指向位置+1）
  addi $t2, $t2, 1 # j++
  j innerLoop  #再次进入inner循环

init:
  la $t0, array  # t0=array[0]
  addi $t1, $zero, 0  # i=0，使得i能继续用于printResult循环（在进入printResult之前完成i的初始化）

printResult:
  # 按顺序打印数组元素
  lw $a0, 0($t0)  # 将t0中的地址（初始值为数组头地址array[0]）所指向的主存单元存入a0
  li $v0, 1  # 调用print_int，打印整数
  syscall
  #打印空格隔开数组元素
  la $a0, seperate  #将seperate中的字符串存入a0中
  li $v0, 4  # 调用print_string，打印字符串
  syscall
  addi $t0, $t0, 4  # t0地址偏移4个字节（即t0指向的数组元素位置+1）
  addi $t1, $t1, 1  # i++
  blt $t1, $t6, printResult  #若i仍处于数组下标范围内（0—(数组长度-1)），则再次重新进入printResult进行循环

  li $v0, 10  # 调用exit，程序结束
  syscall
