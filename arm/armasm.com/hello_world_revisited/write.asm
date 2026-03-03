.macro print_str strp len
  mov r7, #4
  mov r0, #1
  ldr r1, =\strp
  ldr r2, =\len
  ldr r2, [r2]
  svc #0
.endm

.macro print_char_in_var var
  mov r7, #4
  mov r0, #1
  ldr r1, =\var @ r1 has to contain an address
  mov r2, #1
  svc 0
.endm

.macro print_char_addr_in_r1
  mov r7, #4
  mov r0, #1
  mov r2, #1
  svc 0
.endm

@ TODO> Print value of char contained in R9 
@ mov r9, #'A'

.macro print_strnull strp
  mov r11, #0
  ldr r10, =\strp

  .loop:
  mov r1, r10  @ Copy the address of the character in memory to r1
  print_char_addr_in_r1 @ Print the character

  ldrb r9, [r10] @ Load the value of the character in r9
  add r10, #1 @ Point to next character
  cmp r9, #0 @ Check if the character is null
  bne .loop @ Iterate if the character is not null
.endm
