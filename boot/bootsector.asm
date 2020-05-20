; BIOS places bootloader at 0x7C00, so all addresses should be offset by that
[org 0x7C00]

  ; BIOS stored boot drive index in dl, thus store the value for later
  MOV [BOOT_DRIVE_INDEX], dl

  ; Move block pointer away from 0x7C00 so stack has space
  MOV bp, 0x9000 
  MOV sp, bp

  ; Print that we are starting off in 16 bit real mode
  MOV bx, MSG_REAL_MODE
  CALL print
  CALL print_nl

  CALL load_kernel

  CALL switch_to_protected_mode

%include "bios-level-functions/bootsector-disk.asm"
%include "bios-level-functions/bootsector-hex-print-func.asm"
%include "bios-level-functions/bootsector-print-func.asm"
%include "protected-mode-gdt.asm"
%include "protected-mode-print.asm"
%include "protected-mode-switch.asm"

[bits 16]
load_kernel:
  MOV bx, MSG_LOADING_KERNEL
  CALL print

  ; bx contains where the data from disk should be loaded
  MOV bx, KERNEL_OFFSET ; Note: es is 0, thus es:bx is just bx
  MOV dh, 15 ; Load 15 sectors to overshoot the size of our kernel
  MOV dl, [BOOT_DRIVE_INDEX] ; Load the boot drive index that we stored before
  CALL disk_load

  ret

[bits 32]
begin_protected_mode:
  MOV ebx, MSG_PROTECTED_MODE
  CALL print_string_pm

  ; Jump to the entrypoint of our kernel
  call KERNEL_OFFSET

  JMP $ ; Infinite loop here

KERNEL_OFFSET equ 0x1000
BOOT_DRIVE_INDEX db 0
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROTECTED_MODE db "Loaded 32-bit protected mode", 0
MSG_LOADING_KERNEL  db "Loading  kernel  into  memory.", 0

; Padding with 0s until magic number
TIMES 510-($-$$) db 0

; Magic number
dw 0xaa55