;---------------------
;  NASM Assembler file
;  Syscall Hello World
;---------------------
section .text
global _start

; receives parameter in rax
; prints contents of rax in hexadecimal
print_hex:
  push rax
  push r8
  push rdi
  push rsi
  push rdx
  
  .loop:
  mov r8, rax
  shl rax, 4
  shr r8, 60
  
  push rax
  ; sys_write
  mov rax, 1
  mov rdi, 1
  lea rsi, [codes + r8]
  mov rdx, 1
  syscall
  
  pop rax
  cmp rax, 0
  jne .loop
  
  ; sys_write
  mov rax, 1
  mov rdi, 1
  mov rsi, newline
  mov rdx, 1
  syscall
  
  pop rdx
  pop rsi
  pop rdi
  pop r8
  pop rax
  ret

_start:
  mov ax, [demo1]
  call print_hex
  
  mov rax, [demo1]
  call print_hex
  
  mov rax, [demo2]
  call print_hex
  
  mov rax, [demo3]
  call print_hex

  ; sys_exit
  mov rax, 60         ; syscall: exit
  xor rdi, rdi        ; exit code 0
  syscall

section .data
codes:
    db      '0123456789ABCDEF'
newline: db 10
demo1: dq 0xAABBCCDDAABBCCDD
demo2: db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88
demo3: db 0x11
demo4: db 0x22
demo5: db 0x33
demo6: db 0x44
