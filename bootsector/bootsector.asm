loop:
  jmp loop

; Padding with 0s until magic number
TIMES 510-($-$$) db 0

; Magic number
dw 0xaa55