.data
    msg_k: .asciiz "Digite o valor de k: "
    msg_n: .asciiz "Digite o valor de n: "
    msg_result: .asciiz "Resultado: "

.text
    main:
        # Solicita o valor de k ao usuário
        li $v0, 4
        la $a0, msg_k
        syscall

        # Lê o valor de k
        li $v0, 5
        syscall
        move $s0, $v0  # $s0 = k

        # Solicita o valor de n ao usuário
        li $v0, 4
        la $a0, msg_n
        syscall

        # Lê o valor de n
        li $v0, 5
        syscall
        move $s1, $v0  # $s1 = n

        # Imprime o resultado
        li $v0, 4
        la $a0, msg_result
        syscall
        
        move $a0, $s0
        move $a1, $s1
        jal potencia

        move $a0, $v0   # Move o resultado para impressão
        li $v0, 1
        syscall

        # Termina o programa
        li $v0, 10
        syscall

   
    potencia:
    	bnez $a1, recursao 
    	li $v0, 1
    	jr $ra
    	
    recursao:
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        
       	subi $a1, $a1, 1
       	
	jal potencia
	
	mul $v0, $a0, $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
        jr $ra
