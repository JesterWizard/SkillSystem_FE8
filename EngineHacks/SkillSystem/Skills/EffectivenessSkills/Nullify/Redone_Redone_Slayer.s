.thumb

@jumped to from 16C88

@r0=attacker battle struct, r1=defender battle struct

@Slayer table outline: BYTE class_ID multiplier is_there_another_entry 0; SHORT class_types 0

@tequila why the h*ck are you checking the slayer table after checking the skill making it still hardcoded to classes
@this version just checks a given class type EA literal

.equ SlayerID, SkillTester+4
.equ NullifyID, SlayerID+4
.equ SlayerClassType, NullifyID+4
.equ SkybreakerID, SlayerClassType+4
.equ SkybreakerClassType,SkybreakerID+4
.equ ResourcefulID,SkybreakerClassType+4
.equ DoOrDieID, ResourcefulID+4
.equ DoOrDieClassType, DoOrDieID+4

push	{r4-r6,r14}
mov		r4,r0
mov		r5,r1
ldr		r0,[r5,#0x4]       @load class data from (what should be) the defender battle struct
cmp		r0,#0              @compare the value against a 'null' class
beq		RetFalse           @if there isn't a class here, we're not looking at a unit and so exit early

Slayer:
mov		r0,r4
ldr		r1,SlayerID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		Skybreaker

ldr		r2,[r5,#4]
mov		r1,#0x50
ldrh	r2,[r2,r1]			@weaknesses defender unit has
ldrh 	r0,SlayerClassType
and		r0,r2
cmp		r0,#0
bne		NullifyCheck

Skybreaker:
mov		r0,r4
ldr		r1,SkybreakerID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		DoOrDie

ldr		r2,[r5,#4]
mov		r1,#0x50
ldrh	r2,[r2,r1]			@weaknesses defender unit has
ldrh 	r0,SkybreakerClassType
and		r0,r2
cmp		r0,#0
bne		NullifyCheck


@In all likelihood this is impossible to get workinng as
@the battle stats aren't correctly calculated at this stage
@and for some reason units that can only attack once are listed
@as being able to attack twice. So killing strikes are recorded
@more frequenly then they should be. Parking this for now.
DoOrDie:
mov		r0,r4
ldr		r1,DoOrDieID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		RetFalse

mov     r0,#0x5A
ldrh    r0,[r5,r0]          @load the enemy's battle attack
ldrb    r1,[r4,#0x13]       @load the skill holder's current HP
cmp     r0,r1               @compare both
blt     RetFalse            @if the skill holder's HP is greater, we don't apply effectiveness

ldr		r2,[r5,#4]
mov		r1,#0x50
ldrh	r2,[r2,r1]			@weaknesses defender unit has
ldrh 	r0,DoOrDieClassType
and		r0,r2
cmp		r0,#0
bne		NullifyCheck
b		RetFalse

NullifyCheck:
mov		r0,r5
ldr		r1,NullifyID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
bne		RetFalse

mov		r0,#6
mov		r6,r0
ldr		r0,SkillTester
mov		r14,r0
mov		r0,r4
ldr		r1,ResourcefulID	
.short	0xF800
cmp		r0,#0
beq		GoBack
lsl		r6,#1
b 		GoBack

RetFalse:
mov		r6,#0
GoBack:
mov		r0,r6
pop		{r4-r6}
pop		{r1}
bx		r1

.ltorg
.align
SkillTester:
@
