# University of Toronto, Scarborough
#
# Student: Name, Student Number, UTorID, official email #
# Gon Yang, 1007128243, yanggon, gon.yang@mail.utoronto.ca

# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed) # - Base Address for Display: 0x10008000 ($gp)
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 512 (update this as needed) # - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones) # - Milestone 1/2/3 (choose the one the applies)
#
# - Milestone 1 ()
# - Milestone 2 ()
#- Milestone 3 ()
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features) # 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# - yes / no / yes, and please share this project github link as well! #
# Any additional information that the TA needs to know:
# - (write here, if any)
# #####################################################################
# #####################################################################


# constant
.eqv  BASE_ADDRESS    0x10008000
.eqv  
.eqv  DIS_BR	      0x1000BFFC    
.eqv  DIS_BL          0x1000BF00
.eqv  DIS_LAND_START_CHAR  0x1000B900



.eqv  WIDTH   256

.eqv CHAR_LOCATION 0x10008000
 
# colours 
.eqv  COL_RED,  0x00ff0000  # red
.eqv  COL_BRW,  0x00663300  # brown
.eqv  COL_ORA,  0x00ff9966  # orange
.eqv  COL_GRE,  0x00669900  # green
.eqv  COL_BLU,  0x000066ff  # blue
.eqv  COL_YEL,  0x00ffff00  # yellow
.eqv  COL_WHI,  0x00ffffff  # white
.eqv  COL_BLA,  0x00000000  # black

#debug

#li $v0, 1
#li $a0, 5
#syscall


.data

END:  .word   1
.text
.globl main
main: 		li $s0, DIS_LAND_START_CHAR
		li $s1, BASE_ADDRESS
		addi $s1, $s1, 256
		addi $s1, $s1, 256
		li $t0, BASE_ADDRESS
		addi $t1, $t0, 252
		li $t2, COL_BLU
		jal fill
		
		li $t0, DIS_LAND_START_CHAR
		li $t1, 256
		add $t0, $t0, $t1
		add $t0, $t0, $t1
		add $t0, $t0, $t1
		add $t0, $t0, $t1
		li $t1, DIS_BR
		li $t2, COL_BRW
		
		jal fill
main_loop:
		# t0 = init location
		# t1 = end location
		# t2 = colour
		# t3 = temp
		# t4 = temp
		
		# s0 = location of char
		# s1 = previous location of char (to erase)
		
		li $t9, 0xffff0000
		lw $t8, 0($t9)
		lw $t1, 4($t9)
		bne $t8, 1, update
		jal key
		
		

update: 	beq $s1, $s0, same
		jal clear

same:		jal char
		
		lw $t8, 0($t9)
		
		li $v0, 32
		li $a0, 305
		syscall
		

		
		lw $t1, 0($t9)
		add $t8, $t8, $t1
		bnez $t8, main_loop
		
		jal clear
		
		jal s
		jal char
		
		j main_loop
		
clear_dis:	la $t0, BASE_ADDRESS
		la $t1, DIS_BR
		la $t2, COL_BLA
clear_dis_loop: sw $t2, 0($t0)
		addi $t0, $t0, 4
		beq $t0, $t1, clear_dis_end
		j clear_dis_loop
clear_dis_end:  jr $ra		
		
clear:		# s1 = location of character to erase
		li $t2, COL_BLA
		sw $t2, -256($s1)
		sw $t2, -252($s1)
		sw $t2, -248($s1)
		sw $t2, -244($s1)
		sw $t2, -512($s1)
		sw $t2, -508($s1)
		sw $t2, -504($s1)
		sw $t2, -500($s1)
		sw $t2, 4($s1)
		sw $t2, 8($s1)
		sw $t2, 256($s1)
		sw $t2, 260($s1)
		sw $t2, 264($s1)
		sw $t2, 268($s1)
		sw $t2, 516($s1)
		sw $t2, 520($s1)
		sw $t2, 768($s1)
		sw $t2, 780($s1)
		
		j end
		
key:		
		
		beq $t1, 0x61, a
		beq $t1, 0x64, d
		beq $t1, 0x70, p
		beq $t1, 0x73, s
		beq $t1, 0x77, w
		j end
		
a:		#left
		li $t3, WIDTH  # width
		div $s0, $t3  # divide by width
		mfhi $t4  # remainder
		beq $t4, $zero, end
		move $s1, $s0
		addi $s0, $s0, -8
		j end
		
w:		#jump
		li $t3, BASE_ADDRESS
		addi $t3, $t3, WIDTH
		addi $t3, $t3, WIDTH
		blt $s0, $t3, end
		move $s1, $s0
		subi $s0, $s0, WIDTH
		subi $s0, $s0, WIDTH
		j end

d:		#right
		li $t3, WIDTH
		div $s0, $t3
		mfhi $t4
		subi $t3, $t3, 16
		beq $t4, $t3, end 
		move $s1, $s0
		addi $s0, $s0, 8
		j end

s:		#down
		li $t3, DIS_BR
		addi $t3, $t3, -WIDTH
		addi $t3, $t3, -WIDTH
		addi $t3, $t3, -WIDTH
		addi $t3, $t3, -WIDTH
		addi $t3, $t3, -WIDTH
		addi $t3, $t3, -WIDTH
		addi $t3, $t3, -WIDTH
		addi $t3, $t3, -WIDTH
		blt $t3, $s0, end
		move $s1, $s0
		addi $s0, $s0, WIDTH
		addi $s0, $s0, WIDTH
		j end

p:		#end and restart
		la $ra, main
		j end
		

		
end:  		jr $ra		
		
		
		
exit:    	li $v0, 10
		syscall
		 
		
fill:		# t0 = start point, t1 = end point, t2 = colour
		j fill_loop
		
fill_loop:	sw $t2, 0($t0)		
		addi $t0, $t0, 4
  		beq $t0, $t1, fill_end	
		j fill_loop
fill_end:       sw $t2, 0($t0)
		jr $ra
		
platform:	# t0 = start point
		li $t2, COL_GRE
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		sw $t2, 20($t0)
		sw $t2, 24($t0)
		sw $t2, 28($t0)	
		sw $t2, 32($t0)
		sw $t2, 36($t0)	
		sw $t2, 40($t0)	
		sw $t2, 44($t0)	
		sw $t2, 48($t0)
		sw $t2, 52($t0)	
		sw $t2, 56($t0)	
		
		j end

char:		# s0 = location of character
		li $t2, COL_ORA
		sw $t2, 4($s0)
		sw $t2, 8($s0)
		li $t2, COL_GRE
		sw $t2, 256($s0)
		sw $t2, 260($s0)
		sw $t2, 264($s0)
		sw $t2, 268($s0)
		sw $t2, 516($s0)
		sw $t2, 520($s0)
		sw $t2, 768($s0)
		sw $t2, 780($s0)
		
		j end	
		 
mine:		# t0 = location of object   # is it big enough?
		li $t2, COL_YEL
		sw $t2, 4($t0)
		
		li $t2, COL_RED
		sw $t2, 256($t0)
		sw $t2, 264($t0)
		
		j end
		
aid:		# t0 = location of aid
		li $t2, COL_WHI
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		
		li $t2, COL_BLU
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		
		j end