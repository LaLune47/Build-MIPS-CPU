.data
matrix:  .space 400   #10*10*4
kernel:  .space 400   
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.macro  getIndex(%ans,%i,%j)
    mul %ans   ,%i , 10
    add %ans   ,%ans , %j
    sll %ans   ,%ans ,2
.end_macro

.macro READ(%n)
	li $v0, 5
	syscall
	move %n, $v0
.end_macro

.macro PRINT(%n)
	li $v0, 1
	move $a0, %n
	syscall
.end_macro


.text
      READ($s0)    #  s0  ==  m1
      READ($s1)    #  s1  ==  n1
      READ($s2)    #  s2  ==  m2
      READ($s3)    #  s3  ==  n2

     ######### read M     
      li $t0 , 0   #  t0  ==  i
      for_M_i:
      beq $t0 , $s0 ,for_M_i_end
      nop  
           li $t1 , 0   #  t1  ==  j
           for_M_j:
           beq  $t1 , $s1 ,for_M_j_end
           nop
               READ($t2)    #  t2 == num
               getIndex($t4, $t0 ,$t1 )  #  t4 ==  address
               sw  $t2 , matrix($t4)
               add  $t1 ,$t1 ,1
               j for_M_j
           for_M_j_end:
           add  $t0 , $t0 , 1
           j  for_M_i
       for_M_i_end:

     ######### read K     
      li  $t0 , 0   #  t0  ==  i
      for_K_i:
      beq $t0 , $s2 ,for_K_i_end
      nop  
           li $t1 , 0   #  t1  ==  j
           for_K_j:
           beq  $t1 , $s3 ,for_K_j_end
           nop
               READ($t2)    #  t2 == num
               getIndex($t4, $t0 ,$t1 )  #  t4 ==  address
               sw  $t2 , kernel($t4)
               add  $t1 ,$t1 ,1
               j for_K_j
           for_K_j_end:
           add  $t0 , $t0 , 1
           j  for_K_i
       for_K_i_end:

     ######### print   
      li  $t0 , 0   #  t0  ==  i
      for_PRINT_i:
      move  $t4 , $s0
      sub   $t4  , $t4 , $s2
      add   $t4  , $t4 , 1   #  t4 ==  m1 - n1 + 1
      beq  $t0 , $t4 ,for_PRINT_i_end
      nop  
           li $t1 , 0   #  t1  ==  j
           for_PRINT_j:
           move  $t4 , $s1
           sub   $t4  , $t4 , $s3
           add   $t4  , $t4 , 1   #  t4 ==  m2 - n2 + 1
           beq   $t1 , $t4 ,for_PRINT_j_end
           nop
                   li  $t4 , 0 # t4 == sum ，初始为0
                       li $t2 , 0   #  t2  ==  k
                       for_PRINT_k:
                       beq   $t2 , $s2 ,for_PRINT_k_end
                       nop         
                            li $t3 , 0   #  t3  ==  l
                            for_PRINT_l:
                            beq   $t3 , $s3 ,for_PRINT_l_end
                            nop    
                                   add  $t5 , $t0 , $t2  # i+k
                                   add  $t6 , $t1 , $t3  # j+l 
                                   getIndex($t7 , $t5 , $t6 )
                                   lw  $t7 , matrix($t7)
                                   getIndex($t5 , $t2, $t3)
                                   lw  $a3 , kernel($t5)    #小心不同矩阵不一样，最后算错了
                                   mul $t6 , $t7, $a3       #乘法当然不需要乘法底子，就两个数想什么呢
                                   add  $t4, $t4 , $t6
                                   
                                   add  $t3 , $t3 ,1
                                   j for_PRINT_l
                             for_PRINT_l_end:
                             add  $t2 ,$t2 ,1
                             j  for_PRINT_k
                        for_PRINT_k_end:
                        PRINT($t4)
                     #### 空格符的操作 ###
                     move  $t5 , $s1
                     sub   $t5  , $t5 , $s3    #  t5 == n1-n2
                     beq  $t1, $t5 ,else
                         la  $a0  ,str_space
                         li  $v0 ,4
                         syscall 
                         j if_end         # 每个if 都不能省，要不然会if——else连着执行，编译没有那么智能可以直接跳出
                       else:
                         la  $a0  ,str_enter
                         li $v0 ,4
                         syscall    
                       if_end:                   
               add  $t1 ,$t1 ,1
               j for_PRINT_j
           for_PRINT_j_end:
           add  $t0 , $t0 , 1
           j  for_PRINT_i
       for_PRINT_i_end:



       li  $v0 , 10
       syscall 




















