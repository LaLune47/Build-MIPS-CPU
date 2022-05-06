ori $1 ,$zero ,5
ori $2 ,$zero ,5
ori $3 ,$zero ,6

cut2:

beq $1 ,$3 ,cut1
lui $10 ,0xffff
cut1:
lui $11 ,0xffff

beq $1 ,$2 ,cut2
lui $12 ,0xffff
#  ÍùÇ°Ìø£¬ËÀÑ­»·