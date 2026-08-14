section .text
global _start
extern exit
extern string_length
extern print_string
extern print_char
extern print_newline

_start:
  mov rdi, codes
  call print_char
  call print_newline

  mov rdi, 0
  call exit

section .data
codes: db '0123456789ABCDEF', 0x0
newline: db 10