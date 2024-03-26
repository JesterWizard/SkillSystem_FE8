.thumb
.equ SwordProwessID, SkillTester+4

@Sword Prowess LV1: Grants Hit +5, Avo +7, and Crit Avo +5 when using a sword (Rank D)
@Sword Prowess LV2: Grants Hit +6, Avo +10, and Crit Avo +6 when using a sword (Rank C)
@Sword Prowess LV3: Grants Hit +7, Avo +13, and Crit Avo +7 when using a sword (Rank B)
@Sword Prowess LV4: Grants Hit +8, Avo +16, and Crit Avo +8 when using a sword (Rank A)
@Sword Prowess LV5: Grants Hit +10, Avo +20, and Crit Avo +10 when using a sword (Rank S)

@currently I have no way of updating the skill description and icons to match the boost each level gives.

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@has SwordProwess
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, SwordProwessID
.short 0xf800
cmp r0, #0
beq End

@check weapon level
mov r0,#0x28 
ldrb r1,[r4,r0] @weapon level - sword
cmp r1,#31
blt End
cmp r1,#71  @D rank check
blt SwordProwessLV1
cmp r1,#121 @C rank check
blt SwordProwessLV2
cmp r1,#181 @B rank check
blt SwordProwessLV3
cmp r1,#251 @A rank check
blt SwordProwessLV4
@if we make it this far, we can conclude the weapon level is S rank
b SwordProwessLV5


@apply SwordProwess LV1
SwordProwessLV1:
mov r1, #0x60 
ldrh r0, [r4, r1] @hit
add r0, #5
strh r0, [r4, r1]
mov r1, #0x62
ldrh r0, [r4, r1] @avoid
add r0, #7
strh r0, [r4, r1]
mov r1, #0x68
ldrh r0, [r4, r1] @crit avoid
add r0, #5
strh r0, [r4, r1]
b End

@apply SwordProwess LV2
SwordProwessLV2:
mov r1, #0x60 
ldrh r0, [r4, r1] @hit
add r0, #6
strh r0, [r4, r1]
mov r1, #0x62
ldrh r0, [r4, r1] @avoid
add r0, #10
strh r0, [r4, r1]
mov r1, #0x68
ldrh r0, [r4, r1] @crit avoid
add r0, #6
strh r0, [r4, r1]
b End

@apply SwordProwess LV3
SwordProwessLV3:
mov r1, #0x60 
ldrh r0, [r4, r1] @hit
add r0, #7
strh r0, [r4, r1]
mov r1, #0x62
ldrh r0, [r4, r1] @avoid
add r0, #13
strh r0, [r4, r1]
mov r1, #0x68
ldrh r0, [r4, r1] @crit avoid
add r0, #7
strh r0, [r4, r1]
b End

@apply SwordProwess LV4
SwordProwessLV4:
mov r1, #0x60 
ldrh r0, [r4, r1] @hit
add r0, #8
strh r0, [r4, r1]
mov r1, #0x62
ldrh r0, [r4, r1] @avoid
add r0, #16
strh r0, [r4, r1]
mov r1, #0x68
ldrh r0, [r4, r1] @crit avoid
add r0, #8
strh r0, [r4, r1]
b End

@apply SwordProwess LV5
SwordProwessLV5:
mov r1, #0x60 
ldrh r0, [r4, r1] @hit
add r0, #10
strh r0, [r4, r1]
mov r1, #0x62
ldrh r0, [r4, r1] @avoid
add r0, #20
strh r0, [r4, r1]
mov r1, #0x68
ldrh r0, [r4, r1] @crit avoid
add r0, #10
strh r0, [r4, r1]
b End

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD SwordProwessID
