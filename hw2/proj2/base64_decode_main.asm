.data
decoded_str4: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
encoded_str4: .asciiz "bYKLodGUOjH8Hw=="
base64_table4: .asciiz "w964Nem/zAR37BtJxKv0byjkgMOfoH2PqIulnDdT8CV1UcEL5QXhrGsYaZpFi+SW"
decoded_str5: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
encoded_str5: .asciiz "MipF4izIuMxtcrcy4iwvcNkOANIg+S5/CUn="
base64_table5: .asciiz "VxZDRbN7s6T9om8lP5MXwkrS+cJC4AuKv2tYeIiW0/EG3LgyQfBOhFUjnzHdqpa1"
decoded_str6: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
encoded_str6: .asciiz "kkV="
base64_table6: .asciiz "JacdT30UI79KV1povPfwrkjlZznDYELQGH/Ohm6BXu2itbe8xRWsgC5q4SyAM+FN"
#trash: .ascii "random garbage"

.text

la $a0, decoded_str0
la $a1, encoded_str0
la $a2, base64_table0
jal base64_decode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str0
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str1
la $a1, encoded_str1
la $a2, base64_table1
jal base64_decode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str1
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str2
la $a1, encoded_str2
la $a2, base64_table2
jal base64_decode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str2
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str4
la $a1, encoded_str4
la $a2, base64_table4
jal base64_decode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str4
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str5
la $a1, encoded_str5
la $a2, base64_table5
jal base64_decode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str5
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str6
la $a1, encoded_str6
la $a2, base64_table6
jal base64_decode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str6
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall


