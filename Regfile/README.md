# REGFILE
## Aaron Diefes

## Description of Design
My RegFile contains 32 32-bit registers, and supports 2 read ports and 1 write port. The design utilizes decoders to decode the control bits that specify which of the 32 registers to access, and tri-state buffers to successfully choose the correct read data. 

## Bugs
There are no known bugs within the RegFile.
