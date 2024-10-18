.data
	msg_a: .asciiz "Digite o valor de a: "
	msg_b: .asciiz "Digite o valor de b: "
    	msg_n: .asciiz "Digite o valor de n: "
    	
.text
	# Solicita o valor de n ao usuário
        li $v0, 4
        la $a0, msg_n
        syscall

        # Lê o valor de n
        li $v0, 5
        syscall
        move $s0, $v0  # $s0 = n

        # Solicita o valor de a ao usuário
        li $v0, 4
        la $a0, msg_a
        syscall

        # Lê o valor de a
        li $v0, 5
        syscall
        move $s1, $v0  # $s1 = a
        
        # Solicita o valor de b ao usuário
        li $v0, 4
        la $a0, msg_b
        syscall

        # Lê o valor de b
        li $v0, 5
        syscall
        move $s2, $v0  # $s2 = b
        
        jal multiplos
        
        li $v0, 10
        syscall
        
        
multiplos:
	li $t0, 2	#valor inicial

loop:
	blez $s0, fim
	
	div $t0, $s1	#divide o valor por a
	mfhi $t1	#verifica o resto
	
	beqz $t1, multiplo	#se resto == 0 é multiplo
	
	div $t0, $s2 	# se nao for multiplo de a verifica se é multiplo de b
	mfhi $t1
	
        beqz $t1, multiplo	#se resto == 0 é multiplo

incrementa:
        addi $t0, $t0, 1	#incrementa o valor
        j loop
        
multiplo:
	move $a0, $t0	#imprime valor
	li $v0, 1
	syscall
	li $a0, 32
	li $v0, 11
	syscall
	
	subi $s0, $s0, 1	#diminui a quantidade de valores a achar
	j incrementa
	
fim:
	jr $ra
        