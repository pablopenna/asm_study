; From the book: Any function can accept an unlimited number of arguments. The 
; first six arguments are passed in rdi, rsi, rdx, rcx, r8, and r9, respectively. 
; The rest is passed on to the stack in reverse order.
;
; Callee-saved registers must be restored by the procedure being called. So, if it needs to change them, it has to change them back.
; These registers are callee-saved: rbx, rbp, rsp, r12-r15, a total of seven registers.
section .text

; exit code in rdi as parameter - matches the syscall so we do not touch rdi
global exit
exit:
    ; no need to care about the stack as the program is going to exit so nothing after this
    mov rax, 60
    syscall

global string_length
; in - rdi contains pointer to string
; out - rax contains length of the string
string_length:
    xor rax, rax

    .loop:
    cmp byte[rdi+rax], 0
    je .end
    inc rax
    jmp .loop

    .end:
    ret

global print_string
; in - rdi contains pointer to string
print_string:
    mov r8, rdi ; string in r8
    
    call string_length
    mov r9, rax ; string length in r9

    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, r9
    syscall

    ret