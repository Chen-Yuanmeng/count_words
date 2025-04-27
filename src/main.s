	.section .data
	.align 3
	.globl hashTable
hashTable:
	.zero 8 * 10007			# initiate hashTable with 0

	.section .rodata
	.align 3
help_output:
	.asciz "Usage: %s <filename>\n"
	.align 3
normal_output:
	.asciz "The most frequent word is \"%s\", which appeared %d times.\n"
	.align 3
noword_output:
	.asciz "Could not find any words or could not read the file.\n"

	.section .text
	.globl main
	.type main, @function
main:
	addi	sp, sp, -64
	sd		s0, 0(sp)
	sd		ra, 8(sp)
	sw		a0, 16(sp)		# (int) argc
	sd		a1, 24(sp)		# (char **)argv

	li		t0, 2
	beq		a0, t0, normal

	ld		a1, 24(sp)
	ld		a1, 0(a1)
	la		a0, help_output
	call	printf

	li		a0, 1			# return 1
	ld		ra, 8(sp)
	ld		s0, 0(sp)
	addi	sp, sp, 64
	ret

	.local normal
normal:
	ld		a0, 24(sp)
	ld		a0, 8(a0)		# a0 = argv[1]
	call	get_most_frequent_word
	# return word in a0, count in a1
	sd		a0, 32(sp)		# word
	sd		a1, 40(sp)		# count
	
	beqz	a0, noword

	la		a0, normal_output
	ld		a1, 32(sp)
	ld		a2, 40(sp)
	call	printf
	j		freehash

	.local noword
noword:
	la		a0, noword_output
	call	printf

	.local freehash
freehash:
	call	freeHashTable

	li		a0, 0				# return 0
	ld		ra, 8(sp)
	ld		s0, 0(sp)
	addi	sp, sp, 64
	ret
