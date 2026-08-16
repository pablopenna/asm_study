section .text
global _start
extern exit
extern string_length
extern print_string
extern print_char
extern print_newline
extern print_uint
extern print_int

_start:
  mov rdi, codes
  call print_string
  call print_newline

  mov rdi, plus
  call print_char
  call print_newline

  mov rdi, minus
  call print_char
  call print_newline

  mov rdi, 0xFFFFFFFFFFFFFFFF
  call print_uint
  call print_newline

  mov rdi, 0xFFFFFFFFFFFFFFFF
  call print_int
  call print_newline

  mov rdi, 0
  call exit

section .data
codes: db '0123456789ABCDEF', 0x0
plus: db 0x2B
minus: db 0x2D
newline: db 10