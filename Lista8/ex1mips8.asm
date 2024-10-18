.data
	vetor: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	local_arq: .asciiz "dados.txt"
	null_char: .byte 0
.text
	la $t0, vetor
	
	li $v0, 9
	li $a0, 80		#alocação do vetor de inteiros
	syscall
	
	move $t1, $v0		#endereço do vetor de primos

	jal primo_gemeo
	
	move $t3, $t1
	
	jal print_values_loop
	
	li $v0, 9
	li $a0, 80		#alocação da string
	syscall
	
	move $t2, $v0
	
	jal int_to_string
		
	#abrir arquivo
	li $v0, 13
	la $a0, local_arq
	li $a1, 1
	syscall
	
	move $s0, $v0
	
	#escrevendo no arquivo
	li $v0, 15
	move $a0, $s0
	move $a1, $t2
	move $a2, $s1
	syscall
	
	#fechar arquivo
	li $v0, 16
	move $a0, $s0
	syscall
	
	li $v0, 10
	syscall


#==================================================================

primo_gemeo:
	move $s0, $t0	#endereço base do vetor
	move $s1, $t1 	#endereço base do vetor primos
	li $s4, 1	#variavel que armazena numero primo anterior
	addi $s6, $s0, 80
begin_loop:
	bge $s0, $s6, end_primo	
	li $t2, 2	#divisor inicial
	li $s2, 0	#contador de divisoes
	lw $t3, ($s0)	#valor do vetor
	
loop_primo:	
	bge $t2, $t3, end_loop_primo	
	
	div $t3, $t2	
	mfhi $s3	#resto
	
	bnez $s3, not_divisor
	addi $s2, $s2, 1

not_divisor:
	addi $t2, $t2, 1
	j loop_primo
	
end_loop_primo:
	addi $s0, $s0, 4
	
	bnez $s2, begin_loop
	
	addi $s5, $s4, 2	#primo anterior + 2
	
	bne $t3, $s5, not_primo_gemeo
	
	sw $s4, ($s1)
	addi $s1, $s1, 4
	sw $t3, ($s1)
	addi $s1, $s1, 4
	
not_primo_gemeo:
	move $s4, $t3		#primo anterior = primo atual
	j begin_loop

end_primo:
	jr $ra

#================================================

print_values_loop:
    	li $s0, 20
loop_print:   	
    	blez $s0, end_print
    	
    	lw $a0, ($t3)
    	li $v0, 1
    	syscall
    	
    	li $v0, 11
    	li $a0, 32
    	syscall
    	
    	addi $t3, $t3, 4
    	subi $s0, $s0, 1
    	
    	j loop_print

end_print:
	jr $ra
	
#==========================================

int_to_string:
	move $s0, $t1	#enderço base do vetor
	move $s3, $t2	#endereço da string
	li $s1, 0	#quantidade de caracteres
	
loop_conversor:
	lw $s2, ($s0)
	beqz $s2, end_conversor
	bgt $s2, 9, greater_than_nine
	
	addi $s2, $s2, 48
	
	sb $s2, ($s3)
	addi $s0, $s0, 4
	addi $s3, $s3, 1
	addi $s1, $s1, 2
	
	li $s2, 32
	sb $s2, ($s3)
	addi $s3, $s3, 1
	
	j loop_conversor

greater_than_nine:
	li $t3, 10
	div $s2, $t3
	mflo $t4
	
	addi $t5, $t4, 48
	sb $t5, ($s3)
	addi $s3, $s3, 1
	
	mul $t4, $t3, $t4
	sub $t5, $s2, $t4
	addi $t5, $t5, 48
	sb $t5, ($s3)
	addi $s3, $s3, 1
	
	addi $s0, $s0, 4
	addi $s1, $s1, 3
	
	li $s2, 32
	sb $s2, ($s3)
	addi $s3, $s3, 1
	
	j loop_conversor
	
end_conversor:
	la $s0, null_char
	sb $s0, ($s3)
	
	jr $ra	

	