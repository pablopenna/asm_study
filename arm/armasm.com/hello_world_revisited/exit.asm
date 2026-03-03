.macro exit code
  mov r7, #1
  mov r0, \code
  svc 0
.endm
