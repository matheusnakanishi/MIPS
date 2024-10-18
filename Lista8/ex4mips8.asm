.data
    Arquivo: .asciiz "matriz.txt"
    ArquivoSaida: .asciiz "matriz_resultante.txt"
    espaco: .asciiz " "
    enter: .asciiz "\r\n"
    erro: .asciiz "Erro ao abrir arquivo!\n"
    buffer: .asciiz " "
    
.text
	.globl main
main:
        li $v0, 13	# codigo abertura arquivo
        la $a0, Arquivo # carrega endereco do arquivo
        li $a1, 0       # modo somente leitura    
        syscall

        bnez $v0, valido	# if(v0 != 0) jump valido
        invalido:
        li $v0, 4               # codigo syscall escrever string
        la $a0, erro   		# parâmetro ("Erro ao abrir arquivo!\n")
        syscall
        li $v0, 10              # codigo syscall finalizar programa
        syscall
valido:
        move $s0, $v0	# s0 = descriptor arquivo
        
        jal lerInteiro
        move $s1, $v0		# s1 = n_linha
        jal lerInteiro
        move $s2, $v0		# s2 = n_coluna
        jal lerInteiro
        move $s3, $v0		# s3 = n_anulada

        mul $t0, $s1, $s2   	# t0 = linha * coluna
        mul $t0, $t0, 4     	# t0 = t0 * sizeof(int)

        move $a0, $t0		# a0 = t0
        addi $v0, $0, 9		# codigo SysCall alocar memoria
        syscall					
        move $a3, $v0		# a3 = v0
        move  $a2, $s2		# a2 = n_coluna(s2)
        
        li $t0, 0 # i(t0) = 0
        for_linha: # for(i = 0; i < n_linha; i++)
            bge $t0, $s1, fim_linha # if(i >= n_linha) jump fim_linha
            li $t1, 0 # j(t1) = 0
            for_coluna: # for(j = 0; j < $s2; j++)
                bge $t1, $s2, fim_coluna # if(j >= n_coluna) jump fim_coluna
                jal indice # &matriz[i][j]
                li $t2, 1  # t2 = 1
                sw $t2, ($v0) # matriz[i][j] = 1
            
                addi $t1, $t1, 1 # j(t1)++
                j for_coluna # retorna for_coluna
            fim_coluna:
            addi $t0, $t0, 1 # i(t0)++
            j for_linha	# retorna for_linha
        fim_linha:
        
        li $t9, 0 # i(t9) = 0
        for_anulada: # for(i = 0; i < n_anulada; i++)
            bge $t9, $s3, fim_anulada # if(i >= n_anulada) jump fim_anulada
                jal lerInteiro # pula o '\n'
                jal lerInteiro           
                move $t8, $v0  # t8 = linha
                jal lerInteiro
                move $t0, $t8  # t0 = t8
                move $t1, $v0  # t1 = coluna
                move $a2, $s2  # a2 = n_coluna(s2)
                jal indice     # &matriz[linha][coluna]
                sw $zero, ($v0) # matriz[i][j] = 0
            addi $t9, $t9, 1 # i(t9)++
            j for_anulada # retorna for_anulada
        fim_anulada:
        
        li $v0, 16	# codigo Syscall fechar arquivo
        move $a0, $s0   # a0 = descriptor
        syscall           
        
        li $v0, 13      # codigo abertura arquivo
        la $a0, ArquivoSaida # carrega endereco do arquivo
        li $a1, 1       # somente escrita
        syscall
        bltz $v0, invalido # if(v0 == 0) jump invalido
        move $s0, $v0      # s0 = descriptor
        
        li $t0, 0 # i(t0) = 0
        for_linhaE: # for(i = 0; i < n_linha; i++)
            bge $t0, $s1, fim_linhaE # if(i >= n_linha) jump fim_linhaE
            li $t1, 0 # j(t1) = 0
            for_colunaE: # for(j = 0; j < n_coluna; j++)
                bge $t1, $s2, fim_colunaE # # if(j >= n_coluna) jump fim_colunaE
                move $a2, $s2 # a2 = n_anulada
                jal indice # &matriz[i][j]
                lw $a0, ($v0) # a0 = matriz[i][j]
                jal imprimirInteiro	
                
                li $v0, 15 # codigo escrita em arquivo
                la $a1, espaco # a1 = &espaco
                li $a2, 1 # a2 = tamanho
                syscall									
            
                addi $t1, $t1, 1 # j(t1)++
                j for_colunaE # retorna for_colunaE
            fim_colunaE:
            li $v0, 15  # codigo escrita em arquivo
            la $a1, enter # a1 = $enter
            li $a2, 2 # a2 = tamanho
            syscall	
        
            addi $t0, $t0, 1 # i(t0)++
            j for_linhaE # retorna for_linhaE
        fim_linhaE:
        
        li $v0, 16  	# codigo fechamento arquivo
        move $a0, $s0   # a0 = descriptor
        syscall           

        li $v0, 10	# codigo Syscall finalizar programa
        syscall	
        
        
indice: # (t0 = i, t1 = j, a2 = n_coluna, a3 = &matriz)
        mul $v0, $t0, $a2 # v0 = i(t0) * n_coluna(a2)
        add $v0, $v0, $t1 # v0 += j(t1)
        sll $v0, $v0, 2   # v0 *= 4 (sizeof(int))
        add $v0, $v0, $a3 # v0 += a3(&matriz)
        
        jr $ra # retorna para o caller
        

lerInteiro:
        li $t1, 0   # t1 = 0
        li $t3, 48  # ASCII '0'
        li $t4, 57  # ASCII '9'
        while_leitura:
            li $v0, 14 		# codigo leitura arquivo
            move $a0, $s0	# a0 = descriptor
            la $a1, buffer     	# $a1 = &buffer
            li $a2, 1		# $a2 = tamanho
            syscall				   
            blez $v0, fim_leitura  # fim do arquivo
            lb $t2, ($a1)
            blt $t2, $t3, fim_leitura
            bgt $t2, $t4, fim_leitura

            sub $t2, $t2, $t3  # subtrai o valor ASCII '0'
            mul $t1, $t1, 10   # multiplica o acumulador por 10
            add $t1, $t1, $t2  # adiciona o digito ao acumulador

            j while_leitura    # retorna while_leitura
        fim_leitura:
        move $v0, $t1 # $v0 = $t1
        jr $ra	
        
        
imprimirInteiro: # (a0 = num)
        subi $sp, $sp, 4 # espaco para 1 item na pilha
        sw $ra, ($sp)    # salva o retorno 
        
	la $a1, buffer  # a1 = &buffer
	li $v0, 0	# v0 = 0
	li $t2, 0	# t2 = 0		
	jal intToString	

	li $v0, 15	# codigo escrita arquivo
	move $a0, $s0	# a0 = descriptor
	la $a1, buffer  # a1 = &buffer
	move $a2, $v0	# a2 = tamanho
	syscall									

        lw $ra, ($sp) 	 # recupera retorno 
        addi $sp, $sp, 4 # libera espaco pilha
        jr $ra # retorna para o caller
        
        		
intToString:
	div $a0, $a0, 10 # n = n / 10
	mfhi $t3	 # t3 = resto
	subi $sp, $sp, 4 # espaco para 1 item na pilha
	sw $t3, ($sp)   # armazena o resto na pilha
	addi $v0, $v0, 1 # caracteres(v0)++

	bnez $a0, intToString # if(a0 != 0) retorna intToString
	li $t2, 0 # i(t2) = 0
	loop_iTS:
		lw $t3, ($sp) 	# recupera resto da pilha 
		addi $sp, $sp, 4 # libera espaco pilha

		add $t3, $t3, 48 # converte unidade para caractere
		sb $t3, ($a1)	 # armazena t3 no buffer
		addi $a1, $a1, 1 # incrementa endereco do buffer
		addi $t2, $t2, 1 # i(t2)++
		bne $t2, $v0, loop_iTS # if(i != caracteres(v0)) retorna loop_iTS
	sb $zero, ($a1)	# armazena zero no buffer
	jr $ra # retorna para o caller
		
