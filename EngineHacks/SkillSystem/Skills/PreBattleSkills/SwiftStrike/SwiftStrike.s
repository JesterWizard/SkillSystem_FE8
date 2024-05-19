.thumb
.equ ItemTable, SkillTester+4
.equ SwiftStrikeID, ItemTable+4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr


@has SwiftStrike
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @Attacker data
ldr r1, SwiftStrikeID
.short 0xf800
cmp r0, #0
beq End

mov r3,#0x4A     
ldrb r2,[r4,r3] 
mov r3,#0x24      
mul r2,r3
ldr r3,ItemTable
add r2,r3
mov r3,#0x14        @load default weapon uses
ldrb r2,[r2,r3]

mov r0, #0x48       @equipped weapon and uses after battle
ldrh r0,[r4,r0]     @load this value
lsr  r0,#8          @shift this two places to the right to isolate the weapon uses
cmp r0, r2          @compare both
bne End             @if the weapon isn't brand new, branch to the end

mov r1, #0x66
ldrh r0, [r4, r1]   @load the unit's critical hit rate
mov  r0,#0xFF       @set it to 100%
strh r0, [r4,r1]    @store the new value


End:
pop {r4-r7, r15}

.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD SwiftStrikeID
