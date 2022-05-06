ori $3,$zero,0
ori $4,$zero,4

for:
   beq $3 ,$4 ,for_end
   
   addiu $3,$3,1
   j   for
   
for_end:
ori $7,$zero,123