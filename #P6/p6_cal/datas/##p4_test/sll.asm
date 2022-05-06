ori $8, $zero, 1
sll $8, $8, 2

ori $8, $zero, 0x1000
srl $8, $8, 2

li $8, 0xf0000000
sra $8, $8, 2

li $9 ,2
ori $8, $zero, 1
sllv $8, $8,$9

ori $8, $zero, 0x1000
srlv $8, $8, $9

li $8, 0xf0000000
srav $8, $8, $9