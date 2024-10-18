.data
	m1: .asciiz "Quantidade de alunos: "
	m2: .asciiz "Aluno "
	m3: .asciiz "Nota "
	m4: .asciiz ": "
	m5: .asciiz "Media: "
	m6: .asciiz "Quantidade de Aprovados: "
	m7: .asciiz "Media da turma: "
	floatz: .float 0.0
	float1: .float 1.0
	float3: .float 3.0
	float6: .float 6.0
.text
	la $a0, m1
	li $v0, 4
	syscall
	
	li $v0, 5	# Leitura de n
	syscall
	move $t0, $v0	
	
	mul $t0, $t0, 3	# alunos * 3 notas * 4bytes
	mul $a0, $t0, 4	 	
	
	li $v0, 9	# aloca matriz
	syscall
	move $s0, $v0	# $s0 = endereço base da matriz
	add $t1, $s0, $a0	#endereço final da matriz
	
	jal leitura
	
	li $a0, 10
	li $v0, 11
	syscall
	
	jal medias
	
	li $v0, 10
	syscall
	

leitura:
	move $s2, $s0	#endereço base
	li $t2, 1	# i = 1
loop1:
	bge $s2, $t1, fimloop1
	
	la $a0, m2	#print Aluno i
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
	li $t3, 1 # j
	
loop2:	
	bgt $t3, 3, fimloop2
	la $a0, m3	#print Nota j
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	la $a0, m4	
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	mov.s $f1, $f0	# Leitura da nota
	
	s.s $f1,($s2)	# Guarda nota na matriz
	
	addi $s2, $s2, 4	# proxima posição da matriz
	addi $t3, $t3, 1	#j++
	j loop2

fimloop2:
	addi $t2, $t2, 1	#i++
	j loop1

fimloop1:
	jr $ra
	
	
	
	

medias:
	move $s2, $s0	#emdereço base
	li $t2, 1	# i = 1
	li $t4, 0	# aprovados = 0
	l.s $f5, floatz	# soma das medias = 0
	l.s $f8, float1	# constante 1.0
	l.s $f9, floatz	# quantidade de alunos
loop1m:
	bge $s2, $t1, fimloop1m
	
	la $a0, m2	#print Aluno i
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
	la $a0, m5	#print Media
	li $v0, 4
	syscall
	
	li $t3, 1 # j
	l.s $f2, floatz
	
loop2m:	
	bgt $t3, 3, fimloop2m
	
	l.s $f1,($s2)	# Guarda nota na matriz
	add.s $f2, $f2, $f1	# soma notas
	
	addi $s2, $s2, 4	# proxima posição da matriz
	addi $t3, $t3, 1	#j++
	
	j loop2m

fimloop2m:
	l.s $f3, float3
	div.s $f12, $f2, $f3	#Media
	li $v0, 2
	syscall	
	
	#somar media
	add.s $f5, $f5, $f12
	add.s $f9, $f9, $f8	#alunos++
	
	li $a0, 10
	li $v0, 11
	syscall
	li $a0, 10
	li $v0, 11
	syscall
	
	l.s $f6, float6
	c.lt.s $f12, $f6	# nota < 6.0
	bc1t rep
	addi $t4, $t4, 1	#aprovados++
	
rep:	
	addi $t2, $t2, 1	#i++
	j loop1m

fimloop1m:
	la $a0, m6
	li $v0, 4
	syscall
	
	move $a0, $t4
	li $v0, 1
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall
	
	div.s $f12, $f5, $f9	#media da turma
	
	la $a0, m7
	li $v0, 4
	syscall
	
	li $v0, 2
	syscall
	
	jr $ra

	