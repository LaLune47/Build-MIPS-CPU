ori $1 ,$zero ,5
ori $2 ,$zero ,5
ori $3 ,$zero ,6

beq $1 ,$2 ,cut1
lui $10 ,0xffff
cut1:
lui $11 ,0xffff
beq $1 ,$3 ,cut2
lui $12 ,0xffff
cut2:
lui $13 ,0xffff
###################################################

ori $1 ,$zero ,5
ori $2 ,$zero ,5
ori $3 ,$zero ,6

bne $1 ,$3 ,cut3
lui $10 ,0xffff
cut3:
lui $11 ,0xffff
bne $1 ,$2 ,cut4
lui $12 ,0xffff
cut4:
lui $13 ,0xffff


###############################################################
ori $1 ,$zero ,5
ori $2 ,$zero ,0
ori $3 ,$zero ,-3

blez $1   ,cut5
lui $10 ,0xffff
cut5:
lui $11 ,0xffff
blez $2   ,cut6
lui $12 ,0xffff
cut6:
lui $13 ,0xffff
blez $3   ,cut7
lui $14 ,0xffff
cut7:
lui $15 ,0xffff

#############################################################################33333

ori $1 ,$zero ,5
ori $2 ,$zero ,0
ori $3 ,$zero ,-3

bgtz $1   ,cut8
lui $10 ,0xffff
cut8:
lui $11 ,0xffff
bgtz $2   ,cut9
lui $12 ,0xffff
cut9:
lui $13 ,0xffff
bgtz $3   ,cut10
lui $14 ,0xffff
cut10:
lui $15 ,0xffff

#############################################################################33333
ori $1 ,$zero ,5
ori $2 ,$zero ,0
ori $3 ,$zero ,-3

bltz $1   ,cut11
lui $10 ,0xffff
cut11:
lui $11 ,0xffff
bltz $2   ,cut12
lui $12 ,0xffff
cut12:
lui $13 ,0xffff
bltz $3   ,cut13
lui $14 ,0xffff
cut13:
lui $15 ,0xffff

#############################################################################33333
ori $1 ,$zero ,5
ori $2 ,$zero ,0
ori $3 ,$zero ,-3

bgez $1   ,cut14
lui $10 ,0xffff
cut14:
lui $11 ,0xffff
bgez $2   ,cut15
lui $12 ,0xffff
cut15:
lui $13 ,0xffff
bgez $3   ,cut16
lui $14 ,0xffff
cut16:
lui $15 ,0xffff

#############################################################################33333


















