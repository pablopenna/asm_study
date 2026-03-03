// https://arm64.syscall.sh/
.global _start

.data
	msg: .ascii "Hello World!\n"
	length = . - msg

.text

_start:
	mov x8, 0x40
	mov x0, 1
	ldr x1, =msg
	ldr x2, =length
	svc 0

	mov x8, 0x5D
	mov x0, 0
	svc 0
