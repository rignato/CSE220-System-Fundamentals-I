.data
str4: .asciiz "**[CSE 220 Fall 2019]!!!**"
char0: .byte 'F'
str5: .asciiz "**[CSE 220 Fall 2019]!!!**"
char1: .byte '0'
str6: .asciiz ""
char2: .byte 'A'

.text

la $a0, str4
lbu $a1, char0
jal index_of

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, str5
lbu $a1, char1
jal index_of

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, str6
lbu $a1, char2
jal index_of

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall
