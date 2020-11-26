#include "../drivers/screen.h"

int print_to_terminal() {
  print_char('D', 0, 0, 0x0f);
  print_char('D', 0, 1, 0x0f);
}

void main() {
  print_to_terminal();
}