#studentName: Bora Dirilgen
#studentID: 260715482

# This MIPS program should sort a set of numbers using the quicksort algorithm
# The program should use MMIO

.data
#any any data you need be after this line 

rawbuff: .space 500
intarray: .space 10
sortedarray: .space 100
dispbuff: .space 600
welcomeStr: .asciiz "Welcome to Quicksort"
sortedStr:  .space 200
sortedArrStr: .asciiz "\nThe sorted array is: "
reinitStr:  .space 200
reinitArrStr: .asciiz "\nThe array is re-initialized "
Goodbye: .asciiz "\nThank you for using quicksort. Goodbye! "
CMD:  .space 5



	.text
	.globl main

reset:

	la $t4, CMD		# store in CMD string
	lb $t9 0($t4)
	bne $t9, 99, main
	la $a0, reinitArrStr
	jal WriteFixedStr
	add $s0, $0, $0
	add $s2, $0, $0
	add $s3, $0, $0
	j skipWelcome

#reset size of intarray to zero
main:	# all subroutines you create must come below "main"
###################

#get input from read/write stored into rawbuff
#s3 is the offset
	
	la $a0, welcomeStr
	jal WriteFixedStr
	
	skipWelcome:
	beq $s3, 0, clearrb
	addi $t9, $0, 32
	sb $t9, 0($s3)
	sb $t9, 1($s3)
	addi $s3, $s3, 2
	add $a3, $0, $s3
	j locloaded
	
clearrb:
	la $a3, rawbuff 		# send the address of required buffer via a3
locloaded:
	jal echo
	
	# CONVERT RAWBUFF TO INTARRAY
	la $a0, rawbuff
	#add $a0, $a0, $s3
	la $a1, intarray
	#add $a1, $a1, $s0
	jal rawToInt
	
	# RETRUNS LENGTH OF INTARRAY
	add $s0, $v0, $0	# s0 = length of intarray
	
	
	subi $t0, $s0, 1	# s0 = last index (length - 1)
	
	
	la $a0, intarray
	add $a1, $0, $0
	add $a2, $t0, $0
	jal quicksort		# call quicksort with a0 = array address, a1 = index '0', a2 = last index
	
	
	la $a0, intarray
	la $a1, dispbuff
	jal intToAscii
	
	
	
	
	la $a0, sortedStr	
	la $a1, sortedArrStr
	jal concatStrs
	add $t0, $v0, $0	# get pointer back
	
	move $a0, $t0	
	la $a1, dispbuff
	jal concatStrs
	add $t0, $v0, $0	# get pointer back
	
	la $a0, sortedStr
	jal WriteFixedStr
	
	#####################################
	
	#send dispbuff to write
	#read/write for c/s/q
		#if q, j here
		#if s, then jump to main
		#if c, jump to reset
		
	la $t4, CMD		# store in CMD string
	lb $t9 0($t4)
	beq $t9, 115, skipWelcome
	
	
		
	
	#END PROGRAM

	quitProgram:
	
	la $a0, Goodbye
	jal WriteFixedStr
	
	li $v0, 10	# gracefully exit the program
	syscall
	
	
echo:	
	add $v1, $0, $0		# setting the initiating address of buffer indicator register to 0, just in case
	addi $sp, $sp, -4  # we need 3 spots in the stack
	sw $ra ($sp)
	readwriteloop:
		jal Read		# reading and writing using MMIO
		add $a0,$v0,$zero	# in an infinite loop
		beq $a0, 32, inrange
		beq $a0, 115, inrange
		beq $a0, 99, inrange
		beq $a0, 113, inrange
		blt $a0, 48, notinrange
		bgt $a0, 57, notinrange
		inrange:
		
		beq $v1, $0, initiate
			add $a1, $v1, $0	# there is already a pointer on a specific location, a1 = v1
			j jalwrite
		initiate:
			add $a1, $a3, $0		# initialize the 0th char addr of buffer
		jalwrite:	
			jal Write
			notinrange:
			bne $s1, $0, exitecho	# if our indicator, s1 = 1, we must exit the echo as the text to be entered has been terminated
	j readwriteloop
	
exitecho:
	add $v1, $0, $0		# re-set the pointer to null for the next string to be entered 
				# (needed for the initating indicator when setting the initial address of the buffer)
	add $s1, $0, $0 	# re-set the "ENTER" indicator to zero for next use
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

Read:  	
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	lui $t0, 0xffff 	#ffff0000
Loop1:	lw $t1, 0($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop1
	lw $v0, 4($t0) 		#data
		
		
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


Write:  subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	lui $t0, 0xffff 	#ffff0000
Loop2: 	lw $t1, 8($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop2
	
	add $t9, $a0, $0
	bne $t9, 115, notS
#	li $a0, 32
#	jal WriteC
#	li $a0, 60
#	jal WriteC
#	li $a0, 115
#	jal WriteC
#	li $a0, 62
#	jal WriteC
#	li $a0, 10
#	jal WriteC
	
	la $t4, CMD		# store in CMD string
	sb $t9 0($t4)
	
	
	j alreadyDisplayed
	
	notS:
	bne $t9, 99, notC
#	li $a0, 32
#	jal WriteC
#	li $a0, 60
#	jal WriteC
#	li $a0, 99
#	jal WriteC
#	li $a0, 62
#	jal WriteC
#	li $a0, 10
#	jal WriteC
	
	la $t4, CMD		# store in CMD string
	sb $t9 0($t4)
	
	j reset
	
	notC:
	
	bne $t9, 113, notQ
#	li $a0, 32
#	jal WriteC
#	li $a0, 60
#	jal WriteC
#	li $a0, 113
#	jal WriteC
#	li $a0, 62
#	jal WriteC
#	li $a0, 10
#	jal WriteC
	
	la $t4, CMD		# store in CMD string
	sb $t9 0($t4)
	
	j quitProgram
	
	notQ:
	sw $t9, 12($t0) 	#data
	alreadyDisplayed:
	
	add $t6, $a1, $0	# t6 = bufferptr
	
	
	# ENDING THE PROGRAM WHEN USER PRESSES ENTER
	

	bne $t9, 115, storechar	# if the user has NOT pressed <s>, we store the entered char.

	add $t9, $0, $0		# otherwise, the termination of the text is indicated buy a "null ending", 
				# so we change t9 = $0, and then store char
	addi $s1, $0, 1		# if s1 = 1, the text has been terminated. This will serve as our indicator
	
	
	# STORING THE CHAR ENTERED INTO THE BUFFER, UPDATING THE BUFFER POINTER
	
	storechar:	add $s3, $t6, $0	# ultimately, s3 = pointer at null for rawbuff
			sb $t9, 0($t6)		# store the char at a0 also on the buffer pointer location
			addi $t6, $t6, 1	# increment buffer ptr ++
			add $v1, $t6, $0	# v1 = updated buffer pointer location - sending back as an argument
			
			la $a0, rawbuff
			la $a1, intarray
			jal rawToInt
			add $s2, $v0, $0	# number of ints so far 
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
WriteC: 
	subi $sp, $sp, 16
	sw $a0, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $ra, 12($sp)
	lui $t0, 0xffff 	#ffff0000
Loop2C: lw $t1, 8($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop2C	
	sw $a0, 12($t0) 	#data

	lw $a0, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra


	
	
# CONVERT RAW INPUT FROM USER TO AN INTEGER ARRAY	
rawToInt:
	subi $sp, $sp, 32
	sw $t0, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 12($sp)
	sw $t5, 16($sp)
	sw $t6, 20($sp)
	sw $t9, 24($sp)
	sw $ra, 28($sp)
	
	add $t0, $a0, $0	# t0 = rawbuff[0]
	add $t5, $a1, $0	# t5 = intarray[0]
	add $t6, $0, $0		# t6 = counter, will store length of intarray
	
conversionLoop:
	lb $t2, 0($t0)		# t2 = char at t0[0]
	lb $t3, 1($t0)		# t3 = char at t0[1]
	
	subi $t2, $t2, 48	# convert from ascii to int
	subi $t3, $t3, 48
	
	beq $t2, -48, endConversion	# if t2 = null char (null char - 48 = -48, we have reached the end)
	beq $t2, -16, increment		# if t2 = space char (space - 48 = -16, we must increment one slot)
	blt $t3, $0, singleDigit	# if t2 != null && t2 != space && t3 < 0, that means t2 has a number and
					# t3 is either a space or has reached the end. This indicates a single digit @ t2.
					# Else, we must store a double digit using t2 and t3 
	
	doubleDigit:
		addi $t9, $0, 10	# t9 = 10
		mul $t2, $t2, $t9	# t2 is the tens' digit so we multiply by 10
		add $t2, $t2, $t3	# t3 holds the single digit, which must be added onto t2*10
		addi $t0, $t0, 1	# we increment the pointer t0++

	singleDigit:
		sb $t2, 0($t5)		# if we have gone thru the double digit process or not, we have the num to be stored
					# in t2, so we store byte in position t5
		addi $t5, $t5, 1	# t5 ++
		addi $t6, $t6, 1	# t6 (counter) ++
	increment:
		addi $t0, $t0, 1	# t0 ++
		j conversionLoop
	endConversion:
		add $v0, $t6, $0

		lw $t0, 0($sp)
		lw $t2, 4($sp)
		lw $t3, 12($sp)
		lw $t5, 16($sp)
		lw $t6, 20($sp)
		lw $t9, 24($sp)
		lw $ra, 28($sp)
		addi $sp, $sp, 32
		jr $ra
	

	
# CONVERT INTEGER ARRAY TO FORMAT THAT CAN BE DISPLAYED BY MMIO
intToAscii:
	add $t0, $a0, $0	# t0 = intarray[0]
	add $t5, $a1, $0	# t5 = dispbuff[0]
	
	add $t9, $0, $0		# t9 = counter
	
convLoop:

	lb $t2, 0($t0)		# t2 = char at t0
	lb $t3, 1($t0)		# t2 = char at t0
	beq $t9, $s2, endConv	# awhen t9 = length we end conversion
	blt $t2, 10, oneDigit	# if t2 < 10, it is a single digit number
	
	twoDigit:
		addi $t8, $0, 10	# in the case of two-digit numbers, we must multiply the first 
					# digit by 10, then add the remainder i.e. the second digit
	
		div $t2, $t8		# To differentiate between the first and second digits, we must divide t2/10, 
					# then examine the quotient and remainder
		mflo $t1		# t1 = quotient
		mfhi $t2		# t2 = remainder
		addi $t1, $t1, 48	# convert to ascii
		sb $t1, 0($t5)		# store byte in t5
		addi $t5, $t5, 1	# t5++
	oneDigit:
		addi $t2, $t2, 48	# convert to ascii
		sb $t2, 0($t5)		# store byte in t5
		addi $t5, $t5, 1	# t5++
		
		subi $t7, $s2, 1	# t7 = length - 1 --> to see if we have reached the last char. 
		beq $t9, $t7, skipSpace	# if we have traversed 9 ints, we must not store space as the last char
		
		addi $t8, $0, 32	# store space after storing the number, as long as not last char
		sb $t8, 0($t5)		# store byte in t5
		addi $t5, $t5, 1	# t5++
		
	skipSpace:
		addi $t9, $t9, 1	# counter++
		addi $t0, $t0, 1	# intarrayptr++
		j convLoop		# keep looping
	
	endConv:
		add $t8, $0, $0		# end with ascii null terminator
		sb $t8, 0($t5)
		jr $ra

# QUICKSORT WITH THE INTARRAY

#QUICKSORT

quicksort:

	addi $sp, $sp, -60  
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	sw $t7, 28($sp)
	sw $t8, 32($sp)
	sw $t9, 36($sp)
	sw $a0, 40($sp)
	sw $a1, 44($sp)
	sw $a2, 48($sp)
	sw $v0, 52($sp)
	sw $ra, 56($sp)
	
	add $t0, $a0, $0	# t0 = intarray[0] ptr
	add $t1, $a1, $0	# t1 = low
	add $t2, $a2, $0	# t2 = hi
	
	
	ble $t2, $t1, qsdone	# if hi <= low, goto qsdone
	
	# partition(intarray, low, hi)
	add $a0, $t0, $0	# a0 = a[0] ptr
	add $a1, $t1, $0	# a1 = low
	add $a2, $t2, $0	# a2 = hi
	jal partition
	add $s4, $v0, $0
	
	add $t8, $s4, $0	# t8 = ppos returned from partition(a, low, hi) = pivot
	subi $t7, $t8, 1	# t7 = pivot - 1
	addi $t9, $t8, 1	# t9 = pivot + 1
	
	# quicksort(intarray, low, pivot - 1)
	add $a0, $t0, $0	# a0 = a[0] addr
	add $a1, $t1, $0	# a1 = low
	add $a2, $t7, $0	# a2 = piv - 1
	jal quicksort

	# quicksort(intarray, pivot + 1, hi)	
	add $a0, $t0, $0	# a0 = a[0] addr
	add $a1, $t9, $0	# a1 = piv + 1
	add $a2, $t2, $0	# a2 = hi
	jal quicksort
	
qsdone:
	
	# RESTORE ALL VALUES FROM STACK
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	lw $t6, 24($sp)
	lw $t7, 28($sp)
	lw $t8, 32($sp)
	lw $t9, 36($sp)
	lw $a0, 40($sp)
	lw $a1, 44($sp)
	lw $a2, 48($sp)
	lw $v0, 52($sp)
	lw $ra, 56($sp)
	addi $sp, $sp, 60  
	jr $ra


# PARTITION
partition:
# a0 = intarray
# a1 = low
# a2 = hi
	
	# save the t regs in stack
	addi $sp, $sp, -52  #we need 3 spots in the stack
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	sw $t8, 28($sp)
	sw $t9, 32($sp)
	sw $a0, 36($sp)
	sw $a1, 40($sp)
	sw $a2, 44($sp)
	#sw $v0, 48($sp)
	sw $ra, 48($sp)
	
	# Now start partitioning
	
	add $t0, $a0, $0	# t0 = intarray[0] address
	add $t1, $a1, $0	# t1 = low
	add $t2, $a2, $0	# t2 = hi
	
	
	add $t3, $t0, $t1	# t3 = a[low]ptr
	lb $t8, 0($t3)		# t8 = a[low] = pivot
	add $t4, $t1, $0	# t4 = ppos = low
	
	addi $t9, $t1, 1	# t9 = iterator = i = low + 1
	
	part_loop:
		bgt $t9, $t2, endpartloop	# for (i <= hi)
		add $t5, $t0, $t9		# a[i]ptr
		lb $t6, 0($t5)			# t6 = a[i]
		
		slt $t5, $t6, $t8		# set t5 if t6<t8 (i.e. a[i] < pivot)
		beq $t5, $0, iterate		# if t5 = 0, the if statement does not hold
			addi $t4, $t4, 1	# ppos++
	
			# set arguments for swap
			add $a0, $t0, $0	# a0 = t0 = intarray[0] address
			add $a1, $t4, $0	# a1 = t4 = ppos
			add $a2, $t9, $0	# a2 = t9 = iterator, i
			jal swap
		iterate:
		addi $t9, $t9, 1	# i++
		j part_loop
	endpartloop:
		add $a0, $t0, $0	# a0 = t0 = intarray[0] address
		add $a1, $t1, $0	# a1 = t1 = low
		add $a2, $t4, $0	# a2 = ppos
		jal swap
		add $v0, $t4, $0	# return ppos
		
	# reload t regs to previous values
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	lw $t6, 24($sp)
	lw $t8, 28($sp)
	lw $t9, 32($sp)
	lw $a0, 36($sp)
	lw $a1, 40($sp)
	lw $a2, 44($sp)
	#lw $v0, 48($sp)
	lw $ra, 48($sp)
	addi $sp, $sp, 52  #we need 3 spots in the stack
	jr $ra
	
swap:
# a0 = intarray
# a1 = low
# a2 = ppos

	# save the t regs in stack
	addi $sp, $sp, -40  #we need 3 spots in the stack
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 8($sp)
	sw $t4, 12($sp)
	sw $t5, 16($sp)
	sw $a0, 20($sp)
	sw $a1, 24($sp)
	sw $a2, 28($sp)
	sw $v0, 32($sp)
	sw $ra, 36($sp)


	
	add $t1, $a0, $a1	# t1 = intarray[i] ptr
	add $t2, $a0, $a2	# t2 = intarray[j] ptr
	
	lb $t3, 0($t1)		# t3 = intarray[i]
	lb $t4, 0($t2)		# t4 = intarray[j]
	
	add $t5, $t3, $0	# t5 = temp = intarray[i]
	sb $t4, 0($t1)		# store intarray[j] in intarray[i] ptr
	sb $t5, 0($t2)		# store temp in intarray[j] ptr
	
	# load the previous t reg values from stack
	
	lw $t1, 0($sp)
	lw $t2, 4($sp)
	lw $t3, 8($sp)
	lw $t4, 12($sp)
	lw $t5, 16($sp)
	lw $a0, 20($sp)
	lw $a1, 24($sp)
	lw $a2, 28($sp)
	lw $v0, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	jr $ra

WriteFixedStr:
	add $t9, $a0, $0
getLetter:
	lb $t8, 0($t9)
	beq $t8, $0, endWriteFS
	lui $t0, 0xffff 	#ffff0000
LoopFStr: 	
	lw $t1, 8($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,LoopFStr
	sw $t8, 12($t0) 	#data
	addi $t9, $t9, 1
	j getLetter
endWriteFS:
LoopENDFStr:
	addi $t8, $0, 10
	lw $t1, 8($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,LoopENDFStr
	sw $t8, 12($t0) 	#data
	jr $ra
	
	
concatStrs:
# a0 = addr str1
# a1 = addr str2
	add $t0, $a0, $0	# address of str1
	add $t1, $a1, $0	# address of str2
loopConcat:
	lb $t3, 0($t1)		# char at t0
	beq $t3, $0, doneConcat
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j loopConcat
doneConcat:
	sb $t3, 0($t0)
	add $v0, $t0, $0
	jr $ra
	

