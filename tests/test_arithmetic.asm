# Cobertura:
# add: operandos positivos y al menos un operando negativo
# sub: operandos positivos y al menos un operando negativo
# and/or: operandos con unos en los 16 bits superiores
# lui/ori/andi: inmediato con bit 15 = 1
# addiu: mediante li
# addu: mediante move

.text
main:
    # ADD y SUB con un operando negativo
    li   $t0, 7
    li   $t1, -3

    add  $s0, $t0, $t1       # 7 + (-3) = 4
    sub  $s1, $t0, $t1       # 7 - (-3) = 10

    # ADD y SUB con ambos operandos positivos
    li   $t0, 7
    li   $t1, 3

    add  $s7, $t0, $t1       # 7 + 3 = 10
    sub  $t7, $t0, $t1       # 7 - 3 = 4

    # AND y OR con unos en los 16 bits superiores
    lui  $t2, 0xFFFF         # 0xFFFF0000
    lui  $t3, 0xFFFF
    ori  $t3, $t3, 0x0001    # 0xFFFF0001

    and  $s2, $t2, $t3       # 0xFFFF0000
    or   $s3, $t2, $t3       # 0xFFFF0001

    # LUI con bit 15 del inmediato = 1
    lui  $s4, 0x8001         # 0x80010000

    # ORI con bit 15 del inmediato = 1
    ori  $s5, $zero, 0x8001  # 0x00008001

    # ANDI con bit 15 del inmediato = 1
    lui  $t4, 0xFFFF
    ori  $t4, $t4, 0x8001    # 0xFFFF8001
    andi $s6, $t4, 0x8001    # 0x00008001

    # ADDIU mediante LI
    li   $t6, 12345          # 0x00003039

    # ADDU mediante MOVE
    move $t5, $t6

    # Imprimir primera línea
    move $a0, $s0
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $s1
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $s2
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $s3
    jal  print_hex
    li   $a0, 10
    syscall

    # Imprimir segunda línea
    move $a0, $s4
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $s5
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $s6
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $t6
    jal  print_hex
    li   $a0, 10
    syscall

    # Imprimir tercera línea
    move $a0, $t5
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $s7
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $t7
    jal  print_hex

    li   $a0, 10
    syscall

    li   $v0, 10
    syscall


# Convierte e imprime un valor de 32 bits en hexadecimal.
# Entrada: $a0. Utiliza syscall 11 para imprimir cada carácter.
print_hex:
    move $t0, $a0
    li   $t2, 8
    li   $v0, 11

hex_loop:
    srl  $t1, $t0, 28
    andi $t1, $t1, 0x000F

    li   $t3, 10
    slt  $t4, $t1, $t3

    beq  $t4, $zero, hex_letter

    addi $a0, $t1, 48
    j    hex_emit

hex_letter:
    addi $a0, $t1, 55

hex_emit:
    syscall

    sll  $t0, $t0, 4
    addi $t2, $t2, -1

    bne  $t2, $zero, hex_loop

    jr   $ra
