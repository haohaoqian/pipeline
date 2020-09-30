import random

temp=[]
for i in range(128):
    t=random.randint(0,1000)
    temp.append(t)
    print('li $t0,{}'.format(t))
    print('sw $t0,{}($a0)'.format(4*i))
print(temp)