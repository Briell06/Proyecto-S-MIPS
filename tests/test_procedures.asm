# Covers:
# jal: procedure call
# jr: procedure return
# Non-leaf procedure calling another procedure
# Saving and restoring $ra using the stack
# $zero: attempting to write and verifying it remains 0
# addi: negative immediate

.text
main:
    # Initialize stack
    li   $sp, 0x3FFC

    # Initialize value
    li   $s0, 5

    # Call procedure A
    jal  procedure_a

    # Attempt to modify $zero
    addi $zero, $zero, 100

    # Verify $zero
    addu $s1, $zero, $zero

    # Print modified value
    move $a0, $s0
    jal  print_hex

    li   $a0, 32
    syscall

    # Print $zero result
    move $a0, $s1
    jal  print_hex

    li   $a0, 10
    syscall

    li   $v0, 10
    syscall


# Procedure A:
# This is a non-leaf procedure because it calls B.
procedure_a:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)

    jal  procedure_b

    lw   $ra, 0($sp)
    addi $sp, $sp, 4

    jr   $ra


# Procedure B:
# Adds 7 to the value.
procedure_b:
    addi $s0, $s0, 7

    jr   $ra


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
