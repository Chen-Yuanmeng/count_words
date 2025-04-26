	.globl insertWord
	.type insertWord, @function
insertWord:
	addi	sp, sp, -32
	sd		ra, 8(sp)
	sd		s0, 0(sp)

	mv		t0, a0				# t0 = word

	# save before call
	addi	sp, sp, -32
	sd		ra, 0(sp)
	sd		t0, 8(sp)

	call	strlen
	ld		ra, 0(sp)
	ld		t0, 8(sp)
	addi	sp, sp, 32

	beqz	a0, end_insertWord

	# save before call
	addi	sp, sp, -32
	sd		ra, 0(sp)
	sd		t0, 8(sp)
	
	mv		a0, t0				# arg: word
	call	hash
	ld		ra, 0(sp)
	ld		t0, 8(sp)
	addi	sp, sp, 32
	
	mv		t1, a0				# t1 = idx

	slli	t2, t1, 3			# t2 = t1 * 8
	la		t6, hashTable
	add		t3, t2, t6			# t3 = hashTable + (t1 * 8)
	# 0(t3) is address "node"

	ld		t4, 0(t3)			# node in t4
	sd		t4, 16(sp)			# store node for pop later
	.local while_loop
while_loop:
	beqz	t4, end_while

	ld		t5, 0(t4)			# node->word

	addi	sp, sp, -64
	sd		ra, 0(sp)
	sd		t0, 8(sp)
	sd		t1, 16(sp)
	sd		t3, 24(sp)
	sd		t4, 32(sp)
	sd		t5, 40(sp)

	mv		a0, t5				# arg 2: node->word
	mv		a1, t0				# arg 1: word
	call	strcasecmp

	ld		ra, 0(sp)
	ld		t0, 8(sp)
	ld		t1, 16(sp)
	ld		t3, 24(sp)
	ld		t4, 32(sp)
	ld		t5, 40(sp)
	addi	sp, sp, 64
	
	bnez	a0, end_if
	lw		t5, 8(t4)			# count in t5
	sext.w	t5, t5
	addi	t5, t5, 1			# count++
	sw		t5, 8(t4)
	j 		end_insertWord  	# jump to end_insertWord
	
	.local end_if
end_if:
	ld		t4, 16(t4)			# node = node->next
	j		while_loop			# jump to the start of while
	
	.local end_while
end_while:
	# add a new node using malloc
	
	addi	sp, sp, -64
	sd		ra, 0(sp)
	sd		t0, 8(sp)
	sd		t1, 16(sp)
	sd		t3, 24(sp)
	sd		t4, 32(sp)
	sd		t5, 40(sp)

	li 		a0, 24				# a0 = 24
	call	malloc				# newNode in a0
	mv		t2, a0				# newNode in t2
	
	ld		ra, 0(sp)
	ld		t0, 8(sp)
	ld		t1, 16(sp)
	ld		t3, 24(sp)
	ld		t4, 32(sp)
	ld		t5, 40(sp)
	addi	sp, sp, 64
	
	addi	sp, sp, -64
	sd		ra, 0(sp)
	sd		t0, 8(sp)
	sd		t1, 16(sp)
	sd		t3, 24(sp)
	sd		t4, 32(sp)
	sd		t5, 40(sp)
	sd		t2, 48(sp)

	mv		a0, t0				# arg: word
	call	strdup

	ld		ra, 0(sp)
	ld		t0, 8(sp)
	ld		t1, 16(sp)
	ld		t3, 24(sp)
	ld		t4, 32(sp)
	ld		t5, 40(sp)
	ld		t2, 48(sp)
	addi	sp, sp, 64

	sd		a0, 0(t2)			# newNode->word = strdup(word)
	li		t6, 1
	sw		t6, 8(t2)
	ld		t4, 16(sp)
	sd		t4, 16(t2)
	sd		t2, 0(t3)

end_insertWord:
	ld		ra, 8(sp)
	ld		s0, 0(sp)
	addi	sp, sp, 32
	ret
