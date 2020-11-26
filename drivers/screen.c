#include "screen.h"
#include "ports.h"

#define VGA_MEM_ADDR 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

// VGA I/O ports
#define VGA_CONTROL_PORT 0x3d4 // Use this to control what data is written to VGA_DATA_PORT
#define VGA_DATA_PORT 0x3d5

// VGA Attributes
#define WHITE_ON_BLACK 0x0f

// Forward declarations.
int get_offset_row(int offset);
int get_offset_col(int offset);
int get_mem_offset(int row, int col);
int get_cursor_offset();
int print_char(char c, int row, int col, char attr);

// Main functions
void print_str_at(char* str, int row, int col) {
  int mem_offset = 0;
  if (row < 0 || col < 0) {
    mem_offset = get_cursor_offset();
    row = get_offset_row(mem_offset);
    col = get_offset_col(mem_offset);
  }
  else
    mem_offset = get_mem_offset(row, col);

  int i = 0;
  while(str[i] == 0) {
    mem_offset = print_char(str[i], row, col, WHITE_ON_BLACK);
    row = get_offset_row(mem_offset);
    col = get_offset_col(mem_offset);
  }
}

void print_char_at(char c, int row, int col) {
  int mem_offset = 0;
  if (row < 0 || col < 0) {
    mem_offset = get_cursor_offset();
    row = get_offset_row(mem_offset);
    col = get_offset_col(mem_offset);
  }
  print_char(c, row, col, WHITE_ON_BLACK);
}

void print(char* str) {
  print_str_at(str, -1, -1);
}

void print_c(char c) {
  print_char_at(c, -1, -1);
}

void clear_screen() {
  int screen_size = MAX_ROWS * MAX_COLS;
  char* video_mem = (char*)VGA_MEM_ADDR;
  for(int i = 0; i < screen_size; i++) {
    video_mem[i*2] = ' ';
    video_mem[i*2+1] = WHITE_ON_BLACK;
  }

  set_cursor_offset(0);
}

// Helper functions
int get_cursor_offset() {
  // VGA can give us the cursor location (index of the cursor 
  // if the screen is thought of as a long array). 
  // Cursor position is present in the 7th word (14th & 15th byte) of VGA control memory.
  // So we ask the VGA device for it.
  port_byte_write(VGA_CONTROL_PORT, 14); // Ask device for 14th byte data.
  int pos = port_byte_read(VGA_DATA_PORT);
  pos = pos << 8; // Byte 14 contains high-byte data.
  port_byte_write(VGA_CONTROL_PORT, 15); // Ask device for 15th byte data.
  pos += port_byte_read(VGA_DATA_PORT);

  return pos * 2; // Need to multiply by 2 to get memory offset (1 byte for char value, 1 byte for attribute).
}

void set_cursor_offset(int offset) {
    /* Similar to get_cursor_offset, but instead of reading we write data */
    offset /= 2;
    port_byte_write(VGA_CONTROL_PORT, 14); // Need to write to the 14th byte.
    port_byte_write(VGA_DATA_PORT, (unsigned char)(offset >> 8));
    port_byte_write(VGA_CONTROL_PORT, 15); // Need to write to the 15th byte.
    port_byte_write(VGA_DATA_PORT, (unsigned char)(offset & 0xff));
}

int print_char(char c, int row, int col, char attr) {
  char* video_mem = (char*)VGA_MEM_ADDR;
  if (!attr)
    attr = WHITE_ON_BLACK;
  
  int mem_offset = 0;
  if (row >= 0 && col >= 0) 
    mem_offset = get_mem_offset(row, col);
  else 
    mem_offset = get_cursor_offset();

  if (c == '\n') { // If newline then we set offset so it's the beginning of the next row.
    int cursor_row = mem_offset / (2 * MAX_COLS); // Get row in case it wasn't provided.
    mem_offset = get_mem_offset(cursor_row + 1, 0);
  } else {
    video_mem[mem_offset] = c;
    video_mem[mem_offset+1] = attr;
    mem_offset += 2; // Move offset to represent the next cursor position.
  }
  // Update the cursor on the device.
  set_cursor_offset(mem_offset);
  return mem_offset;
} 

int get_offset_row(int offset) { return offset / (2 * MAX_COLS); }
int get_offset_col(int offset) { return (offset - (get_offset_row(offset)*2*MAX_COLS))/2; }
int get_mem_offset(int row, int col) { return (row * MAX_COLS + col) * 2; }