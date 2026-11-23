.text
main:
    li   $t0, 5
    li   $t1, 5
    li   $s0, 0

    # BEQ taken
    beq  $t0, $t1, beq_taken

    addi $s0, $s0, 100

beq_taken:
    addi $s0, $s0, 1

    # BEQ not taken
    li   $t1, 6

    beq  $t0, $t1, beq_wrong

    addi $s0, $s0, 1
    j    after_beq

beq_wrong:
    addi $s0, $s0, 100

after_beq:

    # BNE taken
    li   $t1, 6

    bne  $t0, $t1, bne_taken

    addi $s0, $s0, 100

bne_taken:
    addi $s0, $s0, 1

    # BNE not taken
    li   $t1, 5

    bne  $t0, $t1, bne_wrong

    addi $s0, $s0, 1
    j    after_bne

bne_wrong:
    addi $s0, $s0, 100

after_bne:

    # Backward branch
    li   $s1, 5
    li   $s2, 0

loop:
    addi $s2, $s2, 1
    addi $s1, $s1, -1

    bne  $s1, $zero, loop

    # Unconditional jump
    j    jump_target

    addi $s0, $s0, 100

jump_target:
    addi $s0, $s0, 1

    # Print final counter
    move $a0, $s0
    jal  print_hex

    li   $a0, 32
    syscall

    # Print loop counter
    move $a0, $s2
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
