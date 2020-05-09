; Bootloader places bootsector
[org 0x7C00]
mov bp, 0x8000 ; Move block pointer away from 0x7C00 so stack has space
mov sp, bp

mov bx, 0x8500 ; es:bx = 0x0000:0x8500 = 0x08500
mov dh, 2 ; Need to read 2 sectors
call disk_load

mov dx, [0x8500] ; Get the the first 4 bytes of the sectors read
call print_hex

call print_nl

mov dx, [0x8500 + 512] ; first 4 bytes from second loaded sector
call print_hex

jmp $

%include "bootsector-hex-print-func.asm"
%include "bootsector-print-func.asm"
%include "bootsector-disk.asm"

; Padding with 0s until magic number
TIMES 510-($-$$) db 0

; Magic number
dw 0xaa55

; Next two 512 byte sectors contain data
TIMES 256 dw 0xAAAA
TIMES 256 dw 0xBBBB