.data
	msg1: .asciiz "Tamanho do Vetor: "
	msg3: .asciiz "Vet["
	msg4: .asciiz "]: "
	msg5: .asciiz " ocorre "
	msg6: .asciiz " vezes"
.text
	la $a0, msg1	# Pede n ao usuário
	li $v0, 4
	syscall
	
	li $v0, 5	# Lê n	
	syscall
	
	move $t0, $v0	# $t0 = n
	mul $t0, $t0, 4	# n x 4
	
	move $a0, $t0	# Carrega nx4
	li $v0, 9	# Alocação dinâmica
	syscall
	move $t1, $v0	# $t1 = VetA

	move $a0, $t0	# Carrega nx4
	li $v0, 9	# Alocação dinâmica
	syscall
	move $t2, $v0	# $t2 = VetAux
			
	move $a0, $t1
	jal leitura
	
	move $a0, $t1
	move $a1, $t2
	jal contador
	
	li $v0, 10
	syscall
	
	
leitura:
	move $s0, $a0	# $s0 = vet
	li $t3, 1	# i = 0
	add $t5, $a0, $t0
	
loopl:
	bge $s0, $t5, fiml	# se i > n fim
		
		la $a0, msg3	
		li $v0, 4
		syscall
		move $a0, $t3
		li $v0, 1
		syscall
		la $a0, msg4	
		li $v0, 4
		syscall
		li $v0, 6
		syscall
		
		s.s $f0, ($s0)	# vet[i] = valor lido
		
		addi $s0, $s0, 4
		addi $t3, $t3, 1
	
	j loopl

fiml:
	jr $ra

		
escrita:
	move $s0, $a0
loope:
	bge $s0, $t5, fime
		l.s $f12, ($s0)
		li $v0, 2
		syscall
		
		li $a0, 32
		li $v0, 11
		syscall
		
		addi $s0, $s0, 4
		j loope
fime:
	jr $ra


#a0 = vet1  a1 = vetAux
contador:
	move $s0, $a0	#guarda endereço do inicio dos vetores
	move $s1, $a1
	move $s3, $a1
	add $t7, $a1, $t0

loopc:	
	bge $s0, $t5, fimc	#for para percorrer o vetor1
	l.s $f1, ($s0)	#carrega vet1[i]
	li $t6, 0	#contador
	move $s2, $s0
loopci:
	bge $s1, $t7, loopci2	#for para percorrer o vetorAux
	l.s $f2, ($s1)	#carrega vetAux[j]
	c.eq.s $f1, $f2
	bc1t fimci
	addi $s1, $s1, 4
	j loopci
			
loopci2:
	bge $s2, $t5, fimci2	
	l.s $f2, ($s2)	
	c.eq.s $f1, $f2	
	bc1t soma
	j incr
soma:
	addi $t6, $t6, 1
incr:
	addi $s2, $s2, 4
	j loopci2
fimci2:
	s.s $f1, ($s3)
	addi $s3, $s3, 4
	mov.s $f12, $f1
	li $v0, 2
	syscall 
		
	la $a0, msg5
	li $v0, 4
	syscall
		
	move $a0, $t6
	li $v0, 1
	syscall	
	
	la $a0, msg6
	li $v0, 4
	syscall
	
	li $a0, 10
	li $v0, 11
	syscall	
	
		
fimci:
	move $s1, $a1
	addi $s0, $s0, 4
	j loopc
fimc:
	jr $ra
	
	
