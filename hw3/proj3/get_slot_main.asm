.data
struct:
.byte 6
.byte 10
.ascii "....................OOO.......OOOO.....OOOOOO....OOOOOOO..OO"  # not null-terminated during grading!
row: .word 0
col: .word 2
piece:
.byte 2
.byte 2
.ascii "OOOO.."

.text
main:
la $a0, struct
lw $a1, row
lw $a2, col
jal get_slot

# report return value
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

li $v0, 10
syscall

.include "proj3.asm"
