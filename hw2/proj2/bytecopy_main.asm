.data
src0: .asciiz "ABCDEFGHIJKLMNOP"
src_pos0: .word 3
dest0: .asciiz "abcdefghijklmn"
dest_pos0: .word 4
length0: .word 5
src1: .asciiz "ABCDEFGHIJKLMNOP"
src_pos1: .word 3
dest1: .asciiz "abcdefghijklmn"
dest_pos1: .word 0
length1: .word 5
src2: .asciiz "ABCDEFGHIJKLMNOP"
src_pos2: .word -2
dest2: .asciiz "abcdefghijklmn"
dest_pos2: .word 4
length2: .word 5
.text

la $a0, src0
lw $a1, src_pos0
la $a2, dest0
lw $a3, dest_pos0
lw $t0, length0
addi $sp, $sp, -4
sw $t0, 0($sp)
jal bytecopy
addi $sp, $sp, 4

move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

la $a0, dest0
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, src1
lw $a1, src_pos1
la $a2, dest1
lw $a3, dest_pos1
lw $t0, length1
addi $sp, $sp, -4
sw $t0, 0($sp)
jal bytecopy
addi $sp, $sp, 4

move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

la $a0, dest1
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, src2
lw $a1, src_pos2
la $a2, dest2
lw $a3, dest_pos2
lw $t0, length2
addi $sp, $sp, -4
sw $t0, 0($sp)
jal bytecopy
addi $sp, $sp, 4

move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

la $a0, dest2
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall
