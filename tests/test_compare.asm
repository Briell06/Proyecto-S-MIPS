# Covers:
# slt: result 1 and result 0
# slt: negative versus positive operands
# slti: result 1 and result 0
# sll: shamt = 0 and shamt != 0
# srl: shamt = 0 and shamt != 0
# srl: negative value, verifying zero-fill

.text
main:
    # Signed comparisons
    li   $t0, -1
    li   $t1, 1

    slt  $s0, $t0, $t1
    slt  $s1, $t1, $t0

    # Immediate comparisons
    slti $s2, $t0, 0
    slti $s3, $t1, 0

    # Shift left
    li   $t2, 3

    sll  $s4, $t2, 0
    sll  $s5, $t2, 2

    # Shift right logical
    li   $t3, -1

    srl  $s6, $t3, 0
    srl  $s7, $t3, 1

    # Print first line
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

    # Print second line
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

    move $a0, $s7
    jal  print_hex

    li   $a0, 10
    syscall

    li   $v0, 10
    syscall


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
