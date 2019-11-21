#.data
#plaintext: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!!!!!!!!"
#ciphertext0: .asciiz "R#onq kTCzS,A* N;rig W(%Bm-U)"
#key_square0: .asciiz "g.WDO?s1Htj2X#ydhP$!o6M- Zplz'a;nVTv3Qek7SBIJ=8C,cu@9/Ym4Fxb5AKf(*RU\"rq)%wEN:0LiG"
#period0: .word 7
#ciphertext1: .asciiz "S(vtjrB3drm,UNBn1!plm?"
#key_square1: .asciiz "#8yszp,gv4\"huWA!w=lMRatXrEDGeBm5j$Z1Iq?Q*n;PTNV2iC9.H)k06o(f3@d7\'S:%OYK-xL/cUJ bF"
#period1: .word 6
#ciphertext2: .asciiz "ZHFwS/xOoH-C*7$C"
#key_square2: "68*be/x!1uSvE0t?U;$l-ci(4nak=)2CW5\'ZOHPDAwf7qIXs#mjF\"VrLN@3p:BRJzdygGhTYMoQ9 %.,K"
#period2: .word 2
#ciphertext3: .asciiz "DD$Vg5g$g$sDqx- 5oh-hTV"
#key_square3: .asciiz "DQn\'v)t;iGI%5dOr*Rbu4zH@xcZ?:/M1XK,0P$9f=meps(#VUg aBYCSj\"!-N.TlAkWLyh7FE3q2wo8J6"
#period3: .word 200
#index_buffer: .ascii "This is raw, memory - it could have any contents! Go SBU!!"
#trash: .ascii "random garbage"
#block_buffer: .ascii "RandomTrashYea"
#junk: .ascii "More random garbage"

.text

la $a0, plaintext0
la $a1, ciphertext0
la $a2, key_square0
lw $a3, period0
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_decrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, plaintext0
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, plaintext1
la $a1, ciphertext1
la $a2, key_square1
lw $a3, period1
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_decrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, plaintext1
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, plaintext2
la $a1, ciphertext2
la $a2, key_square2
lw $a3, period2
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_decrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, plaintext2
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, plaintext3
la $a1, ciphertext3
la $a2, key_square3
lw $a3, period3
addi $sp, $sp, -8
la $t0, index_buffer
sw $t0, 0($sp)
la $t0, block_buffer
sw $t0, 4($sp)
jal bifid_decrypt
addi $sp, $sp, 8

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, plaintext3
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall
