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
  Instead of multiplexing whether we are reading instruction or data from
  the memory, there are actually 2 different memory units :
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
  * At each "tick" of the clock (instants "N+" in the hardware simulator),
    inputs of registers in the CPU are set everywhere but are not output yet :
    we are in a state of electrical equilibrium.
  * At each "tock" of the clock (instants "N"), each registers in the CPU
    actually outputs its input value. InstructionAddress and DataAddress change
    and affect the ROM and RAM immediately, at least in the simulator.

- Even though we have an Harvard architecture, we still have 2 cycles.
  These two cylces are executed sequentially.

- Illustration (as we see things in the Hardware simulator for chip Computer.hdl) :

  time  state ROM    input PC   state PC   input ROM (output PC)
            0           0           0              0
  tick      0           0          @10             0             (execute)
  tock     @10         @10         @10            @10            (fetch)
  tick     @10         @10         @11            @10            (execute)
  tock     @11         @11         @11            @11            (fetch)
  tick     @11         @11         @24            @11            (execute)
  tock     @24         @24         @24            @24            (fetch)
  ...

  Notice that with in this simplified representation : input ROM = state ROM = input PC 
  In the hardware simulator we skip the cycle where the ROM state is updated.

- Detailed illustration :

  time  state ROM   input PC   state PC   input ROM (output PC)
            0          0           0              0
  tick      0          0          @10             0              (execute - start)
  tock      0          0          @10            @10             (execute - end)
  tick     @10         0          @10            @10             (fetch - start)
  tock     @10        @10         @10            @10             (fetch - end)
  tick     @10        @10         @11            @10             (execute - start)
  tock     @10        @10         @11            @11             (execute - end)
  tick     @11        @10         @11            @11             (fetch - start)
  tock     @11        @11         @11            @11             (fetch - end)
  tick     @11        @11         @24            @11             (execute - start)
  tock     @11        @11         @24            @24             (execute - end)
  tick     @24        @11         @24            @24             (fetch - start)
  tock     @24        @24         @24            @24             (fetch - end)
  ...

  Here we have detailed the update cycle of the ROM (the fetch cycle). 

  Here I have assumed that as long as the input PC does not change, the state of
  PC doesn't change as well. However in theory, after one clock cycle the PC is
  incremented by one. So the above is wrong... but this is the behaviour
  observed from the hardware simulator.

- Explanation after reading : http://labs.domipheus.com/blog/tpu-series-quick-links/
  * In part 3 and 4 : 
    - Definitions of the instruction decoder and of the ALU. What the decoder
      does is basically forwarding its inputs to the ALU, doing some grouping
      and splitting to match ALU inputs. This corresponds to the operation of
      sending the 'c' control bits on the CPU_schema picture. Here it has been
      properly isolated as a chip itself so the CPU looks like a chip pipeline
      starting with the sequence : Decoder -> ALU -> ...
    - Both of these chips have an enable pin which needs to be set at '1' if
      there are to output what is expected (there must be a multiplexer at first
      taking the enable pin as one of its input).
    - Both of these chips are clocked. This means that their state change at the
      rising edge of the clock (it could be the falling edge, but in the tpu
      series, the vhdl source code features rising edge).
      Remember that the clock is a simple square signal ('1' for half of the
      cycle, '0' for the other half). The physical implementation of rising edge
      change is done via D Flip-Flops (connected to the clock) of which inner
      state and (delayed) output change at the rising edge of the clock. The
      mere use of DFF in your chip will make it clocked.
      Check the corresponding electronic circuit on wikipedia at (paragraph
      "Classical positive-edge-triggered D flip-flop"): 
      https://en.wikipedia.org/wiki/Flip-flop_(electronics)
      NB : You can implement a rising edge detector on a lower frequency than
      the one of  the clock with that kind of circuit : 
      http://fpgacenter.com/examples/basic/edge_detector.php
  * In part 5 :
    - The above chips are wired (along with a third one, always enabled and
      clocked, that performs write back to memory). Then a test script is played
      (both Decoder and ALU enable pin are enabled all the time, check the 'en'
      signal below the 'clock' signal). As chips are piped we notice that we
      need to wait for 2 clock cycles in order to reach a stable state, 3 when
      we are writing back the result to the same register from which we are
      reading.
    - Since adding wait cycles is not a tractable approach if we want to chain
      operations : we would need to add the right amount of wait cycles between
      each operation. Thus we add a control unit of which output is a bitmask
      (0010 for example) corresponding to the currently active state in the
      pipeline, as well as a reset and clock input. At each rising edge of the
      clock the bitmask changes to the next state. Each bit is connected to the
      enable pin of one chip in the pipeline. Thus each chip is activated
      alternatively.
  * In part 6 :
    - Definition of the PC in a very similar fashion to what is done in
      nand2tetris. However, here it is pointed out, that when assigning the PC
      to some address, we need to wait for the termination of the ALU stage.
      Thus the input of the PC is for some given stages NOP (ie. halt - don't do
      anything) and for some others it is either reset, incremented, or set to
      some arbitrary value. 
  
  It is key to notice here that the control unit lets us implement a proper
  finite state machine, that lets information propagate synchronously at the
  cost of adding some delay cycles. This is not so clear in the CPU_schema (for
  which the implementation is actually wrong, since the PC can get off sync when
  assigned to a specific address rather than just being incremented).

  NB : In part 10 of the series, interrupts are tackled. The way they are
  implemented in the hardware consists basically in adding an extra stage in the
  control unit for handling an interrupt. To get into this stage the
  interrupt input must be enabled. What this stage does is :
   - acknowledging the interrupt, emiting a '1' on the interrupt output pin
   - saving the current PC to some register for later
   - disabling the interrupt for the time this one gets handled
   - setting the PC to the handler
  During this time the external device (upon reception of the interrupt ACK,
  sends the data to be processed). You can get a rough idea of what is going on
  here :
  https://github.com/Domipheus/TPU/blob/master/vhdl/core/control_unit.vhd#L128

- A computer (ie. CPU + Memory) can be represented theortically by a finite state machine,
  from which we can easily derive a physical implementations. Transitions are
  triggered by the clock, and state lies in registers.

- In real life computers there is some hardware called `device controller` that
  handle the peripherics directly to not overload the CPU. 
  
- For example, the CPU doesn't write in memory all the bits required to color
  the screen. Instead it writes in the memory of a a graphics card which has a
  higher level API (eg. : "draw a line between (x0, y0) and (x1, y1)).
