main:
     li   $v0, 5   
     syscall               # n �Ա���
     move   $s0, $v0       #����s0���Ż�a0��ϰ�߽���Ҫ���ݵı�������a0��
     move   $a0, $s0
     jal  factorial
     
     move  $a0, $v0       #��������ֵ
     li  $v0, 1
     syscall                     
     li  $v0, 10 
     syscall              #���������
     
factorial:
     bne  $a0, 1, work    #�ݹ��ٽ�����
     li   $v0, 1
     jr   $ra            #ͨ��������ƣ������ݹ麯���������ٽ�ȥ����λ��
     
work:
     move  $t0, $a0      #�洢��ǰ��nֵ
     
     sw  $ra , 0($sp)
     subi  $sp, $sp, 4
     sw  $t0,  0($sp)
     subi  $sp, $sp, 4   #��ջ�ռ��б������õ�����һ���ǵ�ǰn��һ���ǵ�ַ�����ⱻ�������ת����ǣ�
     
     subi   $t1, $t0 ,1
     move   $a0, $t1     #���ô��ݸ���һ�κ����Ĳ�����������˵����n-1��ֵ
     jal   factorial
     
     addi  $sp, $sp, 4
     lw   $t0, 0($sp)    #����д�뱣��ֵ�����һָ�ջָ��
     addi  $sp, $sp ,4
     lw   $ra, 0($sp)
     
     mult   $t0,$v0
     mflo   $v0
     jr     $ra  
     
     
          
               
                    
                         
                              
                                   
                                        
                                             
                                                  
                                                       
                                                            
                                                                 
                                                                      
                                                                           
                                                                                
                                                                                     
                                                                                          
                                                                                               
                                                                                                    
                                                                                                         
                                                                                                              
                                                                                                                        