.data
    msg1: .asciiz "Digite o valor de n: "
    msg2: .asciiz "Insira um número positivo.\n"
    msg3: .asciiz "Combinações: "
   
.text
    .globl main
    main:
        li $v0, 4		# imprimir string
        la $a0, msg1
        syscall						
        li $v0, 5		# ler inteiro
        syscall						
        move $s0, $v0		# $s0 = n

        bgtz $s0, comb	# if($s0 > 0) jump comb
            li $v0, 4		# imprimir string
            la $a0, msg2
            syscall						
            li $v0, 10	# codigo syscall finalizar programa
            syscall					
        
        comb:
        add $a0, $0, $s0	# $s0 bytes to be allocated
        li $v0, 9		# codigo syscall alocar memoria
        syscall					
        move $s1, $v0       # Salva o endereço de char letras[n];

        li $t0, 0 # i(t0) = 0
        loop_letras: # for(i = 0; i < $s0; i++)
            bge $t0, $s0, end_letras # Se i >= $s0 então vai para fim_for
        
            addi $t2, $t0, 65			# $t2 = i + 'A' (ASCII)
            add $t1, $s1, $t0	        # &letras[i]
            sb $t2, 0($t1)	            # letras[i] = 'A' + i;
        
            addi $t0, $t0, 1 # i++
            j loop_letras		# jump loop_letras
        end_letras:

        li $v0, 4		# imprimir string
        la $a0, msg3        # msg
        syscall											

        move $a0, $s1		# $a0 = $s1
        li $a1, 0		    # $a1 = 0
        move $a2, $s0		# $a2 = $s0
        jal	permutar		

        li $v0, 10		#finalizar programa
        syscall					
    
     
permutar: 
        beq $a1, $a2, if_permutar	# if $a1 == $a2 j if_permutar
        j else_permutar	# else j para else_permutar
        if_permutar:
            move $t2, $a0		# $t2 = $a0
            li $t0, 0 # i(t0) = 0
            loop_print: # for(i = 0; i < $a2; i++)
                bge $t0, $a2, fim_loop_print # Se i >= $a2 então vai para fim_for

                add $t1, $t2, $t0	# &letras[i]
                lb  $a0, 0($t1)	    # letras[i]
                li $v0, 11		# imprimir char
                syscall						
            
                addi $t0, $t0, 1 # i++
                j loop_print		
            fim_loop_print:

            li $v0, 11		# imprimir char
            li $a0, 10		    # \n
            syscall						
        
            j fim_else_permutar	# jump para fim_else_permutar
        else_permutar:
            move $t0, $a1 # i = $a1
            loop_permutar: # for(i = $a1; i < $a2; i++)
                bge $t0, $a2, fim_loop_permutar # Se i >= $a2 então vai para fim_for

                add $t1, $a0, $a1	# &letras[inicio]
                lb  $t2, 0($t1)	    # temp = letras[inicio]
                add $t3, $a0, $t0	# &letras[i]
                lb  $t4, 0($t3)	    # letras[i]
                sb  $t4, 0($t1)	    # letras[inicio] = letras[i]
                sb  $t2, 0($t3)	    # letras[i] = temp

                # Salva o registrador $ra na pilha
                subi $sp, $sp, 20
                sw $ra, 0($sp)
                sw $a0, 4($sp)
                sw $a1, 8($sp)
                sw $a2, 12($sp)
                sw $t0, 16($sp)
                move $a0, $a0		# $a0 = $a0
                addi $a1, $a1, 1	# $a1 = $a1 + 1
                move $a2, $a2		# $a2 = $a2
                jal permutar
                # Restaura o registrador $ra da pilha
                lw $ra, 0($sp)
                lw $a0, 4($sp)
                lw $a1, 8($sp)
                lw $a2, 12($sp)
                lw $t0, 16($sp)
                addi $sp, $sp, 20

                add $t1, $a0, $a1	# &letras[inicio]
                lb  $t2, 0($t1)	    # temp = letras[inicio]
                add $t3, $a0, $t0	# &letras[i]
                lb  $t4, 0($t3)	    # letras[i]
                sb  $t4, 0($t1)	    # letras[inicio] = letras[i]
                sb  $t2, 0($t3)	    # letras[i] = temp
            
                addi $t0, $t0, 1    # i++
                j loop_permutar		
            fim_loop_permutar:
        fim_else_permutar:
        jr $ra					
        
