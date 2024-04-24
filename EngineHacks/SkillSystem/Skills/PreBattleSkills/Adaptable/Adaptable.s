.thumb
.equ AdaptableID, SkillTester+4
.equ ItemBuffer, 0x202763C
.equ GetUnit, 0x8019430
.equ ChapterStruct, 0x202BCF0
.equ GetItemMight, 0x80175DD
.equ GetItemHit, 0x80175F5

.macro blh to, reg
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@check if turn phase doesn't match unit faction
@as we don't want this executing on the unit's attacking phase
ldr r0, =ChapterStruct
ldrb r0,[r0,#0xF]    @turn phase (0x00 for player, 0x40 for allied, 0x80 for enemy)
ldrb r1,[r4,#0xB]    @deployment byte (0x00 for player, 0x40 for NPC, 0x80 for enemy)
sub  r0,r1           @calculate the difference between the two
@get the absolute value
asr  r1, r0, #31
add  r0, r0, r1
eor  r0, r1
mov  r1,#0x3F        @0x3F represents the highest number of units per faction
cmp  r0, r1          @compare the difference between the turn phase and unit deployment byte to this value
ble  End             @stop any further checks if the unit isn't in their attacking phase

@has Adaptable
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, AdaptableID
.short 0xf800
cmp r0, #0
beq End

mov r6,#0x1E        @first item
LoopThroughItems:
@ ldrh r0,[r4,r6]
@ cmp r0,#0
@ beq Adaptable     @we've reached the last item in the user's inventory, so we now apply the skill
ldrb r0,[r4,r6]     @load the first item short as a byte to isolate the item ID to check its hit
blh GetItemHit, r1  @r0 = item hit
cmp r0,#0           @check if the hit is 0
beq NextItem        @if so, it's safe to assume its not a weapon and load the next item

@compare item strength
ldrb r0,[r4,#0x1E]  @load the first item short as a byte to isolate the item ID to check its hit
blh GetItemMight, r1
mov r2,r0
ldrb r0,[r4,r6]     @load the current item short as a byte to isolate the item ID to check its hit
blh GetItemMight, r1
mov r3,r0
cmp r2,r3
bge NextItem        @if the first weapon (in r2) is stronger or equal to the current weapon (in r3) check the next item

ldrh r3,[r4,#0x1E]  @load the equipped weapon and remaining uses
ldrh r7,[r4,r6]     @load the current weapon and remaining uses
@ ldr r1,=GetUnit
@ mov lr,r1
@ .short 0xf800     @r0 = unit struct of current unit
mov r0,r9
strh r7,[r0,#0x1E]  @the current weapon gets stored as the equipped weapon
strh r3,[r0,r6]     @the equipped weapon gets stored as the current weapon

NextItem:
add r6,#2           @add two to the character struct offset to load the next item
cmp r6,#0x26        @check if we've gone past the fifth item
bgt End             @if so, we have nothing left to check
b   LoopThroughItems

@ @set equipped weapon
@ ldr r1,=GetUnit
@ mov lr,r1
@ .short 0xf800       @r0 = unit struct of current unit
@ ldr r1,=0x2809      @test - rapier (09) with 40 (28) uses
@ strh r1,[r0,#0x1E]  @store this as the first weapon in the user's inventory

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD AdaptableID
