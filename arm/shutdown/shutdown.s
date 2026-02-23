.global _start

_start:

mov r7, #125
mov r0, #0 @ ????
mov r1, #1 @ ????
svc 0

mov r7, #1
mov r0, #0
svc 0
