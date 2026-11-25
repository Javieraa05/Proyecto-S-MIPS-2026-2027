
# Cubre: beq, bne, j.
# Casos:
# beq tomado y no tomado.
# bne tomado y no tomado.
# Salto hacia atras mediante bne.
# Saltos hacia delante mediante j.

.text
.globl main

main:
    addi $t0, $zero, 5
    addi $t1, $zero, 5

    # BEQ tomado
    beq  $t0, $t1, beq_taken
    addi $t2, $zero, 0
    j beq_done

beq_taken:
    addi $t2, $zero, 1

beq_done:
    move $a0, $t2
    jal print_hex

    # BEQ no tomado
    beq  $t0, $zero, beq_unexpected
    addi $t2, $zero, 2
    j beq2_done

beq_unexpected:
    addi $t2, $zero, 0

beq2_done:
    move $a0, $t2
    jal print_hex
    jal newline

    # BNE no tomado
    bne  $t0, $t1, bne_unexpected
    addi $t2, $zero, 3
    j bne_done

bne_unexpected:
    addi $t2, $zero, 0

bne_done:
    move $a0, $t2
    jal print_hex

    # BNE tomado
    bne  $t0, $zero, bne_taken
    addi $t2, $zero, 0
    j bne2_done

bne_taken:
    addi $t2, $zero, 4

bne2_done:
    move $a0, $t2
    jal print_hex
    jal newline

    # Salto hacia atras: repetir tres veces
    addi $t3, $zero, 3
    addi $t4, $zero, 0

loop:
    addi $t4, $t4, 1
    addi $t3, $t3, -1
    bne  $t3, $zero, loop

    move $a0, $t4
    jal print_hex
    jal newline

    # Terminar
    addi $v0, $zero, 10
    syscall

# Imprime un entero de 32 bits en hexadecimal
print_hex:
    move $t6, $a0
    li   $t7, 8

hex_loop:
    srl  $t5, $t6, 28
    andi $t5, $t5, 15
    slti $t4, $t5, 10
    beq  $t4, $zero, hex_letter

    addi $t5, $t5, 48
    j hex_output

hex_letter:
    addi $t5, $t5, 55

hex_output:
    addi $v0, $zero, 11
    move $a0, $t5
    syscall

    sll  $t6, $t6, 4
    addi $t7, $t7, -1
    bne  $t7, $zero, hex_loop

    addi $a0, $zero, 32
    addi $v0, $zero, 11
    syscall
    jr $ra

newline:
    addi $a0, $zero, 10
    addi $v0, $zero, 11
    syscall
    jr $ra
