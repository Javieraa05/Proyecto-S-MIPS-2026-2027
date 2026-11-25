
# Cubre: add, sub, and, or, slt, slti,
# sll, srl, addi, addiu, addu, andi, ori, lui.
# Casos: positivos, negativos, comparaciones 0/1,
# desplazamientos 0/no 0, inmediatos con bit 15=1,
# registros con bits altos y escritura en $zero.

.text
.globl main

main:
    # ADD y SUB: positivos y negativos
    addi $t0, $zero, 10
    addi $t1, $zero, 5
    add  $t2, $t0, $t1
    move $a0, $t2
    jal print_hex

    sub  $t2, $t0, $t1
    move $a0, $t2
    jal print_hex

    addi $t0, $zero, -10
    add  $t2, $t0, $t1
    move $a0, $t2
    jal print_hex

    sub  $t2, $t1, $t0
    move $a0, $t2
    jal print_hex
    jal newline

    # AND y OR con bits altos
    lui  $t0, 0xF0F0
    ori  $t0, $t0, 0x8001
    lui  $t1, 0xFF00
    ori  $t1, $t1, 0xFFFF

    and  $t2, $t0, $t1
    move $a0, $t2
    jal print_hex

    or   $t2, $t0, $t1
    move $a0, $t2
    jal print_hex
    jal newline

    # SLT y SLTI: resultados 1 y 0
    addi $t0, $zero, -1
    addi $t1, $zero, 1

    slt  $t2, $t0, $t1
    move $a0, $t2
    jal print_hex

    slt  $t2, $t1, $t0
    move $a0, $t2
    jal print_hex

    slti $t2, $t0, 1
    move $a0, $t2
    jal print_hex

    slti $t2, $t1, 0
    move $a0, $t2
    jal print_hex
    jal newline

    # SLL y SRL: shamt 0 y distinto de 0
    lui  $t0, 0x8001

    sll  $t2, $t0, 0
    move $a0, $t2
    jal print_hex

    sll  $t2, $t0, 2
    move $a0, $t2
    jal print_hex

    srl  $t2, $t0, 0
    move $a0, $t2
    jal print_hex

    srl  $t2, $t0, 2
    move $a0, $t2
    jal print_hex
    jal newline

    # ADDI con inmediato negativo
    addi $t2, $t1, -8
    move $a0, $t2
    jal print_hex

    # ADDIU mediante LI
    li   $t0, 1234
    move $a0, $t0
    jal print_hex

    # ADDU mediante MOVE
    move $t1, $t0
    move $a0, $t1
    jal print_hex
    jal newline

    # ANDI y ORI con bit 15 = 1
    lui  $t0, 0xFFFF

    andi $t2, $t0, 0x8001
    move $a0, $t2
    jal print_hex

    ori  $t2, $zero, 0x8001
    move $a0, $t2
    jal print_hex

    # LUI con bit 15 = 1
    lui  $t2, 0x8001
    move $a0, $t2
    jal print_hex
    jal newline

    # Escritura en $zero
    addi $zero, $zero, 123
    move $a0, $zero
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
