.data 
map:   .space  256

.macro getIndex(%ans, %i, %j)
     mul  %ans ,%i ,8
     add  %ans ,%ans ,%j
     sll  %ans ,%ans ,2
.end_macro 

.macro READ(%n)
     li  $v0 ,5
     syscall 
     move  %n,$v0
.end_macro 

.macro PRINT(%n)
	li $v0, 1
	move $a0, %n
	syscall
.end_macro

.macro LOAD_LOCAL(%n)
	addi $sp, $sp, 4
	lw %n, 0($sp)
.end_macro

.macro SAVE_LOCAL(%n)
	sw %n, 0($sp)
	subi $sp, $sp, 4
.end_macro



.text 
     READ($s0)    # 行数 n  s0 
     READ($s1)    # 列数 n  s1 
     
     li  $t0, 0   #  i
     for_i:
     beq $t0, $s0 ,for_i_end
          li  $t1, 0    #j
          for_j:
          beq $t1, $s1 ,for_j_end     
               READ($t3)                    #  scanf( map[i,j] )
               getIndex($t2,$t0,$t1)
               sw  $t3, map($t2)                
          add  $t1 ,$t1 ,1
          j for_j      
        for_j_end:
          add  $t0 ,$t0 ,1
          j for_i
     for_i_end:
    
     READ($s2)   #row  (还要经过 -1 处理才能得到数组下标值)
     add $s2 ,$s2 ,-1
     READ($s3)   #column
     add $s3 ,$s3 ,-1
     READ($)    #end_row
     add $s4 ,$s4 ,-1
     READ($s5)     #end_column
     add $s5 ,$s5 ,-1
    
     li  $s6 ,0     #cnt=0   
     getIndex($t0,$s2,$s3)
     li $t1 ,2
     sw $t1 ,map($t0)
     move $a0 ,$s2 # row
     move $a1 ,$s3 #column
     jal dfs
     
     PRINT($s6)
     
     li $v0 , 10
     syscall      
########################################  DFS   ## 考虑四个方向的时候，还要考虑出界的问题
dfs:  
     seq $t0 , $a0 ,$s4
     seq $t1 , $a1 ,$s5
     and $t2 , $t0 ,$t1    # 两个条件
     beqz $t2, if_0_end
         add   $s6 , $s6 ,1
         jr $ra
     if_0_end:
     
     getIndex($t0,$a0,$a1)
     li $t1 ,2
     sw $t1 ,map($t0)
     
     #up
     beqz $a0 ,if_up_end_2
     add   $a0, $a0 ,-1
     getIndex($t0 ,$a0 ,$a1)
     lw  $t1 ,map($t0)
     bnez  $t1 ,if_up_end_1
          #############################
          SAVE_LOCAL($a0)
          SAVE_LOCAL($a1)
          SAVE_LOCAL($ra)
          
          jal dfs
           
	  LOAD_LOCAL($ra)
          LOAD_LOCAL($a1)
          LOAD_LOCAL($a0)        
          #############################
        if_up_end_1:
          add $a0, $a0, 1
     if_up_end_2:
     
     #down
     add  $t0 ,$s0 ,-1
     beq  $a0, $t0  if_down_end_2
     add   $a0, $a0 ,1
     getIndex($t0 ,$a0 ,$a1)
     lw  $t1 ,map($t0)
     bnez  $t1 ,if_down_end_1
          #############################
          SAVE_LOCAL($a0)
          SAVE_LOCAL($a1)
          SAVE_LOCAL($ra)
          
          jal dfs
           
	  LOAD_LOCAL($ra)
          LOAD_LOCAL($a1)
          LOAD_LOCAL($a0)        
          #############################
        if_down_end_1:
          add $a0, $a0, -1
     if_down_end_2:
     
     
     #left
     beqz $a1 ,if_left_end_2
     add   $a1, $a1 ,-1
     getIndex($t0 ,$a0 ,$a1)
     lw  $t1 ,map($t0)
     bnez  $t1 ,if_left_end_1
          #############################
          SAVE_LOCAL($a0)
          SAVE_LOCAL($a1)
          SAVE_LOCAL($ra)
          
          jal dfs
           
	  LOAD_LOCAL($ra)
          LOAD_LOCAL($a1)
          LOAD_LOCAL($a0)        
          #############################
        if_left_end_1:
          add $a1, $a1, 1
     if_left_end_2:
     
     ### right
     add  $t0 ,$s1 ,-1
     beq  $a1,$t0  if_right_end_2
     add  $a1, $a1, 1
     getIndex($t0 ,$a0 ,$a1)
     lw  $t1 ,map($t0)
     bnez  $t1 ,if_right_end_1
          #############################
	  SAVE_LOCAL($a0)
	  SAVE_LOCAL($a1)
	  SAVE_LOCAL($ra)
		
          jal dfs
           
          LOAD_LOCAL($ra)
	  LOAD_LOCAL($a1)
	  LOAD_LOCAL($a0)       
          #############################
        if_right_end_1:
          add $a1, $a1, -1
     if_right_end_2:
		
		
     getIndex($t0, $a0, $a1)	
     li $t1, 0
     sw $t1, map($t0)
     jr $ra
