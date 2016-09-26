# Week 1 :

- Introduction to boolean logic : boolean functions and truth tables.

- Results : 
  * Any boolean function can be encoded via Disjunction of conjunctions.
  * Finding the simplest expression is NP-complete.
  * Disjunctions of conjunctions are written only with `not`, `and` and `or`.
  * `not`, `and` and `or` can be all be expressed in terms of `nand`.

- Nand chips let you implement physically boolean functions.

- Project : write several basic boolean functions in terms of Nand gates.

# Week 2 :

- Representations of integers on 16-bits (base 10 vs bas 2)

- Representation of negative numbers : same representation as the number + 2^16.
  I guess it is the formatting of the number that lets you interpret the number
  as between 0 and 2^16 - 1 or between -2^15 to 2^15 - 1.
  Note : other representation of negative numbers has been mentionned. First
  bit gives the sign, and the rests of the bits gives the absolute value. Lots
  of inconvenience with this representation, in particular : two representations
  of 0.

- When performing additions drop out the last carry (equivalent to additions
  modulo 2^16)

- Description of adders, and ALU (kind of mega-multiplexer : according to side
  inputs chain various computations on x and y (inputs).

# Week 3 :

- Introduction to sequential logic. Logic where there is the notion of time :
  eg : if x[t] then y[t+1] = 1 else y[t+1] = 0

- Physical implementation of sequential logic relies on D-Flip Flops that acts
  like a buffer for one quantum of time : out[t + 1] = int[t].
  
- These can be constructed from 2 Nand gates of which outputs are bound to the
  other one inputs. Detailed implementation not discussed in the course, but one
  would need 2 such pairs of connected Nand gates and one clock.

- From D-Flip Flops you can build 1 bit which can be set and then keeps this
  value untill it is set back to some other value by piping its output to one of
  its input branch.

- Then you can build : Registers (8 bits), RAM (N numbers of registers), PC
  (Program Counter) which is incremented by one at each increment of time, or
  reset to some other value.

- Project : implementation of 1 Bit, Registers, RAM, and PC

# Week 4

- Description of a machine language for the HACK architecture that we will build
  in week 5.

- The machine language instructions are made of 16 bits.

- The resulting program is then loaded in the ROM (Read-Only memory) (I guess in
  real computers those can also be loaded in some part of the RAM). This
  physically means setting some bits to 0 and 1, ie. switching them on and off.
  Once under power, electrical signal will flow in a way that can be controlled
  from a higher level by the programmer !

- There are a few registers close to memory, which are denoted by D, A and M in the Hack
  machine language. 
  
- There are 2 kind of instructions : 
  * A-instruction : which sets the A registers and of which side effect is to
    set the M register to the content that is in RAM at the address stored in the
    content of A.
  * C-instruction : which sets up the input bits for the ALU, the bits of the
    ALU to compute something, where to write the result back, and sets the PC to
    the next instuction according to the result.

- These 2 instuctions are encoded on 16-bits, A instructions starts by 0 and
  C-instuction by 1.

- You can write machine language program in an assembly language that gets
  compiled to binary format by a program named "Assembler".

- Inputs and outputs are controlled by connecting their physical pins into
  RAM. Setting bits in those RAM parts will send the subsequent electrical
  signal to the output device which will react accordingly (eg. switching each
  pixels of a screen on/off). Reading those bits will let you read the signal
  emitted by the pins of an input device (eg. key pressed on a keyboard). How to
  interpret those bits can be done by loading a driver program I guess.

- Project : Implement two programs in assembly language : 
  * multiply RAM[0] and RAM[1] and put the result in RAM[2]
  * fill the screen in black when input is received from the keyboard
