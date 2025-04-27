	.globl freeHashTable
	.type freeHashTable, @function
freeHashTable:
	addi	sp, sp, -32
	sd		ra, 8(sp)
	sd		s0, 0(sp)

	li		t0, 0				# i

	.local for_loop
for_loop:
	li		t6, 10007
	bge		t0, t6, end_freeHashTable

	slli	t1, t0, 3			# i*8

	la		t2, hashTable
	add		t2, t2, t1			# t2 = &(hashtable[i])

	.local while_loop
while_loop:
	ld		t3, 0(t2)			# node
	beqz	t3, end_while_loop
	ld		t4, 16(t3)			# node->next

	addi	sp, sp, -32
	sd		t0, 0(sp)
	sd		t3, 8(sp)
	sd		t4, 16(sp)

	ld		a0, 0(t3)			# node->word
	call	free

	ld		a0, 8(sp)			# node
	call	free

	ld		t0, 0(sp)
	ld		t3, 8(sp)
	ld		t4, 16(sp)
	addi	sp, sp, 32

	mv		t3, t4
	sd		t3, 0(t2)
	j		while_loop			# jump to while_loop

	.local end_while_loop
end_while_loop:
	slli	t1, t0, 3			# i*8

	la		t2, hashTable
	add		t2, t2, t1			# t2 = hashtable[i]
	sd		zero, 0(t2)
	addi	t0, t0, 1			# i++
	j		for_loop			# jump to for_loop
	
	.local end_freeHashTable
end_freeHashTable:
	ld		ra, 8(sp)
	ld		s0, 0(sp)
	addi	sp, sp, 32
	ret
