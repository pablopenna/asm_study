section .text
global _start
extern exit
extern string_length
extern print_string
extern print_char
extern print_newline
extern print_uint
extern print_int
extern read_char
extern read_word
extern parse_uint

_start:
  mov rdi, test_number_to_parse
  call parse_uint
  
  .end:
  mov rdi, 0
  call exit

section .data
test_number_to_parse: db '20251219', 0x0
codes: db '0123456789ABCDEF', 0x0
plus: db 0x2B
minus: db 0x2D
newline: db 10
hello: db 'Hello World'
hello_len: equ $ - hello
buffer: times 64 db 0xFF