.text 

    li $v0,5
    syscall
    move $t0 , $v0             #���벿��
    
    rem  $a1 , $t0 , 4         
    seq  $t1 , $a1 , 0         #t1 �Ƿ�Ϊ4�ı���
    rem  $a2 , $t0 , 100      
    seq  $t2 , $a2 , 0                   #t2 �Ƿ�Ϊ100�ı���'
    rem  $a3 , $t0 , 400       
    seq  $t3 , $a3 , 0                            #t3 �Ƿ�Ϊ400�ı���
    
    bne  $t1 , $zero,if_1_else   #��������ת�����ڽ�������     if t1==0   if ����4�ı���
    nop
             li   $a0 , 0
    j if_end
    nop
  
    if_1_else:
      beq   $t2 , $zero, if_2_else   #������ת�������ڽ�������     ��100�ı����ٽ���
      nop
                bne   $t3 , $zero, if_3_else      #��������ת�����ڽ�������     ����400�ı����ٽ���
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
   
    if_2_else:                       #����100�ı���
      li   $a0 ,1
    
      
   if_end:
      li $v0 , 1
      syscall
      
      li $v0, 10
      syscall
      
