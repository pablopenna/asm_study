.syntax unified 

.global _start

_start:

  @ Print
  mov r7, 4
  mov r0, 1
  ldr r1, text
  mov r2, 20
  svc 0

  @ Exit
  mov r7, 1
  mov r0, 0
  svc 0

.data
  text: .ascii "Ni hao wode pengyou\n"
