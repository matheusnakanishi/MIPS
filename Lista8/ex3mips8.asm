.data
    vet: .word 5, 10, 15, 20	# vetor inicial
    i: .word 0                	# indice
    elem: .word 0               # elemento
    arq: .asciiz "vet.dat"      # nome do arquivo
    erro: .asciiz "Nao foi possivel abrir o arquivo\n"
    
.text
    .globl main
main:
        li $v0, 13	# codigo abertura arquivo
        la $a0, arq     # carrega endereco do arquivo
        li $a1, 9       # modo de abertura (w+b)
        li $a2, 0               
        syscall

        bnez $v0, valido	# if(v0 != 0) jump valido
        li $v0, 4               # codigo syscall escrever string
        la $a0, erro   		# parâmetro ("Nao foi possivel abrir o arquivo\n")
        syscall
        li $v0, 10              # codigo syscall finalizar programa
        syscall

valido:
        move $s0, $v0           # s0 = descriptor arquivo

        li $v0, 15              # codigo escrita arquivo
        move $a0, $s0           # a0 = descriptor
        la $a1, vet             # a1 = &vet[]
        li $a2, 16              # a2 = tamanho vetor (4 * sizeof(int))
        syscall

        li $v0, 5               # codigo Syscall para ler inteiro
        syscall
        move $t0, $v0           # t0 = indice

        bltz $t0, fim           # if(i < 0) jump fim
        li $t1, 3               # t1 = 3 (ultimo indice valido do vetor)
        bgt $t0, $t1, fim       # if(i > t1) jump fim

        # posiciona cursor no i-esimo elemento
        li $v0, 19              # codigo para mover cursor arquivo
        move $a0, $s0           # a0 = descriptor
        li $v1, 0               # offset (0)
        move $a2, $t0           # a2 = deslocamento (i * sizeof(int))
        li $a3, 0               # origem (SEEK_SET)
        syscall

        # le um elemento
        li $v0, 14              # codigo leitura arquivo
        move $a0, $s0           # a0 = descriptor
        la $a1, elem            # a1 = &elemento
        li $a2, 4               # a2 = tamanho (sizeof(int))
        syscall

        lw $t2, elem            # t2 = elemento
        addi $t2, $t2, 1        # elemento(t2)++
        sw $t2, elem            # elemento = t2

        # volta 1 posicao (reposiciona no i-esimo)
        li $v0, 19              # codigo para mover cursor arquivo
        move $a0, $s0           # a0 = descriptor
        li $v1, 0               # offset (0)
        li $a2, -4              # deslocamento (-sizeof(int))
        li $a3, 1               # origem (SEEK_CUR)
        syscall

        # grava o novo elemento
        li $v0, 15              # codigo escrita arquivo
        move $a0, $s0           # a0 = descriptor
        la $a1, elem            # a1 = &elemento
        li $a2, 4               # tamanho (sizeof(int))
        syscall

        li $v0, 19              # codigo para mover cursor arquivo
        move $a0, $s0           # a0 = descriptor
        li $v1, 0               # offset (0)
        li $a2, 0               # deslocamento (0)
        li $a3, 0               # origem (SEEK_SET)
        syscall			# retorna ao inicio do arquivo

        # carrega todo o arquivo no vetor
        li $v0, 14              # codigo leitura arquivo
        move $a0, $s0           # s0 = descriptor
        la $a1, vet             # a1 = &vet
        li $a2, 16              # a2 = tamanho vetor (4 * sizeof(int))
        syscall

        # imprime o vetor alterado
        li $v0, 1               # codigo para imprimir inteiro
        la $a0, vet             # a0 = &vet
        li $a1, 0               # i(a1) = 0
loop_imprimir:
        lw $a0, 0($a0)          # a0 = vet[i]
        syscall
        li $v0, 11              # codigo impressao "espaco"
        li $a0, 32              # espaco (' ')
        syscall
        addi $a1, $a1, 1      	# i(a1)++
        ble $a1, 3, loop_imprimir # if(i <= 3) retorna loop

fim:
        li $v0, 16              # codigo fechamento arquivo
        move $a0, $s0           # a0 = descriptor
        syscall

        li $v0, 10              # codigo syscall finalizar programa
        syscall
