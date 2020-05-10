; BIOS places bootloader at 0x7C00, so all addresses should be offset by that
[org 0x7C00]
MOV bp, 0x8000 ; Move block pointer away from 0x7C00 so stack has space
MOV sp, bp

MOV bx, MSG_REAL_MODE
CALL print

CALL switch_to_protected_mode

%include "bios-level-functions/bootsector-print-func.asm"
%include "protected-mode-gdt.asm"
%include "protected-mode-print.asm"
%include "protected-mode-switch.asm"

[bits 32]
begin_protected_mode:
  MOV ebx, MSG_PROTECTED_MODE
  CALL print_string_pm
  JMP $ ; Infinite loop here

MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROTECTED_MODE db "Loaded 32-bit protected mode", 0

; Padding with 0s until magic number
TIMES 510-($-$$) db 0

; Magic number
dw 0xaa55