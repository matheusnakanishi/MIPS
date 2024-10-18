.data
	msg1: .asciiz "Tamanho do Vetor: "
	msg3: .asciiz "Vet["
	msg4: .asciiz "]: "
	
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
	move $t2, $v0	# $t2 = VetB
	
	move $a0, $t1
	jal leitura
	
	move $a0, $t1
	jal escrita
	
	#inverter
	jal inverter
	
	li $a0, 10	# \n
	li $v0, 11
	syscall
	
	add $t5, $t2, $t0
	move $a0, $t2
	jal escrita
	
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
		li $v0, 5
		syscall
		
		sw $v0, ($s0)	# vet[i] = valor lido
		
		addi $s0, $s0, 4
		addi $t3, $t3, 1
	
	j loopl

fiml:
	jr $ra
	

escrita:
	move $s0, $a0
loope:
	bge $s0, $t5, fime
		lw $a0, ($s0)
		li $v0, 1
		syscall
		
		li $a0, 32
		li $v0, 11
		syscall
		
		addi $s0, $s0, 4
		j loope
fime:
	jr $ra
	

inverter:
	move $s0, $t5	#s0 = endereço final do vetA
	subi $s0, $s0, 4	#volta uma posicao do vetA
	move $s1, $t2	#s1 = endereço inicial do vetB

loop_inverter:
	blt $s0, $t1, fim_inverter
	lw $s3, ($s0)		#armazena o valor final do vetorA no vetorB
	sw $s3, ($s1)
	subi $s0, $s0, 4
	addi $s1, $s1, 4
	j loop_inverter

fim_inverter:
	jr $ra
	
		
	
	
	