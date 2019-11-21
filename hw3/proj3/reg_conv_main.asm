.data
struct: .space 1000  # not null-terminated during grading!
num_rows: .word 8
num_cols: .word 6
character: .byte 'A'
filename: .asciiz "Documents/stonybrook/cse220/hw/hw3/game1.txt"
row: .word 0
col: .word 2
piece:
.byte 2
.byte 2
.ascii "OOOO.."
rotation: .word 500
rotated_piece: .asciiz "GB8uJnHG"   # not null-terminated during grading!
moves: .asciiz  "O500I212S916L508L310J607L609Z503S309Z719L418O619O806J511L506I610O101O520Z514S512"
num_pieces_to_drop: .word 20
pieces_list:
# T piece
.byte 2
.byte 3
.ascii "OOO.O."
# J piece
.byte 2
.byte 3
.ascii "OOO..O"
# Z piece
.byte 2
.byte 3
.ascii "OO..OO"
# O piece
.byte 2
.byte 2
.ascii "OOOO.."
# S piece
.byte 2
.byte 3
.ascii ".OOOO."
# L piece
.byte 2
.byte 3
.ascii "OOOO.."
# I piece
.byte 1
.byte 4
.ascii "OOOO.."
.text

main:
li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, struct
lb $a1, num_rows
lb $a2, num_cols
lbu $a3, character
jal initialize

li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, struct
la $a1, filename
jal load_game

li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, struct
lw $a1, row
lw $a2, col
jal get_slot

li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, struct
lw $a1, row
lw $a2, col
lbu $a3, character
jal set_slot

li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, piece
lw $a1, rotation
la $a2, rotated_piece
jal rotate

li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, struct
lw $a1, row
lw $a2, col
la $a3, piece
jal count_overlaps

li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, struct
lw $a1, col
la $a2, piece
lw $a3, rotation
la $t0, rotated_piece
addi $sp, $sp, -4
sw $t0, 0($sp)
li $t0, 0x839313  # trashing $t0
jal drop_piece
addi $sp, $sp, 4

li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, struct
lw $a1, row
jal check_row_clear

li $s0, 10
li $s1, 20
li $s2, 30
li $s3, 40
li $s4, 50
li $s5, 60
li $s6, 70
li $s7, 80
li $fp, 90
li $gp, 100

la $a0, struct
la $a1, filename
la $a2, moves
la $a3, rotated_piece
addi $sp, $sp, -8
lw $t0, num_pieces_to_drop
sw $t0, 0($sp)
la $t0, pieces_list
sw $t0, 4($sp)
li $t0, 28132 # trashing $t0
jal simulate_game
addi $sp, $sp, 8

li $v0, 10
syscall

.include "proj3.asm"