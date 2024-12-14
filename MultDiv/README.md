# ALU
## Aaron Diefes

## Description of Design
My ALU design implements 6 operations: Add, Subtract, bitwise AND, bitwise OR, Shift Logical Left, and Shift Logical Right. The add and subtract are implemented using a 2-stage Carry Lookahead adder, and I use my subtract operation to determine if my input bits are equal, or if A is less than B. I also have an overflow detector that checks if my addition or subtraction has overflown past the 32-but limit of my ALU. My shift operations are implemented using Barrel Shifters.

## Bugs
There are no known bugs within the ALU.
