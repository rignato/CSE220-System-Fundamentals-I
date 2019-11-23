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
	
set_total_length:
# $a0 = packet_ptr
# $a1 = new_total_length
	sh $a1, 0($a0)
	jr $ra

get_msg_id:
# $a0 = packet_ptr
#
# $v0 = msg_id
	lhu $v0, 2($a0)
	andi $v0, $v0, 0x00000fff
	jr $ra

set_msg_id:
# $a0 = packet_ptr
# $a1 = new_msg_id
	lhu $t0, 2($a0)
	andi $t0, $t0, 0x0000f000
	or $t0, $t0, $a1
	sh $t0, 2($a0)
	jr $ra

get_version:
# $a0 = packet_ptr
#
# $v0 = version
	lbu $v0, 3($a0)
	andi $v0, $v0, 0x000000f0
	srl $v0, $v0, 4
	jr $ra
	
set_version:
# $a0 = packet_ptr
# $a1 = new_version
	lbu $t0, 3($a0)
	andi $t0, $t0, 0x0000000f
	sll $t1, $a1, 4
	or $t0, $t0, $t1
	sb $t0, 3($a0)
	jr $ra
	
get_frag_offset:
# $a0 = packet_ptr
#
# $v0 = frag_offset
	lhu $v0, 4($a0)
	andi $v0, $v0, 0x00000fff
	jr $ra

set_frag_offset:
# $a0 = packet_ptr
# $a1 = new_frag_offset
	lhu $t0, 4($a0)
	andi $t0, $t0, 0x0000f000
	or $t0, $t0, $a1
	sh $t0, 4($a0)
	jr $ra

get_protocol:
# $a0 = packet_ptr
#
# $v0 = protocol
	lw $v0, 4($a0)
	andi $v0, $v0, 0x003ff000
	srl $v0, $v0, 12
	jr $ra
	
set_protocol:
# $a0 = packet_ptr
# $a1 = new_protocol
	lw $t0, 4($a0)
	andi $t0, $t0, 0xffc00fff
	sll $t1, $a1, 12
	or $t0, $t0, $t1
	sw $t0, 4($a0)
	jr $ra
	
get_flags:
# $a0 = packet_ptr
#
# $v0 = flags
	lbu $v0, 6($a0)
	andi $v0, $v0, 0x000000c0
	srl $v0, $v0, 6
	jr $ra

set_flags:
# $a0 = packet_ptr
# $a1 = new_flags
	lbu $t0, 6($a0)
	andi $t0, $t0, 0x0000003f
	sll $t1, $a1, 6
	or $t0, $t0, $t1
	sb $t0, 6($a0)
	jr $ra

get_priority:
# $a0 = packet_ptr
#
# $v0 = priority
	lbu $v0, 7($a0)
	jr $ra

set_priority:
# $a0 = packet_ptr
# $a1 = new_priority
	sb $a1, 7($a0)
	jr $ra

get_src_addr:
# $a0 = packet_ptr
#
# $v0 = src_addr
	lbu $v0, 8($a0)
	jr $ra

set_src_addr:
# $a0 = packet_ptr
# $a1 = new_src_addr
	sb $a1, 8($a0)
	jr $ra

get_dest_addr:
# $a0 = packet_ptr
#
# $v0 = dest_addr
	lbu $v0, 9($a0)
	jr $ra
	
set_dest_addr:
# $a0 = packet_ptr
# $a1 = new_dest_addr
	sb $a1, 9($a0)
	jr $ra

get_checksum:
# $a0 = packet_ptr
#
# $v0 = checksum
	lhu $v0, 10($a0)
	jr $ra

set_checksum:
# $a0 = packet_ptr
# $a1 = new_checksum
	sh $a1, 10($a0)
	jr $ra

print_payload:
# $a0 = packet_ptr
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal get_total_length
	addi $t2, $a0, 12
	move $t1, $v0
	li $t0, 12
	print_payload.loop:
		beq $t0, $t1, print_payload.endloop
		lbu $a0, 0($t2)
		li $v0, 11
		syscall
		addi $t0, $t0, 1
		addi $t2, $t2, 1
		j print_payload.loop
	print_payload.endloop:
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

print_packet:
# $a0 = packet_ptr
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	move $s0, $a0
	
	jal get_version
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_msg_id
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_total_length
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_priority
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_flags
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_protocol
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_frag_offset
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_checksum
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_src_addr
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal get_dest_addr
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $a0, '\n'	
	li $v0, 11
	syscall
	
	move $a0, $s0
	jal print_payload
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
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
	
	jal get_src_addr
	lhu $t0, 0($sp)
	add $v0, $v0, $t0
	sh $v0, 0($sp)
	
	jal get_dest_addr
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
# $a0 = byte[] packet_date
# $a1 = string msg
# $a2 = int payload_size
# $a3 = int version
# 0($sp) = int msg_id
# 4($sp) = int priority
# 8($sp) = int protocol
# 12($sp) = int src_addr
# 16($sp) = int dest_addr
#
# $v0 = number of packets created
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
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	addi $fp, $sp, 40
	
	li $s4, 0			# frag_offset = 0
	li $s7, 0			# packets = 0
	packetize.loop:
		li $s5, 0		# msg_len_for_packet = 0
		li $s6, 1		# flag = 1
		addi $t0, $s0, 12
		packetize.payload_loop:
			beq $s5, $s2, packetize.end_payload_loop
			lbu $t1, 0($s1)
			sb  $t1, 0($t0)
			beqz $t1, packetize.final_packet
			addi $s1, $s1, 1
			addi $t0, $t0, 1
			addi $s5, $s5, 1
			j packetize.payload_loop
			packetize.final_packet:
				li $s6, 0
		packetize.end_payload_loop:
		
		move $a0, $s0
		addi $a1, $s5, 12
		jal set_total_length
		
		move $a0, $s0
		lhu $a1, 0($fp)
		jal set_msg_id
		
		move $a0, $s0
		move $a1, $s3
		jal set_version
		
		move $a0, $s0
		move $a1, $s4
		jal set_frag_offset
		
		move $a0, $s0
		lhu $a1, 8($fp)
		jal set_protocol
		
		move $a0, $s0
		move $a1, $s6
		jal set_flags
		
		move $a0, $s0
		lbu $a1, 4($fp)
		jal set_priority
		
		move $a0, $s0
		lbu $a1, 12($fp)
		jal set_src_addr
		
		move $a0, $s0
		lbu $a1, 16($fp)
		jal set_dest_addr
		
		move $a0, $s0
		jal compute_checksum
		move $a0, $s0
		move $a1, $v0
		jal set_checksum
		
		move $a0, $s0
		jal get_total_length
		add $s0, $s0, $v0				# increment packet_ptr by total_length (move on to next packet)
		
		add $s4, $s4, $s2				# frag_offset += payload_size
		addi $s7, $s7, 1				# packets++
		bgtz $s6, packetize.loop
	packetize.endloop:
	
	move $v0, $s7
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	lw $fp, 36($sp)
	addi $sp, $sp, 40
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
