; Subroutine that loads sectors address pointed to by [es:dx]
disk_load:
  pusha
  push dx

  mov ah, 0x02 ; 'Read' function of BIOS interrupt 0x13
  mov al, dh
  mov cl, 0x02 ; First sector is bootloader, second sector is remaining data
  mov ch, 0x00 ; Zero-th cylinder
  ; dl has head number, set by caller. given by BIOS
  mov dh, 0x00 ; Head number

  int 0x13 ; Disk interrupt
  jc disk_error ; Carry bit set if error in reading

  pop dx
  cmp al, dh ; BIOS sets al to number of sectors read, check for consistency
  jne sectors_error
  popa
  ret

disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah ; ah = error code, dl = disk drive that dropped the error
    call print_hex ; check out the code at http://stanislavs.org/helppc/int_13-1.html
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0