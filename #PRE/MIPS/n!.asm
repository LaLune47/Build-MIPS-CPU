main:
     li   $v0, 5   
     syscall               # n 自变量
     move   $s0, $v0       #存入s0，放回a0（习惯将需要传递的变量放入a0）
     move   $a0, $s0
     jal  factorial
     
     move  $a0, $v0       #传回来的值
     li  $v0, 1
     syscall                     
     li  $v0, 10 
     syscall              #输出，结束
     
factorial:
     bne  $a0, 1, work    #递归临界条件
     li   $v0, 1
     jr   $ra            #通过巧妙设计，让深层递归函数结束后再进去跳出位置
     
work:
     move  $t0, $a0      #存储当前的n值
     
     sw  $ra , 0($sp)
     subi  $sp, $sp, 4
     sw  $t0,  0($sp)
     subi  $sp, $sp, 4   #在栈空间中保存有用的量，一个是当前n，一个是地址（避免被后面的跳转命令覆盖）
     
     subi   $t1, $t0 ,1
     move   $a0, $t1     #设置传递给下一次函数的参数，具体来说就是n-1的值
     jal   factorial
     
     addi  $sp, $sp, 4
     lw   $t0, 0($sp)    #重新写入保存值，并且恢复栈指针
     addi  $sp, $sp ,4
     lw   $ra, 0($sp)
     
     mult   $t0,$v0
     mflo   $v0
     jr     $ra  
     
     
          
               
                    
                         
                              
                                   
                                        
                                             
                                                  
                                                       
                                                            
                                                                 
                                                                      
                                                                           
                                                                                
                                                                                     
                                                                                          
                                                                                               
                                                                                                    
                                                                                                         
                                                                                                              
                                                                                                                        