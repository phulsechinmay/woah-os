void main() {
  char* video_memory = (char*)0xb8000;
  // Just write a simple 'H' to the terminal
  *video_memory = 'H';
}