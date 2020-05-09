; Make BIOS output 'Hello world'
mov ah, 0x0e ; Tele-type output mode for BIOS interrupt
mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
int 0x10
mov al, 'o'
int 0x10
mov al, ' '
int 0x10
mov al, 'W'
int 0x10
mov al, 'o'
int 0x10
mov al, 'r'
int 0x10
mov al, 'l'
int 0x10
mov al, 'd'
int 0x10

jmp $ ; Infinite loop

; Padding with 0s until magic number
TIMES 510-($-$$) db 0

; Magic number
dw 0xaa55