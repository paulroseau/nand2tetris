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

- Introduction to sequential logic, a logic with the notion of time :
  eg : if x[t] then y[t+1] = 1 else y[t+1] = 0

- Physical implementation of sequential logic relies on D-Flip Flops that act
  like buffers for one quantum of time : out[t + 1] = int[t].
  
- These can be constructed from 2 Nand gates of which outputs are bound to the
  other one inputs. Detailed implementation not discussed in the course, but one
  would need 2 such pairs of connected Nand gates and one clock.

- From aa D-Flip Flop you can build 1 bit which can be set and then keeps this
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

# Week 5

- Description of the Von Neuman architecture :
  * 1 CPU that fetches data and executes instruction
  * 1 Memory where data and instructions are stored

- The Harvard architecture is a variation of the Von Neuman architecture.
  Instead of multiplexing wheter we are reading instruction or data in from of
  the memory, there are actually 2 different memory unit :
  * ROM (Read-Only Memory) that stores instructions
  * RAM (Random Access Memory) that stores data

- Harvard architecture is well suited for programs embedded in hardware that is
  supposed to do one thing, whereas Von Neuman architecture is more general but
  a little more complex. 
  
- In Von Neuman architecture, there is a multiplexer between the program counter
  and the address register (output of the CPU) :
  * one cycle out of two the output of this multiplexer is the next instruction
    to fetch
  * one cycle out of two it outputs the data to read from/write to

- There must be a demultiplexer on the input side of CPU as well :
  * one cycle out of two the input of this demultiplexer is the next instruction to execute
  * one cycle out of two it inputs the relevant data

- Execution should occur one cycle out of two as well (either when data just
  comes in or when instruction just comes in).

- In the Hack architecture (Harvard like), CPU is made of :
  * one register D that stores data
  * one register A that stores the address of the data to access
  * one PC (Program Counter)
  * one ALU (Arithmetic Boolean Unit)

- Check project or slide to have a more precise idea of how these components are
  connected.

- Important remark : Registers and PC in the CPU are clocked and so are the ROM
  and the RAM are clocked. However the ALU inside the CPU is not. 
  All these components are synchronized :
  * at the "tock" instant : we have reached a state of electrical equilibrium. 
  Potential is set everywhere according to in[t] and out[t] of every D-Flip-Flop
  in the circuit.
  * at the "tick" instant : D-Flip-Flops let the electrical current flow inside
    them, which transfers the value from in to out instantanously. Potential is
    not set anywhere. It will stabilize untill the next "tock" instant.
  One cycle goes from one "tock" instant to the next "tock" instant. Right after
  the first "tock" instant, there is a "tick" instant, then followed by some
  period of time untill the second "tock" instant.

- To load PC we need data to go through register A and then through PC. Thus PC
  is loaded with the content of A at t-1. This means that if you do :
  ```
  @3
  D=5
  A=D+1;JMP 
  ```
  Here you will jump at 3 and not at 6 since PC input is 3 at t-1 and A input is
  6 at t-1.  When this third line gets executed, A outputs 6, and PC outputs 3

- Notice that the whole Computer is a closed circuit. That is the output of some
  DFF are the input of other ones.
  At each "tick" of the clock, inputs become outputs : 
  * the PC outputs a new instruction address IAddr1.
  * the addressM outputs a new data address DAddr1.
  * the RAM and ROM output the data and instructions previously
    selected, Data1 and Instr1.
  At each "tock" of the clock, we have reached equilibrium :
  * IAddr1 and DAddr1 flow to the ROM and RAM which "preselect" Instr2 and
    Data2 (ie. Instr2 and Data2 are inputs to corresponding D-Flip-Flops). 
  * Data1 and Instr1 have flown through the CPU which is ready to output IAddr2
    and DAddr2.

- A computer (ie. CPU + Memory) can be represented theortically by a finite state machine,
  from which we can easily derive a physical implementations. Transitions are
  triggered by the clock, and state lies in registers.

- In real life computers there is some hardware called `device controller` that
  handle the peripherics directly to not overload the CPU. 
  
- For example, the CPU doesn't write in memory all the bits required to color
  the screen. Instead it writes in the memory of a a graphics card which has a
  higher level API (eg. : "draw a line between (x0, y0) and (x1, y1)).
