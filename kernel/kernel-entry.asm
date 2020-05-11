[bits 32] ; This runs in 32 bit protected mode
[extern main] ; main is defined by our kernel.c

CALL main
JMP $ ; Should never run