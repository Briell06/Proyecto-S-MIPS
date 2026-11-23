.data
before: .word 0x11223344
target: .word 0x80FF7F01
after:  .word 0x55667788

.text
main:
    la   $s0, target

    # LW using negative and positive offsets
    lw   $s1, -4($s0)
    lw   $s2, 4($s0)

    # SW using positive and negative offsets
    sw   $s1, 4($s0)
    sw   $s2, -4($s0)

    # Verify SW
    lw   $s3, -4($s0)
    lw   $s4, 4($s0)

    # LB and LBU
    lb   $s5, 2($s0)
    lbu  $s6, 3($s0)

    # Print first line
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
    li   $a0, 32
    syscall

    move $a0, $s4
    jal  print_hex
    li   $a0, 10
    syscall

    # Print LB and LBU
    move $a0, $s5
    jal  print_hex
    li   $a0, 32
    syscall

    move $a0, $s6
    jal  print_hex
    li   $a0, 32
    syscall

    # SB position 0
    li   $t0, 0xAA
    sb   $t0, 0($s0)
    lw   $s7, 0($s0)

    move $a0, $s7
    jal  print_hex
    li   $a0, 32
    syscall

    # SB position 1
    li   $t0, 0xBB
    sb   $t0, 1($s0)
    lw   $s7, 0($s0)

    move $a0, $s7
    jal  print_hex
    li   $a0, 10
    syscall

    # SB position 2
    li   $t0, 0xCC
    sb   $t0, 2($s0)
    lw   $s7, 0($s0)

    move $a0, $s7
    jal  print_hex
    li   $a0, 32
    syscall

    # SB position 3
    li   $t0, 0xDD
    sb   $t0, 3($s0)
    lw   $s7, 0($s0)

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
