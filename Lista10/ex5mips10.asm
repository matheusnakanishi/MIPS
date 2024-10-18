.data
    msg_n: .asciiz "Digite o valor de n: "
    msg_result: .asciiz "Resultado: "

.text

        # Solicita o valor de n ao usuário
        li $v0, 4
        la $a0, msg_n
        syscall

        # Lê o valor de n
        li $v0, 5
        syscall
        move $t0, $v0  # $s0 = n

        # Imprime o resultado
        li $v0, 4
        la $a0, msg_result
        syscall
        
        move $a0, $t0
        jal hiper_fatorial

        move $a0, $v0   # Move o resultado para impressão
        li $v0, 1
        syscall

        # Termina o programa
        li $v0, 10
        syscall

        
#===========================================

hiper_fatorial:
    	addi $sp, $sp, -8
        sw $ra, 0($sp)
        sw $s0, 4($sp)
        
        #caso base
        li $v0 ,1
        beqz $a0 ,fim_fatorial
        
        move $s0, $a0
        
        #n-1
        subi $a0, $a0, 1
       	
       	#chamada recursiva
       	jal hiper_fatorial
       	
       	move $t0, $s0
       	li $a2, 1
pow:
	beqz $t0, fim_pow
	mul $a2, $a2, $s0
	subi $t0, $t0, 1
       	j pow
fim_pow:
       	
       	mul $v0, $a2, $v0
       	
fim_fatorial:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	
        jr $ra
        