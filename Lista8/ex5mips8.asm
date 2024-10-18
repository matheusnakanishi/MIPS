.macro strcmp($str1, $str2)
    li $t0, 0 # i(t0)
    loop:
        lb $t1, 0($str1) # t1 = str1[i]
        lb $t2, 0($str2) # t2 = str2[i]

        beqz $t1, fim_loop # if(t1 == 0) jump fim
        beqz $t2, fim_loop # if(t2 == 0) jump fim

        sub $t3, $t1, $t2  # t3 = t1 - t2
        bnez $t3, fim   # if(t3 != 0) jump fim (nao sao iguais)

        addi $str1, $str1, 1 # incrementa 1
        addi $str2, $str2, 1 # incrementa 1
        j loop
    fim_loop:
        beqz $t1, c	# se str1 terminou
        beqz $t2, fim	# se str2 terminou
    c:  beqz $t2, fim 	# se str2 terminou (sao iguais)
        li $t3, -1	# str1 menor
        j fim
    fim:
        move $v0, $t3	# se v0 == 0 sao iguais
.end_macro

.data
    arquivo1: .asciiz "arquivo1.txt"
    arquivo2: .asciiz "arquivo2.txt"
    valido: .asciiz "Tem pelo menos uma sequencia de tamanho maior ou igual a cinco.\n"
    invalido: .asciiz "Nao tem pelo menos uma sequencia de tamanho maior ou igual a cinco.\n"
    erro: .asciiz "Erro ao abrir arquivo!\n"
    buffer: .asciiz " "
    word1: .space 100
    word2: .space 100
    
.text
	.globl main
 main:
        li $v0, 13       # codigo abertura arquivo
        la $a0, arquivo1 # endereco arquivo
        li $a1, 0        # modo someente leitura
        syscall
        bnez $v0, aberto # if(v0 != 0) jump aberto
	erroAbrir:
        li $v0, 4	 # codigo imprimir string
        la $a0, erro	 # carrega ("Erro ao abrir arquivo!\n")
        syscall						
        li $v0, 10	 # codigo finalizar programa
        syscall					
aberto:
        move $s0, $v0    # s0 = descritor arq1

        li $v0, 13       # codigo abertura arquivo
        la $a0, arquivo2 # endereco arquivo
        li $a1, 0        # modo someente leitura
        syscall
        beqz $v0, erroAbrir # if(v0 != 0) jump erroAbrir
        move $s1, $v0	 # s1 = descritor arq2
        
        while_words:
            move $a0, $s0 	# a0 = descritor arq1
            la	$a1, word1 	# a1 = &word1
            jal	lerWord		
            blez $v0, fim_words # fim arquivo
            
            move $a0, $s1	# a0 = descritor arq2
            la	$a1, word2	# a1 = &word2
            jal	lerWord				
            blez $v0, fim_words # fim arquivo

            la $a0, word1	# a0 = $word1
            la $a1, word2	# a1 = $word2
            strcmp($a0, $a1)
            bnez $v0, diferente	# if(v0 != 0) jump diferente:
            addi $s2, $s2, 1    # sequencia(s2)++;
            j c
            diferente:
            ble	$s2, $s3, c1 	# if(sequencia(s2) <= sequencia_max(s3)) jump c1
            move $s3, $s2	# sequencia_max(s3) = sequencia(s2)
        c1: li $s2, 0		# sequencia(s2) = 0
         c: j while_words	# retorna while_words
        fim_words:
        
        li $v0, 16  	# codigo fechar arquivo
        move $a0, $s0   # a0 = descritor arq1
        syscall            

        li $v0, 16  	# codigo fechar arquivo
        move $a0, $s1   # a0 = descritor arq2
        syscall             

        li $t0, 5	# t0 = 5
        blt $s3, $t0, menor5	# if(s3 < 5) jump menor
        li $v0, 4	# codigo imprimir string
        la $a0, valido  # carrega("Tem pelo menos uma sequencia de tamanho maior ou igual a cinco.\n")
        syscall						
        j fim_main	
      
menor5: blt $s3, $t0, menor5 # if(s3 < 5) jump menor
        li $v0, 4	# codigo imprimir string
        la $a0, invalido # carrega("Nao tem pelo menos uma sequencia de tamanho maior ou igual a cinco.\n")						# execute
        
fim_main:
        li $v0, 10	# codigo finalizar programa		
        syscall			
        
        		
lerWord: # (a0 = descritor, a1 = &word)
        li $t0, 0 # i(t0) = 0
        move $t1, $a1 # t1 = &word
        while_lW:
            li $v0, 14 	   # codigo leitura arquivo
            la $a1, buffer # $a1 = &buffer
            li $a2, 1	   # $a2 = tamanho
            syscall				    
            blez $v0, fim_lW  # fim arquivo
            lb $t2, ($a1)
            # fim string (caractere nulo)
            beqz $t2, fim_lW  
            beq $t2, ' ', fim_lW
            beq $t2, '\t', fim_lW
            beq $t2, '\n', fim_lW
            
            add	$t3, $t1, $t0 # t3 = word[i]
            sb $t2, 0($t3) # word[i] = buffer

            addi $t0, $t0, 1 # i(t0)++
            j while_lW # retorna while_lW
        fim_lW:
        add $t3, $t1, $t0 # t3 = word[i]
        sb $zero, 0($t3)  # word[i] = \0
        jr $ra # retorna para o caller
        