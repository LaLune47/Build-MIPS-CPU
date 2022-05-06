#ori $t1, 10
#LABEL:
#beq $t0, $t1, END
#addiu $t0, $t0, 1
#j LABEL
#END:
#jal TEST              # jal 0x00003018
#   ori $1,0x1234

#TEST:
#lui $t1, 0xffff
#jr $ra
##################################################
ori $t1, 10
LABEL:
beq $t0, $t1, END
addiu $t0, $t0, 1
j LABEL
END:
ori $15,$zero,0x301c
jalr $30,$15     # jal 0x00003018  +  ¸³Öµ301c(TEST)
   ori $1,0x1234

#TEST:
lui $t1, 0xffff
jr $30
