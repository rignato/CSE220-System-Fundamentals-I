# CSE 220 Programming Project #2
# Robert Ignatowicz
# rignatowicz
# 112069216

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

strlen:
# $a0 = str (str_addr)
	li $v0,	0		# len = 0
	li $v1, 0		# clear other return
	strlen.loop:
		lbu $t0, 0($a0)			# get current char
		beqz $t0, strlen.loop.end	# end loop for '\0'
		addi $a0, $a0, 1		# str_addr++
		addi $v0, $v0, 1		# len++
		j strlen.loop
	strlen.loop.end:
	jr $ra			# return len

index_of:
# $a0 = str (str_addr)
# $a1 = ch (char to get index of)
	li $v0,	-1	# index
	li $v1, 0	# clear other return
	li $t0, 0	# i = 0
	index_of.loop:
		lbu $t1, 0($a0)						# get current char
		beq $t1, $a1, index_of.loop.found	# jump if curr_char = ch
		beqz $t1, index_of.loop.end			# if '\0', end loop
		addi $a0, $a0, 1					# str_addr++
		addi $t0, $t0, 1					# i++
		j index_of.loop
		index_of.loop.found:
			move $v0, $t0
	index_of.loop.end:
	jr $ra
	
indices_of:
# $a0 = byte matrix
# $a1 = byte to get indices of
# $a2 = number of columns
	addi $sp, $sp, -4	# allocate stack for $ra
	sw $ra, 0($sp)		# save $ra
	
	li $v0, -1	# row index
	li $v1, -1	# column index
	bltz $a2, indices_of.exit
	
	jal index_of
	bltz $v0, indices_of.exit
	div $v0, $a2	
	mflo $v0	# row index is quotient
	mfhi $v1	# col index is remainder
	indices_of.exit:
	lw $ra, 0($sp)		# load $ra
	addi $sp, $sp, 4	# deallocate stack
	jr $ra

bytecopy:
# $a0 = src (arr1_addr)
# $a1 = src_pos
# $a2 = dest (arr2_addr)
# $a3 = dest_pos
# 0($sp) = length (# of chars to copy)
	li $v0, -1
	li $v1, 0		# clear other return
	
	bltz $a1, bytecopy.loop.end		# return -1 if src_pos < 0
	bltz $a3, bytecopy.loop.end		# return -1 if dest_pos < 0
	
	lw $t2, 0($sp)		   			# load length in $t2
	blez $t2, bytecopy.loop.end		# return -1 if length <= 0
	
	add $t0, $a0, $a1	# get src_pos_addr in $t0
	add $t1, $a2, $a3	# get dest_pos_addr in $t1
	
	li $v0, 0			# i = 0
	bytecopy.loop:
		beq $v0, $t2, bytecopy.loop.end	# end loop if i = length
		lbu $t3, 0($t0)			# get src_char
		sb $t3, 0($t1)			# store src_char in dest_pos_addr
		addi $v0, $v0, 1		# i++
		addi $t0, $t0, 1		# src_pos_addr++
		addi $t1, $t1, 1		# dest_pos_addr++
		j bytecopy.loop
	bytecopy.loop.end:
	jr $ra

is_letter:
# returns 1 if lowercase, 0 if uppercase, -1 if not letter
# $a0 = char to check if is letter
	li $t0, 'A'
	li $v0, -1	# default is -1
	li $v1, 0	# clear return 2
	
	blt $a0, $t0, is_letter.exit		# jump if curr_char < 'A'
	addi $t0, $t0, 57
	bgt $a0, $t0, is_letter.exit		# jump if curr_char > 'z'
	addi $t0, $t0, -25
	bge $a0, $t0, is_letter.lower			# jump if 'a' <= curr_char <= 'z'
	addi $t0, $t0, -7
	bgt $a0, $t0, is_letter.exit		# jump if 'Z' < curr_char < 'a'
	j is_letter.upper
	
	is_letter.lower:
		addi $v0, $v0, 1
	is_letter.upper:
		addi $v0, $v0, 1
	is_letter.exit:
		jr $ra

scramble_encrypt:
# $a0 = ciphertext (ciphertext_addr)
# $a1 = plaintext (plaintext_addr)
# $a2 = alphabet
	addi $sp, $sp -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s0, $a0	# save ciphertext in $s0
	move $s1, $a1	# save plaintext in $s1
	move $s2, $a2	# save alphabet in $s2
	
	li $v0, 0		# clear first return
	li $v1, 0		# clear other return
	
	li $s3, 0		# num_encrypted = 0
	li $s4, 0 		# i = 0
	
	li $s5, 'A'
	
	addi $sp, $sp -4	# allocate stack for length arg in bytecopy
	li $t2, 1			
	sw $t2, 0($sp)		# set length to 1
	
	scramble_encrypt.loop:
		li $t2, -65
		
		lbu $s6, 0($s1)	# get curr_char
		beqz $s6, scramble_encrypt.loop.end			# end loop if '\0' is reached
		
		move $a0, $s6
		jal is_letter
		
		move $a0, $s1	# set src to plaintext (default before letter check)
		li $a1, 0		# set src_pos to 0	   (default before letter check)
		
		bltz $v0, scramble_encrypt.continue
		beqz $v0, scramble_encrypt.upper
		
		scramble_encrypt.lower:
			li $t2, -71 
		scramble_encrypt.upper:
			move $a0, $s2		# set src to alphabet
			add $t1, $s6, $t2   # get index_of_curr_char_in_alphabet
			move $a1, $t1		# set src_pos to index_of_curr_char_in_alphabet
			addi $s3, $s3, 1	# num_encrypted++
		scramble_encrypt.continue:
			move $a2, $s0		# set dest to ciphertext
			move $a3, $s4		# set dest_pos to i
			
			jal bytecopy		# bytecopy(src, src_pos, ciphertext, i, 1)
			
			addi $s4, $s4, 1	# i++
			addi $s1, $s1, 1	# plaintext_addr++
			j scramble_encrypt.loop
	scramble_encrypt.loop.end:
	
	addi $sp, $sp, 4	# deallocate stack for length arg
	add $s0, $s0, $s4	# ciphertext_addr += i
	sb $0, 0($s0)	# Add null terminator to ciphertext
	
	move $v0, $s3
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	addi $sp, $sp, 32
	jr $ra


scramble_decrypt:
# $a0 = plaintext (plaintext_addr)
# $a1 = ciphertext (ciphertext_addr)
# $a2 = alphabet
	
	addi $sp, $sp -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s0, $a0	# save plaintext in $s0
	move $s1, $a1	# save ciphertext in $s1
	move $s2, $a2	# save alphabet in $s2
	
	li $v0, 0		# clear first return
	li $v1, 0		# clear other return
	
	
	li $s3, 0		# i = 0
	li $s4, 0		# num_decrypted = 0
	
	li $s6, 26		# number to check for lowercase
	
	scramble_decrypt.loop:
		lbu $s5, 0($s1)							# get curr_char in ciphertext
		beqz $s5, scramble_decrypt.loop.end		# end loop if curr_char = '\0'
		addi $s3, $s3, 1						# i++
		move $a0, $s5
		jal is_letter
		bltz $v0, scramble_decrypt.continue
		move $a0, $s2							# set str to alphabet
		move $a1, $s5							# set ch to curr_char
		jal index_of							# index_of(alphabet, curr_char)
		bge $v0, $s6, scramble_decrypt.lower	# jump if index > 25 (lowercase)
		j scramble_decrypt.upper
		scramble_decrypt.lower:
			sub $s5, $v0, $s6
			addi $s5, $s5, 'a'
			addi $s4, $s4, 1				# num_decrypted++
			j scramble_decrypt.continue
		scramble_decrypt.upper:
			addi $s5, $v0, 'A'
			addi $s4, $s4, 1				# num_decrypted++
		scramble_decrypt.continue:
			sb $s5, 0($s0)		# store char in plaintext
			addi $s1, $s1, 1	# ciphertext_addr++
			addi $s0, $s0, 1	# plaintext_addr++
			j scramble_decrypt.loop
			
	scramble_decrypt.loop.end:

	sb $0, 0($s0)				# add null terminator to plaintext
	
	move $v0, $s4
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	addi $sp, $sp, 32
	jr $ra


base64_encode:
# $a0 = encoded_str (encoded_str_addr)
# $a1 = str (str_addr)
# $a2 = base64_table (base64_table_addr)

	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	li $v0, 0	# clear return 1
	li $v1, 0	# clear return 2
	
	li $t0, 0	# i = 0
	
	base64_encode.loop:
		li $s3, 1			# $s3 is boolean if padding was used
		lbu $s0, 0($a1)		# load curr_char 1
		
		beqz $s0, base64_encode.loop.end
		
		lbu $s1, 1($a1)		# load curr_char 2
		lbu $s2, 2($a1)		# load curr_char 3
		
		addi $sp, $sp, -4		# allocate stack for base64 values
		
		sll $s0, $s0, 16
		sll $s1, $s1, 8
		or $s0, $s0, $s1
		or $s0, $s0, $s2		# join char 1, 2, 3 into one int
		
		andi $t1, $s0, 0x00fc0000	# mask for base64 value 1
		srl $t1, $t1, 18			# get char 1 value
		add $t1, $t1, $a2			# get addr of char_1_index
		lbu $t2, 0($t1)				# get char 1 at index in table
		sb $t2, 0($sp)				# store base64 char 1
		
		andi $t1, $s0, 0x0003f000	# mask for base64 value 2
		srl $t1, $t1, 12			# get char 2 value
		add $t1, $t1, $a2			# get addr of char_2_index
		lbu $t2, 0($t1)				# get char 2 at index in table
		sb $t2, 1($sp)				# store char 2 value
		
		li $t2, '='			# padding
		sb $t2, 2($sp)		# base64 char 3 default
		sb $t2, 3($sp)		# base64 char 4 default
		
		beqz $s1, base64_encode.loop.continue
		
		andi $t1, $s0, 0x00000fc0	# mask for base64 value 3
		srl $t1, $t1, 6				# get char 3 value
		add $t1, $t1, $a2			# get addr of char_3_index
		lbu $t2, 0($t1)				# get char 3 at index in table
		sb $t2, 2($sp)				# store char 3 value
		
		beqz $s2, base64_encode.loop.continue
		
		andi $t1, $s0, 0x0000003f	# mask for base64 value 4 (no shift needed)
		add $t1, $t1, $a2			# get addr of char_4_index
		lbu $t2, 0($t1)				# get char 4 at index in table
		sb $t2, 3($sp)				# store char 4 value
		
		li $s3, 0
		
		base64_encode.loop.continue:
		lbu $t1, 0($sp)		# get value of char 1	
		sb $t1, 0($a0)		# store char 1 in encoding
		
		lbu $t1, 1($sp)		# get value of char 2		
		sb $t1, 1($a0)		# store char 2 in encoding
		
		lbu $t1, 2($sp)		# get value of char 3		
		sb $t1, 2($a0)		# store char 3 in encoding
		
		lbu $t1, 3($sp)		# get value of char 4	
		sb $t1, 3($a0)		# store char 4 in encoding
		
		addi $t0, $t0, 4	# i += 4
		addi $a0, $a0, 4	# encoded_str_addr += 4
		addi $a1, $a1, 3	# str_addr += 3
		addi $sp, $sp, 4	# deallocate stack
		
		beqz $s3, base64_encode.loop
	base64_encode.loop.end:
	
	sb $0, 0($a0)			# add null term to encoding
	
	move $v0, $t0			# set i to return value
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra


base64_decode:
# $a0 = decoded_str (decoded_str_addr)
# $a1 = encoded_str (encoded_str_addr)
# $a2 = base64_table (base64_table_addr)

	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	move $s0, $a0	# store decoded_str in $s0
	move $s1, $a1	# store encoded_str in $s1

	li $v0, 0	# clear return 1
	li $v1, 0	# clear return 2
	
	li $s4, 0	# len = 0
	
	li $s5, '='	# padding 
	
	base64_decode.loop:
		lbu $s2, 0($s1)
		beqz $s2, base64_decode.loop.end	# end loop if null term reached
		move $a0, $a2
		move $a1, $s2
		jal index_of
		sll $s3, $v0, 18	# shift index to left to start building binary sequence to decode	
		
		lbu $s2, 1($s1)
		move $a0, $a2	
		move $a1, $s2	
		jal index_of
		sll $s2, $v0, 12	# add on second index to encoded binary sequence
		or $s3, $s2, $s3	# join first two encoded indices
		
		andi $t0, $s3, 0x00ff0000
		srl $t0, $t0, 16
		sb $t0, 0($s0)
		addi $s4, $s4, 1	# len++
		addi $s0, $s0, 1	# decoded_str++
		
		lbu $s2, 2($s1)
		beq $s2, $s5, base64_decode.loop.end		# end loop if double padded
		
		move $a0, $a2
		move $a1, $s2
		jal index_of
		sll $s2, $v0, 6		# add on third index to encoded sequence
		or $s3, $s2, $s3	# join third to first two indices
		
		andi $t0, $s3, 0x0000ff00
		srl $t0, $t0, 8
		sb $t0, 0($s0)
		addi $s4, $s4, 1	# len++
		addi $s0, $s0, 1	# decoded_str++
		
		lbu $s2, 3($s1)
		beq $s2, $s5, base64_decode.loop.end		# end loop if single padded
		
		move $a0, $a2
		move $a1, $s2
		jal index_of
		or $s3, $v0, $s3	# join final index to encoded sequence
		
		andi $t0, $s3, 0x000000ff
		sb $t0, 0($s0)
		addi $s4, $s4, 1	# len++
		addi $s0, $s0, 1	# decoded_str++
		addi $s1, $s1, 4	# encoded_str += 4
		j base64_decode.loop
			
	base64_decode.loop.end:
	
	sb $0, 0($s0)		# add null term
	move $v0, $s4		# move number of chars decoded to return
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	jr $ra

bifid_get_block_count:
# $a0 = strlen
# $a1 = period
	move $t0, $a0
	li $t1, -1
	blt $a0, $a1, bifid_get_block_count.exit	# return $v0 = strlen and $v1 = -1 if period > strlen
	div $a0, $a1
	mflo $t0			# number of complete blocks in $t0
	mfhi $t1			# size of partial block in $t1
	
	bifid_get_block_count.exit:
	move $v0, $t0
	move $v1, $t1
	jr $ra

bifid_get_offset:
# $a0 = current index
# $a1 = num blocks
# $a2 = size of partial
# $a3 = period

# $v0 = offset for col index
# $v1 = amount to increment index_buffer by
	li $t2, 0
	move $t1, $a3
	bgez $a2, bifid_get_offset.period_smaller
	move $t1, $a1
	j bifid_get_offset.exit
	bifid_get_offset.period_smaller:
	blt $a0, $a3, bifid_get_offset.exit
	div $a0, $a3
	mfhi $t0
	bnez $t0, bifid_get_offset.not_first_of_block
	move $t2, $a3
	bifid_get_offset.not_first_of_block:
	mflo $t0
	
	blt $t0, $a1, bifid_get_offset.exit
	beqz $a2, bifid_get_offset.exit
	move $t1, $a2
	
	bifid_get_offset.exit:
	move $v0, $t1
	move $v1, $t2
	jr $ra

bifid_encrypt:
# $a0 = ciphertext
# $a1 = plaintext
# $a2 = key_square
# $a3 = period
# 0($sp) = index_buffer (store 8-bit integers)
# 4($sp) = block_buffer (store ASCII characters)
	li $v0, -1	# set return 1 default
	li $v1, 0	# clean return 2
	
	blez $a3, bifid_encrypt.exit	# exit with -1 if period <= 0 
	
	move $fp, $sp		# save stack ptr to frame ptr
	
	addi $sp, $sp, -36	
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $a0		# store ciphertext in $s0
	move $s1, $a1		# store plaintext in $s1
	move $s2, $a2		# store key_square in $s2
	move $s3, $a3		# store period in $s3
	
	lw $s4, 0($fp)		# store index buffer in $s4
	
	move $a0, $s1		
	jal strlen
	move $s5, $v0		# store len(plaintext) in $s5
	
	addi $sp, $sp, -8	# allocate stack space for 2 registers
	sw $s5, 0($sp)
	move $a0, $s5
	move $a1, $s3
	jal bifid_get_block_count
	move $s5, $v0
	move $s7, $v1
	move $t0, $s5
	beqz $s7, bifid_encrypt.no_partial
	li $t0, 1
	bltz $s7, bifid_encrypt.no_partial
	addi $t0, $s5, 1
	bifid_encrypt.no_partial:
	sw $t0, 4($sp)		# store block count on stack
	li $s6, 0			# i = 0
	bifid_encrypt.group:
		lbu $t0, 0($s1)		# get curr_char
		beqz $t0, bifid_encrypt.group.end
		move $a0, $s2
		move $a1, $t0
		li $a2, 9			# col number for indices_of	
		jal indices_of
		addi $sp, $sp, -8
		sw $v0, 0($sp)
		sw $v1, 4($sp)
		move $a0, $s6
		move $a1, $s5
		move $a2, $s7
		move $a3, $s3
		jal bifid_get_offset
		
		move $t0, $v0
		add $s4, $s4, $v1
		lw $v0, 0($sp)
		lw $v1, 4($sp)
		addi $sp, $sp, 8
		
		sb $v0, 0($s4)		# store row index in index_buffer
		add $t0, $s4, $t0 
		sb $v1, 0($t0)		# store col index in index_buffer
		
		addi $s1, $s1, 1	# curr_char++
		addi $s4, $s4, 1	# addr_in_index_buffer++
		addi $s6, $s6, 1	# i++
		j bifid_encrypt.group
	bifid_encrypt.group.end:
	lw $s7, 0($sp)		# load back strlen in $s7
	lw $s5, 4($sp)		# load block count in $s5
	addi $sp, $sp 8		# deallocate stack
	
	lw $t3, 4($fp)		# block buffer in $t3
	
	li $t4, 0				# i = 0 
	lw $s4, 0($fp)			# reset index buffer ptr
	li $t2, 9				# num columns
	# arr[i][j] = base + offset*[(i*(# cols) + j] : row-major
	# i = row, j = col
	bifid_encrypt.chars:
		beq $t4, $s7, bifid_encrypt.chars.end	# end loop if i = len(plaintext)
		lbu $t0, 0($s4)
		lbu $t1, 1($s4)
		mul $t0, $t0, $t2
		add $t0, $t0, $t1
		add $t0, $t0, $s2	
		lbu $t1, 0($t0)		# get key_square[$t0][$t1]
		sb $t1, 0($t3)
		addi $t3, $t3, 1	# block_buffer++
		addi $s4, $s4, 2	# index_buffer++
		addi $t4, $t4, 1	# i++
		j bifid_encrypt.chars
	bifid_encrypt.chars.end:
	
	lw $t0, 4($fp)			# reset position of block_buffer ptr
	addi $sp, $sp, -4		# allocate stack for bytecopy length arg
	move $a0, $t0			# src = block_buffer
	li $a1, 0				# src_pos = 0
	move $a2, $s0			# dest = ciphertext
	li $a3, 0				# src_pos = 0
	sw $t4, 0($sp)
	jal bytecopy
	add $s0, $s0, $v0
	sb $0, 0($s0)			# add null term
	addi $sp, $sp, 4		# deallocate stack
	move $v0, $s5			# return block count
	li $v1, 0				# clear $v1
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36
	
	bifid_encrypt.exit:
	jr $ra


bifid_decrypt:
# $a0 = plaintext
# $a1 = ciphertext
# $a2 = key_square
# $a3 = period
# 0($sp) = index_buffer (store 8-bit integers)
# 4($sp) = block_buffer (store ASCII characters)
	li $v0, -1	# set return 1 default
	li $v1, 0	# clean return 2
	
	blez $a3, bifid_decrypt.exit	# exit with -1 if period <= 0
	
	move $fp, $sp	# save stack ptr in $fp
	
	addi $sp, $sp, -36	
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $a0	# save plaintext in $s0
	move $s1, $a1	# save ciphertext in $s1
	move $s2, $a2	# save key_square in $s2
	move $s3, $a3	# save period in $s3
	
	lw $s4, 0($fp)	# open index buffer in $s4
	
	move $a0, $s1
	jal strlen
	move $s5, $v0	# store len(ciphertext) in $s5
	
	bifid_decrypt.indices:
		lbu $t0, 0($s1)			# get curr_char
		beqz $t0, bifid_decrypt.indices.end		# end loop if null term reached
		move $a0, $s2
		move $a1, $t0
		li $a2, 9
		jal indices_of
		sb $v0, 0($s4)
		sb $v1, 1($s4)
		
		addi $s1, $s1, 1		# curr_char++
		addi $s4, $s4, 2		# index_buffer++
		j bifid_decrypt.indices
	bifid_decrypt.indices.end:
	
	lw $s4, 0($fp)		# restore index_buffer ptr
	move $a0, $s5
	move $a1, $s3
	jal bifid_get_block_count
	addi $sp, $sp, -8
	sw $s0, 0($sp)		# save plaintext_addr in stack
	move $s0, $s5		# move strlen to $s0
	move $s5, $v0
	move $s7, $v1
	move $t0, $s5
	beqz $s7, bifid_decrypt.no_partial
	li $t0, 1
	bltz $s7, bifid_decrypt.no_partial
	addi $t0, $s5, 1
	bifid_decrypt.no_partial:
	sw $t0, 4($sp)		# store block count on stack
	li $s6, 0			# i = 0
	lw $s1, 4($fp)		# $s1 is block_buffer
	
	bifid_decrypt.chars:
		beq $s6, $s0, bifid_decrypt.chars.end
		move $a0, $s6
		move $a1, $s5
		move $a2, $s7
		move $a3, $s3
		jal bifid_get_offset
		li $t2, 9			# $t2 = num columns
		add $s4, $s4, $v1
		lbu $t0, 0($s4)
		add $t1, $s4, $v0
		lbu $t1, 0($t1)
		
		mul $t0, $t0, $t2
		add $t0, $t0, $t1
		add $t0, $t0, $s2
		lbu $t1, 0($t0)
		sb $t1, 0($s1)
		
		addi $s1, $s1, 1	# block_buffer++
		addi $s6, $s6, 1	# i++
		addi $s4, $s4, 1	# index_buffer++
		j bifid_decrypt.chars
	
	bifid_decrypt.chars.end:
	
	lw $s0, 0($sp)			# restore plaintext_addr in $s0
	lw $s5, 4($sp)			# restore block count in $s5
	addi $sp, $sp, 8		# deallocate stack
	
	lw $t0, 4($fp)			# reset position of block_buffer ptr
	addi $sp, $sp, -4		# allocate stack for bytecopy length arg
	move $a0, $t0			# src = block_buffer
	li $a1, 0				# src_pos = 0
	move $a2, $s0			# dest = plaintext
	li $a3, 0				# src_pos = 0
	sw $s6, 0($sp)			# len is i = (strlen)
	jal bytecopy
	add $s0, $s0, $v0
	sb $0, 0($s0)			# add null term
	addi $sp, $sp, 4		# deallocate stack
	move $v0, $s5			# return block count
	li $v1, 0				# clear $v1
	
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36
	
	bifid_decrypt.exit:
	jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
