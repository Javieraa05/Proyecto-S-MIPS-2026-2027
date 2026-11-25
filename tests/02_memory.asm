
# Cubre: lw, sw, lb, lbu, sb.
# Casos:
# lw/sw con desplazamientos positivos y negativos.
# lb/lbu con bytes de bit 7 = 1 en posiciones distintas.
# sb en las cuatro posiciones de una palabra.
# Comprobacion de conservacion de los bytes no modificados.

.data
.align 2
mem:
    .word 0x0180FF7F
    .word 0x11223344
    .word 0x99AABBCC

.text
.globl main

main:
    la   $s0, mem
    addi $s1, $s0, 4
    addi $s2, $s0, 8

    # LB y LBU: bytes en posiciones 1 y 2
    lb   $t0, 1($s0)
    move $a0, $t0
    jal  print_hex

    lbu  $t0, 1($s0)
    move $a0, $t0
    jal  print_hex

    lb   $t0, 2($s0)
    move $a0, $t0
    jal  print_hex

    lbu  $t0, 2($s0)
    move $a0, $t0
    jal  print_hex
    jal  newline

    # LW con desplazamientos positivo y negativo
    lw   $t0, 4($s0)
    move $a0, $t0
    jal  print_hex

    lw   $t1, -4($s1)
    move $a0, $t1
    jal  print_hex

    # SW con desplazamientos positivo y negativo
    lui  $t2, 0x5566
    ori  $t2, $t2, 0x7788
    sw   $t2, -4($s1)

    lui  $t3, 0x1234
    ori  $t3, $t3, 0x5678
    sw   $t3, 4($s1)

    # Comprobar las escrituras con LW
    lw   $t0, -4($s1)
    move $a0, $t0
    jal  print_hex

    lw   $t0, 4($s1)
    move $a0, $t0
    jal  print_hex
    jal  newline

    # SB: escribir en las cuatro posiciones
    addi $t4, $zero, 0x11
    sb   $t4, 0($s2)
    lw   $a0, 0($s2)
    jal  print_hex

    addi $t4, $zero, 0x22
    sb   $t4, 1($s2)
    lw   $a0, 0($s2)
    jal  print_hex

    addi $t4, $zero, 0x33
    sb   $t4, 2($s2)
    lw   $a0, 0($s2)
    jal  print_hex

    addi $t4, $zero, 0x44
    sb   $t4, 3($s2)
    lw   $a0, 0($s2)
    jal  print_hex
    jal  newline

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
