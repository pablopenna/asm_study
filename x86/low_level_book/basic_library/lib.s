; From the book: Any function can accept an unlimited number of arguments. The
; first six arguments are passed in rdi, rsi, rdx, rcx, r8, and r9, respectively.
; The rest is passed on to the stack in reverse order.
;
; Return values in rax and rdx.
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

global print_char
print_char:
    mov rsi, rdi; move parameter to register used as pointer to string
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall
    ret

global print_newline
print_newline:
    push 0x0A

    mov rdi, rsp

    call print_char

    pop rax

    ret

global print_uint
; div <reg> where <reg> holds the divisor. The number being divided is 128 bits: RDX:RAX.
; After the instruction finishes RAX holds the quotient and RDX the remainder.
print_uint:
    mov rax, rdi
    mov rcx, 10 ; base 10
    sub rsp, 32 ; get 32-byte buffer in the stack. we can write from [rsp] to [rsp+31]. sub instead of add because the stack grows to lower positions.
    mov byte[rsp + 31], 0; null terminated string, print string goes from provided position and moves to upper addresses - most significant byte is 0. Since we pushed 0, we do not need to manually set the most significant byte to 0, just be carefult with overflowing
    mov r8, rsp ; pointer to buffer
    add r8, 30; Leave most significant byte as is (0), so we start in the one below. (remember the range of bytes is 0 to 7, so second to last is 6)
    mov r9, 1; written bytes counter, already count the 0 in the most significant byte.

    .loop:
    cmp r9, 32 ; prevent overflow - cannot write more than 8 bytes into buffer or we start overwriting the next element in the stack.
    jge .end

    xor rdx, rdx
    div rcx
    add dl, '0' ; convert to ASCII as print_string expects ASCII values in the address provided
    mov [r8], dl; dl = less significant byte of rdx
    dec r8 ; we write from higher address of the buffer to lower so that digits are displayed in proper order by print_string
    inc r9

    cmp rax, 0
    jne .loop

    .end:
    add r8, 1
    mov rdi, r8 ; why r8 instead of rsp? r8 contains the lowest address of the buffer written to. If we do not write 7 digits and pass rsp, the first byte read by print string is 0, thus it would consider it an empty string.
    call print_string
    add rsp, 32; similar to pop but discarding value
    ret

global print_int
; div <reg> where <reg> holds the divisor. The number being divided is 128 bits: RDX:RAX.
; After the instruction finishes RAX holds the quotient and RDX the remainder.
print_int:
    mov r8, rdi
    cmp r8, 0
    jl .negative

    .positive
    .print_plus:
    push byte 0x0
    mov byte[rsp], 0x2B
    mov rdi, rsp
    call print_char
    add rsp, 8
    jmp .finally

    .negative:
    .print_minus:
    push byte 0x0
    mov byte[rsp], 0x2D
    mov rdi, rsp
    call print_char
    add rsp, 8
    .convert_to_positive:
    neg r8

    .finally:
    mov rdi, r8
    call print_uint
    ret

global read_char
read_char:
  push 0x0
  mov rax, 0
  mov rdi, 0
  mov rsi, rsp
  mov rdx, 1
  syscall

  pop rax
  ret

global read_word
; rdi - buffer address
; rsi - buffer size
; Accepts a buffer address and size as arguments. 
; Reads next word from stdin (skipping whitespaces7 into buffer). Stops 
; and returns 0 if word is too big for the buffer specified; otherwise 
; returns a buffer address.
; This function should null-terminate the accepted string.
read_word:
  mov r8, rdi ; buffer address
  mov r10, rsi ; buffer size
  mov byte [r8 + r10 - 1], 0x0 ; set last character in buffer as null

  mov rax, 0
  mov rdi, 0
  mov rsi, r8
  mov rdx, r10
  syscall

  cmp byte [r8 + r10 - 1], 0x0 ; if it is not 0, it has been overwritten
  jne .overflow
  
  .finish:
  mov rax, r8
  mov rdx, r10
  ret

    .overflow:
  mov rax, 0
  mov rdx, 0
  ret