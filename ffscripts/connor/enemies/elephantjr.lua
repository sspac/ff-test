local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local WALK_SPEED_MIN = 2
local WALK_SPEED_MAX = 8
local CRAWL_SPEED = 4
local PILE_STUN = 40 --number of frames the enemy gets stunlocked once turned into a pile
local INITIAL_HP_PCT = 0.5
local REGEN_HP = EntityConfig.GetEntity(mod.FF.ElephantJr.ID, mod.FF.ElephantJr.Var):GetBaseHP() / 2

local function Pathfind(npc, targetPos, speed)
	if game:GetRoom():CheckLine(npc.Position, targetPos, 1, 900) then
		npc.Velocity = mod:Lerp(npc.Velocity, (targetPos - npc.Position):Resized(speed), 0.15)
	else
		npc.Pathfinder:FindGridPath(targetPos, speed / 9.5, 900, true)
	end
end

local function GetRadAuraSamplePoints(aura)
	local room = game:GetRoom()
	local samplePoints = {aura.Position}
	
	local step = 40
	local dist = step
	while dist < aura.Size do
		for i=0,3 do
			local pos = aura.Position + Vector(dist, 0):Rotated(i*90)
			if room:IsPositionInRoom(pos, 5) then
				local gridIndex = room:GetGridIndex(pos)
				if gridIndex > -1 then
					local gridPos = room:GetGridPosition(gridIndex)
					if gridPos:Distance(aura.Position) < aura.Size - 20 then
						table.insert(samplePoints, gridPos)
					end
				end
			end
		end
		dist = dist + step
	end
	
	return samplePoints
end

local function FindNearestRadiationAura(npc)
	local radiationAuras = mod:FindRadiationAuras()
	table.sort(radiationAuras, function(a, b) return a.Position:Distance(npc.Position) < b.Position:Distance(npc.Position) end)
	
	for _, radAura in ipairs(radiationAuras) do
		local samplePoints = GetRadAuraSamplePoints(radAura)
		table.sort(samplePoints, function(a, b) return a:Distance(npc.Position) < b:Distance(npc.Position) end)
		for _, pos in ipairs(samplePoints) do
			if npc.Pathfinder:HasPathToPos(pos, false) then
				return radAura, pos
			end
		end
	end
	return nil, mod.nilvector
end

local function PathfindToNearestRadiation(npc, speed)
	local currentFrame = game:GetFrameCount()
	local data = mod:GetEntityData(npc)
	
	if not data.elephantLastRadAuraCheck or currentFrame - data.elephantLastRadAuraCheck > 30 then
		local radAura, targetPos = FindNearestRadiationAura(npc)
		npc.TargetPosition = targetPos
		data.elephantLastRadAuraCheck = currentFrame
	end
	
	if npc.TargetPosition:Length() > 0 then
		Pathfind(npc, npc.TargetPosition, speed)
	else
		npc.Velocity = mod:Lerp(npc.Velocity, mod.nilvector, 0.2)
		npc:GetSprite():SetFrame(30)
	end
end

function mod:ElephantJrInit(npc)
	local data = mod:GetEntityData(npc)
	data.ffRadioactiveEnemy = true
	data.pileHP = npc.MaxHitPoints
	data.initialHP = npc.MaxHitPoints * INITIAL_HP_PCT
	npc.HitPoints = data.initialHP
	npc.SplatColor = mod.ColorBobsGreen

	if npc.SubType == 1 then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc:GetSprite():Play("PileMove", true)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, mod.nilvector, npc)
	end
end

local function IsMelted(npc)
	local spr = npc:GetSprite()
	local anim = spr:GetAnimation()
	return anim == "IntoPile" or anim == "PileMove" or spr:IsPlaying("ReGen")
end

function mod:ElephantJrUpdate(npc)
	local data = mod:GetEntityData(npc)
	local spr = npc:GetSprite()
	local target = npc:GetPlayerTarget()
	
	local isMelted = IsMelted(npc)
	data.ffAbsorbRadiation = isMelted

	-- Champions need their initial HP set on frame 1 instead of init
	if npc.FrameCount <= 1 and data.initialHP and npc.HitPoints > data.initialHP then
		npc.HitPoints = data.initialHP
	end

	if spr:IsFinished("IntoPile") then
		npc:GetSprite():Play("PileMove", true)
	end
	
	if spr:IsPlaying("ReGen") then
		npc.Velocity = mod:Lerp(npc.Velocity, mod.nilvector, 0.2)
	elseif isMelted then
		if npc.FrameCount < 30 then
			npc:GetSprite():SetFrame(0)
		elseif mod:GetRadiationPercent(npc) > 0.8 then
			spr:Play("ReGen", true)
			npc:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, 1.0, 0, false, 1.0)
			data.pileHP = npc.HitPoints
			npc.HitPoints = REGEN_HP
		else
			local exposedRadZone = mod:IsEnemyExposedToRadiation(npc, false, data)
			if data.pileStun and data.pileStun > 0 then
				local radAura, targetPos = FindNearestRadiationAura(npc)
				if npc.Position:Distance(targetPos) < 120 then
					data.pileStun = 0
				end

				data.pileStun = data.pileStun - 1
				npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
			else
				if exposedRadZone then
					npc.Velocity = mod:Lerp(npc.Velocity, (exposedRadZone.Position - npc.Position):Resized(1), 0.1)
				else
					PathfindToNearestRadiation(npc, CRAWL_SPEED)
				end
			end
		end
	else
		data.walkSpeed = data.walkSpeed or WALK_SPEED_MIN
		local walkSpeedMax = WALK_SPEED_MAX
		local playerSpeed = game:GetNearestPlayer(npc.Position).MoveSpeed
		if playerSpeed < 1 then
			walkSpeedMax = walkSpeedMax - (1-playerSpeed)*3
		end
		data.walkSpeed = math.min(walkSpeedMax, data.walkSpeed + 0.05)

		if mod:isConfuse(npc) then
			npc.Pathfinder:MoveRandomly()
		elseif mod:isScare(npc) then
			npc.Velocity = mod:Lerp(npc.Velocity, (npc.Position - target.Position):Resized(data.walkSpeed * 0.5), 0.15)
		elseif mod:isFriend(npc) and target.Type == EntityType.ENTITY_PLAYER and target.Position:Distance(npc.Position) < 60 then
			npc.Velocity = mod:Lerp(npc.Velocity, mod.nilvector, 0.2)
		else
			Pathfind(npc, target.Position, data.walkSpeed)
		end
		mod:AnimWalkFrame(npc, spr, "WalkHori", "WalkHori", true)
		spr.FlipX = npc.Velocity.X < 0
	end
end

function mod:ElephantJrTakeDamageEarly(npc, damage, flags, source)
	if IsMelted(npc) then
		if npc:GetSprite():IsPlaying("ReGen") then
			return { Damage = damage * 0.25 }
		--elseif mod:IsEnemyExposedToRadiation(npc) then
			--return { Damage = damage * 0.8 }
		end
	end
end

function mod:ElephantJrTakeDamageLate(npc, damage, flags, source)
	if damage >= npc.HitPoints and not IsMelted(npc) then
		npc:GetSprite():Play("IntoPile", true)
		local data = mod:GetEntityData(npc)
		if not data.pileHP then
			data.pileHP = npc.MaxHitPoints
		end
		npc.HitPoints = data.pileHP
		data.walkSpeed = nil
		data.pileStun = PILE_STUN
		npc:BloodExplode()
		mod:SetRadiationBuildup(npc, 0)
		return false
	end
end
