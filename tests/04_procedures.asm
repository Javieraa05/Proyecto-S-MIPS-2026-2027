
# Cubre: jal, jr.
# Casos:
# Llamada a un procedimiento no hoja.
# Un procedimiento llama a otro procedimiento.
# Guardar y recuperar $ra usando la pila.
# Retorno correcto al procedimiento llamador.

.data
.align 2
stack:
    .space 32
stack_top:

.text
.globl main

main:
    # Inicializar la pila dentro del segmento de datos
    la   $sp, stack_top

    # Llamar al procedimiento A
    addi $a0, $zero, 7
    jal  procedure_A

    # Si regresamos correctamente, imprimimos 99
    addi $a0, $zero, 99
    jal  print_hex
    jal  newline

    # Terminar
    addi $v0, $zero, 10
    syscall


# Procedimiento A: NO es hoja.
# Llama a B y también a print_hex.
procedure_A:
    # Reservar espacio y guardar la direccion de retorno
    addi $sp, $sp, -4
    sw   $ra, 0($sp)

    # Preparar argumento para B
    addi $a0, $a0, 5
    jal  procedure_B

    # B devuelve el resultado en $v0
    move $a0, $v0
    jal  print_hex

    # Recuperar la direccion de retorno original
    lw   $ra, 0($sp)
    addi $sp, $sp, 4

    jr   $ra


# Procedimiento B: hoja.
procedure_B:
    addi $v0, $a0, 10
    jr   $ra


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
