    .section .rodata
	.align 3
    msg1: .asciz "r"
	.align 3
    msg2: .asciz "Can not open file\n"
	.section .text
	.globl get_most_frequent_word
    .type get_most_frequent_word, @function
get_most_frequent_word:
    li      t0, 4128            # t0 = 4128
    sub     sp, sp, t0          # sp -= 4128 
	sd		ra, 8(sp)
	sd		s0, 0(sp)
    addi    s0, sp, 16          # char line[4096]
        
    
    
    mv      a0, a0              # *filename
    la      a1, msg1            # "r"    
    call    fopen               # fopen

    bnez    a0, if_end

    la      a0, msg2
    call    perror

    li      a0, 0               # return NULL
    j       end

    
    .local if_end
if_end:
    mv      t0, a0             # store fp in t0
    .local while
while:
    
    addi    sp, sp, -16         # store *line
    sd      s0, 0(sp)
    sd      t0, 8(sp)
    
    mv      a0, s0
    li      a1, 4096
    mv      a2, t0
    call    fgets

    ld      t0, 8(sp)
    ld      s0, 0(sp)
    addi    sp, sp, 16
    
    beqz    a0, while_end

    addi    sp, sp, -16
    sd      s0, 0(sp)
    sd      t0, 8(sp)

    mv      a0, s0              # store fp
    call    processLine

    ld      s0, 0(sp)
    ld      t0, 8(sp)
    addi    sp, sp, 16

    j       while

    .local while_end
while_end:
    mv      a0, t0
    call    fclose

    li      t1, 0               # mostWord = NULL
    li      t2, 0               # maxcount = 0

    li      t3, 0

    .local for_loop
for_loop:
    li      t4, 10007
    bgeu    t3, t4, for_loop_end

    slli    a3, t3, 3           # address need *8
    la      t5, hashTable
    add     t5, t5, a3          # *node
    ld      t6, 0(t5)           # node
    
    .local while_loop
while_loop:
    
    beqz    t6, while_loop_end
    lw      t0, 8(t6)           # count
    bleu    t0, t2, if_end1
    mv      t2, t0
    ld      a1, 0(t6)           # node -> *word
    mv      t1, a1

    .local if_end1
if_end1:
    ld      t6, 16(t6)          # node -> next
    j       while_loop
    .local while_loop_end
while_loop_end:


    addi    t3, t3, 1
    j       for_loop
    .local for_loop_end
for_loop_end:


    mv      a0, t1              # return mostWord
    mv      a1, t2              # count_out

    .local end
end:
    nop
	ld		ra, 8(sp)
	ld		s0, 0(sp)
	li      t0, 4128            # t0 = 4128
    add     sp, sp, t0          # sp += 4128
	ret
