section .text
global _start
extern exit
extern string_length

_start:
  mov rdi, codes
  call string_length

  mov rdi, rax
  call exit

section .data
codes: db '0123456789ABCDEF', 0x0
newline: db 10