# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.eqv  BASE_ADDRESS    0x10008000

#   0x00RRGGBB

.text
      li $t0, BASE_ADDRESS
      li $t1, 0xff0000
      li $t2, 0xffff00
      li $t3, 0x0000ff
      li $t4, 0x00ff00

# $t0 stores the base address for display
# $t1 stores the red colour code
# $t2 stores the yellow colour code
# $t3 stores the blue colour code
# $t4 stores the green colour code

sw $t1, 0($t0)
sw $t2, 4($t0)
# paint the first (top-left) unit red.
# paint the second unit on the first row green. Why $t0+4?
sw $t3, 256($t0) # paint the first unit on the second row blue. Why +256?
sw $t4, 260($t0)
li $v0, 10 # terminate the program gracefully syscall


# fetching keyboard input
li $t9, 0xffff0000
lw $t8, 0($t9)
beq $t8, 1, keypress_happened    # if the val of 0xffff0000, then key is pressed
# but which key? --> Saved in next memory location as ascii

keypress_happened:

# ex) a pressed?
lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal
# a is pressed -> go to respond_to_a
respond_to_a:

# rand num generator 41, 42 (with range)

li $v0, 42
li $a0, 0
li $a1, 28
syscall

li $v0, 1
syscall

# sleep operation:  suspends the program for a given number of milliseconds  32 (with value)

li $v0, 32
li $a0, 1000  # 1000ms = 1s
syscall


# array = location of player and others
# determine what values stored and label the locations in memory where you’ll be storing them (in the .data section)


#initialization: clean the screen

#in the loop
#• Check for keyboard input.
#• Figure out if the player character is standing on a platform.
#• Update player location, enemies, platforms, power ups, etc.
#• Check for various collisions (e.g., between player and enemies).
#• Update other game state and end of game.
#• Erase objects from the old position on the screen.
#• Redraw objects in the new position on the screen.
#each iteration -> sleep for short time and go to the loop again



#animation

#update display 20-60 times per sec
#sleeping for 40 ms, for debuggin -> high num
#wait time -> using .eqv



#start small!












#questions
# how to jump left