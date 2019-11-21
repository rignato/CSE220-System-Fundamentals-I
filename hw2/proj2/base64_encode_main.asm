.data
encoded_str0: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
encoded_str1: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
encoded_str2: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
decoded_str0: .asciiz "Let's hear it for MIPS! Goooooo MIPS!"
base64_table0: .asciiz "HWegnLO7mM0Q6XwTplBduqSNJsZhkrf25cUoE49bAvPtz8IKDyVjiYC31/+axFRG"
decoded_str1: .asciiz "23 + 52 equals 75"
base64_table1: .asciiz "3YbGHP1qIX5OyFsxgWKliB7h8AanUk6trD4w+LR0jMZfTp29J/NuCdomvzVcEeSQ"
decoded_str2: .asciiz "Stony Brook University 2019"
base64_table2: .asciiz "jm3MX7T1wFRHLfVDQlGvtNs/ZCon8JyBig+2EurkPU0K9q4aOhSIW5pxY6Adzceb"
trash2: .ascii "random garbage"

.text

la $a0, encoded_str0
la $a1, decoded_str0
la $a2, base64_table0
jal base64_encode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, encoded_str0
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, encoded_str1
la $a1, decoded_str1
la $a2, base64_table1
jal base64_encode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, encoded_str1
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, encoded_str2
la $a1, decoded_str2
la $a2, base64_table2
jal base64_encode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, encoded_str2
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

