.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ EndlessVitalityID, SkillTester+4
.equ EndlessVitalityEvent, EndlessVitalityID+4
.thumb
push	{lr}
@check if dead
ldrb	r0, [r4,#0x13]
cmp	r0, #0x00
beq	End

@check if attacked this turn
ldrb 	r0, [r6,#0x11]	@action taken this turn
cmp	r0, #0x2 @attack
bne	End
ldrb 	r0, [r6,#0x0C]	@allegiance byte of the current character taking action
ldrb	r1, [r4,#0x0B]	@allegiance byte of the character we are checking
cmp	r0, r1		@check if same character
bne	End

@check attacker for skill
mov	r0, r4
ldr	r1, EndlessVitalityID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0,#0x00
beq CheckDefender

mov	r0,r4
ldr	r3,=#0x8019190	@max hp getter
mov	lr,r3
.short	0xF800
mov	r1,r0
push	{r1}
mov	r0,r4
ldr	r3,=#0x8019150	@current hp getter
mov	lr,r3
.short	0xF800
mov	r2,r0
pop	{r1}
cmp	r1, r2		@check if hp is already max
beq	End

@this used to just add curHP to curHP and set that as new curHP
ldrb r0,[r4,#0x12]   @max HP as the numerator           
mov r1, #5           @5 as the denominator
swi 6                @divide r0 by r1 and return the divided amount in r0 and the remainder in r1
add	r2, r0		       @total healing
ldrb r1,[r4,#0x12]   @max HP again
cmp	r2, r1		       @is the new hp higher than max?
ble	StoreHPAttacker
mov	r2, r1		       @if so, set to max
StoreHPAttacker:
strb	r2, [r4,#0x13]

EventAttacker:
mov	r3, #0x00
ldrb	r0, [r4,#0x11]		@load y coordinate of character
lsl	r0, #0x10
add	r3, r0
ldrb	r0, [r4,#0x10]		@load x coordinate of character
add	r3, r0
ldr	r1,=#0x30004E4		@and store them for the event engine
str	r3, [r1]

ldr	r0,=#0x800D07C		@event engine thingy
mov	lr, r0
ldr	r0, EndlessVitalityEvent	@this event is just "teleport animation on current character"
mov	r1, #0x01		@0x01 = wait for events
.short	0xF800

@check defender for skill
CheckDefender:
mov	r0, r5
ldr	r1, EndlessVitalityID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0,#0x00
beq	End

mov	r0,r5
ldr	r3,=#0x8019190	@max hp getter
mov	lr,r3
.short	0xF800
mov	r1,r0
push	{r1}
mov	r0,r5
ldr	r3,=#0x8019150	@current hp getter
mov	lr,r3
.short	0xF800
mov	r2,r0
pop	{r1}
cmp	r1, r2		@check if hp is already max
beq	End

@this used to just add curHP to curHP and set that as new curHP
ldrb r0,[r5,#0x12]   @max HP as the numerator           
mov r1, #5           @5 as the denominator
swi 6                @divide r0 by r1 and return the divided amount in r0 and the remainder in r1
add	r2, r0		       @total healing
ldrb r1,[r5,#0x12]   @max HP again
cmp	r2, r1		       @is the new hp higher than max?
ble	StoreHPDefender
mov	r2, r1		       @if so, set to max
StoreHPDefender:
strb	r2, [r5,#0x13]

EventDefender:
mov	r3, #0x00
ldrb	r0, [r5,#0x11]		@load y coordinate of character
lsl	r0, #0x10
add	r3, r0
ldrb	r0, [r5,#0x10]		@load x coordinate of character
add	r3, r0
ldr	r1,=#0x30004E4		@and store them for the event engine
str	r3, [r1]

ldr	r0,=#0x800D07C		@event engine thingy
mov	lr, r0
ldr	r0, EndlessVitalityEvent	@this event is just "teleport animation on current character"
mov	r1, #0x01		@0x01 = wait for events
.short	0xF800

End:
pop	{r0}
bx	r0
.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD EndlessVitalityID
@POIN EndlessVitalityEvent
