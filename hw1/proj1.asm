# Name:		 Robert Ignatowicz
# NetID: 	 rignatowicz
# ID Number: 112069216

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
royal_flush_str: .asciiz "ROYAL_FLUSH\n"
straight_flush_str: .asciiz "STRAIGHT_FLUSH\n"
four_of_a_kind_str: .asciiz "FOUR_OF_A_KIND\n"
full_house_str: .asciiz "FULL_HOUSE\n"
simple_flush_str: .asciiz "SIMPLE_FLUSH\n"
simple_straight_str: .asciiz "SIMPLE_STRAIGHT\n"
high_card_str: .asciiz "HIGH_CARD\n"

zero_str: .asciiz "ZERO\n"
neg_infinity_str: .asciiz "-INF\n"
pos_infinity_str: .asciiz "+INF\n"
NaN_str: .asciiz "NAN\n"
floating_point_str: .asciiz "_2*2^"

# Put your additional .data declarations here, if any.
valid_first_args_list: .byte 'F', 'M', 'P'
r_type_format: .byte 6, 5, 5, 5, 5, 6
r_type_masks: .word 0xfc000000, 0x03e00000, 0x001f0000, 0x0000f800, 0x000007c0, 0x0000003f
r_type_given: .byte 0, 0, 0, 0, 0, 0

ieee_format: .byte 1, 5, 10
ieee_masks: .word 0x8000, 0x7c00, 0x03ff
ieee_given: .word 0, 0, 0

binary_str: .ascii ""

poker_values: .byte '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A' 
poker_suits: .byte 'S', 'C', 'H', 'D'
values_given: .byte 0, 0, 0, 0, 0
suits_given: .byte 0, 0, 0, 0, 0

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
	j arg_check

arg_check:
	la $s0, valid_first_args_list	# $s0 stores address of valid arg list
	li $s1, 0						# valid_arg_found (stored in $s1) = 0
	lw $s2, addr_arg0				# $s2 stores address of addr_arg0
	li $t2, 0						# i = 0
	li $t3, 1						# max number of chars
	j first_arg_check
	second_arg_check:
		li $t0, 2					# Required number of args is stored in $t0
		lw $t1, num_args 			# Store value of num_args in $t1
		bne $t0, $t1, invalid_args 	# Jump to invalid_args if num_args != 2
	j valid_args

first_arg_check:
	lbu $t0, 0($s2)					# $t0 has current char in arg
	bnez $t2 end_first_arg_check
	li $t4, 0						# j = 0
	li $t5, 2						# for j < 2
	arg_check_inner_loop:
		bgt $t4, $t5, end_first_arg_check		# leave loop if j ($t4) > 2 ($t5)
		lbu $t1, 0($s0)							# get current char in valid arg list
		check_arg:
			beq $t0, $t1, valid_arg_found
		bnez $s1, check_arg						# if boolean isn't true, check if arg is valid
		addi $s0, $s0, 1						# increment byte for valid arg list address ($s0)
		addi $t4, $t4, 1						# j++
		j arg_check_inner_loop					# continue loop
	valid_arg_found: 
		move $s1, $t0			# valid_arg_found = current char
	addi, $t2, $t2, 1			# i++
	addi, $s2, $s2, 1			# move to next character in arg
	j first_arg_check
	end_first_arg_check:
		bnez $t0, invalid_op	# invalid op if current char not ascii 0, meaning there's more than one char
		beqz $s1, invalid_op	# invalid op if char not in valid arg list
		j second_arg_check

strlen:
	move $s0, $a0	# load the arg string address into $s0
	li $t0, 0		# strlen = 0
	while_strlen:
		lbu $t1, 0($s0) 			# i = current string char
		beqz $t1, end_strlen_loop	# end loop if null terminator reached
		addi $t0, $t0, 1 			# strlen++
		addi $s0, $s0, 1			# increment byte for i
		j while_strlen
	end_strlen_loop:
		move $v0, $t0
		jr $ra

convert_hexstr_to_int:
	move $t9, $a0	# save the hexstr arg address to $t9 before strlen call
	move $t8, $ra	# save the return address before strlen call
	jal strlen		# get len of hexstr
	move $s0, $t9	# load the hexstr arg address into $s0
	move $ra, $t8	# load return address 
	
	li $t0, 1		# i = 1
	move $t1, $v0	# i <= len_hexstr
	li $t4, 10		# if ascii code - 48 > 10, its a letter
	li $t5, 4		# number of bits in a nibble
	li $t9, 15		# max hex number 
	li $v0, 0		# the resulting int is stored in $v0
	hexstr_conv_loop:
		bgt $t0, $t1, end_hexstr_conv	# end loop if i = len_hexstr
		lbu $t3, 0($s0)					# get current char ($t3)
		addi $t3, $t3, -48				# subtract 48 to get num from ascii code
		bltz $t3, invalid_args			# invalid_args if hex_num < 0
		blt $t3, $t4, is_num			# jump to is_num if its a number
		addi $t3, $t3, -7				# otherwise subtract 7 to get the decimal from hex letter
		bgt $t3, $t9, invalid_args		# invalid_args if hex_num > max_hex_number
		
		is_num:
		sub $t2, $t1, $t0				# number of bytes to shift ($t2) = len_hexstr ($t1) - i ($t0)
		mult $t2, $t5					# convert nibbles to bits
		mflo $t2						# move multiplication result to $t2
		
		sllv $t3, $t3, $t2 				# shift by number of bits to shift
		or $v0, $v0, $t3				# add the number to result
		addi $s0, $s0, 1				# char++
		addi $t0, $t0, 1				# i++
		j hexstr_conv_loop
		
	end_hexstr_conv:
		li $t4, 0	 # clear temp register
		jr $ra
		

valid_args:
	la $s0, valid_first_args_list		# $s0 stores address of valid arg list
	lbu $t0, 0($s0)						# store first byte of valid arg list
	beq $s1, $t0, parse_hex_as_ieee 	# jump to parsing hex -> iee if 'F'
	addi, $s0, $s0, 1 					# increment byte
	lbu $t0, 0($s0)						# store next byte of valid arg list
	beq $s1, $t0, parse_r_type 			# jump to parsing hex -> r_type if 'M'
	j parse_poker

get_index:
	# list address in $a0
	# list length in $a1
	# item in $a2
	# offset in $a3
	move $t7, $a0			# store address of list in $t7
	li $t8, 0				# i = 0
	li $v0, -1				# return index is -1 by default
	while_list_check:
		beq $t8, $a1, end_list_check		# end loop if i = len(list)
		lbu $t9, 0($t7)						# load current elem in list
		beq $a2, $t9, found_in_list			# jump if found in list
		addi $t8, $t8, 1					# i++
		add $t7, $t7, $a3					# increment list by offset
		j while_list_check
		found_in_list:	
			move $v0, $t8					# return index found in list
			j end_list_check
	end_list_check:
		jr $ra

get_lowest_card:
	la $s0, values_given
	li $t0, 0				# i = 0
	li $t1, 5				# i < 5
	li $v0, 14				# $v0 = lowest card (initialized to 14 since 13 is highest value so cards must be < 14)
	while_low_card:
		beq $t0, $t1, end_low_card	# end loop if i = 5
		lbu $t2, 0($s0)				# load current card value
		bge $t2, $v0, not_lower		# jump if greater than low card
		move $v0, $t2				# set low card to current
		not_lower:
		addi $t0, $t0, 1			# i++
		addi $s0, $s0, 1			# increment byte for values_given
		j while_low_card 
	end_low_card:
		jr $ra

parse_poker:
	lw $s0, addr_arg1		# load arg1 address in $s0
	la $s1, values_given	# load values_given address in $s1
	la $s2, suits_given 	# load suits_given address in $s2
	li $t0, 0				# i = 0
	li $t1, 5				# i < 5	
	
	save_card_loop:
		beq $t0, $t1, end_save_card # end loop if i = 5
		lbu $t2, 0($s0)				# load current value
		
		la $a0, poker_values		# move poker_values list to $a0
		li $a1, 13					# number of cards in suit
		move $a2, $t2		 		# move current value to arg2
		li $a3, 1					# set offset to 1 byte
		jal get_index				# validate value
		bltz $v0, invalid_args		# invalid_args if invalid value
		sb $v0, 0($s1)				# save value to values_given
		
		lbu $t3, 1($s0)				# load current suit
		la $a0, poker_suits			# move poker_suits list to $a0
		li $a1, 4					# number of suits in deck
		move $a2, $t3		 		# move current suit to arg2
		jal get_index				# validate suit
		bltz $v0, invalid_args		# invalid_args if invalid suit
		sb $t3, 0($s2)				# save suit to suits_given
		
		addi $t0, $t0, 1			# i++
		addi $s0, $s0, 2			# increment char in arg by 2
		addi $s1, $s1, 1			# increment byte for values_given
		addi $s2, $s2, 1			# increment byte for suits_given
		
		j save_card_loop
		
	end_save_card:
		li $s0, 1					# $s0 boolean for straight
		li $s1, 1					# $s1 boolean for flush
		li $s2, 8					# $s2 is highest possible value for low card (10)
		
		jal get_lowest_card			# get lowest card value in hand
		move $t0, $v0				# move lowest value to $t0
		move $s3, $t0				# save lowest value in $s3 as well
		bgt $t0, $s2, no_straight	# skip straight check if lowest card is greater than 10
		addi $t1, $t0, 4			# add 4 to lowest value 
		
		la $a0, values_given		# store list address arg for values
		li $a1, 5					# store list length arg
		li $a3, 1					# store list offset arg
		
		j check_straight			# start straight check
		
		no_straight:
			li $s0, 0					# set straight bool to false 
			j end_straight				# end straight check
		check_straight:
			addi $t0, $t0, 1			# i++
			bgt $t0, $t1, end_straight 	# end loop if i > low_card_val+4
			move $a2, $t0				# move current card value to arg2 
			jal get_index				# check if its in the hand
			bltz $v0, no_straight		# if the next consecutive number isn't in the hand, isn't a straight
			j check_straight			# continue loop
		end_straight:
		
		li $t0, 1			# i = 1
		li $t1, 5			# i < 5
		la $t2, suits_given # load suits in hand ($t2)
		lbu $t3, 0($t2)		# load current suit	($t3)
		addi $t2, $t2, 1	# increment current suit
		
		j check_flush		# start flush check
		
		no_flush:
			li $s1, 0					# set flush bool to false
			j end_flush					# end flush check
		check_flush:
			beq $t0, $t1, end_flush 	# end loop if i = 5
			lbu $t4, 0($t2)				# load next suit
			bne $t3, $t4, no_flush		# not flush if next suit isn't equal
			addi $t0, $t0, 1			# i++
			addi $t2, $t2, 1			# increment byte in suits_given
			j check_flush
		end_flush:
		
		bnez $s0, straight	# jump if straight
		bnez $s1, flush		# jump if flush
		j other_hand
		
		straight:
			bnez $s1, straight_flush
			la $a0, simple_straight_str
			j hand_label_loaded
		flush:
			la $a0, simple_flush_str
			j hand_label_loaded
		straight_flush:
			beq $s3, $s2, royal_flush
			la $a0, straight_flush_str
			j hand_label_loaded
		royal_flush:
			la $a0, royal_flush_str
			j hand_label_loaded
		
		other_hand:
		la $s0, values_given
		lbu $s1, 0($s0)		# value of first card
		lbu $s2, 1($s0)		# value of second card
		li $t0, 2 			# i = 2
		addi $s0, $s0, 2	# increment current card by 2
		li $t1, 5			# i < 5
		li $t2, 1			# card 1 count
		li $t3, 0			# card 2 count
		bne $s1, $s2, add_card2_count
		add_card1_count:
			addi $t2, $t2, 1				# card_1_count++
			j check_other
		add_card2_count:
			addi $t3, $t3, 1				# card_2_count++
			j check_other
		check_other:
			beq $t0, $t1, end_check_other	# end loop if i = 5
			lbu $t4, 0($s0) 				# load current card
			addi $t0, $t0, 1				# i++
			addi $s0, $s0, 1				# increment byte in values_given
			beq $t4, $s1, add_card1_count	# add to card 1 count if card = card 1
			beq $t4, $s2, add_card2_count	# add to card 2 count if card = card 2
			j check_other
		end_check_other:
		
		add $t0, $t2, $t3				# add card 1 count + card 2 count
		bne $t0, $t1, high_card			# if not 5, then high card
		li $t0, 3
		beq $t2, $t0, full_house		# if card 1 count = 3, then full house
		beq $t3, $t0, full_house		# or card 2 count = 3
										# otherwise four of a kind
		four_of_a_kind:
			la $a0, four_of_a_kind_str
			j hand_label_loaded
		full_house:
			la $a0, full_house_str
			j hand_label_loaded
		high_card:
			la $a0, high_card_str
			j hand_label_loaded
		
		hand_label_loaded:
			li $v0, 4					
			syscall 		# print the poker hand found
			j exit			
		
convert_int_to_binary:
	move $s0, $a0		# move int arg to $s0
	move $s1, $a1		# move n-bit size arg to $s1
	la $s2, binary_str	# load binary string holder address for result
	li $t0, 0			# ($t0) i = 0
	 
	move $t2, $a1		# $t2 = num bits to shift (will decrement)
	
	while_int_binary:
		beq $t0, $s1, end_int_binary	# end loop if i = n
		li $t3, 0						# init tmp
		li $t1, 1						# init mask
		addi $t2, $t2, -1				# num_bits_to_shift--
		sllv $t1, $t1, $t2 				# shift mask left
		and $t3, $s0, $t1				# AND int and mask, store in tmp
		srlv $t3, $t3, $t2				# shift result right
		addi $t3, $t3, 48				# increment by 48 to get ascii char
		
		sb $t3, 0($s2)					# store current bit char in string
		
		addi $t0, $t0, 1				# i++
		addi $s2, $s2, 1				# increment current char 
		
		j while_int_binary
		
	end_int_binary:
		sb $zero, 0($s2)				# add null terminator to string
		la $v0, binary_str				# load address of binary_str in result
		jr $ra							# return

parse_hex_as_ieee:
	lw $a0, addr_arg1
	jal convert_hexstr_to_int
	move $t0, $v0		# store int version of hexstr in $t0
	la $s0, ieee_given
	la $s1, ieee_format
	la $s2, ieee_masks
	
	li $t1, 0			# ($1) i = 0
	li $t2, 3			# i < 3
	li $t3, 16			# number of bits to shift (will decrement)
	
	while_hex_ieee:
		li $t4, 0					# clear temp register for storing result
		beq $t1, $t2, end_hex_ieee	# end loop if ($1) i = ($t2) 3
		lbu $t5, 0($s1)				# load current number of bits in $t5
		lw $t6, 0($s2)				# load current mask in $t6
		sub $t3, $t3, $t5			# decrement number of bits to shift by current bit space
		and $t4, $t0, $t6			# store AND of hex_int and mask in $t4
		srlv $t4, $t4, $t3			# shift right by num bits to shift
		sw $t4, 0($s0)				# store the result in ieee_given
		
		addi $s0, $s0, 4			# increment 4 bytes for ieee_given
		addi $s1, $s1, 1			# increment byte for ieee_format
		addi $s2, $s2, 4			# increment 4 bytes for ieee_masks
		addi $t1, $t1, 1			# i++
		
		j while_hex_ieee
		
	end_hex_ieee:
		j print_ieee
		
print_ieee:
	# Special Values
	#
	# +zero:  s = 0, e = 000...0, f = 000...0
	# -zero:  s = 1, e = 000...0, f = 000...0
	#
	# +inf:   s = 0, e = 111...1, f = 000...0
	# -inf:   s = 1, e = 111...1, f = 000...0
	#
	# NaN:	  s = 0 or 1, e = 111...1, f = non-zero
	
	la $s0, ieee_given
	
	lw $s1, 0($s0)		# load sign bit value
	lw $s2, 4($s0)		# load exponent value
	lw $s3, 8($s0)		# load fraction value
	li $s4, 15			# we are in excess-15
	
	add $t0, $s2, $s3	 	# add exponent and fraction, save to $t0
	beqz $t0, is_zero		# jump to is_zero if $t0 = 0
	sub $s2, $s2, $s4		# get exponent in excess-15
	bgt $s2, $s4, is_NaN	# jump to is_NaN if exponent > 15
	
	j is_not_special		# otherwise jump to is_not_special
	
	is_zero:
		la $a0, zero_str
		li $v0, 4
		syscall					# print zero_str
		j exit
		
	is_NaN:
		beqz $s3, is_inf		# if fraction = 0, jump to is_inf
		la $a0, NaN_str
		li $v0, 4
		syscall					# print NaN_str
		j exit
		
	is_inf:
		bnez $s1, is_neg_inf		# if sign bit = 1, jump to is_neg_inf
		la $a0, pos_infinity_str	
		li $v0, 4
		syscall						# print pos_infinity_str
		j exit
		
	is_neg_inf:
		la $a0, neg_infinity_str
		li $v0, 4
		syscall						# print neg_infinity_str
		j exit
		
	is_not_special:
		li $v0, 11
		beqz $s1, is_not_negative	# if sign bit = 0, jump to is_not_negative
		li $a0, '-'	
		syscall						# otherwise print '-'
		is_not_negative:
			li $a0, '1'				
			syscall	
			li $a0, '.'
			syscall						# print '1.'
			
			move $a0, $s3				# move fraction to arg0
			li $a1, 10					# arg1 = 10 for 10-bit
			move $t9, $s2 				# save exponent value to $t0 before function call
			jal convert_int_to_binary	# convert fraction to binary string
			move $s2, $t9				# bring back exponent value to $s2
			
			move $a0, $v0
			li $v0, 4
			syscall						# print binary fraction
			
			la $a0, floating_point_str
			syscall						# print floating_point_str
			
			move $a0, $s2
			li $v0, 1
			syscall						# print exponent
			
			li $a0, '\n'
			li $v0, 11
			syscall						# print newline
			
		j exit
	
parse_r_type:
	lw $a0, addr_arg1
	jal convert_hexstr_to_int
	move $t0, $v0		# store int version of hexstr in $t0
	la $s0, r_type_given
	la $s1, r_type_format	
	la $s2, r_type_masks	
	
	li $t1, 0			# ($t1) i = 0
	li $t2, 6			# i < 6
	li $t3, 32			# number of bits to shift (will decrement)
	li $t9, 1			# validate op code on 1 to save time
	validate_op_code:
		bnez $t4, invalid_args		# invalid_args if opcode != 0
		beq $t1, $t9, validated		# jump back to loop if valid
	while_r_type:
		li $t4, 0						# clear temp register for storing result
		beq $t1, $t2, end_r_type		# end loop if ($t1) i = ($t2) 6 
		lbu $t5, 0($s1)					# load the number of bits for current format in $t5
		lw $t6, 0($s2)					# load the mask for current format in $t6
		sub $t3, $t3, $t5				# decrement number of bits by current format in list
		and $t4, $t6, $t0				# store the AND of mask and hex_int in $t4
		srlv $t4, $t4, $t3				# shift right by num bits to shift
		sb $t4, 0($s0)					# store this value in r_type_given list
		addi $s0, $s0, 1				# increment byte for r_type_given
		addi $s1, $s1, 1				# increment byte for r_type_format
		addi $s2, $s2, 4				# increment 4 bytes for r_type_masks
		addi $t1, $t1, 1				# i++
		beq $t1, $t9, validate_op_code	# if i = 1 make sure opcode is 0
		
		validated:
		move $a0, $t4		# print the number 
		li $v0, 1
		syscall
		
		li $a0, ' '			# print space
		li $v0, 11
		syscall 
		
		j while_r_type
		
	end_r_type:
		li $a0, '\n'		# print newline
		li $v0, 11
		syscall
		
		j exit

invalid_op:
	la $a0, invalid_operation_error
	li $v0, 4
	syscall
	j exit
	
invalid_args:
	la $a0, invalid_args_error
	li $v0, 4
	syscall
	j exit

exit:
    li $v0, 10   # terminate program
    syscall
