.data
	local_arq: .asciiz "dados.txt"
	conteudo_arq: .space 1024

.text
	#abrir arquivo leitura
	li $v0, 13
	la $a0, local_arq
	li $a1, 0
	syscall
	
	move $s0, $v0
	
	move $a0, $s0
	li $v0 ,14
	la $a1, conteudo_arq
	li $a2, 1024
	syscall
	
	li $v0, 4
	la $a0, conteudo_arq
	syscall
	
	jal substituir_vogais
	
	li $v0, 4
	la $a0, conteudo_arq
	syscall
	
	#fechar arquivo
	li $v0, 16
	move $a0, $s0
	syscall
	
	#abrir arquivo
	li $v0, 13
	la $a0, local_arq
	li $a1, 1
	syscall
	
	move $s0, $v0
	
	move $a0, $s0
	li $v0 ,15
	la $a1, conteudo_arq
	move $a2, $t1
	syscall
	
	#fechar arquivo
	li $v0, 16
	move $a0, $s0
	syscall
	
	li $v0, 10
	syscall
	
#============================================

substituir_vogais:
	la $t0, conteudo_arq
	li $t1, 0	#quantidade de chars
loop:
	lb $t2, ($t0)
	beq $t2, $zero, fim
	
	#verifica se é vogal
	beq $t2, 65, vogal
	beq $t2, 69, vogal
	beq $t2, 73, vogal
	beq $t2, 79, vogal
	beq $t2, 85, vogal
	beq $t2, 97, vogal
	beq $t2, 101, vogal
	beq $t2, 105, vogal
	beq $t2, 111, vogal
	beq $t2, 117, vogal
	
	j proximo
	
vogal:
	li $t2, 42	#*
	sb $t2, ($t0)	# substitui
	
proximo:
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	
	j loop

fim:
	jr $ra