;---------------------
;  NASM Assembler file
;  Syscall Hello World
;---------------------
section .text
global _start

_start:
  mov eax, 0xabcdefff
.loop:
  mov r8d, eax
  shl eax, 4
  shr r8d, 28

  push rax
  ; sys_write
  mov rax, 1          ; syscall: write
  mov rdi, 1          ; fd: stdout
  mov rsi, codes  ; pointer to string
  add rsi, r8
  mov rdx, 1   ; string length
  syscall

  pop rax
  test r8d, r8d
  jnz .loop

  ; sys_exit
  mov rax, 60         ; syscall: exit
  xor rdi, rdi        ; exit code 0
  syscall

section .data
codes:
    db      '0123456789ABCDEF', 10

