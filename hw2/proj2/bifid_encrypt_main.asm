.data
ciphertext0: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
ciphertext1: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
ciphertext2: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
ciphertext3: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
plaintext0: .asciiz "\"The Man\", The Killers (2017)"
key_square0: .asciiz "g.WDO?s1Htj2X#ydhP$!o6M- Zplz\'a;nVTv3Qek7SBIJ=8C,cu@9/Ym4Fxb5AKf(*RU\"rq)%wEN:0LiG"
period0: .word 7
plaintext1: .asciiz "Stony Brook University"
key_square1: .asciiz "#8yszp,gv4\"huWA!w=lMRatXrEDGeBm5j$Z1Iq?Q*n;PTNV2iC9.H)k06o(f3@d7\'S:%OYK-xL/cUJ bF"
period1: .word 6
plaintext2: .asciiz "Computer Science"
key_square2: .asciiz "68*be/x!1uSvE0t?U;$l-ci(4nak=)2CW5\'ZOHPDAwf7qIXs#mjF\"VrLN@3p:BRJzdygGhTYMoQ9 %.,K"
period2: .word 2
plaintext3: .asciiz "Dinner @ $50 per person"
key_square3: .asciiz "DQn\'v)t;iGI%5dOr*Rbu4zH@xcZ?:/M1XK,0P$9f=meps(#VUg aBYCSj\"!-N.TlAkWLyh7FE3q2wo8J6"
period3: .word 200
index_buffer: .ascii "Coming out of my cage, And I've been doing just fine Gotta"
trash3: .ascii "random garbage"
block_buffer: .ascii "800ILUVSBU"
junk: .ascii "More random garbage"

.text

la $a0, ciphertext0
la $a1, plaintext0
la $a2, key_square0
lw $a3, period0
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_encrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, ciphertext0
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, ciphertext1
la $a1, plaintext1
la $a2, key_square1
lw $a3, period1
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_encrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, ciphertext1
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, ciphertext2
la $a1, plaintext2
la $a2, key_square2
lw $a3, period2
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_encrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, ciphertext2
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, ciphertext3
la $a1, plaintext3
la $a2, key_square3
lw $a3, period3
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_encrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, ciphertext3
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall
