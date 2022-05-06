ori $1, $0, 4
ori $2, $0, 5
ori $3, $0, 6
ori $4, $0, 12
sw $3, 0($0)
sw $2, 4($0)
sw $2, 8($0)
sw $2, 12($0)
sw $1, 16($0)
sw $4, 20($0)
sw $2, 24($0)
sw $4, 28($0)
sw $3, 32($0)
sw $3, 36($0)
sw $2, 40($0)
sw $2, 44($0)
sw $2, 48($0)
sw $4, 52($0)
sw $1, 56($0)
sw $3, 60($0)
sw $2, 64($0)
sw $1, 68($0)
sw $2, 72($0)
sw $2, 76($0)
sw $4, 80($0)
sw $1, 84($0)
sw $3, 88($0)
sw $3, 92($0)
sw $1, 96($0)
sw $2, 100($0)
sw $2, 104($0)
sw $2, 108($0)
sw $1, 112($0)
sw $1, 116($0)
sw $1, 120($0)
sw $4, 124($0)
lbu $1, 0($2)
beq $1, $2, TAG1
lbu $4, 0($1)
lw $3, 0($1)
TAG1:
lui $2, 13
sb $3, 0($3)
lui $2, 7
and $3, $2, $3
TAG2:
mtlo $3
addi $2, $3, 11
mult $2, $2
lui $3, 6
TAG3:
mtlo $3
lui $1, 14
sll $0, $0, 0
slti $4, $1, 15
TAG4:
mtlo $4
lbu $1, 0($4)
sltiu $4, $4, 7
addiu $4, $4, 12
TAG5:
subu $2, $4, $4
lui $2, 3
sll $0, $0, 0
div $2, $2
TAG6:
mflo $1
bgtz $4, TAG7
sb $4, 0($4)
beq $1, $1, TAG7
TAG7:
lb $1, 0($1)
bne $1, $1, TAG8
sh $1, 0($1)
bgtz $1, TAG8
TAG8:
mthi $1
mflo $4
lbu $4, 0($4)
mtlo $4
TAG9:
beq $4, $4, TAG10
mthi $4
mthi $4
lw $3, 0($4)
TAG10:
xor $4, $3, $3
bne $4, $3, TAG11
mtlo $4
mfhi $4
TAG11:
sltu $2, $4, $4
mflo $1
sb $4, 0($2)
mflo $2
TAG12:
bgtz $2, TAG13
ori $2, $2, 13
slti $2, $2, 10
bgez $2, TAG13
TAG13:
sh $2, 0($2)
mthi $2
bltz $2, TAG14
mtlo $2
TAG14:
lw $4, 0($2)
bltz $4, TAG15
mfhi $2
sltiu $4, $4, 10
TAG15:
mflo $2
sb $2, 0($2)
srl $4, $2, 0
mtlo $2
TAG16:
lui $4, 7
ori $2, $4, 15
bgez $4, TAG17
mthi $2
TAG17:
ori $4, $2, 6
sllv $4, $4, $2
bne $4, $2, TAG18
lui $1, 2
TAG18:
sll $0, $0, 0
mflo $3
lui $1, 12
mthi $1
TAG19:
mfhi $2
mfhi $1
multu $1, $1
mfhi $1
TAG20:
sw $1, -144($1)
lui $4, 8
sll $0, $0, 0
lhu $1, -144($1)
TAG21:
slt $2, $1, $1
mult $2, $2
lui $4, 3
bgez $2, TAG22
TAG22:
mfhi $2
xori $4, $2, 5
beq $4, $2, TAG23
mult $4, $4
TAG23:
lui $2, 6
div $2, $4
mfhi $2
subu $3, $2, $2
TAG24:
beq $3, $3, TAG25
slti $4, $3, 13
mthi $4
bne $3, $3, TAG25
TAG25:
sll $1, $4, 1
mfhi $4
mfhi $1
blez $1, TAG26
TAG26:
sb $1, 0($1)
bne $1, $1, TAG27
lb $4, 0($1)
lb $3, 0($4)
TAG27:
lui $3, 15
mfhi $2
mthi $3
beq $3, $3, TAG28
TAG28:
mtlo $2
lbu $4, 0($2)
ori $2, $2, 15
blez $4, TAG29
TAG29:
sltu $2, $2, $2
lw $2, 0($2)
mthi $2
lb $2, -400($2)
TAG30:
lui $4, 9
lw $2, 112($2)
xor $3, $2, $2
mflo $4
TAG31:
mtlo $4
bgez $4, TAG32
lui $2, 2
multu $4, $4
TAG32:
mfhi $4
sw $4, -400($4)
mtlo $4
slti $2, $2, 3
TAG33:
mfhi $4
lui $3, 14
and $1, $3, $2
lhu $4, 0($1)
TAG34:
sll $0, $0, 0
lh $3, -400($4)
lw $1, -400($4)
sra $1, $1, 2
TAG35:
lh $1, 0($1)
lbu $2, 0($1)
bltz $2, TAG36
mtlo $1
TAG36:
lui $1, 0
sb $1, 0($2)
lui $1, 3
mtlo $1
TAG37:
blez $1, TAG38
mtlo $1
sll $0, $0, 0
sll $0, $0, 0
TAG38:
beq $4, $4, TAG39
lh $4, -400($4)
mfhi $1
divu $1, $4
TAG39:
bne $1, $1, TAG40
sll $0, $0, 0
sll $0, $0, 0
sll $0, $0, 0
TAG40:
xori $1, $1, 8
bne $1, $1, TAG41
mtlo $1
blez $1, TAG41
TAG41:
lui $4, 8
blez $1, TAG42
mfhi $3
blez $1, TAG42
TAG42:
sh $3, -400($3)
sw $3, -400($3)
srl $3, $3, 9
beq $3, $3, TAG43
TAG43:
lui $3, 15
mthi $3
sll $0, $0, 0
mtlo $3
TAG44:
sll $0, $0, 0
mflo $1
multu $3, $1
mtlo $1
TAG45:
mfhi $2
sb $1, -225($2)
lui $4, 6
lui $1, 2
TAG46:
multu $1, $1
bne $1, $1, TAG47
lui $1, 9
mflo $2
TAG47:
bne $2, $2, TAG48
sh $2, 0($2)
lui $3, 7
mthi $2
TAG48:
addu $3, $3, $3
sra $1, $3, 6
bgtz $3, TAG49
sltiu $4, $3, 13
TAG49:
mflo $4
bgez $4, TAG50
lui $2, 6
bgez $4, TAG50
TAG50:
mflo $3
lui $1, 2
lui $4, 6
mtlo $4
TAG51:
bne $4, $4, TAG52
mflo $1
mfhi $2
sra $4, $2, 0
TAG52:
sb $4, 0($4)
sh $4, 0($4)
srav $2, $4, $4
nor $2, $4, $4
TAG53:
divu $2, $2
mtlo $2
andi $4, $2, 1
lui $1, 13
TAG54:
sll $0, $0, 0
multu $1, $1
divu $1, $1
lui $1, 8
TAG55:
blez $1, TAG56
slti $4, $1, 5
sh $4, 0($4)
bgtz $4, TAG56
TAG56:
lui $3, 4
mult $3, $3
sll $0, $0, 0
mflo $4
TAG57:
lb $3, 0($4)
slti $2, $3, 11
bltz $2, TAG58
srl $4, $3, 13
TAG58:
sh $4, 0($4)
mflo $4
mfhi $1
mtlo $4
TAG59:
mthi $1
mthi $1
andi $4, $1, 7
lui $4, 1
TAG60:
sll $0, $0, 0
sll $0, $0, 0
sh $1, 0($1)
sll $0, $0, 0
TAG61:
xori $2, $1, 0
srlv $2, $1, $2
mtlo $1
slti $3, $2, 14
TAG62:
blez $3, TAG63
mflo $4
mfhi $2
div $2, $3
TAG63:
bne $2, $2, TAG64
subu $3, $2, $2
mult $2, $3
divu $2, $2
TAG64:
sh $3, 0($3)
lbu $2, 0($3)
sw $3, 0($3)
bgez $2, TAG65
TAG65:
ori $3, $2, 14
sb $3, 0($3)
xor $1, $3, $3
lui $1, 15
TAG66:
lui $3, 0
bgez $1, TAG67
sll $0, $0, 0
sltu $3, $3, $1
TAG67:
lui $2, 5
mtlo $3
lw $2, 0($3)
mthi $2
TAG68:
lui $1, 10
bne $1, $2, TAG69
sltiu $3, $1, 3
mtlo $2
TAG69:
beq $3, $3, TAG70
multu $3, $3
mfhi $4
sb $3, 0($4)
TAG70:
sw $4, 0($4)
mflo $4
beq $4, $4, TAG71
xor $4, $4, $4
TAG71:
nor $3, $4, $4
subu $1, $3, $4
mfhi $4
addu $4, $3, $4
TAG72:
addu $4, $4, $4
beq $4, $4, TAG73
divu $4, $4
or $1, $4, $4
TAG73:
blez $1, TAG74
sw $1, 1($1)
mtlo $1
srav $4, $1, $1
TAG74:
sh $4, 2($4)
mfhi $1
sltu $2, $4, $4
lh $4, 0($2)