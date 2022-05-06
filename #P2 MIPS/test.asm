.data
symbol: .space  32
dxy:  .word  -1:1
      .word  0:2
      .word  2:2
       .word 4:2
array:  .space  32
str_space:  .asciiz "pass p2! "



.macro getIndex(%ans,%i,%j)
     mul   %ans , %i , 8
     add   %ans ,%ans ,%j
     sll   %ans , %ans ,2
.end_macro 

.macro  READ (%n)
     li  $v0 , 5
     syscall 
     move %n ,$v0
.end_macro 

.macro   PRINT_int(%n)
     li   $v0 ,1
     move  $a0 ,%n
     syscall 
.end_macro 


.macro   PRINT_str(%n)
     li   $v0 ,4
     la  $a0 ,%n
     syscall 
.end_macro 

.macro STORE(%n)
     sw  %n ,0($sp)
     add  $sp,$sp,-4
.end_macro 

.macro LOAD(%n)
     add  $sp,$sp,4
     lw %n ,0($sp)
.end_macro 





.text
     READ($t3)
  #   PRINT_int($t3)
 #   PRINT_str(str_space)
     STORE($t3)
     STORE($t3)
     LOAD($t4)