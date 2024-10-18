.data
msg1: .asciiz "Digite um valor: "      
msg2: .asciiz " eh triangular\n"   
msg3: .asciiz " nao eh triangular\n"   
divisor: .word 2                     

.text
main:
    li $v0, 4         # comando imprimir string
    la $a0, msg1      # Carrega o endereço da mensagem para $a0
    syscall

    li $v0, 5           # comando ler inteiro
    syscall
    move $t0, $v0       # Move o valor lido para $t0

    li $t1, 1           # Inicializa $t1 com 1 (início do cálculo)
    li $t2, 1           # Inicializa $t2 com 1 (resultado do cálculo)

verifica:
    mult $t1, $t1       # Multiplica $t1 por $t1
    mflo $t3            # Move o resultado para $t3 (parte inferior do cálculo)
    add $t3, $t3, $t1   # Adiciona $t1 ao resultado anterior (parte superior do cálculo)
    lw $t4, divisor     # Carrega o divisor
    div $t3, $t4        # Divide $t3 pelo divisor
    mflo $t3            # Move o resultado da divisão para $t3

    bgt $t3, $t0, nao_triangulo  # Se $t3 for maior que $t0, não é triangular
    beq $t3, $t0, eh_triangulo   # Se $t3 for igual a $t0, é triangular

    addi $t1, $t1, 1    # Incrementa $t1 por 1
    add $t2, $t2, $t1   # Adiciona $t1 a $t2
    j verifica    # Volta ao início para a próxima iteração

eh_triangulo:
    li $v0, 1           # Carrega a syscall 1 (imprimir inteiro)
    move $a0, $t0       # Move $t0 (o valor lido) para $a0
    syscall

    li $v0, 4           # comando imprimir string
    la $a0, msg2     # Carrega o endereço de msg2 para imprimir
    syscall

    j saida              # Pula para o fim do programa

nao_triangulo:
    li $v0, 1           # Carrega a syscall 1 (imprimir inteiro)
    move $a0, $t0       # Move $t0 (o valor lido) para $a0
    syscall

    li $v0, 4           # comando imprimir string
    la $a0, msg3     # Carrega o endereço de msg3 para imprimir
    syscall

    j saida              # Pula para o fim do programa

saida:
    li $v0, 10          # comando finalizar programa
    syscall
