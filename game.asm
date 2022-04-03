######################################################################
# CSCB58 Winter 2022 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Name, Student Number, UTorID, official email #
#
# Gon Yang, 1007128243, yanggon, gon.yang@mail.utoronto.ca

# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 512 (update this as needed) 
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones) # - Milestone 1/2/3 (choose the one the applies)
#
# 	- Milestone 1 (O)
#       - Milestone 2 (O)
#	- Milestone 3 (O)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features) 
#
# 1. Health/score [2 marks]
# 	- 3 lives in the upper left corner of the display
#	- mine(red) -> -1, aid(blue) -> +1
# 	- life = 0 -> game over, if life > 3 -> life = 3
#
# 2. Fail condition [1 mark]
#	- life = 0 -> game over 
#	- show gameover screen(white) and restart the game
#
# 3. Win condition [1 mark]
#	- hit the yellow door -> win the game
# 	- show win screen(yellow)
#
# 4. Moving platforms [2 marks]
# 	- one of platforms is moving
#
# 5. Pick-up effects [2 marks]
#	- blue pickup -> character's body chnages to blue for a while. life +1
#	- red pickup -> character's body changes to red for a while. life -1
#	- purple pickup -> chracter's body changes to purple for a while.
#		- character can fly for 1.5 sec
#
# 6. Animated sprites [2 marks]
#	- character is animated when walking, moving, and jumping
#
#
#
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! #
#
#
#
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well! #
#
#
#
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#
#
#
# #####################################################################
# #####################################################################



#question
# time = 80ms
# am i done?
# comment is enough?




# constant
.eqv  BASE_ADDRESS    	   0x10008000 
.eqv  DIS_BR	     	   0x1000BFFC    
.eqv  DIS_BL         	   0x1000BF00
.eqv  DIS_LAND_START_CHAR  0x1000B900
.eqv  LEFT     		   0x100095C4
.eqv  RIGHT 	       	   0x10009564
.eqv  WIDTH   		   256

.eqv CHAR_LOCATION 	   0x10008000
 
# colours 
.eqv  COL_RED  0x00ff0000  # red
.eqv  COL_PUR  0x009b42f5  #purple
.eqv  COL_BRW  0x00663300  # brown
.eqv  COL_LGR  0x0013D7A9  #light green
.eqv  COL_ORA  0x00ff9966  # orange
.eqv  COL_GRE  0x00669900  # green
.eqv  COL_DGR  0x000F4618  # dark green
.eqv  COL_BLU  0x000066ff  # blue
.eqv  COL_YEL  0x00ffff00  # yellow
.eqv  COL_WHI  0x00ffffff  # white
.eqv  COL_BLA  0x00000000  # black


.data

.text
.globl main
main: 		
		#clear
		li $t0, BASE_ADDRESS
		li $t1, DIS_BR
		li $t2, COL_BLA
		
		jal fill
		
		#charcter and moving_platform
		li $s0, DIS_LAND_START_CHAR
		li $t6, BASE_ADDRESS
		addi $t6, $t6, 512
		addi $t6, $t6, 8

		# character start point change
		subi $s0, $s0, 6144
		
		# setting
		li $t7, 0
		li $t5, 3
		li $s5, 0
		
		# character prev location
		li $s1, BASE_ADDRESS
		addi $s1, $s1, 1024
		addi $s1, $s1, 1024
		
		#blue line at the top
		li $t0, BASE_ADDRESS
		addi $t1, $t0, 252
		li $t2, COL_BLU
		jal fill
		
		li $t0, BASE_ADDRESS
		addi $t0, $t0, 1280
		addi $t1, $t0, 252
		jal fill
		
		#land
		li $t0, DIS_LAND_START_CHAR
		addi $t0, $t0, 1024
		li $t1, DIS_BR
		li $t2, COL_BRW
		jal fill
		
		# platforms
		li $t0, DIS_LAND_START_CHAR
		subi $t0, $t0, 1792    # divisible by 256
		addi $t0, $t0, 52    # divisible by 4, < 256
		jal mine_platform
		
		li $t0, DIS_LAND_START_CHAR
		subi $t0, $t0, 1792    # divisible by 256
		addi $t0, $t0, 124    # divisible by 4, < 256
		
		jal mine_platform
		
		li $t0, DIS_LAND_START_CHAR
		subi $t0, $t0, 3072   # divisible by 256
		addi $t0, $t0, 196    # divisible by 4, < 256
		jal mine_platform
		
		li $t0, DIS_LAND_START_CHAR
		subi $t0, $t0, 5120 
		addi $t0, $t0, 100  
		
		jal platform
		
		
		
		li $t0, BASE_ADDRESS
		addi $t0, $t0, 5572
		add $s2, $t0, $zero
		
		jal moving_platform
		
		li $t0, DIS_LAND_START_CHAR
		subi $t0, $t0, 7424
		addi $t0, $t0, 24
		
		jal aid_platform
		
		li $t0, DIS_LAND_START_CHAR
		addi $t0, $t0, 512
		addi $t0, $t0, 32
		
		
		li $t2, COL_PUR
		sw $t2, -12($t0)
		sw $t2, -8($t0)
		sw $t2, 244($t0)
		sw $t2, 248($t0)
		
		addi $t0, $t0, 24
		li $t2, COL_RED
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		

		
		addi $t0, $t0, 36
		
		li $t2, COL_RED
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		
		addi $t0, $t0, 36
		
		li $t2, COL_RED
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		
		addi $t0, $t0, 36
		
		li $t2, COL_RED
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		
		addi $t0, $t0, 36
		
		li $t2, COL_RED
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		
		addi $t0, $t0, 36
		
		li $t2, COL_RED
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		
		addi $t0, $t0, 36

		
		#finish point
		li $t2, COL_YEL
		li $t0, BASE_ADDRESS
		addi $t0, $t0, 2048
		addi $t0, $t0, 2048
		addi $t0, $t0, 236
		subi $t0, $t0, 256
		
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 512($t0)
		sw $t2, 516($t0)
		sw $t2, 520($t0)
		sw $t2, 768($t0)
		sw $t2, 772($t0)
		sw $t2, 776($t0)
		
		li $t2, COL_BRW
		sw $t2, 1020($t0)
		sw $t2, 1036($t0)
		sw $t2, 1024($t0)
		sw $t2, 1028($t0)
		sw $t2, 1032($t0)
		
		li $t2, COL_DGR
		sw $t2, 1276($t0)
		sw $t2, 1280($t0)
		sw $t2, 1284($t0)
		sw $t2, 1288($t0)
		sw $t2, 1292($t0)
main_loop:
		# t0 = init location
		# t1 = end location
		# t2 = colour
		# t3 = temp
		# t4 = temp
		# t5 = life (3)
		# t6 = life location on the display
		# t7 = moving direction of moving_platform
		# s0 = location of char
		# s1 = previous location of char (to erase)
		# s2 = moving platform locaiton
		# s3 = moving platform previous location
		# s5 = flying time
		
		beq $s2, LEFT, r_most
		beq $s2, RIGHT, l_most
		j moving

r_most:	
		li $t7, 0   #go to the left
		j moving
l_most:
		li $t7, 1  #go to the right
		j moving
		
moving:		beq $t7, 0, move_left
		j move_right
		
move_left:	li $t2, COL_BLA

		lw $t3, -4($s2)
		beq $t3, COL_GRE, moving_end
		lw $t3, 252($s2)
		beq $t3, COL_GRE, moving_end
		lw $t3, 508($s2)
		beq $t3, COL_GRE, moving_end
		
		sw $t2, 48($s2)
		sw $t2, 52($s2)
		sw $t2, 304($s2)
		sw $t2, 308($s2)
		subi $s2, $s2, 4
		
		jal moving_platform
		
		j moving_end
		
move_right:	li $t2, COL_BLA

		lw $t3, 56($s2)
		beq $t3, COL_GRE, moving_end
		lw $t3, 312($s2)
		beq $t3, COL_GRE, moving_end
		lw $t3, 568($s2)
		beq $t3, COL_GRE, moving_end
		
		sw $t2, 0($s2)
		sw $t2, 4($s2)
		sw $t2, 256($s2)
		sw $t2, 260($s2)
		addi $s2, $s2, 4
		
		jal moving_platform

		j moving_end
moving_end:
		#if life > 3, then life = 3
		bge $t5, 3, max_three
		j after_max
max_three:	addi $t5, $zero, 3
	
after_max:
		#draw life
		jal draw_life
		
		# if life = 0, then game is over
		beq $t5, $zero, game_end
		
		# key detection
		li $t9, 0xffff0000
		lw $t8, 0($t9)
		lw $t1, 4($t9)
		bne $t8, 1, update
		jal key
			
update: 	beq $s1, $s0, same
		jal clear
		
		
same:		# if location is same as previous
		jal char
		
		li $v0, 32
		li $a0, 80
		syscall

		bnez $t8, main_loop  
		
		jal clear	

		bnez $s5, flying
		j gravity
		
flying:		subi $s5, $s5, 1
		j draw_c
		
gravity:	#falling
		
		jal s
		
draw_c:		
		
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

		lw $t3, -260($s1)
		beq $t3, COL_DGR, clear_0
		beq $t3, COL_BRW, clear_0
		beq $t3, COL_BLU, clear_0
		sw $t2, -260($s1)
		
clear_0:	lw $t3, -256($s1)
		beq $t3, COL_DGR, clear_1
		beq $t3, COL_BRW, clear_1
		beq $t3, COL_BLU, clear_1
		sw $t2, -256($s1)
		
clear_1:	lw $t3, -252($s1)
		beq $t3, COL_DGR, clear_2
		beq $t3, COL_BRW, clear_2
		beq $t3, COL_BLU, clear_2
		sw $t2, -252($s1)
		
clear_2:	lw $t3, -248($s1)
		beq $t3, COL_DGR, clear_3
		beq $t3, COL_BRW, clear_3
		beq $t3, COL_BLU, clear_3
		sw $t2, -248($s1)
		
clear_3:	lw $t3, -244($s1)
		beq $t3, COL_DGR, clear_4
		beq $t3, COL_BRW, clear_4
		beq $t3, COL_BLU, clear_4		
		sw $t2, -244($s1)
		
clear_4:	lw $t3, -240($s1)
		beq $t3, COL_DGR, clear_5
		beq $t3, COL_BRW, clear_5
		beq $t3, COL_BLU, clear_5	
		sw $t2, -240($s1)
		
clear_5:	lw $t3, -512($s1)
		beq $t3, COL_DGR, clear_6
		beq $t3, COL_BRW, clear_6
		beq $t3, COL_BLU, clear_6
		sw $t2, -512($s1)
		
clear_6:	lw $t3, -508($s1)
		beq $t3, COL_DGR, clear_7
		beq $t3, COL_BRW, clear_7
		beq $t3, COL_BLU, clear_7
		sw $t2, -508($s1)	
		
clear_7:	lw $t3, -504($s1)
		beq $t3, COL_DGR, clear_8
		beq $t3, COL_BRW, clear_8
		beq $t3, COL_BLU, clear_8
		sw $t2, -504($s1)
		
clear_8:	lw $t3, -500($s1)
		beq $t3, COL_DGR, clear_9
		beq $t3, COL_BRW, clear_9
		beq $t3, COL_BLU, clear_9
		sw $t2, -500($s1)
		
clear_9:	sw $t2, 0($s1)
		sw $t2, 4($s1)
		sw $t2, 8($s1)
		sw $t2, 12($s1)
		sw $t2, 256($s1)
		sw $t2, 260($s1)
		sw $t2, 264($s1)
		sw $t2, 268($s1)
		sw $t2, 512($s1)
		sw $t2, 516($s1)
		sw $t2, 520($s1)
		sw $t2, 524($s1)
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
		
		#animation
		li $t2, COL_BLA
		sw $t2, 768($s0)
		sw $t2, 780($s0)
		
		li $t2, COL_GRE
		sw $t2, 772($s0)
		sw $t2, 776($s0)
		
		li $v0, 32
		li $a0, 40
		syscall
		
		li $t2, COL_BLA
		sw $t2, 772($s0)
		sw $t2, 776($s0)
		
		li $t2, COL_GRE
		sw $t2, 768($s0)
		sw $t2, 780($s0)
		
		
		lw $t3, -4($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_BRW, end
		beq $t3, COL_LGR, end
		beq $t3, COL_RED, end
		lw $t3, 252($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_BRW, end
		beq $t3, COL_LGR, end
		beq $t3, COL_RED, end
		lw $t3, 508($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_BRW, end
		beq $t3, COL_PUR, jump_collision
		beq $t3, COL_LGR, aid_collision
		beq $t3, COL_RED, mine_collision
		lw $t3, 764($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_BRW, end
		beq $t3, COL_PUR, jump_collision
		beq $t3, COL_LGR, aid_collision
		beq $t3, COL_RED, mine_collision
		
		move $s1, $s0
		addi $s0, $s0, -4
		j end
		
w:		#jump
		li $t3, BASE_ADDRESS
		addi $t3, $t3, WIDTH
		addi $t3, $t3, WIDTH
		addi $t3, $t3, WIDTH
		addi $t3, $t3, WIDTH
		addi $t3, $t3, WIDTH
		addi $t3, $t3, WIDTH
		addi $t3, $t3, WIDTH
		blt $s0, $t3, end

		lw $t3, -256($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_LGR, end
		beq $t3, COL_RED, end
		lw $t3, -252($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_LGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_RED, end
		lw $t3, -248($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_LGR, end
		beq $t3, COL_RED, end
		lw $t3, -244($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_LGR, end
		beq $t3, COL_RED, end
		
		li $t2, COL_BLA
		sw $t2, 256($s0)
		sw $t2, 268($s0)
		
		li $t2, COL_GRE
		sw $t2, 0($s0)
		sw $t2, 12($s0)
		
		li $v0, 32
		li $a0, 100
		syscall
		
		li $t2, COL_BLA
		sw $t2, 0($s0)
		sw $t2, 12($s0)
		
		li $t2, COL_GRE
		sw $t2, 256($s0)
		sw $t2, 268($s0)


		move $s1, $s0
		subi $s0, $s0, WIDTH
		
		j end

d:		#right
		li $t3, WIDTH
		div $s0, $t3
		mfhi $t4
		subi $t3, $t3, 16
		beq $t4, $t3, end 
		
		li $t2, COL_BLA
		sw $t2, 768($s0)
		sw $t2, 780($s0)
		
		li $t2, COL_GRE
		sw $t2, 772($s0)
		sw $t2, 776($s0)
		
		li $v0, 32
		li $a0, 40
		syscall
		
		li $t2, COL_BLA
		sw $t2, 772($s0)
		sw $t2, 776($s0)
		
		li $t2, COL_GRE
		sw $t2, 768($s0)
		sw $t2, 780($s0)
		
		lw $t3, 16($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_BRW, end
		beq $t3, COL_LGR, end
		beq $t3, COL_RED, end
		lw $t3, 272($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_BRW, end
		beq $t3, COL_LGR, end
		beq $t3, COL_RED, end
		lw $t3, 528($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_BRW, end
		beq $t3, COL_PUR, jump_collision
		beq $t3, COL_LGR, aid_collision
		beq $t3, COL_RED, mine_collision
		lw $t3, 784($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_BRW, end
		beq $t3, COL_PUR, jump_collision
		beq $t3, COL_LGR, aid_collision
		beq $t3, COL_RED, mine_collision

		
		move $s1, $s0
		addi $s0, $s0, 4
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
		blt $t3, $s0, end
		
		
		lw $t3, 1024($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_PUR, jump_collision
		beq $t3, COL_LGR, aid_collision
		beq $t3, COL_RED, mine_collision
		lw $t3, 1028($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_PUR, jump_collision
		beq $t3, COL_LGR, aid_collision
		beq $t3, COL_RED, mine_collision
		lw $t3, 1032($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_PUR, jump_collision
		beq $t3, COL_LGR, aid_collision
		beq $t3, COL_RED, mine_collision
		lw $t3, 1036($s0)
		beq $t3, COL_DGR, end
		beq $t3, COL_YEL, win
		beq $t3, COL_PUR, jump_collision
		beq $t3, COL_LGR, aid_collision
		beq $t3, COL_RED, mine_collision
		
		
		
		lw $t3, 1280($s0)
		beq $t3, COL_DGR, end
		lw $t3, 1284($s0)
		beq $t3, COL_DGR, end
		lw $t3, 1288($s0)
		beq $t3, COL_DGR, end
		lw $t3, 1292($s0)
		beq $t3, COL_DGR, end
		
		move $s1, $s0
		addi $s0, $s0, WIDTH
		
		j end

p:		#end and restart
		move $s1, $s0
		jal clear
		la $ra, main
		j end
		

		
end:  		jr $ra		
		 
		
fill:		# t0 = start point, t1 = end point, t2 = colour
		j fill_loop
		
fill_loop:	sw $t2, 0($t0)		
		addi $t0, $t0, 4
  		beq $t0, $t1, fill_end	
		j fill_loop
fill_end:       sw $t2, 0($t0)
		jr $ra
		
platform:	# t0 = start point
		
		li $t2, COL_DGR
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

		
		addi $t0, $t0, -WIDTH
		li $t2, COL_BRW
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
	
		
		j end
		
aid_platform:   li $t2, COL_DGR
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

		
		addi $t0, $t0, -WIDTH
		li $t2, COL_BRW
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
		
		addi $t0, $t0, -WIDTH
		addi $t0, $t0, -WIDTH
		addi $t0, $t0, 32
		
		li $t2, COL_LGR
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		
		j end
		
		
mine_platform:   li $t2, COL_DGR
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

		
		addi $t0, $t0, -WIDTH
		li $t2, COL_BRW
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
		
		addi $t0, $t0, -WIDTH
		addi $t0, $t0, -WIDTH
		addi $t0, $t0, 16
		
		li $t2, COL_RED
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		
		j end
		
moving_platform:

		li $t2, COL_BRW
		sw $t2, 0($s2)
		sw $t2, 4($s2)
		sw $t2, 8($s2)
		sw $t2, 12($s2)
		sw $t2, 16($s2)
		sw $t2, 20($s2)
		sw $t2, 24($s2)
		sw $t2, 28($s2)	
		sw $t2, 32($s2)
		sw $t2, 36($s2)	
		sw $t2, 40($s2)	
		sw $t2, 44($s2)	
		sw $t2, 48($s2)
		sw $t2, 52($s2)	

		
		
		li $t2, COL_DGR
		sw $t2, 256($s2)
		sw $t2, 260($s2)
		sw $t2, 264($s2)
		sw $t2, 268($s2)
		sw $t2, 272($s2)
		sw $t2, 276($s2)
		sw $t2, 280($s2)
		sw $t2, 284($s2)	
		sw $t2, 288($s2)
		sw $t2, 292($s2)	
		sw $t2, 296($s2)	
		sw $t2, 300($s2)	
		sw $t2, 304($s2)
		sw $t2, 308($s2)	
	
		
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

aid_collision:	
		
		addi $t5, $t5, 1
		
		
		li $t2, COL_LGR
		sw $t2, 4($s0)
		sw $t2, 8($s0)
		sw $t2, 256($s0)
		sw $t2, 260($s0)
		sw $t2, 264($s0)
		sw $t2, 268($s0)
		sw $t2, 516($s0)
		sw $t2, 520($s0)
		sw $t2, 768($s0)
		sw $t2, 780($s0)
		
		
		li $v0, 32
		li $a0, 500
		syscall
		
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
		
		li $t2, COL_BLA
		lw $t3, 504($s0)
		bne $t3, COL_LGR, ac1
		sw $t2, 504($s0)
		
ac1:		li $t2, COL_BLA
		lw $t3, 508($s0)
		bne $t3, COL_LGR, ac2
		sw $t2, 508($s0)
		
ac2:		li $t2, COL_BLA
		lw $t3, 528($s0)
		bne $t3, COL_LGR, ac3
		sw $t2, 528($s0)

ac3:		li $t2, COL_BLA
		lw $t3, 532($s0)
		bne $t3, COL_LGR, ac4
		sw $t2, 532($s0)

ac4:		li $t2, COL_BLA
		lw $t3, 760($s0)
		bne $t3, COL_LGR, ac5
		sw $t2, 760($s0)
		
ac5:		li $t2, COL_BLA
		lw $t3, 764($s0)
		bne $t3, COL_LGR, ac6
		sw $t2, 764($s0)
		
ac6:		li $t2, COL_BLA
		lw $t3, 784($s0)
		bne $t3, COL_LGR, ac7
		sw $t2, 784($s0)
		
ac7:		li $t2, COL_BLA
		lw $t3, 788($s0)
		bne $t3, COL_LGR, ac8
		sw $t2, 788($s0)
		
ac8:		li $t2, COL_BLA
		lw $t3, 1020($s0)
		bne $t3, COL_LGR, ac9
		sw $t2, 1020($s0)
		
ac9:		li $t2, COL_BLA
		lw $t3, 1024($s0)
		bne $t3, COL_LGR, ac10
		sw $t2, 1024($s0)
		
ac10:		li $t2, COL_BLA
		lw $t3, 1028($s0)
		bne $t3, COL_LGR, ac11
		sw $t2, 1028($s0)
		
ac11:		li $t2, COL_BLA
		lw $t3, 1032($s0)
		bne $t3, COL_LGR, ac12
		sw $t2, 1032($s0)
		
ac12:		li $t2, COL_BLA
		lw $t3, 1036($s0)
		bne $t3, COL_LGR, ac13
		sw $t2, 1036($s0)
		
ac13:		li $t2, COL_BLA
		lw $t3, 1040($s0)
		bne $t3, COL_LGR, ac14
		sw $t2, 1036($s0)

ac14:		li $t2, COL_BLA
		lw $t3, 1276($s0)
		bne $t3, COL_LGR, ac15
		sw $t2, 1276($s0)

ac15:		li $t2, COL_BLA
		lw $t3, 1280($s0)
		bne $t3, COL_LGR, ac16
		sw $t2, 1280($s0)
		
ac16:		li $t2, COL_BLA
		lw $t3, 1284($s0)
		bne $t3, COL_LGR, ac17
		sw $t2, 1284($s0)

ac17:		li $t2, COL_BLA
		lw $t3, 1288($s0)
		bne $t3, COL_LGR, ac18
		sw $t2, 1288($s0)
		
ac18:		li $t2, COL_BLA
		lw $t3, 1292($s0)
		bne $t3, COL_LGR, ac19
		sw $t2, 1292($s0)
		
ac19:		li $t2, COL_BLA
		lw $t3, 1296($s0)
		bne $t3, COL_LGR, ac20
		sw $t2, 1296($s0)

ac20:		li $t2, COL_BLA
		lw $t3, 1016($s0)
		bne $t3, COL_LGR, ac21
		sw $t2, 1016($s0)
		
ac21:		li $t2, COL_BLA
		lw $t3, 1040($s0)
		bne $t3, COL_LGR, ac22
		sw $t2, 1040($s0)

ac22:		li $t2, COL_BLA
		lw $t3, 1044($s0)
		bne $t3, COL_LGR, ac_end
		sw $t2, 1044($s0)

		
ac_end:
		
		j end
		
#mine collision
		
mine_collision:	

		addi $t5, $t5, -1
		
		
		li $t2, COL_RED
		sw $t2, 4($s0)
		sw $t2, 8($s0)
		sw $t2, 256($s0)
		sw $t2, 260($s0)
		sw $t2, 264($s0)
		sw $t2, 268($s0)
		sw $t2, 516($s0)
		sw $t2, 520($s0)
		sw $t2, 768($s0)
		sw $t2, 780($s0)
		
		
		li $v0, 32
		li $a0, 500
		syscall
		
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
		
		li $t2, COL_BLA
		lw $t3, 504($s0)
		bne $t3, COL_RED, mc1
		sw $t2, 504($s0)
		
mc1:		li $t2, COL_BLA
		lw $t3, 508($s0)
		bne $t3, COL_RED, mc2
		sw $t2, 508($s0)
		
mc2:		li $t2, COL_BLA
		lw $t3, 528($s0)
		bne $t3, COL_RED, mc3
		sw $t2, 528($s0)

mc3:		li $t2, COL_BLA
		lw $t3, 532($s0)
		bne $t3, COL_RED, mc4
		sw $t2, 532($s0)

mc4:		li $t2, COL_BLA
		lw $t3, 760($s0)
		bne $t3, COL_RED, mc5
		sw $t2, 760($s0)
		
mc5:		li $t2, COL_BLA
		lw $t3, 764($s0)
		bne $t3, COL_RED, mc6
		sw $t2, 764($s0)
		
mc6:		li $t2, COL_BLA
		lw $t3, 784($s0)
		bne $t3, COL_RED, mc7
		sw $t2, 784($s0)
		
mc7:		li $t2, COL_BLA
		lw $t3, 788($s0)
		bne $t3, COL_RED, mc8
		sw $t2, 788($s0)
		
mc8:		li $t2, COL_BLA
		lw $t3, 1020($s0)
		bne $t3, COL_RED, mc9
		sw $t2, 1020($s0)
		
mc9:		li $t2, COL_BLA
		lw $t3, 1024($s0)
		bne $t3, COL_RED, mc10
		sw $t2, 1024($s0)
		
mc10:		li $t2, COL_BLA
		lw $t3, 1028($s0)
		bne $t3, COL_RED, mc11
		sw $t2, 1028($s0)
		
mc11:		li $t2, COL_BLA
		lw $t3, 1032($s0)
		bne $t3, COL_RED, mc12
		sw $t2, 1032($s0)
		
mc12:		li $t2, COL_BLA
		lw $t3, 1036($s0)
		bne $t3, COL_RED, mc13
		sw $t2, 1036($s0)
		
mc13:		li $t2, COL_BLA
		lw $t3, 1040($s0)
		bne $t3, COL_RED, mc14
		sw $t2, 1036($s0)

mc14:		li $t2, COL_BLA
		lw $t3, 1276($s0)
		bne $t3, COL_RED, mc15
		sw $t2, 1276($s0)

mc15:		li $t2, COL_BLA
		lw $t3, 1280($s0)
		bne $t3, COL_RED, mc16
		sw $t2, 1280($s0)
		
mc16:		li $t2, COL_BLA
		lw $t3, 1284($s0)
		bne $t3, COL_RED, mc17
		sw $t2, 1284($s0)

mc17:		li $t2, COL_BLA
		lw $t3, 1288($s0)
		bne $t3, COL_RED, mc18
		sw $t2, 1288($s0)
		
mc18:		li $t2, COL_BLA
		lw $t3, 1292($s0)
		bne $t3, COL_RED, mc19
		sw $t2, 1292($s0)
		
mc19:		li $t2, COL_BLA
		lw $t3, 1296($s0)
		bne $t3, COL_RED, mc20
		sw $t2, 1296($s0)
		
mc20:		li $t2, COL_BLA
		lw $t3, 1016($s0)
		bne $t3, COL_RED, mc21
		sw $t2, 1016($s0)
		
mc21:		li $t2, COL_BLA
		lw $t3, 1040($s0)
		bne $t3, COL_RED, mc22
		sw $t2, 1040($s0)

mc22:		li $t2, COL_BLA
		lw $t3, 1044($s0)
		bne $t3, COL_RED, mc_end
		sw $t2, 1044($s0)
				
mc_end:
		
		j end
		
jump_collision: #can fly for 10 movement
		
		addi $s5, $zero, 15
		
		li $t2, COL_PUR
		sw $t2, 4($s0)
		sw $t2, 8($s0)
		sw $t2, 256($s0)
		sw $t2, 260($s0)
		sw $t2, 264($s0)
		sw $t2, 268($s0)
		sw $t2, 516($s0)
		sw $t2, 520($s0)
		sw $t2, 768($s0)
		sw $t2, 780($s0)
		
		
		li $v0, 32
		li $a0, 650
		syscall
		
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
		
		li $t2, COL_BLA
		lw $t3, 504($s0)
		bne $t3, COL_PUR, jc1
		sw $t2, 504($s0)
		
jc1:		li $t2, COL_BLA
		lw $t3, 508($s0)
		bne $t3, COL_PUR, jc2
		sw $t2, 508($s0)
		
jc2:		li $t2, COL_BLA
		lw $t3, 528($s0)
		bne $t3, COL_PUR, jc3
		sw $t2, 528($s0)

jc3:		li $t2, COL_BLA
		lw $t3, 532($s0)
		bne $t3, COL_PUR, jc4
		sw $t2, 532($s0)

jc4:		li $t2, COL_BLA
		lw $t3, 760($s0)
		bne $t3, COL_PUR, jc5
		sw $t2, 760($s0)
		
jc5:		li $t2, COL_BLA
		lw $t3, 764($s0)
		bne $t3, COL_PUR, jc6
		sw $t2, 764($s0)
		
jc6:		li $t2, COL_BLA
		lw $t3, 784($s0)
		bne $t3, COL_PUR, jc7
		sw $t2, 784($s0)
		
jc7:		li $t2, COL_BLA
		lw $t3, 788($s0)
		bne $t3, COL_PUR, jc8
		sw $t2, 788($s0)
		
jc8:		li $t2, COL_BLA
		lw $t3, 1020($s0)
		bne $t3, COL_PUR, jc9
		sw $t2, 1020($s0)
		
jc9:		li $t2, COL_BLA
		lw $t3, 1024($s0)
		bne $t3, COL_PUR, jc10
		sw $t2, 1024($s0)
		
jc10:		li $t2, COL_BLA
		lw $t3, 1028($s0)
		bne $t3, COL_PUR, jc11
		sw $t2, 1028($s0)
		
jc11:		li $t2, COL_BLA
		lw $t3, 1032($s0)
		bne $t3, COL_PUR, jc12
		sw $t2, 1032($s0)
		
jc12:		li $t2, COL_BLA
		lw $t3, 1036($s0)
		bne $t3, COL_PUR, jc13
		sw $t2, 1036($s0)
		
jc13:		li $t2, COL_BLA
		lw $t3, 1040($s0)
		bne $t3, COL_PUR, jc14
		sw $t2, 1036($s0)

jc14:		li $t2, COL_BLA
		lw $t3, 1276($s0)
		bne $t3, COL_PUR, jc15
		sw $t2, 1276($s0)

jc15:		li $t2, COL_BLA
		lw $t3, 1280($s0)
		bne $t3, COL_PUR, jc16
		sw $t2, 1280($s0)
		
jc16:		li $t2, COL_BLA
		lw $t3, 1284($s0)
		bne $t3, COL_PUR, jc17
		sw $t2, 1284($s0)

jc17:		li $t2, COL_BLA
		lw $t3, 1288($s0)
		bne $t3, COL_PUR, jc18
		sw $t2, 1288($s0)
		
jc18:		li $t2, COL_BLA
		lw $t3, 1292($s0)
		bne $t3, COL_PUR, jc19
		sw $t2, 1292($s0)
		
jc19:		li $t2, COL_BLA
		lw $t3, 1296($s0)
		bne $t3, COL_PUR, jc20
		sw $t2, 1296($s0)

jc20:		li $t2, COL_BLA
		lw $t3, 1016($s0)
		bne $t3, COL_PUR, jc21
		sw $t2, 1016($s0)
		
jc21:		li $t2, COL_BLA
		lw $t3, 1040($s0)
		bne $t3, COL_PUR, ac22
		sw $t2, 1040($s0)

jc22:		li $t2, COL_BLA
		lw $t3, 1044($s0)
		bne $t3, COL_PUR, jc_end
		sw $t2, 1044($s0)

		
jc_end:
		
		j end
		
		
		
draw_life:  	beq $t5, 3, life_three
		beq $t5, 2, life_two
		beq $t5, 1, life_one
		beq $t5, 0, life_zero
	
		
life_zero:    	li $t2, COL_BLA
		sw $t2, 0($t6)
		sw $t2, 8($t6)
		sw $t2, 260($t6)
		sw $t2, 16($t6)
		sw $t2, 24($t6)
		sw $t2, 276($t6)
		sw $t2, 32($t6)
		sw $t2, 40($t6)
		sw $t2, 292($t6)
		
		j life_end
life_one: 	
		li $t2, COL_BLA
		sw $t2, 16($t6)
		sw $t2, 24($t6)
		sw $t2, 276($t6)
		sw $t2, 32($t6)
		sw $t2, 40($t6)
		sw $t2, 292($t6)
		
		li $t2, COL_RED
		sw $t2, 0($t6)
		sw $t2, 8($t6)
		sw $t2, 260($t6)
		j life_end
		
life_two:	li $t2, COL_BLA
		sw $t2, 32($t6)
		sw $t2, 40($t6)
		sw $t2, 292($t6)
		
		li $t2, COL_RED
		sw $t2, 0($t6)
		sw $t2, 8($t6)
		sw $t2, 260($t6)
		sw $t2, 16($t6)
		sw $t2, 24($t6)
		sw $t2, 276($t6)
		j life_end
		
life_three:	li $t2, COL_RED
		sw $t2, 0($t6)
		sw $t2, 8($t6)
		sw $t2, 260($t6)
		sw $t2, 16($t6)
		sw $t2, 24($t6)
		sw $t2, 276($t6)
		sw $t2, 32($t6)
		sw $t2, 40($t6)
		sw $t2, 292($t6)
		j life_end
		
life_end:	j end


game_end:	li $t0, BASE_ADDRESS
		li $t1, DIS_BR
		li $t2, COL_BLA
		

		jal fill

 
		
		li $t0, BASE_ADDRESS
		addi $t0, $t0, 2048
		addi $t0, $t0, 2048
		addi $t0, $t0, 2048
		addi $t0, $t0, 88
		li $t2, COL_WHI
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		sw $t2, 24($t0)
		sw $t2, 28($t0)
		sw $t2, 32($t0)
		sw $t2, 36($t0)
		sw $t2, 40($t0)
		sw $t2, 48($t0)
		sw $t2, 52($t0)
		sw $t2, 56($t0)
		sw $t2, 60($t0)
		sw $t2, 64($t0)
		sw $t2, 72($t0)
		sw $t2, 76($t0)
		sw $t2, 80($t0)
		sw $t2, 84($t0)
		sw $t2, 88($t0)
		sw $t2, 256($t0)
		sw $t2, 280($t0)
		sw $t2, 296($t0)
		sw $t2, 304($t0)
		sw $t2, 312($t0)
		sw $t2, 320($t0)
		sw $t2, 328($t0)
		sw $t2, 512($t0)
		sw $t2, 520($t0)
		sw $t2, 524($t0)
		sw $t2, 528($t0)
		sw $t2, 536($t0)
		sw $t2, 540($t0)
		sw $t2, 544($t0)
		sw $t2, 548($t0)
		sw $t2, 552($t0)
		sw $t2, 560($t0)
		sw $t2, 568($t0)
		sw $t2, 576($t0)
		sw $t2, 584($t0)
		sw $t2, 588($t0)
		sw $t2, 592($t0)
		sw $t2, 596($t0)
		sw $t2, 600($t0)
		sw $t2, 768($t0)
		sw $t2, 784($t0)
		sw $t2, 792($t0)
		sw $t2, 808($t0)
		sw $t2, 816($t0)
		sw $t2, 824($t0)
		sw $t2, 832($t0)
		sw $t2, 840($t0)
		sw $t2, 1024($t0)
		sw $t2, 1028($t0)
		sw $t2, 1032($t0)
		sw $t2, 1036($t0)
		sw $t2, 1040($t0)
		sw $t2, 1048($t0)
		sw $t2, 1064($t0)
		sw $t2, 1072($t0)
		sw $t2, 1080($t0)
		sw $t2, 1088($t0)
		sw $t2, 1096($t0)
		sw $t2, 1100($t0)
		sw $t2, 1104($t0)
		sw $t2, 1108($t0)
		sw $t2, 1112($t0)
		
		addi $t0, $t0, 1536		
		
		sw $t2, 0($t0)
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 12($t0)
		sw $t2, 16($t0)
		sw $t2, 24($t0)
		sw $t2, 40($t0)
		sw $t2, 48($t0)
		sw $t2, 52($t0)
		sw $t2, 56($t0)
		sw $t2, 60($t0)
		sw $t2, 64($t0)
		sw $t2, 72($t0)
		sw $t2, 76($t0)
		sw $t2, 80($t0)
		sw $t2, 84($t0)
		sw $t2, 88($t0)
		sw $t2, 256($t0)
		sw $t2, 272($t0)
		sw $t2, 280($t0)
		sw $t2, 296($t0)
		sw $t2, 304($t0)
		sw $t2, 328($t0)
		sw $t2, 344($t0)
		sw $t2, 512($t0)
		sw $t2, 528($t0)
		sw $t2, 536($t0)
		sw $t2, 552($t0)
		sw $t2, 560($t0)
		sw $t2, 564($t0)
		sw $t2, 568($t0)
		sw $t2, 572($t0)
		sw $t2, 576($t0)
		sw $t2, 584($t0)
		sw $t2, 588($t0)
		sw $t2, 592($t0)
		sw $t2, 596($t0)
		sw $t2, 600($t0)		
		sw $t2, 768($t0)
		sw $t2, 784($t0)
		sw $t2, 796($t0)
		sw $t2, 804($t0)
		sw $t2, 816($t0)
		sw $t2, 840($t0)
		sw $t2, 848($t0)
		sw $t2, 1024($t0)
		sw $t2, 1028($t0)
		sw $t2, 1032($t0)
		sw $t2, 1036($t0)
		sw $t2, 1040($t0)
		sw $t2, 1056($t0)
		sw $t2, 1072($t0)
		sw $t2, 1076($t0)
		sw $t2, 1080($t0)
		sw $t2, 1084($t0)
		sw $t2, 1088($t0)
		sw $t2, 1096($t0)
		sw $t2, 1108($t0)
		sw $t2, 1112($t0)
		
		li $v0, 32
		li $a0, 3000
		syscall
		
		j main

win:		li $t0, BASE_ADDRESS
		li $t1, DIS_BR
		li $t2, COL_BLA
		
		
		
		jal fill
		
		li $t0, BASE_ADDRESS
		addi $t0, $t0, 104
		addi $t0, $t0, 2048
		addi $t0, $t0, 2048
		addi $t0, $t0, 2048
		addi $t0, $t0, 1024
		
		li $t2, COL_YEL
		sw $t2, 0($t0)
		sw $t2, 8($t0)
		sw $t2, 16($t0)
		sw $t2, 24($t0)
		sw $t2, 28($t0)
		sw $t2, 32($t0)
		sw $t2, 40($t0)
		sw $t2, 52($t0)
		sw $t2, 256($t0)
		sw $t2, 264($t0)
		sw $t2, 272($t0)
		sw $t2, 284($t0)
		sw $t2, 296($t0)
		sw $t2, 300($t0)
		sw $t2, 308($t0)
		sw $t2, 512($t0)
		sw $t2, 520($t0)
		sw $t2, 528($t0)
		sw $t2, 540($t0)
		sw $t2, 552($t0)
		sw $t2, 560($t0)
		sw $t2, 564($t0)
		sw $t2, 772($t0)
		sw $t2, 780($t0)
		sw $t2, 792($t0)
		sw $t2, 796($t0)
		sw $t2, 800($t0)
		sw $t2, 808($t0)
		sw $t2, 820($t0)
		
		li $v0, 32
		li $a0, 2000
		syscall
		
		j main	
		
		
