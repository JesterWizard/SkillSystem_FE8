.thumb
.equ ItemTable, SkillTester+4
.equ TextSkimmerID, ItemTable+4


push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@has appropriate weapon type
mov r0,#0x1e
ldrb r0,[r4,r0] @ItemID //Good so far
ldr r1,ItemTable
mov r2,#36
mul r2,r0
add r1,r2
ldrb r1,[r1,#0x7]
cmp r1,#0x5
beq SkillCheck
cmp r1,#0x6
beq SkillCheck
cmp r1,#0x7
bne End

SkillCheck:
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, TextSkimmerID
.short 0xf800
cmp r0, #0
beq End

@GetConAndWt
ldr r0, [r4, #0x0] 
ldrb r0, [r0, #0x13] @unit Con
ldr r1, [r4, #0x04]
ldrb r1, [r1, #0x11] @class Con
add r0, r1
ldrb r1, [r4, #0x1A] @Con bonus
//add r0, r1 @r0 contains attacker con
mov r3,#0x4a
ldrb r2,[r4,r3]
mov r3,#36
mul r2,r3
ldr r3,ItemTable
add r2,r3
mov r3,#23
ldrb r6,[r2,r3] @r6 contains weapon wt
cmp r6,r0
ble End

mov r3,#0x5e
ldrh r7, [r4,r3] @Load the attackers AS into r7.
sub r6,r0
cmp r6,r0
bge AddMaxSpd
add  r7,r6   @Add remaining WT to attackers AS.
strh r7,[r4,r3]     @Store attacker AS.
b End

AddMaxSpd:
add     r7,r0   @Add Con to AS.
strh    r7,[r4,r3]     @Store attacker AS.

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD TextSkimmerID
