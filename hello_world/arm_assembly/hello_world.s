.global _start

.section .data
msg: .asciz "Hello from ARM!\n"

.section .text
_start:
    // Write "Hello from ARM!\n" to stdout
    mov r0, #1              // File descriptor 1 is stdout
    ldr r1, =msg            // Address of the message
    ldr r2, =15             // Length of the message
    mov r7, #4              // System call number for sys_write
    swi 0                   // Make the system call

    // Exit the program
    mov r7, #1              // System call number for sys_exit
    mov r0, #0              // Exit code 0
    swi 0                   // Make the system call

