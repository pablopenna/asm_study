.global _start


_start:

	@ write syscall
	mov r7, #4
	mov r0, #1
	ldr r1, =hello
	mov r2, #12 @ length of the string contained in the 'hello' address
	svc 0

	@ exit syscall	
	mov r7, #1
	mov r0, #0
	svc 0

	.data
	hello: .ascii "Hello world\n"
