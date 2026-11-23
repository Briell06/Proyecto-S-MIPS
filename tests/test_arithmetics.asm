.text
main:
    # ADD and SUB
    li   $t0, 7
    li   $t1, -3

    add  $s0, $t0, $t1
    sub  $s1, $t0, $t1

    # AND and OR
    lui  $t2, 0xFFFF
    lui  $t3, 0xFFFF
    ori  $t3, $t3, 0x0001

    and  $s2, $t2, $t3
    or   $s3, $t2, $t3

    # LUI with bit 15 = 1
    lui  $s4, 0x8001

    # ORI with bit 15 = 1
    ori  $s5, $zero, 0x8001

    # ANDI with bit 15 = 1
    lui  $t4, 0xFFFF
    ori  $t4, $t4, 0x8001
    andi $s6, $t4, 0x8001

    # ADDIU through LI
    li   $t6, 12345

    # ADDU through MOVE
    move $t5, $t6

    # Print results: first line
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

    # Second line
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

    # Third line
    move $a0, $t5
    jal  print_hex

    li   $a0, 10
    syscall

    li   $v0, 10
    syscall


# Prints a 32-bit number in hexadecimal.
# Input: $a0
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
