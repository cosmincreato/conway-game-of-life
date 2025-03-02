# Conway's Game of Life
Implementation of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) in Assembly x86, using the AT&T syntax.

## Evolution

The program takes the number of rows, columns, initial living cells (with their coordinates), and a number k as input. It then computes and displays the state of the grid after k generations.

## Evolution IO

This version functions similarly, but uses C functions to read input from  [in.txt](evolution_io/in.txt) and write the output to [out.txt](evolution_io/out.txt), instead of taking input interactively.

## Encryption

In this version, the number k represents an action: 0 for encryption and 1 for decryption, rather than a generation count. The input also includes the message to be processed. The conversion rules can be found [here](https://cs.unibuc.ro/~crusu/asc/Arhitectura%20Sistemelor%20de%20Calcul%20(ASC)%20-%20Tema%20Laborator%202023.pdf).
