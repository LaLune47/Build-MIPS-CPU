.text 

    li $v0,5
    syscall
    move $t0 , $v0             #读入部分
    
    rem  $a1 , $t0 , 4         
    seq  $t1 , $a1 , 0         #t1 是否为4的倍数
    rem  $a2 , $t0 , 100      
    seq  $t2 , $a2 , 0                   #t2 是否为100的倍数'
    rem  $a3 , $t0 , 400       
    seq  $t3 , $a3 , 0                            #t3 是否为400的倍数
    
    bne  $t1 , $zero,if_1_else   #不等于跳转，等于进入条件     if t1==0   if 不是4的倍数
    nop
             li   $a0 , 0
    j if_end
    nop
  
    if_1_else:
      beq   $t2 , $zero, if_2_else   #等于跳转，不等于进入条件     是100的倍数再进入
      nop
                bne   $t3 , $zero, if_3_else      #不等于跳转，等于进入条件     不是400的倍数再进入
                nop
                    li   $a0 , 0
                j  if_end
                nop
                
                if_3_else:
                    li   $a0 , 1
                j  if_end
                nop          
    j  if_end
    nop
   
    if_2_else:                       #不是100的倍数
      li   $a0 ,1
    
      
   if_end:
      li $v0 , 1
      syscall
      
      li $v0, 10
      syscall
      
