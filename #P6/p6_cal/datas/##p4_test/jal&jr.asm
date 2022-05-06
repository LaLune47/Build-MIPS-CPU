ori $t1, 10
LABEL:
beq $t0, $t1, END
addiu $t0, $t0, 1
j LABEL
END:
jal TEST             
   ori $1,0x1234

TEST:
lui $t1, 0xffff
jr $ra
