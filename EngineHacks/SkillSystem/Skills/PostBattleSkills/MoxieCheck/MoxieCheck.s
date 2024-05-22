.thumb

.type MoxieCheck, %function 
.global MoxieCheck 

MoxieCheck:
push	{r14}

@check if dead
CheckAttacker:
ldrb	r0, [r4,#0x13]
cmp	r0, #0x00
bne	CheckDefender

CheckDefender:
ldrb	r0, [r5,#0x13]
cmp	r0, #0x00
bne	End

@check for skill
mov	r0, r4
ldr	r1, =Moxie_ID_Link
ldr r1, [r1] 
bl  SkillTester
cmp		r0,#0
beq		End

push 	{r3}                        @save this register
mov 	r0,r4                       @r0 is expected to be the unit struct for GetUnitDebuffEntry
bl 		GetUnitDebuffEntry          @r0 = returns starting debuff table location for unit
ldr 	r1, =MoxieBitOffset_Link    @load the offset location in the ROM
ldr 	r1, [r1]                    @load its value
add   r0, r1                      @add the offset to the starting debuff table location for this unit
ldrb  r1, [r0]                    @load the byte value stored at this location
add   r1,#1                       @add 1 to the boost for a successful kill
strb  r1,[r0]                     @store the new value

RestoreRegister:
pop 	{r3}                        @restore this register

End:
pop	{r0}
bx	r0
.ltorg
.align
