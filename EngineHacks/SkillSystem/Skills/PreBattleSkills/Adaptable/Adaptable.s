.thumb
.equ AdaptableID, SkillTester+4
.equ GetUnit, 0x8019430
.equ ChapterStruct, 0x202BCF0
.equ GetItemMight, 0x80175DD
.equ GetItemHit, 0x80175F5

@The next step will be to assign points to each weapon and store the weapon itself
@plus the score inside the itembuffer (which is subject to change location) and then
@store the item with the highest number of points inside the equipped item short (0x1E)
@in the case of a draw, keep the first item loaded from the item buffer

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

@ mov r6,#0x1E            @first item character struct offset
@ ldr r0,=#0x202763C      @load the item buffer (3 bytes per item, first byte is score, second is weapon ID and third is uses)
@ LoopThroughItems_ConstructBuffer:
@ mov  r1,#0
@ strb r1,[r0]            @set the score byte to 0
@ add  r0,#2              @move on to the short position
@ ldrh r1,[r4,r6]         @load the weapon ID and uses
@ strh r1,[r0]            @store them

@ @load next item for buffer
@ add  r0,#2              @add two to the item buffer to start holding the score for the next item
@ add  r6,#2              @add two to the character struct offset to load the next item
@ cmp  r6,#0x26           @check if we've gone past the fifth item
@ ble  LoopThroughItems_ConstructBuffer

@ mov  r6,#0x1E           @first item character struct offset
@ ldr  r5,=#0x202763C     @item buffer
@ LoopThroughItems_CheckAttack:
@ ldrh r0,[r4,r6]         @load the item short as a byte to isolate the item ID to check its might
@ blh GetItemMight, r1    @r0 = item might
@ cmp r0,#0
@ beq AddNone
@ cmp r0,#5
@ ble AddOne
@ cmp r0,#10
@ ble AddTwo
@ cmp r0,#15
@ ble AddThree
@ cmp r0,#16
@ bge AddFour

@ AddNone:
@ add r6,#2               @get ready to load the next item in the character struct
@ add r5,#4               @get ready to load the next item in the item buffer
@ cmp r6,#0x26            @check if we've gone past the fifth item
@ ble LoopThroughItems_CheckAttack
@ b   InitializeScoreChecking

@ AddOne:
@ add r6,#2               @get ready to load the next item in the character struct
@ ldrb r0,[r5]            @load the point value for this weapon
@ add r0,#1               @increase the point value
@ strb r0,[r5]            @store the new point value
@ add r5,#4               @get ready to load the next item in the item buffer
@ cmp r6,#0x26            @check if we've gone past the fifth item
@ ble LoopThroughItems_CheckAttack
@ b   InitializeScoreChecking

@ AddTwo:
@ add r6,#2               @get ready to load the next item in the character struct
@ ldrb r0,[r5]            @load the point value for this weapon
@ add r0,#2               @increase the point value
@ strb r0,[r5]            @store the new point value
@ add r5,#4               @get ready to load the next item in the item buffer
@ cmp r6,#0x26            @check if we've gone past the fifth item
@ ble LoopThroughItems_CheckAttack
@ b   InitializeScoreChecking

@ AddThree:
@ add r6,#2               @get ready to load the next item in the character struct
@ ldrb r0,[r5]            @load the point value for this weapon
@ add r0,#3               @increase the point value
@ strb r0,[r5]            @store the new point value
@ add r5,#4               @get ready to load the next item in the item buffer
@ cmp r6,#0x26            @check if we've gone past the fifth item
@ ble LoopThroughItems_CheckAttack
@ b   InitializeScoreChecking

@ AddFour:
@ add r6,#2               @get ready to load the next item in the character struct
@ ldrb r0,[r5]            @load the point value for this weapon
@ add r0,#4               @increase the point value
@ strb r0,[r5]            @store the new point value
@ add r5,#4               @get ready to load the next item in the item buffer
@ cmp r6,#0x26            @check if we've gone past the fifth item
@ ble LoopThroughItems_CheckAttack
@ b   InitializeScoreChecking

@ InitializeScoreChecking:
@ ldr  r5,=#0x202763C     @item buffer (start)
@ ldr  r1,=#0x2027650     @end of item buffer - 20 bytes (4 * 5 item slots) ahead of start of buffer
@ mov  r3,#0x1E           @holds the character item struct position
@ ldrb r0,[r5]            @load the item value
@ b    LoopThroughItemBuffer

@ LoopThroughItemBuffer:
@ ldrb r2,[r5]
@ cmp r2,r0
@ bgt ReplaceEquippableItem
@ cmp r3,#0x26            @fifth item in the character struct
@ bgt EquipWeapon         @we've run out of items to check
@ add r5,#4               @move on to the next item in the item buffer
@ add r3,#2               @move on to the next item in the character struct
@ cmp r5, r1              @compare the current value of the buffer to the defined end of the buffer in r7
@ bgt EquipWeapon         @if it's greater, then we've reached the end of the buffer and equip our strongest weapon in r0
@ b   LoopThroughItemBuffer @otherwise, we continue to loop through the item buffer

@ ReplaceEquippableItem:
@ mov r0,r2               @save the highest value so far
@ mov r6,r3               @save the position of the current strongest item in the character struct
@ add r5,#4               @move on to the next item in the item buffer
@ add r3,#2               @move on to the next item in the character struct
@ cmp r5, r1              @compare the current value of the buffer to the defined end of the buffer in r7
@ bgt EquipWeapon         @if it's greater, then we've reached the end of the buffer and equip our strongest weapon in r0
@ b   LoopThroughItemBuffer @otherwise, we continue to loop through the item buffer

@ EquipWeapon:
@ ldrb r0,[r4,#0xB]       @allegiance byte of skill holder
@ blh GetUnit, r1         @r0 = unit struct
@ ldrh r3,[r0,#0x1E]      @load the equipped weapon and remaining uses
@ ldrh r1,[r0,r6]         @load the current weapon and remaining uses
@ strh r1,[r0,#0x1E]      @the current weapon gets stored as the equipped weapon
@ strh r3,[r0,r6]         @the equipped weapon gets stored as the current weapon

mov r6,#0x1E        @first item
LoopThroughItems:
ldrh r0,[r4,r6]
cmp r0,#0
beq Adaptable       @we've reached the last item in the user's inventory, so we now apply the skill
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

NextItem:
add r6,#2           @add two to the character struct offset to load the next item
cmp r6,#0x26        @check if we've gone past the fifth item
bgt End             @if so, we have nothing left to check
b   LoopThroughItems

Adaptable:
ldrh r3,[r4,#0x1E]  @load the equipped weapon and remaining uses
ldrh r7,[r4,r6]     @load the current weapon and remaining uses
mov  r0,r9          @it seems the skill holder unit struct is contained in r9?
strh r7,[r0,#0x1E]  @the current weapon gets stored as the equipped weapon
strh r3,[r0,r6]     @the equipped weapon gets stored as the current weapon

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD AdaptableID
