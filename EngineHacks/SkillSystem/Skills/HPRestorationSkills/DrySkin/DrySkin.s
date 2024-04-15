.thumb
.align


.global DrySkin
.type DrySkin, %function

.equ ChapterData, 0x202BCF0

DrySkin:
push {r4-r5,r14}
mov r4,r0 @r4 = unit
mov r5,r1 @r5 = heal %

ldr r0,=SkillTester
mov r14,r0
mov r0,r4
ldr r1,=DrySkinIDLink
ldrb r1,[r1]
.short 0xF800
cmp r0,#0
beq GoBack

@check the weather to decide whether to heal or damage the unit
ldr  r0,=ChapterData    @load the chapter struct
ldrb r0,[r0,#0x15]      @load the weather byte
cmp  r0,#5              @compare the current weather to the sunny byte
beq  DamageUnit         @if the weather is sunny, branch to damage the unit
cmp  r0,#4              @else we compare the current weather to the rain byte
beq  HealUnit           @if the weather is rain, we heal the unit
b    GoBack             @if neither weather is true, we simply end the skill execution

@since we're technically doing this in the heal loop we have to dig deeper to reduce the unit's HP
DamageUnit:
ldrb r0,[r2,#0x13]      @current HP
mov  r1,#10             @set up the divisor
swi  6                  @divide r0 by r1 and return the result in r1 (to get 10% of the unit's current HP)
ldrb r1,[r2,#0x13]      @loading current hp again because the system call wiped our free registers
cmp  r0,#1              @check HP reduction result
blt  SetMinimum         @if the reduction amount is 0 (because we have less than 10 health) branch to set it to 1
sub  r1,r0              @subtract the 10% from the unit's current HP
strb r1,[r2,#0x13]      @store the result
b    GoBack

SetMinimum:
sub  r1,#1              @subtract 1 from the unit's current HP
strb r1,[r2,#0x13]      @store the result
b    GoBack

HealUnit:
add  r5,#10             @add 10% to the unit's health
b    GoBack

GoBack:
mov r0,r5
pop {r4-r5}
pop {r1}
bx r1

.ltorg
.align


