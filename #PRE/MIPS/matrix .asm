.data
matrix: .space  10000            # int matrix[50][50]   50*50*4 字节
                                # matrix[0][0] 的地址为 0x00，matrix[0][1] 的地址为 0x04，……
                                # matrix[1][0] 的地址为 0x20，matrix[1][1] 的地址为 0x24，……
                                # ……
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

# 这里使用了宏，%i 为存储当前行数的寄存器，%j 为存储当前列数的寄存器
# 把 (%i * 8 + %j) * 4 存入 %ans 寄存器中 ,这样就得到了当前处理元素的实际地址
.macro  getindex(%ans, %i, %j)
    mul %ans, %i, 50            # %ans = %i * 50
    add %ans, %ans, %j          # %ans = %ans + %j
    sll %ans, %ans, 2           # %ans = %ans * 4
.end_macro

.text
    li  $v0, 5
    syscall
    move $s0, $v0                   # 行数   s0
    li  $v0, 5
    syscall
    move $s1, $v0                   # 列数   s1
    
##############################################################################################
li  $t0 ,0                         #i,外层循环变量
input_n_begin:
    slt   $t1 , $t0 ,$s0            #  ==(t2<t3)
    beqz $t1 , input_n_end
    nop
   
        li  $t2 ,0                 #j,内层循环变量
        input_m_begin:
           slt  $t3 , $t2 ,$s1                               #  ==(t2<=t3)
           beqz $t3 , input_m_end
           nop 
                 li  $v0, 5
                 syscall         
                 getindex($t4, $t0, $t2) 
                 sw  $v0, matrix($t4)            # matrix[$t0][$t1] = $v0
           addi $t2 ,$t2 ,1                      #j++
           j  input_m_begin
           nop
        input_m_end:
           
    addi $t0 ,$t0 ,1        #i++
    j  input_n_begin
    nop
input_n_end:


move  $t0 ,$s0      #i,外层循环变量
addi   $t0, $t0 ,-1
output_n_begin:
    sge    $t1 , $t0 , $zero                               #  ==(t2>=t3)
    beqz  $t1 , output_n_end
    nop
       
        move  $t2 ,$s1    #j,内层循环变量
        addi  $t2,$t2 ,-1
        output_m_begin:
           sge   $t3 , $t2 , $zero                               #  ==(t2>=t3)
           beqz $t3 , output_m_end
           nop
                 getindex($t4, $t0, $t2) 
                 lw  $a1 ,matrix($t4)
                 
                 bnez  $a1 ,else_output
                 nop
                 j  if_end
                 nop
                 else_output:
                    addi  $t4 , $t0 ,1                          #就是数组地址从1开始的问题
                    move  $a0 , $t4
                    li  $v0 , 1
                    syscall  
                    
                    la   $a0, str_space
                    li  $v0,  4
                    syscall
                    
                    addi  $t5 , $t2 ,1
                    move  $a0 , $t5
                    li  $v0 , 1
                    syscall 
                    
                    la  $a0, str_space
                    li  $v0,4
                    syscall
                    
                    move  $a0 , $a1
                    li  $v0 , 1
                    syscall 
                    
                    la  $a0, str_enter
                    li  $v0,4
                    syscall
                if_end:
       
           addi $t2 ,$t2 ,-1           #j--
           j  output_m_begin
           nop
        output_m_end:
           
    addi $t0 ,$t0 ,-1        #i--
    j  output_n_begin
    nop
    
output_n_end:
    li  $v0, 10
    syscall
