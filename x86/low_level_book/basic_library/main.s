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

_start:
  ; first word
  mov rdi, hello
  mov rsi, hello_len
  call read_word

  mov rdi, rax
  call print_string
  call print_newline

  ; second word
  mov rdi, hello
  mov rsi, hello_len
  call read_word

  mov rdi, rax
  call print_string
  call print_newline

  mov rdi, 0
  call exit

section .data
codes: db '0123456789ABCDEF', 0x0
plus: db 0x2B
minus: db 0x2D
newline: db 10
hello: db 'Hello World'
hello_len: equ $ - hello