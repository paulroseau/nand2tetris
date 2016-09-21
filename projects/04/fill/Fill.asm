// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite MAIN_LOOP that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// Pseudo-code :
// is_white = false
// is_black = false
// while (true) {
//   if (keyboard > 0 && !is_black)
//     color screen in black
//     is_black = true
//     is_white = false
//   else if (keyboard == 0 && !is_white)
//     color screen in white
//     is_white = true
//     is_black = false
// }

@is_white
M=0 // clear screen when 1, black screen when 0, initialized at 0 (black screen)

(MAIN_LOOP)
  @KBD
  D=M  // D = keyboard_input

  @NO_KEY_PRESSED
  D;JEQ

  @KEY_PRESSED
  D;JNE

  @MAIN_LOOP
  0;JMP

(NO_KEY_PRESSED)
  @pixel_color
  M=0 // set pixel color to white

  // set callback
  @RETURN_WHITE
  D=A
  @return
  M=D

  @is_white
  D=M
  
  @FILL_SCREEN
  D;JEQ // is_white == 0, ie !is_white, let's go fill the screen with pixel_color

  (RETURN_WHITE)
    @is_white
    M=1 // white screen

    @MAIN_LOOP
    0;JMP

(KEY_PRESSED)
  @pixel_color
  M=-1 // set pixel color to black

  // set callback
  @RETURN_BLACK
  D=A
  @return
  M=D

  @is_white
  D=M-1
  
  @FILL_SCREEN
  D;JEQ // is_black == 0, ie !is_black, let's go fill the screen with pixel_color

  (RETURN_BLACK)
    @is_white
    M=0 // !is_white, ie. black screen

    @MAIN_LOOP
    0;JMP

(FILL_SCREEN)
  // Let's iterate over the screen RAM with the r variable.
  // Since we set every pixel to black or white indifferently, there is no need
  // to distinguish whether incrementing r sends us to the next row or the next
  // 16 columns on physical screen.

  @SCREEN
  D=A
  @r // currently selected register in the screen RAM
  M=D

  // 1 row <-> 32 16-bit register in the screen RAM
  // End of screen RAM is at 8192 = 32 * 256 (there is 256 rows)
  @END_OF_SCREEN
  M=D // D == SCREEN here
  @8192
  D=A
  @END_OF_SCREEN
  M=D+M

  (FILL_SCREEN_LOOP)
    // Set D to END_OF_SCREEN - r 
    @END_OF_SCREEN
    D=M
    @r
    D=D-M

    // if (END_OF_SCREEN - r <= 0) return
    @return
    A=M // Selecting return breakpoint
    D;JLE 

    // Set current register with right color
    @pixel_color
    D=M
    @r
    A=M // Actually selecting the current register
    M=D // Setting the color

    // Increment r
    @r
    M=M+1
    
    // Goto next iteration
    @FILL_SCREEN_LOOP
    0;JMP
