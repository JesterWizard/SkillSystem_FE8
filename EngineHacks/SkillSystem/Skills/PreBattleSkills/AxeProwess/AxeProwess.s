.thumb
.equ AxeProwessID, SkillTester+4

@Axe Prowess LV1: Grants Hit +5, Avo +7, and Crit Avo +5 when using a Axe (Rank D)
@Axe Prowess LV2: Grants Hit +6, Avo +10, and Crit Avo +6 when using a Axe (Rank C)
@Axe Prowess LV3: Grants Hit +7, Avo +13, and Crit Avo +7 when using a Axe (Rank B)
@Axe Prowess LV4: Grants Hit +8, Avo +16, and Crit Avo +8 when using a Axe (Rank A)
@Axe Prowess LV5: Grants Hit +10, Avo +20, and Crit Avo +10 when using a Axe (Rank S)

@currently I have no way of updating the skill description and icons to match the boost each level gives.

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@has AxeProwess
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, AxeProwessID
.short 0xf800
cmp r0, #0
beq End

@check equipped item is a axe
mov r0, #0x50 @weapon type byte
ldrb r0,[r4,r0]
cmp r0,#2 @is axe?
bne End @branch to end if not

@check weapon level
mov r0,#0x2A
ldrb r1,[r4,r0] @weapon level - Axe
cmp r1,#31
blt End
cmp r1,#71  @D rank check
blt AxeProwessLV1
cmp r1,#121 @C rank check
blt AxeProwessLV2
cmp r1,#181 @B rank check
blt AxeProwessLV3
cmp r1,#251 @A rank check
blt AxeProwessLV4
@if we make it this far, we can conclude the weapon level is S rank
b AxeProwessLV5


@apply AxeProwess LV1
AxeProwessLV1:
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

@apply AxeProwess LV2
AxeProwessLV2:
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

@apply AxeProwess LV3
AxeProwessLV3:
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

@apply AxeProwess LV4
AxeProwessLV4:
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

@apply AxeProwess LV5
AxeProwessLV5:
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
@WORD AxeProwessID
