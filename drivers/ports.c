#include "ports.h"

/*
Inline assembly syntax:
__asm__(<assmebly_command_str> : <read_values> : <write_values>)
*/

// Read a byte from the given port and return it.
unsigned char port_byte_read(unsigned short port) {
  unsigned char value;
  __asm__("in %%dx, %%al": "=a" (value) : "d" (port));
  return value;
}

// Read a word from the given port and return it.
unsigned short port_word_read(unsigned short port) {
  unsigned short value;
  __asm__("in %%dx, %%ax": "=a" (value) : "d" (port));
  return value;
}

// Write the given byte into the specified I/O port.
void port_byte_write(unsigned short port, unsigned char value) {
  __asm__("out %%al, %%dx": : "a" (value), "d" (port));
}

// Write the given word into the specified I/O port.
void port_word_write(unsigned short port, unsigned short value) {
  __asm__("out %%ax, %%dx": : "a" (value), "d" (port));
}