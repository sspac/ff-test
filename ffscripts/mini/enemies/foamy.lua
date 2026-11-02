local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--foamy: charges baty, Foamy, FoamyAI

function mod:foamyai(npc, sprite, npcdata)
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	sprite.Offset = Vector(0,-15)
	--init
	if npcdata.init == nil then
		npcdata.init = true
		npcdata.twitchangle = math.random(0,360)
		npcdata.state = "flap"
		npcdata.twitchtimer = math.random(30,60)
		npcdata.wallbounceleft = 3
		npcdata.statetimer = math.random(120, 240)
		if npcdata.quickcharge then
			npcdata.statetimer = npcdata.statetimer / 2
		end

		npcdata.lastvelocity = Vector(0,0)
	end
	--actually do shit
	if npcdata.state == "flap" then
		--twitch
		if npcdata.twitchtimer == 0 then
			npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_0,1,1,false,2)
			npcdata.twitchtimer = math.random(30,60)
			sprite:Play("Twitch", false)
			npcdata.twitchangle = math.random (0,360)
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				npcdata.twitchangle = (npc.Position - targetpos):GetAngleDegrees()
			end
			npcdata.anglebetween = (npc.Position - targetpos):GetAngleDegrees()
		else
			--MOVE WHEN NOT TWITCHING STAY STILL WHEN
			if not sprite:IsPlaying("Twitch") then
				mod:spritePlay(sprite, "Idle")
				--STOP GET ONTO THE WALL
				if npc:CollidesWithGrid() then
					npcdata.twitchangle = npc.Velocity:GetAngleDegrees()
				end
				npcdata.targetvelocity = Vector(2.25,0):Rotated(npcdata.twitchangle)
				npc.Velocity = mod:Lerp(npc.Velocity, npcdata.targetvelocity, 0.2)
				npcdata.twitchtimer = npcdata.twitchtimer - 1
			else
				npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.1)
			end
		end
		--change state sometime
		npcdata.statetimer = npcdata.statetimer - 1
		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			npcdata.statetimer = npcdata.statetimer + 1
		end
		if npcdata.statetimer <= 0 then
			npc:PlaySound(SoundEffect.SOUND_MONSTER_YELL_B,1,1,false,1.7)
			npcdata.state = "charge"
			sprite:Play("DashStart", false)
			npcdata.wallbounceleft = 3
		end
	--charge - bounce off 3 wall and bulket
	elseif npcdata.state == "charge" then
		if sprite:IsPlaying("DashStart") then
			npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.5)
		elseif sprite:IsFinished("DashStart") then
			npcdata.twitchangle = (targetpos - npc.Position):GetAngleDegrees()
			npc.Velocity = Vector(15, 0):Rotated(npcdata.twitchangle)
			mod:spritePlay(sprite, "Dash")
		elseif sprite:IsPlaying("Dash") then
			npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(10), 0.2)
			--ACTUALLY BOUNCE OFF THE FUCKING WALL FOR ONCE IN YOUR LIFE YOU USELESS SACK OF SHIT
			if npc:CollidesWithGrid() == true then
				npc:PlaySound(SoundEffect.SOUND_FETUS_LAND,2,1,false,1.7)
				npcdata.twitchangle = npc.Velocity:GetAngleDegrees()
				npc.Velocity = Vector(10,0):Rotated(npcdata.twitchangle)
				npcdata.wallbounceleft = npcdata.wallbounceleft - 1
				--shoot
				local params = ProjectileParams()
				local shootnum = math.random(3, 6)
				params.HeightModifier = sprite.Offset.Y
				for i = 0, shootnum, 1 do
					if math.random(1,7) == 7 then
						params.Variant = 1
					else
						params.Variant = 0
					end
					npc:FireProjectiles(npc.Position, Vector(math.random(8,10),0):Rotated(math.random(1,360)), 0, params)
				end
			end
			if npcdata.wallbounceleft <= 0 then
				sprite:Play("DashEnd", false)
			else
				mod:spritePlay(sprite, "Dash")
			end
		elseif sprite:IsPlaying("DashEnd") then
			npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.2)
		elseif sprite:IsFinished("DashEnd") then
			npcdata.twitchangle = math.random(0,360)
			npcdata.state = "flap"
			npcdata.twitchtimer = math.random(30,60)
			npcdata.statetimer = math.random(120, 360)
		end
	end
end