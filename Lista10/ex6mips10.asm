.data
    msg_n: .asciiz "Digite o valor de n: "
    msg_result: .asciiz "Resultado: "
    zero: .float 0.0
    um: .float 1.0
    dois: .float 2.0

.text

        # Solicita o valor de n ao usuário
        li $v0, 4
        la $a0, msg_n
        syscall

        # Lê o valor de n
        li $v0, 6
        syscall
        mov.s $f1, $f0
        

        # Imprime o resultado
        li $v0, 4
        la $a0, msg_result
        syscall
        
        move $a0, $t0
        jal hiper_fatorial
	
	lwc1 $f1, zero
        add.s $f12, $f0, $f1   # Move o resultado para impressão
        li $v0, 2
        syscall

        # Termina o programa
        li $v0, 10
        syscall

        
#===========================================

hiper_fatorial:
    	addi $sp, $sp, -8
        sw $ra, 0($sp)
        s.s $f2, 4($sp)
        
        #caso base
        l.s $f7, um
        mov.s $f0 ,$f7
        l.s $f6, zero
        c.eq.s $f1 ,$f6
        bc1t fim_fatorial
        
        mov.s $f2, $f1
        
        #n-1
        
        sub.s $f1, $f1, $f7
       	
       	#chamada recursiva
       	jal hiper_fatorial
       	
       	mov.s $f3, $f2		#t0 = n
       	
       	l.s $f8, dois
        add.s $f4, $f3, $f7	#n+1
       	mul.s $f3, $f3, $f8		#2n
       	sub.s $f3, $f3, $f7	#2n-1
       	mul.s $f3, $f3, $f8		#2(2n-1)
       	
       	div.s $f5, $f3, $f4		#2(2n-1)/(n+1)
       
       	
       	mul.s $f0, $f5, $f0
       	
fim_fatorial:
	lw $ra, 0($sp)
	l.s $f2, 4($sp)
	addi $sp, $sp, 8
	
        jr $ra
        
