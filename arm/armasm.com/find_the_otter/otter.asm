.global _start

.text

  _start:
    mov r7, #1
    mov r0, #99
    svc 0

.data

  outstr: .ascii "          \n"
