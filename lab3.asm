
.data
msg1: .asciiz "\n Programming Assigment 3 \n"
msg2: .asciiz ","
msg3: .asciiz "Linked List:"
msg5: .asciiz "\n"
msg6: .asciiz "Sonia Lopez\n\n"

.align 4
# You need to insert the value in the input array to the linked list A.
len:  .word 10
input:.word 5, 10, 2, 4, 15, 22, 100, 99, 2, 10

# 'head' stores the address of the first node of the linked list
head: .word 0 
# Total number of inserted numbers
size: .word 0 
# allocate a block of 80 bytes, 20 words: 10 for number, 10 for pointer
A: .space 80 


.text 					
.globl main
main: 
# $s0: i  
# $s1: 10
# $s2: input 
# $s3: head address
# $s4: size
# $s5: A address
	li 		$v0,4				#print msg6
	la		$a0, msg6			# address where msg6 is msg6
	syscall
	li      $v0,4           # print msg3
    la      $a0,msg3        # address where msg3 is stored 	
    syscall	

    add     $s0,$zero,$zero # i = 0
    addi    $s1,$zero,10
    la      $s2,input
    la      $s3,head
    lw      $s4,size
    la      $s5,A
buildList:
    beq     $s0,$s1,end
    sll     $t0,$s0,2
    add     $t1,$t0,$s2     

    lw      $a0,0($t1)      #$a0 = input[i]
    jal     insert

    addi    $s0,1
    j       buildList
end:
    jal     printValueOfList # print the linked list after sorting

    li      $v0,10          # code for syscall: exit
	syscall

insert:
# ================ Your Code Starts Here ====================
	la		$t0,0($s3)		
	move 	$t1,$0			# copies the value in $0 to $t1
	
	add 	$t2,$s5,$s4		# reg $t2 = $s5 + $s4
	sw		$a0,0($t2)		
	bne 	$s4,$0,next		# go to next if $0 != $s4
	
	la		$s3,A
	sw		$0,4($t2)		
	j		ret				# jump to ret
	
next:
	lw		$t3,0($t0)		
	slt		$t4,$t3,$a0
	beq		$t4,$0,target	# if $t4 == $t1 then target
	move 	$t1,$t0			# $t0 = $t0
	lw		$t0,4($t0)		
	beq		$t0,$0,target	# if $t0 == $0 then target
	j		next			# jump to next
	
target:
	beq		$t1,$0,s_else	# if $t1 == $t1 then target
	lw		$t5,0($t1)		
	beq		$t5,$0,s_else	# if $t5 == $t1 then target
	
	addi	$t5,$t1,4		# $t5 = $t1 + 4
	sw		$t2,0($t5)		 
	sw		$t0,4($t2)		 
	j		ret				# jump to ret
	
s_else:
	addi	$t5,$t2,4		# $t5 = $t1 + 4
	sw		$s3,0($t5)		 
	la		$s3,0($t2)		 
	
ret:
	addi	$t6,$t6, 1		# $t6 = $t1 + 1
	sll		$s4,$t6,3	
	jr		$ra				# jump to $ra

# ================ Print Linked List ====================
printValueOfList:
# $t0: p = head
    la      $t0,0($s3)
    add     $t4,$zero,$zero
    li      $v0,4           # system call to print the string
    la      $a0,msg5
    syscall
printLoop:
    beq     $t0,$zero,endLoop # if p == NULL, break loop

    li      $v0,1           # system call to print integer
    lw      $a0,0($t0)
    syscall
    li      $v0,4           # system call to print ","
    la      $a0,msg2
    syscall		
    
    lw      $t0,4($t0)       # p = p->next;
    j       printLoop
endLoop:
    li      $v0,4           # change line
    la      $a0,msg5
    syscall
    jr      $ra             # return to calling routine   


