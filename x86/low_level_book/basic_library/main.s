section .text
global _start
extern exit

_start:
  mov rdi, 69
  call exit

section .data
codes:
    db      '0123456789ABCDEF'
newline: db 10