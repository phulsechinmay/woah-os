[bits 16]
switch_to_protected_mode:
  CLI ; Turn interrupts off
  LGDT [gdt_descriptor] ; Load the GDT using the gdt_descriptor

  ; Enable protected mode using bit 0 of CR0
  ; NOTE: We're using 32-bit registers in 16 bit real mode, but the assembler
  ; changes the instructions accordingly so the same operation happens using 
  ; 16 bit instructions
  MOV eax, cr0
  OR eax, 0x1
  MOV cr0, eax

  ; Need to make sure that all instructions in the pipeline finish
  ; and protected mode is enabled in CR0. We do this using a FAR
  ; jump, achieved using a JMP instruction that specfies both the
  ; segment and the offset within the segment.
  JMP CODE_SEGMENT:initialize_protected_mode

; Following instructions are in 32-bit protected mode
[bits 32]
initialize_protected_mode:
  ; Update all segment registers to point to the correct segment offset now
  MOV ax, DATA_SEGMENT
  MOV ds, ax
  MOV ss, ax
  MOV es, ax
  MOV fs, ax
  MOV gs, ax

  ; Set stack pointer to some high value
  MOV ebp, 0x90000
  MOV esp, ebp

  CALL begin_protected_mode
