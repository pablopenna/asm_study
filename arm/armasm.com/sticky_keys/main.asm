@ Program 6:  Hello World Revisited
@ https://www.armasm.com/docs/branches-and-conditionals/sticky-keyboard/
@
@ My keyboard sucks. Thanks Apple. The keys stick badly. (They don't really)
@ Write a program that takes a string and removes the duplicate letters. 
@
@

.include "write.asm" 
.include "exit.asm" 

.global _start 

@ r9 - pointer index of the input string
@ r10 - poiner index of the output string
@ r11 - last character printed
@ r12 - current character
.macro print_sticky_keys addr_in addr_out
  .init:
    mov r11, #0 
    ldr r10, =\addr_out
    ldr r9, =\addr_in

  .begin:
    ldrb r12, [r9]
    cmp r12, r11
    beq .evaluate_loop

  .print:
    @print_char_pointed_by_r9
    strb r12, [r10]
    add r10, #1 
    mov r11, r12

  .evaluate_loop:
    add r9, #1 
    cmp r12, #0
    bne .begin

.endm

_start: 
  print_sticky_keys instr outstr
  nullwrite outstr
  exit #0

.data 
instr:      .ascii      "I jjjjust   waaaaant thhhis stuppppid " 
            .asciz      "tttthinggggg tooooo wwwwworrrrrrrk!!!!!!!    111233334555667888999\n"
outstr:     .fill       128, 1, 0     @ Reserve 128 bytes
