.data
str0: .asciiz "**[CSE 220 Fall 2019]!!!**"
str1: .asciiz "stonybrook"
str2: .asciiz ""

.text
main:
la $a0, str0
jal strlen

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, str1
jal strlen

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, str2
jal strlen

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

