
// Main functions
void print(char* str);
void print_c(char c);
void print_str_at(char* c, int row, int col);
void print_char_at(char c, int row, int col);
void clear_screen();

// Helper functions
int print_char(char c, int row, int col, char attr);
int get_screen_offset(int row, int col);
int get_cursor_pos();
void set_cursor_offset(int offset);