.macro lerInt($descritor)
    li $t1, 0
    li $t3, 48      # '0'
    li $t4, 57      # '9'
    loop_lI:
        li $v0, 14              # comando de leitura do arquivo
        move $a0, $descritor    # $a0 = descritor
        la $a1, buffer       	# $a1 = buffer
        li $a2, 1              	# $a2 = 1
        syscall                
        blez $v0, fim_lI   # fim do arquivo
        lb $t2, ($a1)	
        blt $t2, $t3, fim_lI
        bgt $t2, $t4, fim_lI

        sub $t2, $t2, $t3  # Subtrai o valor '0'
        mul $t1, $t1, 10   # acumulador x 10
        add $t1, $t1, $t2  # Adiciona o dígito ao acumulador

        j loop_lI # jump para while_lI
    fim_lI:
    move $v0, $t1 # $v0 = $t1
.end_macro
.data
    arquivo: .asciiz "dados1.txt"
    erro: .asciiz "Erro ao abrir arquivo!\n"
    msg1: .asciiz "Maior valor: "
    msg2: .asciiz "\nMenor valor: "
    msg3: .asciiz "\nNúmero de elementos ímpares: "
    msg4: .asciiz "\nNúmero de elementos pares: "
    msg5: .asciiz "\nSoma dos valores: "
    msg6: .asciiz "\nValores em ordem crescente: "
    msg7: .asciiz "\nValores em ordem decrescente: "
    msg8: .asciiz "\nProduto dos elementos: "
    msg9: .asciiz "\nNúmero de caracteres no arquivo: "
    buffer: .asciiz " "
.text
    .globl main
main:
        li $v0, 13       # comando abertura arquivo
        la $a0, arquivo  # Endereço da string com o nome do arquivo
        li $a1, 0        # modo somente leitura
        syscall
        bnez $v0, valido # Checa se foi possível  abrir o arquivo (se $v0 < 0)
        invalido:
            li $v0, 4		# comando impressão string
            la $a0, erro
            syscall						
            addi $v0, $0, 10	# comando finalizar programa
            syscall					
        valido:
        move $s0, $v0           # Guarda o descritor do arquivo na variável

        li $s1, 0
        loop_elemento:
            lerInt($s0)          # Lê um inteiro do arquivo
            blez $v0, fim_elemento   # Chegou ao fim do arquivo
            addi $s1, $s1, 1	     # $s1 = $s1 + 1
            j loop_elemento # jump para while_elemento
        fim_elemento:

        li $v0, 16       # comando fechar arquivo
        move $a0, $s0      # a0 = descritor
        syscall            

        li $v0, 13       # comando abertura arquivo
        la $a0, arquivo  # Endereço da string com o nome do arquivo
        li $a1, 0        # modo somente leitura
        syscall
        bltz $v0, invalido # Checa se foi possível  abrir o arquivo (se $v0 < 0):
        move $s0, $v0      # Guarda o descritor do arquivo na variável

        li $t0, 4          # sizeof(int)
        mult $s1, $t0	   # $s1 * 4 = Hi and Lo registers
        mflo $t0	   # copy Lo to $s0

        move $a0, $t0 	   # $t0 bytes para alocar
        li $v0, 9	   # alocação de memoria
        syscall					

        move $s2, $v0      # Salva o endereço de int *valores;

        li $t0, 0
        loop_numeros:
            lerInt($s0)        	# Lê um inteiro do arquivo
            blez $v0, fim_numeros   	# Chegou ao fim do arquivo
            move $t2, $s2		# $t2 = $s1
            sll	$t1, $t0, 2		# $t1 = $t0 << 2
            add $t2, $t2, $t1       	# valores[i]
            sw $v0, 0($t2)		# valores[i] = inteiro lido
            addi $t0, $t0, 1		# $t0 = $t0 + 1
            j loop_numeros 
        fim_numeros:

        # Fecha o arquivo
        li $v0, 16         
        move $a0, $s0      
        syscall           

        li $v0, 4		# impressão string
        la $a0, msg1
        syscall						
        move $a0, $s2		# $a0 = $s2
        move $a1, $s1		# $a1 = $s1
        jal maior
        move $a0, $v0	    	# $a0 = $v0
        li $v0, 1		# impressao inteiro
        syscall						

        li $v0, 4		# impressão string
        la $a0, msg2
        syscall						
        move $a0, $s2		# $a0 = $s2
        move $a1, $s1		# $a1 = $s1
        jal menor
        move $a0, $v0		# $a0 = $v0
        li $v0, 1		# impressao inteiro
        syscall						
        
        li $v0, 4		# impressão string
        la $a0, msg3
        syscall						
        move $a0, $s2	# $a0 = $s2
        move $a1, $s1	# $a1 = $s1
        jal impar
        move $a0, $v0	# $a0 = $v0
        li $v0, 1		# impressao inteiro
        syscall						

        li $v0, 4		# impressão string
        la $a0, msg4
        syscall						
        move $a0, $s2	# $a0 = $s2
        move $a1, $s1	# $a1 = $s1
        jal par
        move $a0, $v0	# $a0 = $v0
        li $v0, 1		# impressao inteiro
        syscall						

        li $v0, 4		# impressão string
        la $a0, msg5
        syscall						
        move $a0, $s2	# $a0 = $s2
        move $a1, $s1	# $a1 = $s1
        jal somar
        move $a0, $v0	# $a0 = $v0
        li $v0, 1		# impressao inteiro
        syscall						

        li $v0, 4		# impressão string
        la $a0, msg6
        syscall						
        move $a0, $s2		# $a0 = $s2
        move $a1, $s1		# $a1 = $s1
        jal ordenarCrescente
        jal imprimirVetor

        li $v0, 4		# comando impressão string
        la $a0, msg7
        syscall						
        move $a0, $s2		# $a0 = $s2
        move $a1, $s1		# $a1 = $s1
        jal ordenarDecrescente
        jal imprimirVetor

        li $v0, 4		# comando impressão string
        la $a0, msg8
        syscall						
        move $a0, $s2		# $a0 = $s2
        move $a1, $s1		# $a1 = $s1
        jal produto
        move $a0, $v0		# $a0 = $v0
        li $v0, 1		# comando impressao inteiro
        syscall						

        li $v0, 13       # comando abertura arquivo
        la $a0, arquivo  # Endereço da string com o nome do arquivo
        li $a1, 0        # Somente leitura
        syscall
        bltz $v0, invalido # Checa se foi possível  abrir o arquivo (se $v0 < 0)
        move $s0, $v0           # Guarda o descritor do arquivo na variável

        li $v0, 4		# comando impressão string
        la $a0, msg9
        syscall						
        move $a0, $s0		# $a0 = $s0
        jal contarCaracter
        move $a0, $v0		# $a0 = $v0
        li $v0, 1		# comando impressao inteiro
        syscall						

        li $v0, 16         # comando fechar file
        move $a0, $s0      # a0 = descritor
        syscall           

        li $v0, 10		# comando finalizar programa
        syscall					


maior: # ($a0 - $vetor, $a1 = tamanho)
        lw $t1, 0($a0)	# int maior = vetor[0];
        li $t0, 1 # i(t0) = 0
        loop_maior: # for(i = 1; i < $a1; i++)
            bge $t0, $a1, fim_maior # Se i >= $a1 então vai para fim_for
        
            sll	$t2, $t0, 2	# i*sizeof(int)
            add $t3, $a0, $t2   # &vetor[i]
            lw $t3, 0($t3)	# vetor[i]

            ble	$t3, $t1, c # if $t3 <= $t1 then goto if_maior:
            move $t1, $t3	# $t1 = $t3
         c: addi $t0, $t0, 1 	# i++
            j loop_maior	# jump para for_maior
        fim_maior:
        move $v0, $t1	# $v0 = $t1
        jr $ra		# jump to $ra


menor: # ($a0 - $vetor, $a1 = tamanho)
        lw $t1, 0($a0)	# int maior = vetor[0];
        li $t0, 1 # i(t0) = 0
        loop_menor: # for(i = 1; i < $a1; i++)
            bge $t0, $a1, fim_menor # Se i >= $a1 então vai para fim_for
        
            sll $t2, $t0, 2	# i*sizeof(int)
            add $t3, $a0, $t2   # &vetor[i]
            lw $t3, 0($t3)	# vetor[i]

            bge	$t3, $t1, c1 
            move $t1, $t3	# $t1 = $t3
        c1: addi $t0, $t0, 1 	# i++
            j loop_menor	
        fim_menor:
        move $v0, $t1 	# $v0 = $t1
        jr $ra


impar: # ($a0 - $vetor, $a1 = tamanho)
        li $t1, 0 # $t1 = 0
        li $t0, 0 # i(t0) = 0
        loop_impar: # for(i = 0; i < $a1; i++)
            bge $t0, $a1, fim_impar # Se i >= $a1 então vai para fim_for

            sll	$t2, $t0, 2	# i*sizeof(int)
            add $t3, $a0, $t2   # &vetor[i]
            lw $t3, 0($t3)	# vetor[i]

            li $t2, 2
            div	$t3, $t2	# vetor[i] / 2
            mfhi $t2		# $t2 = vetor[i] % 2
    
            beqz $t2, nao_impar	# se $t2 == 0 (se é impar)
            addi $t1, $t1, 1	# $t1 = $t1 + 1
            nao_impar:
            addi $t0, $t0, 1 	# i++
            j loop_impar		# jump para for_impar
        fim_impar:
        move $v0, $t1		# $v0 = $t1
        jr $ra


par: # ($a0 - $vetor, $a1 = tamanho)
        li $t1, 0	# $t1 = 0
        li $t0, 0 # i(t0) = 0
        loop_par: # for(i = 0; i < $a1; i++)
            bge $t0, $a1, fim_par # Se i >= $a1 então vai para fim_for

            sll $t2, $t0, 2	# i*sizeof(int)
            add $t3, $a0, $t2   # &vetor[i]
            lw $t3, 0($t3)	# vetor[i]

            li $t2, 2
            div	$t3, $t2	# vetor[i] / 2
            mfhi $t2		# $t2 = vetor[i] % 2
    
            bnez $t2, nao_par	# se $t2 != 0 (se é impar)
            addi	$t1, $t1, 1	# $t1 = $t1 + 1
            nao_par:
            addi $t0, $t0, 1 # i++
            j loop_par		# jump para for_par
        fim_par:
        move $v0, $t1		# $v0 = $t1
        jr $ra
    

somar: # ($a0 - $vetor, $a1 = tamanho)
        li $t1, 0 	# soma = 0
        li $t0, 0 # i(t0) = 0
        loop_soma: # for(i = 0; i < $a1; i++)
            bge $t0, $a1, fim_soma # Se i >= $a1 então vai para fim_for
       
            sll	$t2, $t0, 2	# i*sizeof(int)
            add $t3, $a0, $t2   # &vetor[i]
            lw $t3, 0($t3)	# vetor[i]
            add	$t1, $t1, $t3	# soma += vetor[i]
        
            addi $t0, $t0, 1	# i++
            j loop_soma		# jump para for_soma
        fim_soma:
        move $v0, $t1		# $v0 = $t1
        jr $ra


ordenarCrescente: # ($a0 - $vetor, $a1 = tamanho)
        subi $t2, $a1, 1	# $t2 = $a1 - 1
        li $t0, 0 # i(t0) = 0
        loop_crescente1: # for(i = 0; i < tamanho - 1; i++)
            bge $t0, $t2, fim_crescente1 # Se i >= $a1 então vai para fim_for
            addi $t1, $t0, 1	# j = i + 1
            loop_crescente2: # for(j = i + 1; j < $a1; j++)
                bge $t1, $a1, fim_crescente2 # Se j >= $a1 então vai para fim_for
                    sll $t3, $t0, 2	# i*sizeof(int)
                    add $t3, $a0, $t3	# &vetor[i]
                    lw  $t4, 0($t3)	# vetor[i]

                    sll $t5, $t1, 2	# j*sizeof(int)
                    add $t5, $a0, $t5	# &vetor[j]
                    lw $t6, 0($t5)	# vetor[j]

                    ble	$t4, $t6, c2	# if $t4 <= $t6 then goto if_crescente
                    sw $t4, 0($t5)	# vetor[j] = vetor[i]
                    sw	$t6, 0($t3)	# vetor[i] = vetor[j]
                c2:
                addi $t1, $t1, 1 # j++
                j loop_crescente2	# jump para for_crescente_2
            fim_crescente2:
            addi $t0, $t0, 1 # i++
            j loop_crescente1		# jump para for_crescente_1
        fim_crescente1:
        jr $ra

ordenarDecrescente: # ($a0 - $vetor, $a1 = tamanho)
        subi $t2, $a1, 1	# $t2 = $a1 - 1
        li $t0, 0 # i(t0) = 0
        loop_decrescente1: # for(i = 0; i < tamanho - 1; i++)
            bge $t0, $t2, fim_decrescente1 # Se i >= $a1 então vai para fim_for
            addi $t1, $t0, 1		# j = i + 1
            loop_decrescente2: # for(j = i + 1; j < $a1; j++)
                bge $t1, $a1, fim_decrescente2 # Se j >= $a1 então vai para fim_for

                    sll $t3, $t0, 2	# i*sizeof(int)
                    add $t3, $a0, $t3	# &vetor[i]
                    lw  $t4, 0($t3)	# vetor[i]

                    sll $t5, $t1, 2	# j*sizeof(int)
                    add $t5, $a0, $t5	# &vetor[j]
                    lw $t6, 0($t5)	# vetor[j]

                    bge	$t4, $t6, c3	# if $t4 >= $t6 then goto if_decrescente
                    sw $t4, 0($t5)	# vetor[j] = vetor[i]
                    sw $t6, 0($t3)	# vetor[i] = vetor[j]:
            	c3:
                addi $t1, $t1, 1 # j++
                j loop_decrescente2	# jump para for_decrescente_2
            fim_decrescente2:
            addi $t0, $t0, 1 # i++
            j loop_decrescente1		# jump para for_decrescente_1
        fim_decrescente1:
        jr $ra


produto: # ($a0 - $vetor, $a1 = tamanho)
        li $v0, 1	# $v0 = 1
        li $t0, 0 # i(t0) = 0
        loop_produto: # for(i = 0; i < $a1; i++)
            bge $t0, $a1, fim_produto # Se i >= $a1 então vai para fim_for

            sll $t1, $t0, 2	# i*sizeof(int)
            add $t1, $a0, $t1	# &vetor[i]
            lw $t1, 0($t1)	# vetor[i]

            mult $v0, $t1	# $v0 * $t1 = Hi and Lo registers
            mflo $v0		# copy Lo to $v0
        
            addi $t0, $t0, 1 # i++
            j loop_produto	# jump para for_produto
        fim_produto:
        jr $ra

   
contarCaracter:  # ($a0 = descriptor)
        li $t0, 0		# $t0 = 0
        loop_char:
            li $v0, 14         	# comando leitura arquivo
            la $a1, buffer      # $a1 = &buffer
            li $a2, 1           # $a2 = 1
            syscall                 
            blez $v0, fim_char  # Chegou ao fim do arquivo
            addi $t0, $t0, 1	# $t0 = $t0 + 1
            j loop_char 
        fim_char:
        move $v0, $t0		# $v0 = $t0
        jr $ra


imprimirVetor: # ($a0 - $vetor, $a1 = tamanho)
        move $t2, $a0	# $t2 = $a0
        # for(i = 0; i < $tamanho; i++)
        li $t0, 0 # i(t0) = 0
        loop_vetor:
            bge $t0, $a1, fim_vetor # Se i >= $tamanho então vai para fim_for
        
            sll $t1, $t0, 2	# i*sizeof(int)
            add $t1, $t2, $t1	# &vetor[i]
            lw $t1, 0($t1)	# vetor[i]
            
            addi $v0, $0, 11	# comando imprimir char
            la $a0, 32          # Código ASCII para espaço
            syscall						

            li $v0, 1		# comando impressao inteiro
            add	$a0, $0, $t1
            syscall						

            addi $t0, $t0, 1 	# i++
            j loop_vetor		# jump para for_vetor
        fim_vetor:
        jr $ra
