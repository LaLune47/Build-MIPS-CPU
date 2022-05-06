.data   
matrix_1:  .space 256     #8*8*4
matrix_2:  .space 256
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.macro  getIndex(%ans,%i,%j,%rank)
    mul %ans   ,%i , %rank
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
     READ($s0)
     
#######################  read matrix_1
     li   $t0,0            # i 
     loop_get_1_x:
       beq  $t0 ,$s0 , loop_get_1_x_end
       nop
           li  $t1, 0            # j
           loop_get_1_y:
             beq  $t1 ,$s0 , loop_get_1_y_end
             nop  
                  READ($t4)
                  li $t2 , 8
                  getIndex($t3 , $t0 ,$t1 ,$t2)
                  sw  $t4 , matrix_1($t3)
             add  $t1  ,$t1 , 1
             j  loop_get_1_y
             nop
          loop_get_1_y_end:
        add  $t0  ,$t0 , 1
        j  loop_get_1_x
        nop
      loop_get_1_x_end:
     
#######################  read matrix_2
     li   $t0,0            # i 
     loop_get_2_x:
       beq  $t0 ,$s0 , loop_get_2_x_end
       nop
           li  $t1, 0            # j
           loop_get_2_y:
             beq  $t1 ,$s0 , loop_get_2_y_end
             nop  
                  READ($t4)
                  li $t2 , 8
                  getIndex($t3 , $t0 ,$t1 ,$t2)
                  sw  $t4 , matrix_2($t3)
             add  $t1  ,$t1 , 1
             j  loop_get_2_y
             nop
          loop_get_2_y_end:
        add  $t0  ,$t0 , 1
        j  loop_get_2_x
        nop
      loop_get_2_x_end:
      

 #######################  write matrix    
     li   $t0,0            # i 
     loop_write_x:
       beq  $t0 ,$s0, loop_write_x_end
       nop
            li   $t1,0            # j
           loop_write_y:
             beq  $t1 ,$s0 , loop_write_y_end
             nop
                   li   $t7 , 0          #最后的累加项
                   li   $t2,0            # k
                 loop_write_ans:
                   beq  $t2 ,$s0  , loop_write_ans_end
                   nop  
                        li   $t4 ,1    #乘法底子
                        li   $t6 ,8    #rank
                        getIndex($t3 , $t0 ,$t2, $t6 )   #  [i,k]
                        lw   $t5 , matrix_1($t3)
                        mul  $t4, $t4 ,$t5
                        getIndex($t3 , $t2 ,$t1 ,$t6)   #  [k,j]
                        lw   $t5 , matrix_2($t3)
                        mul  $t4, $t4 ,$t5 
                        add  $t7 ,$t7 ,$t4
                   add  $t2 , $t2 ,1
                   j  loop_write_ans
                   nop
                 loop_write_ans_end:     
                   PRINT($t7)
                   move  $t5, $t1
                   add  $t5 , $t5 , 1 
                   beq  $t5 , $s0 ,else                      # if 不是末尾  ,是末尾跳转
                   nop
                      la  $a0 , str_space
                      li  $v0, 4
                      syscall 
                      j  end_if
                   else:
                      la  $a0 , str_enter
                      li  $v0, 4
                      syscall
                   end_if:      
             add  $t1  ,$t1 , 1
             j  loop_write_y
             nop
          loop_write_y_end:
        add  $t0  ,$t0 , 1
        j  loop_write_x
        nop
      loop_write_x_end:

        
       
       li  $v0, 10
       syscall   
          
          
          
          
          
          
          
