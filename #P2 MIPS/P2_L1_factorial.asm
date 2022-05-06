.data
ans: .space  4000

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
     READ($s0)   # s0 == n
     li  $t0 ,1 
     getIndex($t1,$t0)    #  t1 µÿ÷∑
     li  $t0 ,1
     sw  $t0 ,ans($t1)
     li  $s1 , 1      #   s1 == weishu
     
     li  $t0 ,2    #  i == 2
     for:
     bgt $t0 ,$s0 ,for_end
     nop
          li  $t1 ,1 
          getIndex($t2,$t1)           #  t2 µÿ÷∑
          lw  $t1 ,ans($t2)          #  t1 == ans[1]
          move  $s2 , $t1      #tmp=ans[1]        #  s2 === tmp
          mul  $s2 ,$s2 ,$t0   #tmp=tmp*i
          div  $s3 ,$s2 ,10    #devision=tmp/10    #  s3 == devision
          li  $t1 ,1 
          getIndex($t2,$t1)    #  t2 µÿ÷∑
          rem   $t1 ,$s2, 10 
          sw  $t1 , ans($t2)   #ans[1] == tmp %10
          li $t3,2        # t3 == j
          
          sgt  $t1 , $s1 ,$t3
          or   $t2 ,$t1, $s3
          beqz $t2 ,if_end
               getIndex($t1,$t3)   
               lw  $t2 ,ans($t1)    # ans[j]
               mul  $t2 ,$t2, $t0    # *i
               add  $t2 ,$t2 ,$s3
               div  $s2 ,$t2 ,10 
               sw  $t2 ,ans($t1)
               
               while:
               sgt  $t1 , $s1 ,$t3
               or   $t2 ,$t1, $s2
               beqz $t2 ,while_end
                   getIndex($t1,$t3)   
                   lw  $t2 ,ans($t1)    # ans[j]      
                   rem  $t2 ,$t2,10
                   sw  $t2 ,ans($t1)     
                   add  $t3, $t3 , 1            # j++
                   getIndex($t1,$t3)   
                   lw  $t2 ,ans($t1)    # ans[j]     
                   mul  $t2, $t2 , $t0
                   add  $t2 ,$t2 ,$s2
                   div   $s2,$t2,10    
                   sw  $t2 ,ans($t1)
               j  while
               while_end:
                 move   $s1 ,$t3   #s1 weishu£¨t3==j  
          if_end:
                 add $t0 ,$t0 ,1
                 j  for
     for_end:
        
        
        
        move   $t0 , $s1     # t0==i
        for_print:
        blt $t0 ,1 ,for_print_end
              getIndex($t1,$t0)
              lw  $t2 ,ans($t1)
              PRINT($t2)
              add  $t0 ,$t0 ,-1
              j  for_print
        for_print_end:


        li  $v0 ,10
        syscall 







