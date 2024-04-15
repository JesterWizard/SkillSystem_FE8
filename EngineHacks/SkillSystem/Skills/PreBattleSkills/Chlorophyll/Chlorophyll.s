.thumb
.equ ChlorophyllID, SkillTester+4
.equ ChapterData, 0x202BCF0

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@check weather
ldr  r0,=ChapterData        @load the chapter data
ldrb r0,[r0,#0x15]          @load the weather byte
cmp  r0,#5                  @compare against the sunny weather byte
bne  End                    @if it isn't sunny, skip to the end

@has Chlorophyll
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, ChlorophyllID
.short 0xf800
cmp r0, #0
beq End

@double speed
mov  r0,#0x5E
ldrh r1,[r4,r0]
lsl  r1,#1
strh r1,[r4,r0]

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD ChlorophyllID
