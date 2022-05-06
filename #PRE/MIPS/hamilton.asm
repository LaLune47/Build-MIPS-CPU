 .data
matrix: .space  256             # ��ʾͼ����ڽӾ���    int matrix[8][8]   8*8*4 �ֽ�
                                # matrix[0][0] �ĵ�ַΪ 0x00��matrix[0][1] �ĵ�ַΪ 0x04������
                                # matrix[1][0] �ĵ�ַΪ 0x20��matrix[1][1] �ĵ�ַΪ 0x24������
                                # ����
flag: .space  32                #����Ƿ��Ѿ������� ��flag����

# ����ʹ���˺꣬%i Ϊ�洢��ǰ�����ļĴ�����%j Ϊ�洢��ǰ�����ļĴ���
# �� (%i * 8 + %j) * 4 ���� %ans �Ĵ����� ,�����͵õ��˵�ǰ����Ԫ�ص�ʵ�ʵ�ַ
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
      move   $s0, $v0       #����s0    s0:number of dots
      li   $v0, 5   
      syscall               
      move   $s1, $v0       #����s1    s0:number of lines
      
      li  $t0, 0            #t0:��ѭ������
      for_input_begin:
         slt   $t3 ,$t0 ,$s1    
         beqz  $t3,for_input_end
         nop
              li   $v0, 5   
              syscall   
              addi   $v0 ,$v0 ,-1            
              move   $t1, $v0       #����t1   
              li   $v0, 5   
              syscall   
              addi   $v0 ,$v0 ,-1              
              move   $t2, $v0       #����t2   t1,t2Ϊ����
              #�������Ϣ
              li $t5, 1                #t5��Ϊ1����ֵ
              getindex($t4, $t1, $t2)  #t4�Ǵ������ʱ��ַ
              sw $t5, matrix($t4)
              getindex($t4, $t2, $t1)  #t4�Ǵ������ʱ��ַ
              sw $t5, matrix($t4)
          addi $t0 ,$t0, 1
          j   for_input_begin
          nop
      for_input_end:
      
      ##�趨�µ�ȫ�ֱ���  s0  dots ,s1lines , 
      ##s2  num(�������)     s3   ans=1�����ս��
      li $s2 ,1            #  ָ����1��Ҳ����judge�ĵڶ���������ʵ����д�ò�̫������´�ע��ע��
      li $s3 ,0
      ##ͬʱ��Ҫ�д��ݲ��� a0
      li $a0 ,0     # now ,����һ����������һֱû��
                              ##�������֮ǰ��������ǰд�� Ԥ����t��ʱ����û��һ������Ҫ�����ģ�ʲô����ʣҲ����
      jal judge
      
      move $a0 , $s3
      li   $v0, 1   
      syscall     
      li   $v0, 10   
      syscall     
      
      
          
judge:
      #�ݹ��ٽ����������ã�num==n && matrix[a0][0]==1    (�������0������㺯���Ĵ��ݲ���a0=0��a0����now)
      seq   $t0, $s2 ,$s0          # t0�洢��һ������
      getindex($t1, $a0, $zero)  # t1 �洢������ʱ��ַ
      lw  $t2, matrix($t1)       # t2 ���ر����
      li  $t3 ,1                 # t3 �洢����1
      seq $t4 ,$t2, $t3           # t4�洢�ڶ�������
      and $t5 ,$t0, $t4          #�����ۺ�
      
      beqz $t5 , if_end_1                  #������Ϊ0��ת
      nop
         li  $s3, 1  
         j  end
      if_end_1:
      
      
      li  $t0 ,1                 # t0 �洢����1 
      Arrayindex($t1, $a0)       # t1 ������ʱ��ַ
      sw $t0 , flag($t1)
      
 ##    seq  $t2 , $s2 , $s0        # t2 =(n!=num)   
 ##     beqz $t2 ,if_end_2        #��������ת������һ��ȥ����
  ##    nop 
          li  $t3 ,0           #t3 i,ѭ������
          for_2_begin:
              slt  $t4 ,$t3 ,$s0     # t4   =(i<n)    
              beqz $t4 , for_2_end
              nop
                  ##�ڲ����ж�flag��i��==0    matrix��now����i��==1
                  Arrayindex($t1, $t3)       # t1 ������ʱ��ַ
                  lw  $t5 , flag($t1)       #$t5  flag[i]
                  seq  $t6 , $t5 ,$zero     #t6:����1   
                  
                  getindex($t1, $a0, $t3)  # t1 �洢������ʱ��ַ
                  lw  $t5, matrix($t1)     # t5 ���ر����
                  seq $t7 , $t5 ,$t0      #t7 ����2 
                    
                  and $t5 ,$t6, $t7          # t7�����ۺ�
                  beqz $t5 , if_end_3             #������Ϊ0��ת
                  nop
                        addi  $s2, $s2 ,1
                        #################################################
                        ##�������������
                        ##����  a0, ��Ϊ��Ҫ��Ϊ�µĲ�����������
                        ##����  t0��t7����õ����ڲ�ʱ����
                        ##�����ַ ����ֹjal����   
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
    
    
                        move   $a0, $t3   ##����i
                        jal   judge
     
                                               ##����д��
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
                                              
      Arrayindex($t1, $a0)       # t1 ������ʱ��ַ  ,flag[now]
      sw $zero ,flag($t1)           
      
      end:   
      jr   $ra            #ͨ��������ƣ������ݹ麯���������ٽ�ȥ����λ��
      
      
       
      
      
      
      
      
      
      
      
      
      
      
      
