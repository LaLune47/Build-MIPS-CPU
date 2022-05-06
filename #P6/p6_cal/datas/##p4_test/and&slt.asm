ori $7 ,$zero ,0x1111
ori $8 ,$zero ,0x2223
li $9,0x12131111

and $10, $7,$8
andi $11, $7,34
andi $12 ,$8,563

ori $13 ,$zero ,2
ori $14 ,$zero ,1
ori $15 ,$zero ,2
ori $16 ,$zero ,3

slt $17,$13,$14    # >
slt $18,$13,$15   # =
slt $19,$13,$16  # <

sltu $17,$13,$14    # >
sltu $18,$13,$15   # =
sltu $19,$13,$16  # <

slti $17,$14 ,34  # >
slti $18,$15 ,2   # =
slti $19,$16 ,4  # <

sltiu $17,$14 ,34  # >
sltiu $18,$15 ,2   # =
sltiu $19,$16 ,4  # <
