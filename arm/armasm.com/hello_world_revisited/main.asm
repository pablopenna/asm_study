.global _start

.include "write.asm"
.include "exit.asm"

_start:
  print_str msg, len

  ldr r1, =nl
  print_char_addr_in_r1

  print_char_in_var char
  
  ldr r1, =nl
  print_char_addr_in_r1
  
  print_strnull msg

  exit #0

.data 
  msg: .ascii "Hello my friend\n\0"
  msg2: .asciz "Bye\n"
  len: .word 5
  char: .byte 'A'
  nl: .byte '\n'

