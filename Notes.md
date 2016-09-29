# Project 1 :
Remark : the `if` notion is encoded by the Mux and DMux chips.

# Project 2 :
How does the lookahead carry forward is actually cabled ?

# Project 3 :
How is a D Flip Flop actually made ? (Start of answer in perspective video)

Putting a D Flip Flop in a circuit actually creates 2 time slots. How can we be
sure that everything is synchronized (ie. that the first time slot part of the
chip is actually stabilized before the second time slot inputs are emitted) ?
I assume that we cannot create arbitrarily long circuits, and that we need to
interleave long sequences of chips with D Flip Flops so that signals in all
branches progress at the same pace.

# Project 4 :
It seems that we can access ROM and RAM indifferently with the `@` instruction
according to the context :
```
@21 // mere A instruction, this addresses RAM[21]
// VS
M=D;JEQ // C instruction, JEQ will then go to ROM[21]
```
How is this possible ? May be answered in project 5
Moreover as ROM is read-only, I guess that a written program gets loaded in the
RAM. In this case the C instruction jump part needs to refer to the RAM and not
the ROM ... :-|

We have seen that the screen outputs and the keyboard input are mapped in RAM.
You can change the screen by writing bits in the corresponding region of the
RAM. You can also read in this part what bits of the screen are on and off.

You cannot write in the keyboard mapped part of the RAM.
It is now quite clear that the 16-bits of this part of the RAM just represent
which key is pressed. Once a driver for this keyboard is installed, there is
some other place in the RAM where you can look up which key has been actually
pressed, ie. the correspondance between 16-bit sequence and some standard
symbol.

Question though, it is still not clear at which frequence does the hardware
check for the input of the keyboard. Does this depend on the program being
currently executed ? Is there a distinct circuit in the CPU that is connected to
this part of the RAM and which reacts to it in such a way some treatment is
already done ... etc ? 
This boils down to the question of concurrency, how are concurrent tasks being
executed ? Probably this is handled at the software level. However, as the
signal of a pressed key is so quick, if there is no mechanism to record/buffer
the various keys input by the hardware somewhere, the software will probably
loose some information.
My guess right now is that the content of this keyboard register in RAM is
automatically appended to some other place in RAM, at least temporarily, so that
the software that should handle the keyboard can catch up the events it missed
when it is given a chance to execute by the scheduling part of the software.

Interesting fact about machine language and assembler.
The assembler is specific to the hardware architecture. For example the "heap"
starts at RAM[16], so the assembler will take this as an input to translate
variables to their corresponding address. Other example, when we will build the
overall computer architecture, we will map the screen memory at some address in
the RAM, let's say 123, and this will be taken as an input by the assembler as
well. Same thing for the keyboard...

I think that all what a driver does is expose the reading and writing of bits
in this section at a little higher level, as functions that implements some API
given by the OS/kernel. I believe that the machine language code for these
functions are to be put somewhere, and the driver copies paste this machine
language code at the right spots.

# Project 5 :

No particular remarks or questions.
