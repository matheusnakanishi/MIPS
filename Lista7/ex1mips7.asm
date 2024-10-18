.data
	msg1: .asciiz "Tamanho do Vetor: "
	msg3: .asciiz "Vet["
	msg4: .asciiz "]: "
	fz: .float 0.0

.text
	la $a0, msg1	# Pede n ao usuário
	li $v0, 4
	syscall
	
	li $v0, 5	# Lê n	
	syscall
	
	move $t0, $v0	# $t0 = n
	move $t4, $v0	# t4 = n
	mul $t0, $t0, 4	# n x 4
	
	move $a0, $t0	# Carrega nx4
	li $v0, 9	# Alocação dinâmica
	syscall
	move $t1, $v0	# $t1 = VetA
	
	move $a0, $t1
	jal leitura
	
	jal notaMax
	
	li $v0, 10
	syscall
	

leitura:
	move $s0, $a0	# $s0 = vet
	li $t3, 1	# i = 0
	add $t5, $a0, $t0 # endereço do fim do vetor
	
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
	
	
notaMax:
	move $s0, $t1 	#s0 = endereço base do vetor
	li $t2, 0	# t2 = i
	l.s $f0, ($s0)	# somaMax = vet[0]
loopm1:
	bge $t2, $t4, floopm1 #for (i=0; i < n; i++)
	move $t3, $t2	# j = i
	mul $t5, $t2, 4	
	add $s0, $t1, $t5	#vet[j]
	l.s $f2, ($s0)	#inicio = vet[j]
loopm2:
	bge $t3, $t4, floopm2	#for (j=i; j < n; j++)
	l.s $f1, fz	#soma = 0
	
	move $t6, $t2	# k = i
loopm3:
	bgt $t6, $t3, floopm3 #for(k = i; k < j; k++)
	mul $t5, $t6, 4
	add $s0, $t1, $t5	#vet[k]
	l.s $f3, ($s0)
	add.s $f1, $f1, $f3	#soma += vet[k]
	addi $t6, $t6, 1 #k++
	j loopm3

floopm3:
	c.le.s $f1, $f0
	bc1t nbigger #if(soma <= somaMax)
	mov.s $f0, $f1	#somaMax = soma
	mov.s $f4, $f2	#inicioMax = inicio
	mov.s $f5, $f3	# fimMax = fim
nbigger:
	addi $t3, $t3, 1	#j++
	
	j loopm2
	
floopm2:
	addi $t2, $t2,1	#i++
	j loopm1

floopm1:
	mov.s $f12, $f4
	li $v0, 2
	syscall
	
	li $a0, 32
	li $v0, 11
	syscall
	
	mov.s $f12, $f5
	li $v0, 2
	syscall
	
	li $a0, 32
	li $v0, 11
	syscall

	mov.s $f12, $f0
	li $v0, 2
	syscall
	
	jr $ra
	
