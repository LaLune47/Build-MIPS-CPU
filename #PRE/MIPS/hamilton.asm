 .data
matrix: .space  256             # 表示图像的邻接矩阵    int matrix[8][8]   8*8*4 字节
                                # matrix[0][0] 的地址为 0x00，matrix[0][1] 的地址为 0x04，……
                                # matrix[1][0] 的地址为 0x20，matrix[1][1] 的地址为 0x24，……
                                # ……
flag: .space  32                #标记是否已经遍历过 ，flag矩阵，

# 这里使用了宏，%i 为存储当前行数的寄存器，%j 为存储当前列数的寄存器
# 把 (%i * 8 + %j) * 4 存入 %ans 寄存器中 ,这样就得到了当前处理元素的实际地址
.macro  getindex(%ans, %i, %j)
    mul %ans, %i, 8             # %ans = %i * 8
    add %ans, %ans, %j          # %ans = %ans + %j
    sll %ans, %ans, 2           # %ans = %ans * 4
.end_macro

.macro  Arrayindex(%ans, %i)
    add  %ans, %i ,0       # %ans = 0 + %j
    sll %ans, %ans, 2           # %ans = %ans * 4
.end_macro


.text
    
      li   $s3, 0
      
      li   $v0, 5   
      syscall               
      move   $s0, $v0       #存入s0    s0:number of dots
      li   $v0, 5   
      syscall               
      move   $s1, $v0       #存入s1    s0:number of lines
      
      li  $t0, 0            #t0:边循环变量
      for_input_begin:
         slt   $t3 ,$t0 ,$s1    
         beqz  $t3,for_input_end
         nop
              li   $v0, 5   
              syscall   
              addi   $v0 ,$v0 ,-1            
              move   $t1, $v0       #存入t1   
              li   $v0, 5   
              syscall   
              addi   $v0 ,$v0 ,-1              
              move   $t2, $v0       #存入t2   t1,t2为顶点
              #存入边信息
              li $t5, 1                #t5作为1，常值
              getindex($t4, $t1, $t2)  #t4是存入的临时地址
              sw $t5, matrix($t4)
              getindex($t4, $t2, $t1)  #t4是存入的临时地址
              sw $t5, matrix($t4)
          addi $t0 ,$t0, 1
          j   for_input_begin
          nop
      for_input_end:
      
      ##设定新的全局变量  s0  dots ,s1lines , 
      ##s2  num(遍历深度)     s3   ans=1，最终结果
      li $s2 ,1            #  指的是1，也就是judge的第二个参数，实在是写得不太清楚，下次注意注释
      li $s3 ,0
      ##同时还要有传递参数 a0
      li $a0 ,0     # now ,后面一个参数倒是一直没变
                              ##这里调用之前，发现先前写的 预处理t临时变量没有一个是需要保留的，什么都不剩也可以
      jal judge
      
      move $a0 , $s3
      li   $v0, 1   
      syscall     
      li   $v0, 10   
      syscall     
      
      
          
judge:
      #递归临界条件的设置，num==n && matrix[a0][0]==1    (想清楚：0是最外层函数的传递参数a0=0，a0就是now)
      seq   $t0, $s2 ,$s0          # t0存储第一个条件
      getindex($t1, $a0, $zero)  # t1 存储矩阵临时地址
      lw  $t2, matrix($t1)       # t2 加载边情况
      li  $t3 ,1                 # t3 存储常数1
      seq $t4 ,$t2, $t3           # t4存储第二个条件
      and $t5 ,$t0, $t4          #条件综合
      
      beqz $t5 , if_end_1                  #若条件为0跳转
      nop
         li  $s3, 1  
         j  end
      if_end_1:
      
      
      li  $t0 ,1                 # t0 存储常数1 
      Arrayindex($t1, $a0)       # t1 数组临时地址
      sw $t0 , flag($t1)
      
 ##    seq  $t2 , $s2 , $s0        # t2 =(n!=num)   
 ##     beqz $t2 ,if_end_2        #等于零跳转，等于一进去条件
  ##    nop 
          li  $t3 ,0           #t3 i,循环变量
          for_2_begin:
              slt  $t4 ,$t3 ,$s0     # t4   =(i<n)    
              beqz $t4 , for_2_end
              nop
                  ##内部再判断flag【i】==0    matrix【now】【i】==1
                  Arrayindex($t1, $t3)       # t1 数组临时地址
                  lw  $t5 , flag($t1)       #$t5  flag[i]
                  seq  $t6 , $t5 ,$zero     #t6:条件1   
                  
                  getindex($t1, $a0, $t3)  # t1 存储矩阵临时地址
                  lw  $t5, matrix($t1)     # t5 加载边情况
                  seq $t7 , $t5 ,$t0      #t7 条件2 
                    
                  and $t5 ,$t6, $t7          # t7条件综合
                  beqz $t5 , if_end_3             #若条件为0跳转
                  nop
                        addi  $s2, $s2 ,1
                        #################################################
                        ##调用体现在这里！
                        ##保存  a0, 因为又要作为新的参数传给下面
                        ##保存  t0—t7，免得调用内层时覆盖
                        ##保存地址 ，防止jal覆盖   
                        sw  $ra , 0($sp)   
                        subi  $sp, $sp, 4
                        sw  $a0,  0($sp)
                        subi  $sp, $sp, 4  
                       
                        sw  $t0 , 0($sp)
                        subi  $sp, $sp, 4
                        sw  $t1,  0($sp)
                        subi  $sp, $sp, 4 
                        
                        sw  $t2 , 0($sp)
                        subi  $sp, $sp, 4
                        sw  $t3,  0($sp)
                        subi  $sp, $sp, 4 
                        
                        sw  $t4 , 0($sp)
                        subi  $sp, $sp, 4
                        sw  $t5,  0($sp)
                        subi  $sp, $sp, 4 
                        
                        sw  $t6 , 0($sp)
                        subi  $sp, $sp, 4
                        sw  $t7,  0($sp)
                        subi  $sp, $sp, 4 
    
    
                        move   $a0, $t3   ##传入i
                        jal   judge
     
                                               ##重新写入
                        addi  $sp, $sp, 4
                        lw   $t7, 0($sp)   
                        addi  $sp, $sp ,4
                        lw   $t6, 0($sp)
                        
                        addi  $sp, $sp, 4
                        lw   $t5, 0($sp)   
                        addi  $sp, $sp ,4
                        lw   $t4, 0($sp)
                        
                        addi  $sp, $sp, 4
                        lw   $t3, 0($sp)   
                        addi  $sp, $sp ,4
                        lw   $t2, 0($sp)
                        
                        addi  $sp, $sp, 4
                        lw   $t1, 0($sp)   
                        addi  $sp, $sp ,4
                        lw   $t0, 0($sp)
                        
                        addi  $sp, $sp, 4
                        lw   $a0, 0($sp)   
                        addi  $sp, $sp ,4
                        lw   $ra, 0($sp)
                        #################################################
                        addi  $s2, $s2 ,-1
                  if_end_3:
                               
              addi $t3 ,$t3,1 
              j  for_2_begin
              nop
          for_2_end:                            
 ##     if_end_2:                               
                                              
      Arrayindex($t1, $a0)       # t1 数组临时地址  ,flag[now]
      sw $zero ,flag($t1)           
      
      end:   
      jr   $ra            #通过巧妙设计，让深层递归函数结束后再进去跳出位置
      
      
       
      
      
      
      
      
      
      
      
      
      
      
      
