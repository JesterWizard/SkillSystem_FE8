
.thumb

.type Moxie, %function 
.global Moxie 

Moxie: 
push {r4-r5, lr} 
mov r4, r0 @ stat value
mov r5, r1 @ unit 

@check for skill
mov	r0, r5
ldr	r1, =MoxieID_Link
ldr r1, [r1] 
bl  SkillTester
cmp		r0,#0
beq		End

push 	{r3}                        @save this register
mov 	r0,r5                       @r0 is expected to be the unit struct for GetUnitDebuffEntry
bl 		GetUnitDebuffEntry          @r0 = returns starting debuff table location for unit
ldr 	r1, =MoxieBitOffset_Link    @load the offset location in the ROM
ldr 	r1, [r1]                    @load its value
add     r0, r1                      @add the offset to the starting debuff table location for this unit
ldrb    r1, [r0]                    @load the byte value stored at this location

RestoreRegister:
pop 	{r3}                        @restore this register

CheckBoost:
mov r2,#10                          @move this value into a gree register for comparisons
cmp r1,r2                           @check to see if the potential boost is greater than our chosen value
bgt SetToTen                        @if it is, reduce it to our chosen value then add it to the unit
b AddBoost                          @otherwise just add the value to the unit

SetToTen:
mov r1,#10                          @self explanatory, this is the limit I gave decided on for the boost

AddBoost:
add r4,r1                           @add the boost for Moxie

End: 
mov r0, r4 @ value 
mov r1, r5 @ unit 
pop {r4-r5} 
pop {r2} 
bx r2 
.ltorg



