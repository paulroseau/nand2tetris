// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.

// if (R0 == 0)
//   then goto ONE_FACTOR_IS_NULL else
//   else allocate a at RAM[16] and set a to R0
  @R0
  D=M
  @ONE_FACTOR_IS_NULL
  D;JEQ
  @a
  M=D

// if (R1 == 0)
//   then goto ONE_FACTOR_IS_NULL else
//   else allocate b at RAM[17] and set b to R1
  @R1
  D=M
  @ONE_FACTOR_IS_NULL
  D;JEQ
  @b
  M=D

// Wanted to do fast exponentiation algorithm :
// b = 1 * 2^k + 0 * 2^k-1 + ... + 0 * 2^1 + 1 * 2^0
// compute
// res = a * 2^k + 0 * 2^k-1 + ... + 0 * 2^1 + a * 2^0

// pow = 0
// select = 1 (last bit is on : 0000...001)
// acc = a (a * 2^0)
// while pow < 15
//   if b & select != 0   // select bit number pow in b
//     then res = res + acc
//   pow = pow + 1
//   select = select >> 1 // shift select by one bit
//   acc = acc >> 1       // shift acc by one bit <==> * 2, acc = a * 2^k, where k is the new bit that select will select in b

// Unfortunately there is no shift operation supported by the ALU and
// consequently the C command.
// We are folding back on a more basic implemententation :
// res = a
// i = 1
// while i < b
//   res = res + a
// Tiny optimization for this dummy algorithm, iterate on the small factor :
// b = min(R0, R1)

// if (b > a) switch a and b
  @a
  D=M
  @b
  D=M-D
  @SWITCH_A_AND_B
  D;JGT

(SWITCH_A_AND_B)
// temp = a
  @a
  D=M
  @temp // allocating temp at RAM[18]
  M=D

// a = b
  @b
  D=M
  @a
  M=D

// b = a
  @temp
  D=M
  @b
  M=D

// Initialization of local variables

// we have already taken care of the case where R0 or R1 are 0 so we know b = 1
// starting iteration at 1

// acc = a
@a
D=M
@res // allocating res at RAM[19]
M=D

// i = 1
@1
D=A
@i   // allocating i at RAM[20]
M=D

(LOOP)
  // Tiny optimization
  // The following is useless as D is already worth the value @i here
  // @i
  // D=M
  @b
  D=M-D  // D = b - i
  @RETURN 
  D;JLE  // if b - i <= 0 goto RETURN

  @a
  D=M
  @res
  M=D+M  // res = res + a
  @i
  M=M+1

  D=M // part of the tiny optimization

  @LOOP
  0;JMP

// Set res to 0 and go to RETURN
(ONE_FACTOR_IS_NULL)
  @0
  D=A
  @res
  M=D
  @RETURN
  0;JMP

// Set R2 to res
(RETURN)
  @res
  D=M
  @R2
  M=D

// Infinite loop
(END)
  @END
  0;JMP
