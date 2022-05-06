ori $1, $0, 0
lw $1, 0($0)
addu $2, $1, $1
addu $3, $2, $1
addu $4, $3, $1
addu $5, $4, $1
ori $1, $0, 0
nop
nop
nop
nop
lw $1, 0($0)
subu $2, $1, $1
subu $3, $2, $1
subu $4, $3, $1
subu $5, $4, $1
lw $2, 0($0)
ori $1, $2, 123
ori $1, $2, 321
ori $1, $2, 245
ori $1, $2, 1234
lw $3, 0($0)
beq $3, $1, label50 
nop
beq $3, $1, label50 
nop
beq $3, $1, label50
nop
beq $3, $1, label50
nop
label50: nop
lw $4, 0($0)
sw $4, 0x2000($0)
sw $4, 0x2004($0)
sw $4, 0x2008($0)
sw $4, 0x200c($0)
ori $9, $0, 0x3000
subu $4, $4, $9
sw $4, 0x0000($0)
jal label51 
sw $31, 0($0)
jal label52 
sw $31, 0($0)
jal label53 
sw $31, 0($0)
j label54 
label51: lw $1, 0($0)   ###
jr $1
nop
label52: lw $1, 0($0)
nop
jr $1
nop
label53: lw $1, 0($0)
nop
nop
jr $1
label54: nop
ori $2, $0, 4
addu $1, $2, $0
lw $3, 0($1)
lw $3, 4($1)
lw $3, 8($1)
lw $3, -4($1)
subu $3, $1, $1
lw $4, 0($3)
lw $4, 4($3)
lw $4, 8($3)
lw $4, 12($3)
ori $3, $0, 8
lw $2, -8($3)
lw $2, -4($3)
lw $2, 0($3)
lw $2, 4($3)
sw $3, 0($0)
lw $1, 0($0)
lw $2, 0($1)
lw $2, -4($1)
lw $2, 4($1)
lw $2, -8($1)
ori $2, $0, 123
lui $2, 0
lw $3, 0($2)
lw $3, 4($2)
lw $3, 8($2)
lw $3, 12($2)
jal label55
lw $4, -0x3000($31)
label55: lw $4, -0x3000($31)
lw $4, -0x3000($31)
lw $4, -0x3000($31)
sw $1, 0($4)
