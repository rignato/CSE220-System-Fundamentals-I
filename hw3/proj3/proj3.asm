# CSE 220 Programming Project #3
# Robert Ignatowicz
# rignatowicz
# 112069216
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

print_struct:
# $a0 = struct_ptr
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	move $s0, $a0
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	lbu $t0, 0($s0)
	move $a0, $t0
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	lbu $t1, 1($s0)
	move $a0, $t1
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	addi $s0, $s0, 2
	
	mul $t2, $t0, $t1
	move $t0, $0
	print_struct.loop:
		beq $t0, $t2, print_struct.endloop
		
		lbu $a0, 0($s0)
		li $v0, 11
		syscall
		
		addi $t0, $t0, 1
		addi $s0, $s0, 1
		
		div $t0, $t1
		mfhi $t3
		bnez $t3, print_struct.loop
		
		li $a0, '\n'
		li $v0, 11
		syscall
		
		j print_struct.loop
	print_struct.endloop:
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

initialize:
# $a0 = state/piece addr (struct_ptr)
# $a1 = num_rows
# $a2 = num_cols
# $a3 = character
#
# $v0 = num_rows if num_rows > 0, or -1 on error
# $v1 = num_cols if num_cols > 0, or -1 on error

	li $v0, -1	# default return for $v0
	li $v1, -1	# default return for $v1
	
	blez $a1, initialize.exit	# exit with error if num_rows <= 0
	blez $a2, initialize.exit	# exit with error if num_cols <= 0
	
	sb $a1, 0($a0)	# store num_rows in byte 0 of struct
	sb $a2, 1($a0)	# store num_cols in byte 1 of struct
	
	addi $a0, $a0, 2	# increment struct_ptr by 2 bytes to create struct matrix
	mul $t1, $a1, $a2	# t1 = num_rows * num_cols
	move $t0, $0		# i = 0
	initialize.loop:
		beq $t0, $t1, initialize.endloop	# exit loop if i = $t1
		sb $a3, 0($a0)						# store character in struct matrix
		addi $t0, $t0, 1					# i++
		addi $a0, $a0, 1					# struct_ptr++
		j initialize.loop
	initialize.endloop:
	move $v0, $a1		# $v0 = num_rows
	move $v1, $a2		# $v1 = num_cols
	initialize.exit:
	jr $ra

load_game:
# $a0 = state_struct_ptr
# $a1 = filename
#
# $v0 = number of O's in file 		 		 or -1 if file doesn't exist
# $v1 = number of invalid characters in file or -1 if file doesn't exist

	li $v0, -1				# default return for $v0
	li $v1, -1				# default return for $v1
	
	addi $sp, $sp, -12		# allocate stack to save $s0-s2
	sw $s0, 0($sp)			# save $s0
	sw $s1, 4($sp)			# ...
	sw $s2, 8($sp)			# save $s2
	
	move $s0, $a0			# save state_struct_ptr in $s0
	move $s1, $a1			# save filename in $s1
	
	move $a0, $s1				# addr_of_filename_str = filename
	move $a1, $0				# flag = 0 (read-only)
								# $a2 is ignored
	li $v0, 13
	syscall						# open_file(filename, 'read-only')
	bltz $v0, load_game.exit	# exit if error on file open
	move $s2, $v0				# store curr_file in $s2
	
	addi $sp, $sp, -1		# allocate stack for temp byte
	
	li $t1, 10
	li $t2, '\n'
	li $t5, 2				# i = 2
	load_game.read_nums:
		beqz $t5, load_game.end_nums		# end loop if i = 0
		
		# read char1
		move $a0, $s2						# file_descriptor = curr_file
		move $a1, $sp						# input_buffer = stack_ptr
		li $a2, 1							# chars_to_read = 1
		li $v0, 14
		syscall								# read_file(curr_file, stack_ptr, 1)
		
		lbu $t3, 0($sp)						# load char1 read from stack
		addi $t3, $t3, -48					# get digit1 from char1
		
		# read char2
		move $a0, $s2						# file_descriptor = curr_file
		move $a1, $sp						# input_buffer = stack_ptr
		li $a2, 1							# chars_to_read = 1
		li $v0, 14
		syscall								# read_file(curr_file, stack_ptr, 1)
		
		lbu $t4, 0($sp)									# load char2 read from stack
		bne $t4, $t2, load_game.read_nums.double_digit	# jump if char2 != '\n'
		move $t4, $0									# digit0 = 0
		j load_game.read_nums.cont
		
		load_game.read_nums.double_digit:
			addi $t4, $t4, -48			# get digit0 from char2
			mul $t3, $t3, $t1			# digit1 = digit1 * 10
			
			# move read_ptr to next line
			move $a0, $s2				# file_descriptor = curr_file
			move $a1, $sp				# input_buffer = stack_ptr
			li $a2, 1					# chars_to_read = 1
			li $v0, 14
			syscall						# read_file(curr_file, stack_ptr, 1)
			
		load_game.read_nums.cont:
			add $t0, $t3, $t4			# $t0 = digit1 + digit0
			sb $t0, 0($s0)				# store num in state_struct
			addi $s0, $s0, 1			# state_struct_ptr++
			addi $t5, $t5, -1			# i--
			j load_game.read_nums
	load_game.end_nums:
	
	move $t0, $0			# num_o_chars = 0
	move $t1, $0			# num_invalid_chars = 0
	li $t2, '.'				
	li $t3, 'O' 
	li $t4, '\n'
	load_game.read_field:
		move $a0, $s2		# file_descriptor = curr_file
		move $a1, $sp		# input_buffer = stack_ptr
		li $a2, 1			# chars_to_read = 1
		li $v0, 14
		syscall						# read_file(curr_file, stack_ptr, 1)
		beqz $v0, load_game.close	# exit if EOF
		lbu $t5, 0($sp)				# load char read from stack
		
		beq $t5, $t2, load_game.read_field.valid		# valid char if '.'
		beq $t5, $t4, load_game.read_field.cont			# continue if '\n'
		beq $t5, $t3, load_game.read_field.o			# jump if 'O'
		addi $t1, $t1, 1		# num_invalid_chars++
		move $t5, $t2			# curr_char = '.'
		j load_game.read_field.valid
		
		load_game.read_field.o:
			addi $t0, $t0, 1	# num_o_chars++
		load_game.read_field.valid:
			sb $t5, 0($s0)					# store curr_char in state_struct
			addi $s0, $s0, 1				# state_struct_ptr++
		load_game.read_field.cont:
			j load_game.read_field			# continue 
	load_game.close:
	
	addi $sp, $sp, 1		# deallocate stack for temp byte
	
	move $a0, $s2			# file_descriptor = curr_file
	li $v0, 16
	syscall					# close_file(curr_file)
	
	move $v0, $t0			# $v0 = num_o_chars
	move $v1, $t1			# $v1 = num_invalid_chars
	
	load_game.exit:
	lw $s2, 8($sp)			# load $s2
	lw $s1, 4($sp)			# ... 
	lw $s0, 0($sp)			# load $s0
	addi $sp, $sp, 12		# deallocate stack
    jr $ra

get_slot:
# $a0 = struct_ptr
# $a1 = row
# $a2 = col
#
# $v0 = character located in struct_arr[row][col] or -1 on error

	li $v0, -1		# default return value
	move $v1, $0	# clear unused return
	
	# invalid row/col values errors
	bltz $a1, get_slot.exit		# error if row < 0
	bltz $a2, get_slot.exit		# error if col < 0
	lbu $t0, 0($a0)				# get num_rows in struct
	bge $a1, $t0, get_slot.exit	# error if row >= num_rows in struct
	lbu $t1, 1($a0)				# get num_cols in struct
	bge $a2, $t1, get_slot.exit	# error if col >= num_cols in struct
	
	# get index_ptr
	mul $t0, $a1, $t1			# index = row * num_cols
	add $t0, $t0, $a2			# index += col
	add $t0, $a0, $t0			# index_ptr = struct_ptr + index
	
	lbu $v0, 2($t0)				# get char at index_ptr offset by 2
	
	get_slot.exit:
    jr $ra

set_slot:
# $a0 = struct_ptr
# $a1 = row
# $a2 = col
# $a3 = character
#
# $v0 = character or -1 on error

	li $v0, -1		# default return value
	move $v1, $0	# clear unused return
	
	# invalid row/col values errors
	bltz $a1, set_slot.exit		# error if row < 0
	bltz $a2, set_slot.exit		# error if col < 0
	lbu $t0, 0($a0)				# get num_rows in struct
	bge $a1, $t0, set_slot.exit	# error if row >= num_rows in struct
	lbu $t1, 1($a0)				# get num_cols in struct
	bge $a2, $t1, set_slot.exit	# error if col >= num_cols in struct
	
	# get index_ptr
	mul $t0, $a1, $t1			# index = row * num_cols
	add $t0, $t0, $a2			# index += col
	add $t0, $a0, $t0			# index_ptr = struct_ptr + index
	
	sb $a3, 2($t0)				# store character at index_ptr
	move $v0, $a3				# return character
	
	set_slot.exit:
    jr $ra

rotate:
# $a0 = piece_ptr
# $a1 = rotations
# $a2 = rotated_piece_ptr
#
# $v0 = rotations or -1 on error (rotations < 0)

	# in order to rotate the 2D array, you have to first transpose (read in col-major order)
	# then reverse each row
	li $v0, -1				# default return
	move $v1, $0			# clear unused return
	bltz $a1, rotate.exit	# error if rotations < 0
	
	addi $sp, $sp, -40
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	sw $fp, 36($sp)
	
	move $s0, $a0			# save curr_piece_ptr in $s0
	move $s1, $a1			# save rotations in $s1
	move $s4, $s1			# save rotations in $s4
	
	li $t0, 4
	div $s1, $t0			# rotations / 4
	mfhi $s1				# save (rotations % 4) in $s1
	
	move $s2, $a2			# save rotated_piece_ptr in $s2
	
	# initialize the piece to empty piece with empty 6 byte matrix
	move $a0, $s2		# piece = rotated_piece_ptr
	li $a1, 1			# num_rows = 1
	li $a2, 6			# num_cols = 6
	li $a3, '.'			# character = '.'
	jal initialize		# initialize(curr_piece_ptr, $t0, $t1, '.')
	
	# copy curr_piece to rotated_piece
	move $t0, $0			# i = 0
	li $t1, 8				# i < 8
	move $t2, $s0			# curr_piece_ptr
	move $t3, $s2			# rotated_piece_ptr
	rotate.copy:
		beq $t0, $t1, rotate.endcopy	# end loop if i = 8
		lbu $t4, 0($t2)					# load char at curr_piece_ptr
		sb $t4, 0($t3)					# store char in rotated_piece_ptr
		addi $t2, $t2, 1				# curr_piece_ptr++
		addi $t3, $t3, 1				# rotated_piece_ptr++
		addi $t0, $t0, 1				# i++
		j rotate.copy
	rotate.endcopy:
	
	lbu $t0, 0($s0)			# get curr_rows
	lbu $t1, 1($s0)			# get curr_cols
	
	move $s0, $s2			# piece_ptr = piece_to_rotate
	mul $s2, $t0, $t1		# s2 = matrix_size = curr_rows * curr_cols
	move $s3, $0			# rotations_done = 0
	rotate.outer:
		beq $s3, $s1, rotate.endouter	# end rotation seq if rotations_done = rotations
		
		sub $fp, $sp, $s2		# allocate matrix_size bytes on stack using fp
		
		lbu $t0, 0($s0)			# $t0 = num_rows
		addi $s5, $t0, -1		# i = num_rows - 1
		move $s6, $0			# j = 0
		lbu $s7, 1($s0)			# $s7 = num_cols
		
		# j < num_cols
		rotate.get:
			bgez $s5, rotate.get.cont	# jump if i >= 0 otherwise
			lbu $t0, 0($s0)				# $t0 = num_rows
			addi $s5, $t0, -1			# i = num_rows - 1
			addi $s6, $s6, 1			# j++
			beq $s6, $s7, rotate.endget
			rotate.get.cont:
			
			move $a0, $s0			# struct_ptr = piece_to_rotate
			move $a1, $s5			# row = i
			move $a2, $s6			# col = j
			jal get_slot			# get_slot(piece_to_rotate, i, j)
			
			sb $v0, 0($fp)			# store char on stack
			addi $fp, $fp, 1		# move fp up one byte
			
			addi $s5, $s5, -1		# i--
			j rotate.get
		rotate.endget:
		
		# swap num_rows and num_cols
		lbu $t0, 0($s0)
		lbu $t1, 1($s0)
		sb $t0, 1($s0)
		sb $t1, 0($s0)
		
		sub $fp, $fp, $s2		# allocate matrix_size bytes on stack using fp
		
		move $s5, $0		# i = 0
		move $s6, $0		# j = 0
		lbu $s7, 1($s0) 	# $s7 = num_col
		rotate.set:
			mul $t0, $s5, $s7				# x = i * num_col
			add $t0, $t0, $s6				# x += j
			beq $t0, $s2, rotate.endset		# exit loop if x = matrix_size
			
			blt $s6, $s7, rotate.set.cont	# jump if j < num_col otherwise
			move $s6, $0					# j = 0
			addi $s5, $s5, 1				# i++
			rotate.set.cont:
			
			move $a0, $s0		# struct_ptr = rotated_piece
			move $a1, $s5		# row = i
			move $a2, $s6		# col = j
			lbu $a3, 0($fp)		# character = curr_char
			jal set_slot		# set_slot(rotated_piece, i, j, curr_char)
			
			addi $fp, $fp, 1	# move fp up one byte
			addi $s6, $s6, 1	# j++
			j rotate.set
		rotate.endset:
		
		addi $s3, $s3, 1		# rotations_done++
		j rotate.outer
	rotate.endouter:
	move $v0, $s4		# return original rotations
	move $v1, $0		# clear unused return
	
	lw $fp, 36($sp)
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 40
	
	rotate.exit:
    jr $ra

count_overlaps:
# $a0 = state_ptr
# $a1 = row	(of upper-leftmost block)
# $a2 = col (of upper-leftmost block)
# $a3 = piece_ptr
#
# $v0 = number of blocks that overlap with state.field or -1 on error
	
	li $v0, -1			# default return
	move $v1, $0		# clear unused return
	
	# error if either row/col < 0
	bltz $a1, count_overlaps.exit
	bltz $a2, count_overlaps.exit
	
	# allocate stack and save ra and s-registers
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s0, $a0		# s0 = state_ptr
	move $s1, $a1		# s1 = row
	move $s2, $a2		# s2 = col
	move $s3, $a3		# s3 = piece_ptr
	
	move $s4, $0		# overlaps = 0
	move $s5, $0		# offset = 0
	
	lbu $t0, 0($s3)		# piece.num_rows
	lbu $t1, 1($s3)		# piece.num_cols
	
	mul $s6, $t0, $t1	# num_rows * num_cols
	
	addi $sp, $sp, -8	# allocate stack for offset buffer
	count_overlaps.loop:
		beq $s5, $s6, count_overlaps.endloop
		
		# get char at state_ptr + offset
		lbu $t0, 1($s3)		# t0 = num_piece_cols
		div $s5, $t0		# offset / num_piece_cols
		mflo $t0			# row_offset
		mfhi $t1			# col_offset
		sw $t0, 0($sp)		# store row_offset in stack
		sw $t1, 4($sp)		# store col_offset in stack
		add $t0, $s1, $t0	# tmprow = row + row_offset
		add $t1, $s2, $t1	# tmpcol = col + col_offset
		move $a0, $s0		# struct_ptr = state_ptr
		move $a1, $t0		# row = tmprow
		move $a2, $t1		# col = tmpcol
		jal get_slot		# get_slot(state_ptr, tmprow, tmpcol)
		
		bltz $v0, count_overlaps.out_of_bounds	# out of bounds error if -1
		addi $v0, $v0, -46						# subtract '.' from char found
		beqz $v0, count_overlaps.cont			# continue loop if empty
		
		# get char at piece_ptr + offset
		move $a0, $s3		# struct_ptr = piece_ptr
		lw $a1, 0($sp)		# row = row_offset
		lw $a2, 4($sp)		# col = col_offset
		jal get_slot		# get_slot(piece_ptr, tmprow, tmpcol)
		
		bltz $v0, count_overlaps.endloop	# end loop if -1
		addi $v0, $v0, -46					# subtract '.' from char found
		beqz $v0, count_overlaps.cont		# continue loop if empty
		addi $s4, $s4, 1		# overlaps++
		
		count_overlaps.cont:
		addi $s5, $s5, 1		# offset++
		j count_overlaps.loop
		
		count_overlaps.out_of_bounds:
		li $s4, -1
	count_overlaps.endloop:
	addi $sp, $sp, 8	# deallocate stack for offset buffer
	move $v0, $s4		# return overlaps
	move $v1, $0		# clear unused return
	
	# load ra and s-registers and deallocate stack
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 32
	
	count_overlaps.exit:
	jr $ra

drop_piece:
# $a0 = state_ptr
# $a1 = col
# $a2 = piece_ptr
# $a3 = rotations
# 0($sp) = rotated_piece_ptr
#
# $v0 = row # if piece came to rest 
# 		-1    if rotated_piece cannot be dropped due to collision w/ existing blocks
#		-2 	  if col < 0 or col >= state.num_cols
#		-3	  if rotated_piece pokes out of game field (rightmost edge)

	li $v0, -2		# default return
	move $v1, $0	# clear unused return
	
	bltz $a1, drop_piece.exit		# error -2 if col < 0
	bltz $a3, drop_piece.exit		# error -2 if rotations < 0
	lbu $t0, 1($a0)					# state.num_cols
	bge $a1, $t0, drop_piece.exit	# error -2 if col >= state.num_cols
	addi $v0, $v0, -1				# -2 + -1 = -3	(error code)
	
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
	
	move $s0, $a0		# s0 = state_ptr
	move $s1, $a1		# s1 = col
	move $s2, $a2		# s2 = piece_ptr
	move $s3, $a3		# s3 = rotations
	lw $s4, 36($sp)		# s4 = rotated_piece_ptr
	move $s7, $v0
	
	move $a0, $s2		# piece_ptr
	move $a1, $s3		# rotations
	move $a2, $s4		# rotated_piece_ptr
	jal rotate			# rotate(piece_ptr, rotations, rotated_piece_ptr)
	
	# check if rotated piece is in horizontal bounds
	lbu $s5, 1($s4)		# num_cols = rotated_piece.num_cols
	move $s6, $0		# i = 0
	drop_piece.bound_check:
		beq $s6, $s5, drop_piece.end_bound_check	# end loop when i = num_cols
		
		move $a0, $s0		# struct_ptr = state_ptr
		move $a1, $0		# row  = 0
		add $a2, $s1, $s6	# col = col + i
		jal get_slot		# get_slot(state_ptr, 0, col + i)
		
		bltz $v0, drop_piece.finish		# error -3 if out of bounds
		addi $s6, $s6, 1
		j drop_piece.bound_check
	drop_piece.end_bound_check:
	
	li $s5, -1		# i = -1
	drop_piece.drop:
		# count overlaps
		move $a0, $s0		# state = state_ptr
		addi $t0, $s5, 1	# i + 1
		move $a1, $t0		# row = i + 1
		move $a2, $s1		# col = col
		move $a3, $s4		# piece = rotated_piece_ptr
		jal count_overlaps  # count_overlaps(state_ptr, i, col, rotated_piece_ptr)
		
		beqz $v0, drop_piece.dropcont	# if count_overlaps = 0, continue else
		move $s7, $s5					# set return to i
		j drop_piece.enddrop			# end loop
		drop_piece.dropcont:
			addi $s5, $s5, 1
			j drop_piece.drop
	drop_piece.enddrop:
	bltz $s7, drop_piece.finish		# error -1
	
	move $s5, $0		# offset = 0
	lbu $t0, 0($s4)		# piece.num_rows
	lbu $t1, 1($s4)		# piece.num_cols
	
	mul $s6, $t0, $t1	# num_rows * num_cols
	addi $sp, $sp, -8		# allocate stack for offset buffer
	drop_piece.fill:
		beq $s5, $s6, drop_piece.endfill
		lbu $t0, 1($s4)		# t0 = num_piece_cols
		div $s5, $t0		# offset / num_piece_cols
		mflo $a1			# row = row_offset
		mfhi $a2			# col = col_offset
		move $a0, $s4		# struct_ptr = piece_ptr
		sw $a1, 0($sp)		# store row_offset in stack
		sw $a2, 4($sp)		# store col_offset in stack
		jal get_slot		# get_slot(piece_ptr, row_offset, col_offset)
		
		addi $v0, $v0, -46	# subtract '.' from char
		beqz $v0, drop_piece.fillcont	# continue if empty
		
		move $a0, $s0		# struct_ptr = state_ptr
		lw $t0, 0($sp)		# load row_offset
		lw $t1, 4($sp)		# load col_offset
		add $a1, $s7, $t0	# row = row + row_offset
		add $a2, $s1, $t1	# col = col + col_offset
		li $a3, 'O'
		jal set_slot		# set_slot(state_ptr, row+row_offset, col+col_offset)
		
		drop_piece.fillcont:
		addi $s5, $s5, 1	# offset++
		j drop_piece.fill	# continue loop
	drop_piece.endfill:
	addi $sp, $sp, 8		# deallocate stack for offset buffer
	
	drop_piece.finish:
	move $v0, $s7		# load return
	move $v1, $0		# clear unused return
	
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	
	addi $sp, $sp, 36
	
	drop_piece.exit:
	jr $ra

check_row_clear:
# $a0 = state_ptr
# $a1 = row
#
# $v0 = -1 if row is invalid
#	 	 0 if cannot clear row
#        1 if can clear row
	
	li $v0, -1		# default return
	move $v1, $0	# clear unused return
	
	bltz $a1, check_row_clear.exit		# error if row < 0
	lbu $t0, 0($a0)						# num_rows
	bge $a1, $t0, check_row_clear.exit	# error if row >= num_rows
	
	move $v0, $0	# set return to 0
	
	# allocate stack for ra and s-registers
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s6, $v0		# store return
	
	move $s0, $a0		# s0 = state_ptr
	move $s1, $a1		# s1 = row
	
	lbu $s2, 1($s0)	
	addi $s2, $s2, -1	# i = num_cols - 1
	
	# check if row can be cleared
	check_row_clear.check:
		bltz $s2, check_row_clear.endcheck	# while i >= 0
		
		move $a0, $s0	# struct_ptr = state_ptr
		move $a1, $s1	# row = row
		move $a2, $s2	# col = i
		jal get_slot	# get_slot(state_ptr, row, i)
		
		addi $v0, $v0, -79					# subtract 'O' from char found
		bnez $v0, check_row_clear.finish	# row cannot be cleared because there is non-'O' char
		
		addi $s2, $s2, -1	# i--
		j check_row_clear.check
	check_row_clear.endcheck:
	
	addi $s6, $s6, 1		# return = 1
	addi $sp, $sp, -4		# 4 byte buffer
	move $s2, $0			# i = 0
	move $s3, $0			# j = 0
	li $s4, '.'				# buffer char is initially '.'
	sw $s4, 0($sp)			# store buffer_char
	lbu $s5, 1($s0)			# num_cols
	check_row_clear.clear:
		beq $s3, $s4, check_row_clear.endclear			# end loop if j = num_cols
		move $a0, $s0		# struct_ptr = state_ptr
		move $a1, $s2		# row = i
		move $a2, $s3		# col = j
		jal get_slot		# get_slot(state_ptr, i, j)
		bltz $v0, check_row_clear.endclear
		
		move $a0, $s0		# struct_ptr = state_ptr
		move $a1, $s2		# row = i
		move $a2, $s3		# col = j
		lw $a3, 0($sp)		# load char from buffer
		sw $v0, 0($sp)		# store current char in buffer
		jal set_slot		# set_slot(state_ptr, i, j, buffer_char)
		
		addi $s2, $s2, 1	# i++
		
		ble $s2, $s1, check_row_clear.clear		# if i <= row, loop, otherwise
		move $s2, $0							# i = 0
		addi $s3, $s3, 1						# j++
		sw $s4, 0($sp)							# load buffer_char to '.'
		
		j check_row_clear.clear
	check_row_clear.endclear:
	addi $sp, $sp, 4	# deallocate buffer
	check_row_clear.finish:
	move $v0, $s6		# load return
	move $v1, $0		# clear unused return
	
	# deallocate stack for s-registers and ra, load return
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 32
	
	check_row_clear.exit:
	jr $ra
	
strlen:
# $a0 = str (str_addr)
# 
# $v0 = length of str (not including '\0')
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
	
simulate_game:
# $a0 = state_ptr
# $a1 = filename
# $a2 = moves
# $a3 = rotated_piece
# 0($sp) = num_pieces_to_drop
# 4($sp) = pieces_array
#
# $v0 = number of pieces successfully dropped into game field
# $v1 = final score
	
	addi $sp, $sp, -40
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	sw $fp, 36($sp)
	
	addi $fp, $sp, 40	# set fp to previous sp
	
	move $s0, $a0	# s0 = state_ptr
	move $s1, $a1	# s1 = filename
	move $s2, $a2	# s2 = moves
	move $s3, $a3	# s3 = rotated_piece
	
	move $s4, $0	# num_successful_drops = 0
	move $s5, $0	# score = 0
	
	# check if filename is valid
	move $a0, $s0	# state_ptr
	move $a1, $s1	# filename
	jal load_game  	# load_game(state_ptr, filename)

	bltz $v0, simulate_game.exit	# exit if invalid filename
	
	move $s1, $0	# s1 = game_over = 0 (false)
	move $s6, $0	# move_number = 0
	
	move $a0, $s2	# str = moves
	jal strlen		# strlen(moves)
	li $t0, 4		
	div $v0, $t0	# len(moves) / 4
	mflo $s7		# moves_length
	
	simulate_game.loop:
		bnez $s1, simulate_game.endloop		# exit if game_over = 1 (true)
		lw $t0, 0($fp)						# num_pieces_to_drop
		beq $s4, $t0, simulate_game.endloop	# exit if num_successful_drops = num_pieces_to_drop
		beq $s6, $s7, simulate_game.endloop	# exit if move_number = moves_length
		
		lbu $t0, 0($s2)		# get piece_type
		lbu $t1, 1($s2)		# get rotation
		addi $t1, $t1, -48	# get numerical rotation
		# get col
		lbu $t2, 2($s2)		# digit1 of col
		addi $t2, $t2, -48	# get numerical digit1
		li $t3, 10
		mul $t2, $t2, $t3	# digit1 *= 10
		lbu $t3, 3($s2)		# digit0 of col
		addi $t3, $t3, -48	# get numerical digit0
		add $t2, $t2 $t3	# col = digit1 + digit0
		
		lw $t4, 4($fp)			# get pieces_array[0]
		
		li $t3, 'T'
		beq $t0, $t3, simulate_game.t_piece
		li $t3, 'J'
		beq $t0, $t3, simulate_game.j_piece
		li $t3, 'Z'
		beq $t0, $t3, simulate_game.z_piece
		li $t3, 'O'
		beq $t0, $t3, simulate_game.o_piece
		li $t3, 'S'
		beq $t0, $t3, simulate_game.s_piece
		li $t3, 'L'
		beq $t0, $t3, simulate_game.l_piece
		li $t3, 'I'
		beq $t0, $t3, simulate_game.i_piece
		j simulate_game.cont	# cont if invalid piece
		simulate_game.i_piece:
			addi $t4, $t4, 8	# pieces_array[6]
		simulate_game.l_piece:
			addi $t4, $t4, 8	# pieces_array[5]
		simulate_game.s_piece:
			addi $t4, $t4, 8	# pieces_array[4]
		simulate_game.o_piece:
			addi $t4, $t4, 8	# pieces_array[3]
		simulate_game.z_piece:
			addi $t4, $t4, 8	# pieces_array[2]
		simulate_game.j_piece:
			addi $t4, $t4, 8	# pieces_array[1]
		simulate_game.t_piece:
		
		move $a0, $s0	# state_ptr
		move $a1, $t2	# col
		move $a2, $t4	# piece
		move $a3, $t1	# rotation
		
		addi $sp, $sp, -4	# allocate arg4 on stack (rotated_piece)
		sw $s3, 0($sp)		# rotated_piece
		jal drop_piece		# drop_piece(state, col, piece, rotation, rotated_piece)
		addi $sp, $sp, 4	# deallocate stack for arg4
		
		li $t0, -2
		ble $v0, $t0, simulate_game.cont	# error -2 or -3
		li $t0, -1
		bgt $v0, $t0, no_game_over			# error -1
		li $s1, 1							# game_over = 1 (true)
		j simulate_game.cont				# continue (end loop since game_over = 1)
		no_game_over:
		
		move $t0, $0			# count = 0
		lbu $t1, 0($s0)			# state.num_rows
		addi $t1, $t1, -1		# r = state.num_rows - 1
		addi $sp, $sp, -8		# allocate 8 byte buffer
		sw $t0, 0($sp)			# store count 
		sw $t1, 4($sp)			# store r
		simulate_game.rowcheck:
			lw $t0, 4($sp)		# load r
			bltz $t0, simulate_game.endcheck	# exit if r < 0
			
			move $a0, $s0		# state_ptr
			move $a1, $t0		# row = r
			jal check_row_clear # check_row_clear(state, r)
			bgtz $v0, simulate_game.row_cleared	# jump if row cleared else
			lw $t0, 4($sp)
			addi $t0, $t0, -1
			sw $t0, 4($sp)		# r--
			j simulate_game.rowcheck
			
			simulate_game.row_cleared:
			lw $t0, 0($sp)
			addi $t0, $t0, 1	# count++
			sw $t0, 0($sp)
			j simulate_game.rowcheck
		simulate_game.endcheck:
		lw $t0, 0($sp)
		addi $sp, $sp, 8
		li $t1, 1
		beq $t0, $t1, simulate_game.1_count		# jump if count = 1 else
		addi $t1, $t1, 1
		beq $t0, $t1, simulate_game.2_count		# jump if count = 2 else
		addi $t1, $t1, 1
		beq $t0, $t1, simulate_game.3_count		# jump if count = 3 else
		addi $t1, $t1, 1
		beq $t0, $t1, simulate_game.4_count		# jump if count = 4
		j simulate_game.0_count
		
		simulate_game.1_count:
			addi $s5, $s5, 40		# score += 40
			j simulate_game.0_count
		simulate_game.2_count:
			addi $s5, $s5, 100		# score += 100
			j simulate_game.0_count
		simulate_game.3_count:
			addi $s5, $s5, 300		# score += 300
			j simulate_game.0_count
		simulate_game.4_count:
			addi $s5, $s5, 1200		# score += 1200
		simulate_game.0_count:
		
		addi $s4, $s4, 1		# num_successful_drops++
		
		simulate_game.cont:
			addi $s6, $s6, 1	# move_number++
			addi $s2, $s2, 4	# moves_ptr += 4
			j simulate_game.loop
	simulate_game.endloop:
	
	simulate_game.exit:
	move $v0, $s4		# return num_successful_drops
	move $v1, $s5		# return score
	
	lw $fp, 36($sp)
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 40
	
	jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
