.data
symbol: .space  32
array:  .space  32
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.macro  READ(%n)
     li  $v0 , 5
     syscall 
     move  %n , $v0
.end_macro 

.macro  PRINT(%n)
     li  $v0 , 1
     move  $a0, %n
     syscall 
.end_macro 

.macro  getIndex(%ans,%n)
     sll  %ans ,%n ,2
.end_macro 

.text
       READ($s0)   #  s0 == n  
       li  $a1 , 0   # a1 传递参数
       jal  FullArray
 #      PRINT($v0)
       
       li $v0 ,10
       syscall 
       
FullArray:
       # a1 == index   
       blt  $a1 , $s0 , if_1_end
            li  $t0 , 0   #  t0 == i   
            for_print:
              beq  $t0 , $s0  ,for_print_end
                 getIndex($t1,$t0)   #  t1  数组地址
                 lw  $t2 , array($t1)
                 PRINT($t2)
                 la  $a0, str_space
                 li  $v0 ,4
                 syscall  
              add  $t0 ,$t0, 1
              j  for_print
            for_print_end:
              la  $a0 , str_enter
              li  $v0,4
              syscall 
       jr $ra
       if_1_end:
       
       li  $t0 , 0   #  t0 == i   
       loop:       
         beq  $t0 , $s0  ,loop_end
            getIndex($t1,$t0)   #  t1  数组地址
            lw  $t2 , symbol($t1)   # t2 symbol[i]
            bnez   $t2 ,if_2_end
                 getIndex($t1,$a1)   #  t1  数组地址
                 add $t2 ,$t0 ,1   #  t2 == i + 1
                 sw  $t2 , array($t1)   # t3 == array[index]  == i+1
                 getIndex($t1,$t0)   #  t1  数组地址
                 li  $t2, 1       # t2 == 1
                 sw  $t2 , symbol($t1)
                 ############################################################
                 sw  $ra , 0($sp)       #基地址
                 subi  $sp, $sp, 4
                 sw  $a1 , 0($sp)       #参数 index
                 subi  $sp, $sp, 4      
                 sw  $t0 , 0($sp)       #t0
                 subi  $sp, $sp, 4
                 sw  $t1, 0($sp)       #t1
                 subi  $sp, $sp, 4                 
                 sw  $t2 , 0($sp)       #t2
                 subi  $sp, $sp, 4
                 
                 add $a1 ,$a1 ,1
                 jal   FullArray
                 
                 addi  $sp, $sp, 4    #t2
                 lw   $t2, 0($sp)   
                 addi  $sp, $sp, 4    #t1
                 lw   $t1, 0($sp)  
                 addi  $sp, $sp, 4    #t0
                 lw   $t0, 0($sp)                       
                 addi  $sp, $sp, 4    #t0
                 lw   $a1, 0($sp) 
                 addi  $sp, $sp, 4    #t0
                 lw   $ra, 0($sp)  
                 ###############################################################
                 getIndex($t1,$t0)   #  t1  数组地址
                 li  $t2, 0       # t2 == 0
                 sw  $t2 , symbol($t1)
            if_2_end:
         add  $t0, $t0 ,1
         j  loop
       loop_end:
         jr  $ra

       
       
       
       
       
       
       
       
       
