section .text

; exit code in rdi as parameter - matches the syscall so we do not touch rdi
global exit
exit:
    ; no need to care about the stack as the program is going to exit so nothing after this
    mov rax, 60
    syscall
