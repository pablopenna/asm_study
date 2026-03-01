@ Program 4:  Memory Copy
@ https://www.armasm.com/docs/registers-and-memory/memory-copy/
@
@ Reads data from one point in data, copies it, and then 
@ outputs the result 

.global _start 

.equ LENGTH, 7

_start:
    @@ Your code here. 

	@ I understand that I have to copy instr to outstr and then print outstr
	
	@ ARM has 13 general purpose registers R0-R12. 
	mov r12, #0
	ldr r11, =outstr
	ldr r10, =instr

	@ Start copying instr over to outstr
	.loop:
	ldrb r9, [r10]
	strb r9, [r11]	

	add r10, #1
	add r11, #1
	add r12, #1

	cmp r12, #LENGTH
	@ beq .loop @ equivalent to je in x86
	bne .loop 	@ equivalent to jne in x86

	@ Print outstr
	mov r7, #4
	mov r0, #1
	ldr r1, =outstr
	mov r2, #LENGTH
	svc 0

	@ exit
	mov r7, #1
	mov r0, #99
	svc 0

.data
instr:      .ascii      "SUMMER\n"
outstr:     .fill       LENGTH, 1, 'X'
