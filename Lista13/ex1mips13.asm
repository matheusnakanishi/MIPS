.data
	Mat: .space 48 	# 4x3 * 4 (inteiro)
	vet: .space 12 	# 3 * 4 (inteiro)
	result: .space 16 	# 4 * 4 (inteiro)
	msg1: .asciiz "Insira o valor de Mat["
	msg2: .asciiz "]["
	msg3: .asciiz "]: "
	msg4: .asciiz "Insira o valor de Vet["
	msg5: .asciiz "\nResultado: "
	
.text
	.globl main
main:
	la $a0, Mat	# endereco base de Mat
	li $a1, 4	# a1 = numero de linhas
	li $a2, 3	# a2 = numero de colunas
	jal leMatriz	# leMatriz(Mat[][], nlin, ncol)
	move $a0, $v0	# endereco da matriz lida
	jal escreveMat	# escreveMat(Mat[][], nlin, ncol)
	move $s0, $v0	# s0 = endereco da matriz 
	
	la $a0, vet	# endereco base de vet
	jal leVetor	# leVetor(vet[])
	move $s1, $v0	# s1 = endereco do vetor 
	
	la $a0, Mat	# endereco base de Mat
	li $a1, 4	# a1 = numero de linhas
	li $a2, 3	# a2 = numero de colunas
	# s1 = &vet[]
	jal produto
	
	la $a0, msg5	# parametro("\nResultado: ")
	li $v0, 4	# codigo impressao de string
	syscall
	
	move $a0, $s3	# endereco de result
	jal escreveVet	# escreveVet(vet[])
	
	li $v0, 10	# codigo para finalizar programa
	syscall		
	
	
indice:
	mul $v0, $t0, $a2	# v0 = i(t0) * ncol(a2)
	add $v0, $v0, $t1	# v0 = [i(t0) * ncol(a2)] + j(t1)
	sll $v0, $v0, 2		# v0 =  {[i(t0) * ncol(a2)] + j(t1)} * 4
	add $v0, $v0, $a3	# v0 += endereco base de mat (&Mat[i][j])
	jr $ra
	
leMatriz: # (a0 = Mat[][], a1 = nlin, a2 = ncol)
	subi $sp, $sp, 4	# espaco para 1 item na pilha
	sw $ra, ($sp)		# salva o retorno da main
	
	move $a3, $a0	# aux(a3) = endereco base de mat
	li $t0, 0	# i(t0) = 0
	li $t1, 0	# i(t1) = 0
lM:	la $a0, msg1	# parametro("Insira o valor de Mat[")
	li $v0, 4	# codigo impressao de string
	syscall
	
	move $a0, $t0	# a0 = i(t0)
	li $v0, 1	# codigo impressao de inteiro
	syscall
	
	la $a0, msg2	# parametro("][")
	li $v0, 4	# codigo impressao de string
	syscall
	
	move $a0, $t1	# a0 = j(t1)
	li $v0, 1	# codigo impressao de inteiro
	syscall
	
	la $a0, msg3	# parametro("]: ")
	li $v0, 4	# codigo impressao de string
	syscall
	
	li $v0, 5 	# codigo leitura de inteiro
	syscall
	move $t2, $v0	# aux(t2) = inteiro lido
	
	jal indice
	sw $t2, ($v0)	# Mat[i][j] = inteiro lido (t2)
	
	addi $t1, $t1, 1	# j(t1)++
	blt $t1, $a2, lM	# if(j < ncol) retorna loop l
	li $t1, 0		# j(t1) = 0 (reseta contador j)
	
	addi $t0, $t0, 1	# i(t0)++
	blt $t0, $a1, lM	# if(i < nlin) retorna loop l
	li $t0, 0		# i(t0) = 0 (reseta contador i)
	
	lw $ra, ($sp)	# recupera retorno para main
	addi $sp, $sp, 4	# libera espaco na pilha
	move $v0, $a3	# v0 = endereco da matriz (retorno)
	jr $ra		# retorna para main
	
	
escreveMat: # (a0 = Mat[][], a1 = nlin, a2 = ncol)
	subi $sp, $sp, 4	# espaco para 1 item na pilha
	sw $ra, ($sp)		# salva o retorno da main
	
	move $a3, $a0	# aux(a3) = endereco base de mat
eM: 	jal indice	# calcula indice de Mat[i][j]
	lw $a0, ($v0)	# a0 = mat[i][j]
	
	li $v0, 1	# codigo impressao de inteiro
	syscall
	
	la $a0, 32	# codigo ASCII para espaco
	li $v0, 11	# codigo impressao de caractere
	syscall
	
	addi $t1, $t1, 1	# j(t1)++
	blt $t1, $a2, eM	# if(j < ncol) retorna loop e
	li $t1, 0		# j(t1) = 0 (reseta contador j)
	
	la $a0, 10	# codigo ASCII para quebra de linha "\n"
	syscall
	
	addi $t0, $t0, 1	# i(t0)++
	blt $t0, $a1, eM	# if(i < nlin) retorna loop e
	li $t0, 0		# i(t0) = 0 (reseta contador i)
	
	lw $ra, ($sp)	# recupera retorno para main
	addi $sp, $sp, 4	# libera espaco na pilha
	move $v0, $a3	# v0 = endereco da matriz (retorno)
	jr $ra		# retorna para main
	
	
leVetor: # (a0 = vet[])
	move $t0, $a0 	# salva endere�o base do vetor em $t0
	move $t1, $t0	# $t1 = endere�o de vetor[i]
	li $t2, 0 	# ($t2)i = 0
		
lV: 	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg4	# par�metro ("Digite vetor[")
    	syscall
			
	move $a0, $t2	# carrega �ndice do vetor
	li $v0, 1 	# codigo para impress�o de inteiro 
	syscall
			
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg3	# par�metro ("]:")
    	syscall
    			
    	li $v0, 5	# codigo SysCall para ler inteiros
    	syscall		# inteiro lido armazenado em $v0
    			
    	sw $v0, ($t1)	# vetor[i] = inteiro lido($v0)
	add $t1, $t1, 4 	# endere�o de vetor[i+1]
	addi $t2, $t2, 1	# ($t2)i++
	blt $t2, 3, lV	# se i < 4 retorna loop(lV)
		
	move $v0, $t0	# retorna endere�o do vetor
	jr $ra 		# retorna para main
	

escreveVet:
	move $t0, $a0	# salva endere�o base do vetor em $t0
	move $t1, $t0	# $t1 = endere�o de vetor[i]
	li $t2, 0 	# ($t2)i = 0
		
eV:	lw $a0, ($t1)	# carrega valor de vetor[i]
	li $v0, 1 	# codigo para impress�o de inteiro 
	syscall
		
	li $a0, 32	# c�digo ASCII para espa�o
	#la $a0, 10	# codigo ASCII para quebra de linha "\n"
	li $v0, 11	# c�digo para impress�o de caractere
	syscall
		
	add $t1, $t1, 4 	# endere�o de vetor[i+1]
	addi $t2, $t2, 1	# ($t2)i++
	blt $t2, 4, eV		# se i < 4 retorna loop(eV)
		
	move $v0, $t0	# retorna endere�o do vetor
	jr $ra 		# retorna para main
	

produto: # (a0 = Mat[][], a1 = nlin, a2 = ncol, s1 = Vet[])
	subi $sp, $sp, 4	# espaco para 1 item na pilha
	sw $ra, ($sp)		# salva o retorno da main
	
	move $a3, $a0	# aux(a3) = endereco base de mat
	la $s3, result	# endereco base de result
	li $t0, 0	# i(t0) = 0
	li $t1, 0	# i(t1) = 0
	li $t4, 0
p: 	jal indice	# calcula indice de Mat[i][j]
	lw $a0, ($v0)	# a0 = mat[i][j]
	
	add $v0, $t1, $zero	# v0 = j(t1)
	sll $v0, $v0, 2		# v0 = j(t1) * 4
	add $v0, $v0, $s1	# v0 += endereco base de vet (&Vet[j])
	lw $s2, ($v0)		# s2 = vet[j]
	
	mul $t3, $a0, $s2	# t3 = Mat[i][j] * vet[j]
	add $t4, $t4, $t3	# t4 += Mat[i][j] * vet[j]
	
	add $v0, $t0, $zero	# v0 = i(t0)
	sll $v0, $v0, 2		# v0 = i(t0) * 4
	add $v0, $v0, $s3	# v0 += endereco base de result (&result[i])
	sw $t4, ($v0)		# result[i] = t4
	
	addi $t1, $t1, 1	# j(t1)++
	blt $t1, $a2, p		# if(j < ncol) retorna loop p
	li $t1, 0		# j(t1) = 0 (reseta contador j)
	li $t4, 0		# reseta t4 (soma produto)
	
	addi $t0, $t0, 1	# i(t0)++
	blt $t0, $a1, p		# if(i < nlin) retorna loop p
	
	lw $ra, ($sp)	# recupera retorno para main
	addi $sp, $sp, 4	# libera espaco na pilha
	move $v0, $s3	# v0 = endereco de result (retorno)
	jr $ra		# retorna para main
	