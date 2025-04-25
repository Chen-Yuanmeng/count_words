	.section .text
	.globl hash
    .type hash, @function
hash:
	addi	sp, sp, -16
	sd		ra, 8(sp)
	sd		s0, 0(sp)

	mv		t0, a0			# t0 = a0
	li		t6, 0 			# t6 = 0 (h)
	li 		t5, 31 			# t5 = 31

while_loop:
	lb		t4, 0(t0) 			# byte
	beqz	t4, end_while		# if t4 == 0, end while loop
	## if t4 >= 65 and t4 <= 90, then t4 = t4 + 32  
	li		t3, 65
	blt		t4, t3, end_lower
	li		t2, 90
	bgt		t4, t2, end_lower
	
lower:
	addi	t4, t4, 32			# t4 = t4 + 32
end_lower:
	mul		t6, t6, t5
	add		t6, t6, t4
	addi	t0, t0, 1			# ++str
	j		while_loop
end_while:
	li		t5, 10007
	remu	a0, t6, t5			# return t6 % t5

	ld		ra, 8(sp)
	ld		s0, 0(sp)
	addi	sp, sp, 16
	ret
