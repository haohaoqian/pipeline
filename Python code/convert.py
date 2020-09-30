count=0
with open('C:\\Users\\郝千越\\Desktop\\instruction') as f:
    for line in f:
        print('30\'d{}:  Instruction'.format(count)+' <= 32\'h'+line.strip()+';')
        count+=1