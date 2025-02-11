.data
piece:
.byte 3
.byte 2
.ascii ".O.OOO"  # not null-terminated during grading!
rotation: .word 2147483647
rotated_piece: .asciiz "GB8uJnHG"   # not null-terminated during grading!

.text
main:
la $a0, piece

jal print_struct

la $a0, piece
lw $a1, rotation
la $a2, rotated_piece

jal rotate

# report return value
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# report the contents of the rotated_piece buffer
la $t0, rotated_piece
lb $a0, 0($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

lb $a0, 1($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

# replace this syscall 4 with some of your own code that prints the game field in 2D
move $a0, $t0
addi $a0, $a0, 2
li $v0, 4
syscall

move $a0, $t0
lw $t1, rotation
bltz $t1, no_print
jal print_struct
no_print:


li $v0, 11
li $a0, '\n'
syscall

li $v0, 10
syscall

.include "proj3.asm"
