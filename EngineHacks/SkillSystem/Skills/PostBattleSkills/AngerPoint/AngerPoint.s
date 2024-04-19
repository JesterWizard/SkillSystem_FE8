.thumb
.equ AngerPointID, SkillTester+4
.equ RoundsData, 0x203AAC0 //Skill system location, vanilla is 0x203A5EC

@This is sort of working and not working. 
@Right now, the boosts are made to the main attack stat instead of being applied as a green boost
@as right now I can't work out how to apply those boosts inside a post battle skill.
@Also, we assume a traditional back and forth in the rounds between defender and attacker
@if either unit has something that inteferes with this structure, like QuickRiposte, Vantage or a Brave weapon
@the skill isn't guranteed to work correctly right now.

push	{lr}

@ r4 = attacker
@ r5 = defender
@ r6 = actiondata

@check if the action was an attack
ldrb  r0, [r6,#0x11]  @action taken this turn
cmp r0, #0x2 @attack
bne End

@check if attacker dead
ldrb	r0, [r4,#0x13]
cmp	r0, #0x00
beq	CheckDefender

@check attacker for skill
mov	r0, r4
ldr	r1, AngerPointID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0,#0x00
beq	CheckDefenderSkill

CheckDefender:
@check if defender dead
ldrb  r0, [r5,#0x13]
cmp r0, #0x00
beq End

mov r2,#4                @the first byte of the second round (as the skill holder will attack first not accounting for vantage or quick riposte)

@check the faction of the attacker
ldr r0,=RoundsData       @load the rounds data
ldrb r1,[r0,r2]          @load the first byte in round 2
b   CheckDefenderCrit

CheckDefenderCrit:
mov r1,#1                @testing
cmp r1,#1                @check if the defender crit
beq ApplySkillToAttacker 
cmp r1,#9                @check for retaliation + crit
beq ApplySkillToAttacker
b   LoadNextRound_Attacker

ApplySkillToAttacker:
mov r1,#0x14             @strength byte
ldrb r3,[r4,r1]          @load the strength value
add r3,#10               @add 10 to strength
strb r3,[r4,r1]          @store the new strength value
b    CheckDefenderSkill  @we've applied the skill to the attacker, so now move on to check the defender

LoadNextRound_Attacker:
add r2,#8                @add 8 (next defender round) to offset
ldr r1,[r0,r2]           @use it to load the next round
cmp r1,#0                @if the word is 0, we can assume we have no rounds left to check               
beq CheckDefenderSkill   @now we now on to do a skill check on the defender

@check defender for skill
CheckDefenderSkill:
mov r0, r5
ldr r1, AngerPointID
ldr r3, SkillTester
mov lr, r3
.short  0xf800
cmp r0,#0x00
beq End

mov r2,#0                @the first byte of the first round

@check the faction of the attacker
ldr r0,=RoundsData       @load the rounds data
ldrb r1,[r0,r2]          @load the first byte in round 1
b   CheckAttackerCrit

CheckAttackerCrit:
cmp r1,#1                @check if the defender crit
beq ApplySkillToDefender 
cmp r1,#9                @check for retaliation + crit
beq ApplySkillToDefender
b   LoadNextRound_Defender

ApplySkillToDefender:
mov r1,#0x14             @strength byte
ldrb r3,[r5,r1]          @load the strength value
add r3,#10               @add 10 to strength
strb r3,[r5,r1]          @store the new strength value
b    End

LoadNextRound_Defender:
add r2,#8                @add 8 (next defender round) to offset
ldr r1,[r0,r2]           @use it to load the next round
cmp r1,#0                @if the word is 0, we can assume we have no rounds left to check               
bne CheckAttackerCrit 


End:
pop	{r0}
bx	r0
.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD AngerPointID
