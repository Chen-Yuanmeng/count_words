	.section .text
	.globl processLine
	.type processLine, @function
processLine:
	addi	sp, sp, -144
	sd		ra, 8(sp)
	sd		s0, 0(sp)  

	li		t0, 0		    # i
	li		t1, 0		    # j

	addi	s0, sp, 16

	mv		a5, a0		    # *line

	.local for_loop
for_loop:		
	
	add		t5, t0, a5
	lb		t3, 0(t5)		# line[i]
	beqz	t3, for_loop_end  

	addi	sp, sp, -80
	sd		a1, 0(sp)  
	sd		a5, 8(sp)
	sd		t1, 16(sp)
	sd		t3, 24(sp)
	sd		t3, 32(sp)
	sd		t4, 40(sp)
	sd		t5, 48(sp)
	sd		t6, 56(sp)
	sd		t0, 64(sp)

	mv		a0, t3		    # parameter line[i]
	call	isalpha		

	ld		t0, 64(sp)
	ld		t6, 56(sp)
	ld		t5, 48(sp)
	ld		t4, 40(sp)
	ld		t3, 32(sp)
	ld		t2, 24(sp)
	ld		t1, 16(sp)
	ld		a5, 8(sp)
	ld		a1, 0(sp)
	addi	sp, sp, 80 

	beq		a0, x0, else_if

	addi	sp, sp, -80
	sd		a1, 0(sp)  
	sd		a5, 8(sp)
	sd		t1, 16(sp)
	sd		t3, 24(sp)
	sd		t3, 32(sp)
	sd		t4, 40(sp)
	sd		t5, 48(sp)
	sd		t6, 56(sp)
	sd		t0, 64(sp)

	mv		a0, t3		    # parameter line[i]
	call    tolower		
	
	ld		t0, 64(sp)
	ld		t6, 56(sp)
	ld		t5, 48(sp)
	ld		t4, 40(sp)
	ld		t3, 32(sp)
	ld		t2, 24(sp)
	ld		t1, 16(sp)
	ld		a5, 8(sp)
	ld		a1, 0(sp)
	addi	sp, sp, 80 

	add		t5, s0, t1
	sb		a0, 0(t5)		# word[j] = tolower(line[i]);
	addi	t1, t1, 1		# j++
	j		else_if_end		

	.local else_if		
else_if:		
	blez	t1, if_end 
	
	add		t5, s0, t1		
	sb		x0, 0(t5)		# word[j] = '\0'

	addi	sp, sp, -80
	sd		a1, 0(sp)  
	sd		a5, 8(sp)
	sd		t1, 16(sp)
	sd		t3, 24(sp)
	sd		t3, 32(sp)
	sd		t4, 40(sp)
	sd		t5, 48(sp)
	sd		t6, 56(sp)
	sd		t0, 64(sp)

	mv		a0, s0		    # parameter *word
	call	insertWord		

	ld		t0, 64(sp)
	ld		t6, 56(sp)
	ld		t5, 48(sp)
	ld		t4, 40(sp)
	ld		t3, 32(sp)
	ld		t2, 24(sp)
	ld		t1, 16(sp)
	ld		a5, 8(sp)
	ld		a1, 0(sp)
	addi	sp, sp, 80  

	li		t1, 0		    # j = 0

	.local if_end
if_end:

	.local else_if_end
else_if_end:

	addi	t0, t0, 1		# i++ 

	j		for_loop
	.local for_loop_end
for_loop_end:

	blez	t1, if_end2
	
	add		t5, s0, t1		
	sb		x0, 0(t5)		# word[j] = '\0'444  

	addi	sp, sp, -80
	sd		a1, 0(sp)  
	sd		a5, 8(sp)
	sd		t1, 16(sp)
	sd		t3, 24(sp)
	sd		t3, 32(sp)
	sd		t4, 40(sp)
	sd		t5, 48(sp)
	sd		t6, 56(sp)
	sd		t0, 64(sp)

	mv		a0, s0		    # parameter *word
	call	insertWord		

	ld		t0, 64(sp)
	ld		t6, 56(sp)
	ld		t5, 48(sp)
	ld		t4, 40(sp)
	ld		t3, 32(sp)
	ld		t2, 24(sp)
	ld		t1, 16(sp)
	ld		a5, 8(sp)
	ld		a1, 0(sp)
	addi	sp, sp, 80  

	.local if_end2
if_end2:
	nop
	ld		ra, 8(sp)
	ld		s0, 0(sp)
	addi	sp, sp, 144
	ret
