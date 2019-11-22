# CSE 220 Programming Project #4
# Robert Ignatowicz
# rignatowicz
# 112069216

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

get_total_length:
# $a0 = packet_ptr
#
# $v0 = total_length
	lhu $v0, 0($a0)
	jr $ra

get_msg_id:
# $a0 = packet_ptr
#
# $v0 = msg_id
	lhu $v0, 2($a0)
	andi $v0, $v0, 0x00000fff
	jr $ra

get_version:
# $a0 = packet_ptr
#
# $v0 = version
	lbu $v0, 3($a0)
	andi $v0, $v0, 0x000000f0
	srl $v0, $v0, 4
	jr $ra
	
get_frag_offset:
# $a0 = packet_ptr
#
# $v0 = frag_offset
	lhu $v0, 4($a0)
	andi $v0, $v0, 0x00000fff
	jr $ra
	
get_protocol:
# $a0 = packet_ptr
#
# $v0 = protocol
	lw $v0, 4($a0)
	andi $v0, $v0, 0x003ff000
	srl $v0, $v0, 12
	jr $ra
	
get_flags:
# $a0 = packet_ptr
#
# $v0 = flags
	lbu $v0, 6($a0)
	andi $v0, $v0, 0x000000c0
	srl $v0, $v0, 6
	jr $ra
	
get_priority:
# $a0 = packet_ptr
#
# $v0 = priority
	lbu $v0, 7($a0)
	jr $ra
	
get_dest_addr:
# $a0 = packet_ptr
#
# $v0 = dest_addr
	lbu $v0, 8($a0)
	jr $ra
	
get_src_addr:
# $a0 = packet_ptr
#
# $v0 = src_addr
	lbu $v0, 9($a0)
	jr $ra

get_checksum:
# $a0 = packet_ptr
#
# $v0 = checksum
	lhu $v0, 10($a0)
	jr $ra

compute_checksum:
# $a0 = packet_ptr
# 
# $v0 = computed_checksum 
#
# checksum formula: 
# (version + msg_id + total_length + priority + flags + protocol + frag_offset + src_addr + dest_addr) mod 2^16
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $sp, $sp, -2	# allocate stack buffer
	sh $0, 0($sp)		# clear data in stack buffer
	
	jal get_total_length
	sh $v0, 0($sp)
	
	jal get_msg_id
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	sh $v0, 0($sp)
	
	jal get_version
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	sh $v0, 0($sp)
	
	jal get_frag_offset
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	sh $v0, 0($sp)
	
	jal get_protocol
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	sh $v0, 0($sp)
	
	jal get_flags
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	sh $v0, 0($sp)
	
	jal get_priority
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	sh $v0, 0($sp)
	
	jal get_dest_addr
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	sh $v0, 0($sp)
	
	jal get_src_addr
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	
	addi $sp, $sp, 2		# deallocate stack buffer
	
	li $t0, 0x00010000		
	div $v0, $t0
	mfhi $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

compare_to:
# $a0 = p1	(packet_1_ptr)
# $a1 = p2	(packet_2_ptr)
#
# $v0 = -1 if p1 < p2
#		 0 if p1 = p2
#		 1 if p1 > p2
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	jal get_msg_id			# p1.msg_id
	move $s2, $v0
	move $a0, $s1
	jal get_msg_id			# p2.msg_id
	blt $s2, $v0, compare_to.less		# less    if p1.msg_id < p2.msg_id
	bgt $s2, $v0, compare_to.greater	# greater if p1.msg_id > p2.msg_id
	
	jal get_frag_offset 	# p2.frag_offset
	move $s2, $v0
	move $a0, $s0
	jal get_frag_offset		# p1.frag_offset
	blt $v0, $s2, compare_to.less		# less	  if p1.frag_offset < p2.frag_offset
	bgt $v0, $s2, compare_to.greater	# greater if p1.frag_offset > p2.frag_offset
	
	jal get_src_addr		# p1.src_addr
	move $s2, $v0
	move $a0, $s1
	jal get_src_addr		# p2.src_addr
	blt $s2, $v0, compare_to.less		# less 	  if p1.src_addr < p2.src_addr
	bgt $s2, $v0, compare_to.greater	# greater if p1.src_addr > p2.src_addr
	j compare_to.equal					# equal   otherwise
	
	compare_to.less:
		li $v0, -1
		j compare_to.exit
	compare_to.equal:
		li $v0, 0
		j compare_to.exit
	compare_to.greater:
		li $v0, 1
		j compare_to.exit
	compare_to.exit:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra

packetize:
jr $ra

clear_queue:
jr $ra

enqueue:
jr $ra

dequeue:
jr $ra

assemble_message:
jr $ra


#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
