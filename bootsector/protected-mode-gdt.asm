gdt_start:

gdt_null_descriptor: ; First entry of gdt should be an 8-byte 0
  dq 0x0

gdt_code: 
  dw 0xffff    ; segment length, bits 0-15
  dw 0x0       ; segment base, bits 0-15
  db 0x0       ; segment base, bits 16-23
  db 10011010b ; flags (8 bits)
  db 11001111b ; flags (4 bits) + segment length, bits 16-19
  db 0x0       ; segment base, bits 24-31

; GDT for data segment. base and length identical to code segment
; some flags changed, again, refer to os-dev.pdf
gdt_data:
  dw 0xffff
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0

gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_start - 1 ; 16 bit size of GDT, should be one less than actual size
  dd gdt_start ; 32 bit start address of GDT

; Constants to use in main files
CODE_SEGMENT equ gdt_code - gdt_start ; Get offset of code segment into GDT
DATA_SEGMENT equ gdt_data - gdt_start ; Get offset of data segment into GDT