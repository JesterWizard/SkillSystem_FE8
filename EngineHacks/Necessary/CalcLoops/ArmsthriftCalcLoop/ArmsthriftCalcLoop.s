.thumb

@ Hook from 0802B7F8

ReturnLocation = 0x0802B828+1

StartLoop:
    mov  r9, r11  @start of unit faction array in RAM, save to a spare register
    mov  r3, #0x0 @initialize for loop
    Loop:
        ldr  r2, ArmsPointers   
        ldr  r2, [r2, r3]
        cmp  r2, #0x0       @check if there is a skill here
        beq  EndLoop        @if not, terminate the loop
            mov  r0, #0x1
            orr  r2, r0     @make sure we're in thumb mode
            mov  lr, r2
            mov  r9, r3     @copy our position in the list of Armsthrift skills
            .short 0xF800
            mov  r3, r9     @restore our position in the list
            add  r3, #0x4   @check for next skill in the loop
            b    Loop       @continue iterating through the loop

    EndLoop:
    mov  r11, r9    @restore the locaton of the unit faction array
    ldr  r3,=ReturnLocation
    bx   r3

.align
.ltorg
ArmsPointers: @ArmsLoopList in the associated event file
@POIN ArmsFunctions
@it should contain a list of pointers to functions terminated by a four bytes of 0

