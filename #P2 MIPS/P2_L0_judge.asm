.data 
str:  .space  100


.text
     li $v0, 5
     syscall 
     move  $s0,$v0   # a0 = n

     
     li $t0 ,0   # i
     loop_read:
       bge  $t0,$s0 ,loop_read_end             #大于等于跳转，条件是小于
       nop
            li $v0, 12    
            syscall 
            sll  $t1,$t0 ,2
            sw  $v0 ,str($t1)
        add $t0 ,$t0 ,1
        j loop_read
      loop_read_end:
      
           
           
      li $t0 ,0   # i
      move  $t1 , $s0  
      addi  $t1,$t1,-1  #j
     loop_judge:
       bge    $t0,$t1 ,loop_judge_good_end             #大于跳转，条件是小于等于
       nop 
            sll $t2,$t0 ,2
            lw  $t3 , str($t2)    #  i值
            sll $t2, $t1 ,2
            lw  $t4 , str($t2)    #  j值
            bne $t3 , $t4 , loop_judge_bad_end
        add $t0 ,$t0 ,1
        add $t1, $t1, -1
        j loop_judge
      
      loop_judge_good_end:
        li $a0 , 1
        li $v0 , 1
        syscall 
        j end    ###  这种分支条件真的不能忘，不然就检查一下输出
      loop_judge_bad_end:
        li $a0 , 0
        li $v0 , 1
       syscall 
       
       end:
       li  $v0, 10
       syscall   
