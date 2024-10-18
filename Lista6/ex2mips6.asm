.data
	m1: .asciiz "x: "
	m2: .asciiz "n: "
	m3: .asciiz "cos("
	m4: .asciiz ") = "
	floatz: .float 0.0
	float1: .float 1.0
	floatm1: .float -1.0
.text
	la $a0, m1
	li $v0, 4
	syscall
	
	li $v0, 6	# Lê x
	syscall
	mov.s $f1, $f0
	
	la $a0, m2
	li $v0, 4
	syscall
	
	li $v0, 5	# Lê n
	syscall
	move $t1, $v0
	
	jal cosseno
	
	li $v0, 10
	syscall
	
	
cosseno:
	l.s $f2, float1	#cos = 1
	li $s1, 1	# i = 1
	l.s $f7, floatm1	# sinal
	l.s $f8, floatm1
	
loop1:	
	bgt $s1, $t1, fimloop1	# for de 1 ate n
	mov.s $f3, $f1	# x^
	li $s5, 2	# j
	mul $s3, $s1, 2	# 2i
	
loop2:
	bgt $s5, $s3, fimloop2	#for 1 ate 2n
	mul.s $f3, $f3, $f1 	# x*x
	addi $s5, $s5, 1	#j++
	j loop2

fimloop2:
	l.s $f4, float1		#denominador = 1
	l.s $f6, float1
	l.s $f9, float1
	li $s5, 1	# j
loop3:
	bgt $s5, $s3, fimloop3 #for 1 ate 2i
	mul.s $f4, $f4, $f6	
	addi $s5, $s5, 1 
	add.s $f6, $f6, $f9
	j loop3

fimloop3:
	div.s $f5, $f3, $f4	
	mul.s $f5, $f5, $f7
	add.s $f2, $f2, $f5
	mul.s $f7, $f7, $f8	#sinal * (-1)
	
	addi $s1, $s1, 1	#i++
	j loop1
	
fimloop1:
	la $a0, m3
	li $v0, 4
	syscall
	
	mov.s $f12, $f1
	li $v0, 2
	syscall
	
	la $a0, m4
	li $v0, 4
	syscall
	
	mov.s $f12, $f2
	li $v0, 2
	syscall
	
	jr $ra
	
	
	