.thumb

@ Hook from 0802B7F8

ReturnLocation = 0x0802B828+1

StartLoop:
    mov r3, r9  @copy over the unit faction array location from r3
    push {r3}   @save it on the stack
    mov  r3, #0x0 @initialize for loop
    Loop:
        ldr  r2, ArmsPointers   
        ldr  r2, [r2, r3]
        cmp  r2, #0x0       @check if there is a skill here
        beq  EndLoop        @if not, terminate the loop
            mov  r0, #0x1
            orr  r2, r0     @make sure we're in thumb mode
            mov  lr, r2
            push {r3}       @copy our position in the list of Armsthrift skills 
            .short 0xF800
            pop {r3}        @restore our position in the list
            add  r3, #0x4   @check for next skill in the loop
            b    Loop       @continue iterating through the loop

    EndLoop:
    pop {r3}    @restore the unit faction array location
    mov  r9, r3 @copy it back to its original register
    ldr  r3,=ReturnLocation
    bx   r3

.align
.ltorg
ArmsPointers: @ArmsLoopList in the associated event file
@POIN ArmsFunctions
@it should contain a list of pointers to functions terminated by a four bytes of 0

