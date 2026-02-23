@ Program 3:  Find the Otter 
@ https://www.armasm.com/docs/registers-and-memory/find-the-otter/
@
@ Reads pre-loaded values in the registers and writes 
@ OTTER to STDOUT 

.global _start 

_start: 
    @@@@@@@@@@@@@@@@ Begin Register Preload 
    mov     r0, #'P' 
    mov     r1, #'O'
    mov     r2, #'I'
    mov     r3, #'U'
    mov     r4, #'Y'
    mov     r5, #'T'
    mov     r6, #'R'
    mov     r7, #'E'
    mov     r8, #'W'
    mov     r9, #'Q'
    @@@@@@@@@@@@@@@@ End Register Preload 

    @ Write your program here!!! 
    ldr r10, =outstr
    strb r1, [r10] @ 'O'

    add r10, #1
    strb r5, [r10] @ 'T'

    add r10, #1
    strb r5, [r10] @ 'T'

    add r10, #1
    strb r7, [r10] @ 'E'
    
    add r10, #1
    strb r6, [r10] @ 'R'

    @ Write string to output
    mov r7, #4
    mov r0, #1
    ldr r1, =outstr
    mov r2, #11
    svc 0

    @ Exit
    mov r7, #1
    mov r0, #0
    svc 0

.data 
  outstr: .ascii "##########\n"
