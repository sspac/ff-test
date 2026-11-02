local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local HALF_LIFE_HEAD = {
	RadGainRate = 1.1,
	RadLossRate = 1/3,
	MinSpeed = 5,
	MaxSpeed = 18,
}

local MELTDOWNS_HEAD = {
	RadGainRate = 1.3,
	RadLossRate = 0.666,
	RadMoveSpeed = 8,  -- Default is ~5
	TransformRads = 0.7,

	-- Meltdown's Head 2 orbital fire
	FireLifeSpan = 40,
	FireHitboxRadius = 8,  -- Previous: 10
	FireMinSize = 0.5,  -- Previous: 1/3
	FireMaxSize = 0.8,  -- Previous: 2/3
	FireSpinSpeed = 1,
	FireInitialSpeed = 5,
	FireMinSpeedMult = 1.0,  -- Previous: 0.75
	FireMaxSpeedMult = 1.75,
	-- These values are very sensitive, small adjustments can do a lot
	FireAcceleration = 0.995,  -- Previous: 1.0 (none)
	FireShrinkRate = 0.9875,  -- Previous: 1.0 (none)
}

function mod:HalfLifeHeadInit(npc)
	local data = mod:GetEntityData(npc)

	data.ffRadioactiveEnemy = true
	data.ffAbsorbRadiation = true
	data.ffNoRadiationColor = true
	data.ffRadiationGainRate = HALF_LIFE_HEAD.RadGainRate
	data.ffRadiationLossRate = HALF_LIFE_HEAD.RadLossRate
end

function mod:HalfLifeHeadUpdate(npc)
	local data = mod:GetEntityData(npc)

	local radiation = mod:GetRadiationPercent(npc, data)

	local currentVel = npc.Velocity
	local targetVel = currentVel:Resized(mod:Lerp(HALF_LIFE_HEAD.MinSpeed, HALF_LIFE_HEAD.MaxSpeed, radiation))
	npc.Velocity = mod:Lerp(currentVel, targetVel, 0.2)

	if radiation > 0 then
		if npc.FrameCount % math.floor(mod:Lerp(10, 2, radiation)) == 0 then
			local pos = npc.Position + Vector(Random() % (npc.Size*1.5), 0):Rotated(Random() % 360) + Vector(0, -npc.Size*1.5)
			local vel = Vector(0, -4) --+ npc.Velocity:Rotated(180) * 0.5
			local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, pos, vel, npc)
			particle.Color = Color(1,1,1,1,0,0,0,0,2,0,1)
		end
		if npc.FrameCount % 2 == 0 then
			local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position + Vector(0, -npc.Size), mod.nilvector, npc):ToEffect()
			smoke.Color = Color(1,1,1,radiation*0.6,0,0.5,0,0,2,0,1)
		end
	end
end

function mod:HalfLifeHeadRender(npc)
	local data = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()
	
	if sprite:IsPlaying("Death") and not game:IsPaused() then
		mod:SetRadiationBuildup(npc, mod:GetRadiationBuildup(npc, data) * 0.95, data)
	end
	
	local radiation = mod:GetRadiationPercent(npc, data)
	for i=1,3 do
		sprite:GetLayer(i):SetColor(Color(1,1,1,radiation))
	end
end

function mod:MeltdownsHeadInit(npc)
	local data = mod:GetEntityData(npc)

	data.ffRadioactiveEnemy = true
	data.ffAbsorbRadiation = true
	data.ffRadiationGainRate = MELTDOWNS_HEAD.RadGainRate
	data.ffRadiationLossRate = MELTDOWNS_HEAD.RadLossRate

	if npc.SubType ~= mod.FF.MeltdownsHead2.Sub then
		npc.SplatColor = Color(1,1,1,1)
	end
end

local function ThrowFalafel(npc)
	-- Copied from Meltdown
	local skin = Isaac.Spawn(mod.FF.Falafel.ID, mod.FF.Falafel.Var, 0, npc.Position + Vector(0, 5) + RandomVector():Resized(0.5 + mod:RandomInt(25)/10), Vector(0, 1):Rotated(-45 + mod:RandomInt(90)):Resized(0.5 + mod:RandomInt(25)/10), npc)
	skin.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	skin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	skin.SpriteOffset = Vector(0, -10 - math.random(20))
	local data = mod:GetEntityData(skin)
	data.fallspeed = -8 - math.random(4)
	data.fallaccel = 1
	data.state = "thrown"
	data.ffRadioactiveEnemy = true
	skin:Update()
end

function mod:MeltdownsHeadUpdate(npc)
	local data = mod:GetEntityData(npc)

	npc.ProjectileCooldown = 10

	if mod:GetRadiationPercent(npc, data) >= MELTDOWNS_HEAD.TransformRads then
		npc:BloodExplode()
		npc:BloodExplode()
		for i=1,3 do
			ThrowFalafel(npc)
		end
		npc:Morph(mod.FF.MeltdownsHead2.ID, mod.FF.MeltdownsHead2.Var, mod.FF.MeltdownsHead2.Sub, -1)
		mod:MeltdownsHead2Update(npc)
	end
end

function mod:MeltdownsHead2Update(npc)
	local data = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()

	local radpct = mod:GetRadiationPercent(npc, data)
	if not data.MeltdownsHeadIrradiated and radpct >= MELTDOWNS_HEAD.TransformRads then
		data.MeltdownsHeadIrradiated = true
		npc.State = NpcState.STATE_ATTACK
		sprite:Play("Attack", true)
		npc:PlaySound(SoundEffect.SOUND_FLAME_BURST, 1.0, 2, false, 1.0)
	elseif radpct < 0.1 then
		data.MeltdownsHeadIrradiated = false
		data.MeltdownsHeadFireFrame = nil
	end

	if sprite:IsPlaying("Attack") then
		if data.MeltdownsHeadIrradiated and radpct < MELTDOWNS_HEAD.TransformRads then
			mod:SetRadiationPercent(npc, MELTDOWNS_HEAD.TransformRads, data)
			radpct = MELTDOWNS_HEAD.TransformRads
		end
		if sprite:IsEventTriggered("Shoot") then
			data.MeltdownsHeadFireFrame = npc.FrameCount % 25
		end
	else
		npc.ProjectileCooldown = 5
	end

	for _, i in ipairs({2,4}) do
		sprite:GetLayer(i):SetColor(Color(1,1,1, data.MeltdownsHeadIrradiated and math.min(1, radpct*2) or 0))
	end

	if npc.State == NpcState.STATE_MOVE and data.MeltdownsHeadIrradiated then
		local currentVel = npc.Velocity
		local targetVel = currentVel:Resized(MELTDOWNS_HEAD.RadMoveSpeed)
		npc.Velocity = mod:Lerp(currentVel, targetVel, 0.2)
	end

	--Fire
	if data.MeltdownsHeadIrradiated and npc.FrameCount % 25 == data.MeltdownsHeadFireFrame then
		-- Copied from Meltdown
		data.fireRots = data.fireRots or 0
		data.fireRots = data.fireRots + 1
		local vec = Vector(0, MELTDOWNS_HEAD.FireInitialSpeed):Rotated(45 * data.fireRots)
		for i = 72, 360, 72 do
			local fire = Isaac.Spawn(1000,7005, 10, npc.Position + Vector(0,-25), vec:Rotated(i) + npc.Velocity, npc):ToEffect()
			fire.PositionOffset = Vector(0, 12)
			local fireData = mod:GetEntityData(fire)
			fireData.timer = MELTDOWNS_HEAD.FireLifeSpan
			fireData.Radius = MELTDOWNS_HEAD.FireHitboxRadius
			fireData.initVel = vec:Rotated(i)
			fireData.parentcounter = 1
			fireData.subt10val1 = mod:Lerp(MELTDOWNS_HEAD.FireMinSpeedMult, MELTDOWNS_HEAD.FireMaxSpeedMult, radpct)
			fireData.subt10val2 = MELTDOWNS_HEAD.FireSpinSpeed
			fireData.MeltdownsHeadFire = true
			local fireSpr = fire:GetSprite()
			fireSpr:ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_radioactive.png")
			fireSpr:LoadGraphics()
			local fireSize = mod:Lerp(MELTDOWNS_HEAD.FireMinSize, MELTDOWNS_HEAD.FireMaxSize, radpct)
			fireSpr.Scale = Vector(fireSize, fireSize)
			fire.Parent = npc
			fire:Update()
		end
	end
end

function mod:UpdateMeltdownsHeadFire(fire, data)
	if data.MeltdownsHeadFire then
		data.subt10val1 = data.subt10val1 * MELTDOWNS_HEAD.FireAcceleration
		data.SpriteScale = data.SpriteScale * MELTDOWNS_HEAD.FireShrinkRate
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, id, var, subt, pos, vel, spawner, seed)
	if spawner and id == EntityType.ENTITY_EFFECT and var == EffectVariant.FIRE_JET and subt == 0
			and spawner.Type == mod.FF.MeltdownsHead2.ID and spawner.Variant == mod.FF.MeltdownsHead2.Var and spawner.SubType == mod.FF.MeltdownsHead2.Sub then
		return {mod.FF.RadioactiveFireJet.ID, mod.FF.RadioactiveFireJet.Var, mod.FF.RadioactiveFireJet.Sub, seed}
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	local variant = npc.Variant

	if variant == mod.FF.HalfLifeHead.Var then
		mod:HalfLifeHeadInit(npc)
	elseif variant == mod.FF.MeltdownsHead.Var and (npc.SubType == mod.FF.MeltdownsHead.Sub or npc.SubType == mod.FF.MeltdownsHead2.Sub) then
		mod:MeltdownsHeadInit(npc)
	end
end, EntityType.ENTITY_DEATHS_HEAD)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local variant = npc.Variant

	if variant == mod.FF.HalfLifeHead.Var then
		mod:HalfLifeHeadUpdate(npc)
	elseif variant == mod.FF.MeltdownsHead.Var then
		local subt = npc.SubType
		if subt == mod.FF.MeltdownsHead.Sub then
			mod:MeltdownsHeadUpdate(npc)
		elseif subt == mod.FF.MeltdownsHead2.Sub then
			mod:MeltdownsHead2Update(npc)
		end
	end
end, EntityType.ENTITY_DEATHS_HEAD)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, function(_, npc)
	if npc.Variant == mod.FF.HalfLifeHead.Var then
		mod:HalfLifeHeadRender(npc)
	end
end, EntityType.ENTITY_DEATHS_HEAD)

mod:AddPreNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, damageFlags, sourceEnt, sourceData, sourceRef)
	if sourceData.MeltdownsHeadFire and not mod:AllowRadioactiveExplosionFireDamage(npc, data, sourceRef) then
		return false
	end
end, 1000, 7005, 10)
