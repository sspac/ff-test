local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local WALK_SPEED_MIN = 2
local WALK_SPEED_MAX = 8
local REGEN_HP = EntityConfig.GetEntity(mod.FF.Elephant.ID, mod.FF.Elephant.Var):GetBaseHP() / 3

function mod:ElephantInit(npc)
	mod:GetEntityData(npc).ffRadioactiveEnemy = true
	npc.SplatColor = mod.ColorBobsGreen
end

function mod:ElephantUpdate(npc)
	local data = mod:GetEntityData(npc)
	local spr = npc:GetSprite()
	
	if npc.FrameCount <= 1 then
		spr:Play("Pile", true)
	end
	
	local isPile = (spr:GetAnimation() == "Pile")
	
	if npc.StateFrame > 0 then
		npc.StateFrame = npc.StateFrame - 1
	end

	if spr:IsEventTriggered("Sound") then
		npc:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, 1.0, 0, false, 0.7)
	end
	
	if isPile then
		if npc.StateFrame <= 0 and npc.HitPoints / npc.MaxHitPoints <= 0.75 then
			spr:Play("ReGen", true)
			npc:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, 1.0, 0, false, 1.0)
		else
			npc.Velocity = mod:Lerp(npc.Velocity, mod.nilvector, 0.5)
		end
	elseif not spr:IsPlaying("ReGen") then
		local targetPos = npc:GetPlayerTarget().Position

		data.walkSpeed = data.walkSpeed or WALK_SPEED_MIN
		data.walkSpeedMax = WALK_SPEED_MAX
		local playerSpeed = game:GetNearestPlayer(npc.Position).MoveSpeed
		if playerSpeed < 1 then
			data.walkSpeedMax = data.walkSpeedMax - (1-playerSpeed)*3
		end
		data.walkSpeed = math.min(data.walkSpeedMax, data.walkSpeed + 0.025)

		if spr:IsEventTriggered("Step") then
			npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.6, 0, false, 1.0)
		end

		if game:GetRoom():CheckLine(npc.Position, targetPos, 1, 900) then
			npc.Velocity = mod:Lerp(npc.Velocity, (targetPos - npc.Position):Resized(data.walkSpeed), 0.15)
		else
			npc.Pathfinder:FindGridPath(targetPos, data.walkSpeed / 9.5, 900, true)
		end
		mod:AnimWalkFrame(npc, spr, "WalkHori", "WalkVert", true)
		spr.FlipX = npc.Velocity.X < 0
		spr.PlaybackSpeed = mod:Lerp(1.6, 0.4, (data.walkSpeedMax-data.walkSpeed)/data.walkSpeedMax)
	else
		npc.Velocity = mod:Lerp(npc.Velocity, mod.nilvector, 0.2)
	end
	
	mod:SetRadioactiveAura(npc, isPile and 80 or 60)
end

function mod:ElephantTakeDamageEarly(npc, damage, flags, source)
	local spr = npc:GetSprite()

	if spr:GetAnimation() ~= "Pile" then
		local data = mod:GetEntityData(npc)
		local dmgReduction = 1
		if data.walkSpeed then
			dmgReduction = mod:Lerp(1, 0.1, (data.walkSpeedMax-data.walkSpeed)/data.walkSpeedMax)
		end
		if spr:GetAnimation() == "ReGen" then
			dmgReduction = 0.1
		end
		if dmgReduction ~= 1 then
			return { Damage = damage * dmgReduction }
		end
	end
end

function mod:ElephantTakeDamageLate(npc, damage, flags, source)
	local spr = npc:GetSprite()

	if damage >= npc.HitPoints and not spr:IsPlaying("ReGen") and spr:GetAnimation() ~= "Pile" then
		spr:Play("Pile", true)
		spr.PlaybackSpeed = 1
		npc.HitPoints = REGEN_HP
		npc:BloodExplode()
		npc:ToNPC().StateFrame = 180
		return false
	end
end
