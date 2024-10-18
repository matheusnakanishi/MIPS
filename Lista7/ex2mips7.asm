.data
prompt:      .asciiz "Digite uma string: "
valid_msg:   .asciiz "CPF válido!"
invalid_msg: .asciiz "CPF inválido!"
input_buffer: .space 13


.text
main:
    li $a0, 44	# Carrega nx4
    li $v0, 9	# Aloca��o din�mica
    syscall
    move $t8, $v0	# $t1 = VetC	

    # Imprimir o prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # Ler a string do usuário
    li $v0, 8
    la $a0, input_buffer
    li $a1, 13
    syscall

    # Chamada de função para verificar a string
    jal check_string

    jal check_cpf
    # Sair do programa
    li $v0, 10
    syscall
    

# Função para verificar a string
check_string:
    # Inicializar contadores
    li $t0, 0   # contador de dígitos
    li $t1, 0   # flag para o hífen
    move $t2, $t8
loop:
    # Carregar o caractere atual
    lb $t3, ($a0)
    beqz $t3, end_loop # se for o caractere nulo, sair do loop

    # Verificar se o caractere é um dígito
    li $t4, '0' # '0' em ASCII
    li $t5, '9' # '9' em ASCII
    blt $t3, $t4, check_hyphen # se o caractere for menor que '0', verificar hífen
    bgt $t3, $t5, check_hyphen # se o caractere for maior que '9', verificar hífen

    # Converter o caractere em inteiro e armazenar no vetor
    li $t7, 0x30
    sub $t3, $t3, $t7
    sw $t3, ($t2)      # armazenar no vetor
    
    addi $t0, $t0, 1   # incrementar contador de dígitos
    addi $t2, $t2, 4   # avançar ponteiro do vetor

check_hyphen:
    # Verificar se é um hífen
    li $t4, '-' # hífen em ASCII
    beq $t3, $t4, set_hyphen_flag

    # Avançar para o próximo caractere
    addi $a0, $a0, 1
    j loop

set_hyphen_flag:
    # Se já encontrou um hífen antes, a string é inválida
    bnez $t1, string_invalid

    # Setar a flag de hífen
    li $t1, 1
    addi $a0, $a0, 1
    j loop

string_invalid:
    # Imprimir mensagem de string inválida e sair
    li $v0,11
    li $a0, 10
    syscall
    li $v0, 4
    la $a0, invalid_msg
    syscall
    li $v0, 10
    syscall

end_loop:
    # Verificar se a string é válida
    li $t6, 11
    bne $t0, $t6, string_invalid

end:
    jr $ra
    
    
    

    
    
check_cpf:
    move $s0, $t8	#Vetor de digitos
    li $t0, 10
    li $t2, 2
    li $s1, 0	#soma
first_validation:
    blt $t0, $t2, endfv
    lw $s3, ($s0)
    mul $t1, $s3, $t0
    add $s1, $s1, $t1
    subi $t0, $t0, 1
    addi $s0, $s0, 4
    j first_validation
    
endfv:
    li $t0, 11
    div $s1, $t0
    mfhi $t1
    blt $t1, $t2 validationz
    
    sub $t0, $t0, $t1	# 11 - (soma%11)
    
    addi $s2, $t8, 36
    lw $s2, ($s2)
    bne $t0, $s2, string_invalid
    
    j second_validation
    
    
validationz:
    addi $s2, $t8, 36
    lw $s2, ($s2)
    bnez $s2, string_invalid
    
    j second_validation
    
second_validation:
    move $s0, $t8	#Vetor de digitos
    li $t0, 11
    li $t2, 2
    li $s1, 0	#soma
loop2v:
    blt $t0, $t2, endsv
    lw $s3, ($s0)
    mul $t1, $t0, $s3
    add $s1, $s1, $t1
    subi $t0, $t0 ,1
    addi $s0, $s0, 4
    j loop2v
endsv:
    li $t0, 11
    div $s1, $t0
    mfhi $t1
    blt $t1, $t2 validationz2
    
    sub $t0, $t0, $t1	# 11 - (soma%11)
    
    addi $s2, $t8, 40
    lw $s2, ($s2)
    bne $t0, $s2, string_invalid
    
    j end_validation
    
validationz2:
    addi $s2, $t8, 40
    lw $s2, ($s2)
    bnez $s2, string_invalid

end_validation:
    li $a0, 10
    li $v0, 11
    syscall
	
    la $a0, valid_msg
    li $v0, 4
    syscall
    
    
    jr $ra