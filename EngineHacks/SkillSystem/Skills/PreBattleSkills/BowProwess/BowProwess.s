.thumb
.equ BowProwessID, SkillTester+4

@Bow Prowess LV1: Grants Hit +5, Avo +7, and Crit Avo +5 when using a Bow (Rank D)
@Bow Prowess LV2: Grants Hit +6, Avo +10, and Crit Avo +6 when using a Bow (Rank C)
@Bow Prowess LV3: Grants Hit +7, Avo +13, and Crit Avo +7 when using a Bow (Rank B)
@Bow Prowess LV4: Grants Hit +8, Avo +16, and Crit Avo +8 when using a Bow (Rank A)
@Bow Prowess LV5: Grants Hit +10, Avo +20, and Crit Avo +10 when using a Bow (Rank S)

@currently I have no way of updating the skill description and icons to match the boost each level gives.

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@has BowProwess
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, BowProwessID
.short 0xf800
cmp r0, #0
beq End

@check equipped item is a bow
mov r0, #0x50 @weapon type byte
ldrb r0,[r4,r0]
cmp r0,#3 @is bow?
bne End @branch to end if not

@check weapon level
mov r0,#0x2B
ldrb r1,[r4,r0] @weapon level - Bow
cmp r1,#31
blt End
cmp r1,#71  @D rank check
blt BowProwessLV1
cmp r1,#121 @C rank check
blt BowProwessLV2
cmp r1,#181 @B rank check
blt BowProwessLV3
cmp r1,#251 @A rank check
blt BowProwessLV4
@if we make it this far, we can conclude the weapon level is S rank
b BowProwessLV5


@apply BowProwess LV1
BowProwessLV1:
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

@apply BowProwess LV2
BowProwessLV2:
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

@apply BowProwess LV3
BowProwessLV3:
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

@apply BowProwess LV4
BowProwessLV4:
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

@apply BowProwess LV5
BowProwessLV5:
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
@WORD BowProwessID
