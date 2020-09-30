j Main
j Interrupt
j Exception
Main: 	jal start
start:	li $t0,0x7fffffff
	and $ra,$ra,$t0
	addi $ra,$ra,28
	li $s0,0x40000000
	jr $ra
	#set timer
	sw $zero,8($s0) #setTCON
	li $t0,0xfffe7960
	sw $t0,0($s0) #setTH
	sw $t0,4($s0) #setTL
	#load data
	li $a0,0x00000000
	li $t0,266
	sw $t0,0($a0) 
	li $t0,834    
	sw $t0,4($a0) 
	li $t0,424    
	sw $t0,8($a0) 
	li $t0,267    
	sw $t0,12($a0)
	li $t0,364    
	sw $t0,16($a0)
	li $t0,158
	sw $t0,20($a0)
	li $t0,383    
	sw $t0,24($a0)
	li $t0,405
	sw $t0,28($a0)
	li $t0,617
	sw $t0,32($a0)
	li $t0,470
	sw $t0,36($a0)
	li $t0,997
	sw $t0,40($a0)
	li $t0,493
	sw $t0,44($a0)
	li $t0,493
	sw $t0,48($a0)
	li $t0,491
	sw $t0,52($a0)
	li $t0,893
	sw $t0,56($a0)
	li $t0,310
	sw $t0,60($a0)
	li $t0,35
	sw $t0,64($a0)
	li $t0,804
	sw $t0,68($a0)
	li $t0,149
	sw $t0,72($a0)
	li $t0,202
	sw $t0,76($a0)
	li $t0,865
	sw $t0,80($a0)
	li $t0,989
	sw $t0,84($a0)
	li $t0,186
	sw $t0,88($a0)
	li $t0,334
	sw $t0,92($a0)
	li $t0,759
	sw $t0,96($a0)
	li $t0,507
	sw $t0,100($a0)
	li $t0,50
	sw $t0,104($a0)
	li $t0,719
	sw $t0,108($a0)
	li $t0,166
	sw $t0,112($a0)
	li $t0,761
	sw $t0,116($a0)
	li $t0,233
	sw $t0,120($a0)
	li $t0,983
	sw $t0,124($a0)
	li $t0,445
	sw $t0,128($a0)
	li $t0,7
	sw $t0,132($a0)
	li $t0,97
	sw $t0,136($a0)
	li $t0,5
	sw $t0,140($a0)
	li $t0,682
	sw $t0,144($a0)
	li $t0,861
	sw $t0,148($a0)
	li $t0,358
	sw $t0,152($a0)
	li $t0,735
	sw $t0,156($a0)
	li $t0,822
	sw $t0,160($a0)
	li $t0,542
	sw $t0,164($a0)
	li $t0,455
	sw $t0,168($a0)
	li $t0,914
	sw $t0,172($a0)
	li $t0,285
	sw $t0,176($a0)
	li $t0,976
	sw $t0,180($a0)
	li $t0,88
	sw $t0,184($a0)
	li $t0,795
	sw $t0,188($a0)
	li $t0,101
	sw $t0,192($a0)
	li $t0,943
	sw $t0,196($a0)
	li $t0,433
	sw $t0,200($a0)
	li $t0,944
	sw $t0,204($a0)
	li $t0,265
	sw $t0,208($a0)
	li $t0,466
	sw $t0,212($a0)
	li $t0,231
	sw $t0,216($a0)
	li $t0,984
	sw $t0,220($a0)
	li $t0,877
	sw $t0,224($a0)
	li $t0,776
	sw $t0,228($a0)
	li $t0,535
	sw $t0,232($a0)
	li $t0,870
	sw $t0,236($a0)
	li $t0,691
	sw $t0,240($a0)
	li $t0,3
	sw $t0,244($a0)
	li $t0,384
	sw $t0,248($a0)
	li $t0,360
	sw $t0,252($a0)
	li $t0,342
	sw $t0,256($a0)
	li $t0,243
	sw $t0,260($a0)
	li $t0,473
	sw $t0,264($a0)
	li $t0,710
	sw $t0,268($a0)
	li $t0,62
	sw $t0,272($a0)
	li $t0,546
	sw $t0,276($a0)
	li $t0,466
	sw $t0,280($a0)
	li $t0,816
	sw $t0,284($a0)
	li $t0,750
	sw $t0,288($a0)
	li $t0,70
	sw $t0,292($a0)
	li $t0,609
	sw $t0,296($a0)
	li $t0,579
	sw $t0,300($a0)
	li $t0,437
	sw $t0,304($a0)
	li $t0,369
	sw $t0,308($a0)
	li $t0,317
	sw $t0,312($a0)
	li $t0,424
	sw $t0,316($a0)
	li $t0,760
	sw $t0,320($a0)
	li $t0,831
	sw $t0,324($a0)
	li $t0,811
	sw $t0,328($a0)
	li $t0,849
	sw $t0,332($a0)
	li $t0,55
	sw $t0,336($a0)
	li $t0,261
	sw $t0,340($a0)
	li $t0,570
	sw $t0,344($a0)
	li $t0,829
	sw $t0,348($a0)
	li $t0,781
	sw $t0,352($a0)
	li $t0,842
	sw $t0,356($a0)
	li $t0,696
	sw $t0,360($a0)
	li $t0,442
	sw $t0,364($a0)
	li $t0,552
	sw $t0,368($a0)
	li $t0,710
	sw $t0,372($a0)
	li $t0,197
	sw $t0,376($a0)
	li $t0,241
	sw $t0,380($a0)
	li $t0,846
	sw $t0,384($a0)
	li $t0,787
	sw $t0,388($a0)
	li $t0,955
	sw $t0,392($a0)
	li $t0,246
	sw $t0,396($a0)
	li $t0,615
	sw $t0,400($a0)
	li $t0,131
	sw $t0,404($a0)
	li $t0,424
	sw $t0,408($a0)
	li $t0,28
	sw $t0,412($a0)
	li $t0,78
	sw $t0,416($a0)
	li $t0,357
	sw $t0,420($a0)
	li $t0,25
	sw $t0,424($a0)
	li $t0,228
	sw $t0,428($a0)
	li $t0,108
	sw $t0,432($a0)
	li $t0,910
	sw $t0,436($a0)
	li $t0,905
	sw $t0,440($a0)
	li $t0,287
	sw $t0,444($a0)
	li $t0,735
	sw $t0,448($a0)
	li $t0,832
	sw $t0,452($a0)
	li $t0,788
	sw $t0,456($a0)
	li $t0,388
	sw $t0,460($a0)
	li $t0,604
	sw $t0,464($a0)
	li $t0,981
	sw $t0,468($a0)
	li $t0,416
	sw $t0,472($a0)
	li $t0,993
	sw $t0,476($a0)
	li $t0,240
	sw $t0,480($a0)
	li $t0,482
	sw $t0,484($a0)
	li $t0,478
	sw $t0,488($a0)
	li $t0,923
	sw $t0,492($a0)
	li $t0,576
	sw $t0,496($a0)
	li $t0,24
	sw $t0,500($a0)
	li $t0,81
	sw $t0,504($a0)
	li $t0,8
	sw $t0,508($a0)
	#record systick	
	lw $s6,20($s0)
	#bubsort
	li $s1,128
	li $s2,0 #$s2=i,a0=v[]
	li $s3,0 #$s3=j
	for1:	slt $t2,$s2,$s1
		beq $t2,$zero,end
		addi $s3,$s2,-1
	for2:	bltz $s3,out2
		sll $t2,$s3,2
		add $t2,$a0,$t2
		lw $t3,0($t2)
		lw $t4,4($t2)
		slt $t5,$t4,$t3
		beq $t5,$zero,out2
		sw $t4,0($t2)
		sw $t3,4($t2)
		addi $s3,$s3,-1
		j for2
		out2:	addi $s2,$s2,1
		j for1
end:	lw $s7,20($s0)
	li $t0 0x000000ff
	sw $t0,12($s0)
	sub $s7,$s7,$s6
	#start timer
	li $t0,0x00000003
	sw $t0,8($s0) #TCON
	li $s5,0
	li $s6,0
Loop:	j Loop	
Interrupt:	li $t0,0x00000001 #set TCON
		sw $t0,8($s0)
		beq $s5,$zero,pos_zero
		li $at,1
		beq $s5,$at,pos_one
		li $at,2
		beq $s5,$at,pos_two
		li $at,3
		beq $s5,$at,pos_three
pos_zero:	li $s4,0x00000100
		andi $t1,$s7,0x000f
		j number
pos_one:	li $s4,0x00000200
		andi $t1,$s7,0x00f0
		srl $t1,$t1,4
		j number
pos_two:	li $s4,0x00000400
		andi $t1,$s7,0x0f00
		srl $t1,$t1,8
		j number
pos_three:	li $s4,0x00000800
		andi $t1,$s7,0xf000
		srl $t1,$t1,12
number:		li $at,0x00000000
		beq $t1,$at,number0
		li $at,0x00000001
		beq $t1,$at,number1
		li $at,0x00000002
		beq $t1,$at,number2
		li $at,0x00000003
		beq $t1,$at,number3
		li $at,0x00000004
		beq $t1,$at,number4
		li $at,0x00000005
		beq $t1,$at,number5
		li $at,0x00000006
		beq $t1,$at,number6
		li $at,0x00000007
		beq $t1,$at,number7
		li $at,0x00000008
		beq $t1,$at,number8
		li $at,0x00000009
		beq $t1,$at,number9
		li $at,0x0000000a
		beq $t1,$at,numberA
		li $at,0x0000000b
		beq $t1,$at,numberB
		li $at,0x0000000c
		beq $t1,$at,numberC
		li $at,0x0000000d
		beq $t1,$at,numberD
		li $at,0x0000000e
		beq $t1,$at,numberE
		li $at,0x0000000f
		beq $t1,$at,numberF
number0:	ori $s4,$s4,0x00c0
		j show
number1:	ori $s4,$s4,0x00f9
		j show
number2:	ori $s4,$s4,0x00a4
		j show
number3:	ori $s4,$s4,0x00b0
		j show
number4:	ori $s4,$s4,0x0099
		j show
number5:	ori $s4,$s4,0x0092
		j show
number6:	ori $s4,$s4,0x0082
		j show
number7:	ori $s4,$s4,0x00f8
		j show
number8:	ori $s4,$s4,0x0080
		j show
number9:	ori $s4,$s4,0x0090
		j show
numberA:	ori $s4,$s4,0x0088
		j show
numberB:	ori $s4,$s4,0x0083
		j show
numberC:	ori $s4,$s4,0x00c6
		j show
numberD:	ori $s4,$s4,0x00a1
		j show
numberE:	ori $s4,$s4,0x0086
		j show
numberF:	ori $s4,$s4,0x008e
show:		li $at,4
		addi $s5,$s5,1
		sw $s4,16($s0)
		bne $s5,$at,continue
		addi $s6,$s6,1
		li $at,5
		li $s5,0
		bne $s6,$at,continue
		sw $zero,8($s0)
		sw $zero,12($s0)
		li $t0,0x00000fff
		sw $t0,16($s0)
		jr $k0
continue:	li $t0,0x00000003
		sw $t0,8($s0)
		jr $k0
Exception:	nop
		nop
		nop
		jr $k0