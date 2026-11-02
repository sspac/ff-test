local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local SPLAT_COLOR = Color(1,1,1,1,0,0.33,0)
SPLAT_COLOR:SetColorize(0,1,0,1)

local GIB_COLOR = Color(1,1,1,1)
GIB_COLOR:SetColorize(0,1,0,1)

local PARTICLE_COLOR = Color(1,1,1,1)
PARTICLE_COLOR:SetColorize(0,2,0,1)

function mod:UraniumSpiderInit(npc)
	if npc.SubType == mod.FF.UraniumSpider.Sub then
		local data = mod:GetEntityData(npc)
		local spr = npc:GetSprite()
		local loadGraphics = false
		if npc.Variant == 2 then
			spr:Load("gfx/enemies/uraniumspider/uraniumspider_flaming.anm2", false)
			loadGraphics = true
		end
		if not data.uraniumSpiderOriginalVariant then
			data.uraniumSpiderOriginalVariant = npc.Variant
		end
		if not data.uraniumSpiderOriginalSubType then
			data.uraniumSpiderOriginalSubType = (npc.InitSeed % 3) + 1
		end
		if data.uraniumSpiderOriginalSubType == 2 or data.uraniumSpiderOriginalSubType == 3 then
			spr:ReplaceSpritesheet(2, "gfx/enemies/uraniumspider/uranium_chunk_" .. data.uraniumSpiderOriginalSubType ..".png")
			loadGraphics = true
		end
		if loadGraphics then
			spr:LoadGraphics()
		end
		npc.SplatColor = SPLAT_COLOR
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.UraniumSpiderInit, EntityType.ENTITY_ROCK_SPIDER)

local function CanRockSpiderBeIrradiated(npc)
	return (npc.Variant == 0 or npc.Variant == 2) and (npc.SubType <= 3)
end

local function IrradiateRockSpider(npc, forceFlaming)
	local data = mod:GetEntityData(npc)
	data.uraniumSpiderOriginalVariant = forceFlaming and 2 or npc.Variant
	data.uraniumSpiderOriginalSubType = npc.SubType
	npc:Morph(EntityType.ENTITY_ROCK_SPIDER, data.uraniumSpiderOriginalVariant, mod.FF.UraniumSpider.Sub, -1)
	data.ffRadiationBuildup = 0
	mod:UraniumSpiderInit(npc)
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 1, npc.Position, mod.nilvector, npc)
	poof.Color = mod.ColorRadiationExplosion
end

function mod:UraniumSpiderUpdate(npc)
	local data = mod:GetEntityData(npc)
	
	local canBeIrradiated = CanRockSpiderBeIrradiated(npc)
	local isIrradiated = not canBeIrradiated and (npc.SubType == mod.FF.UraniumSpider.Sub)
	
	data.ffAbsorbRadiation = canBeIrradiated
	data.ffRadioactiveEnemy = canBeIrradiated or isIrradiated
	
	if (canBeIrradiated and mod:GetRadiationPercent(npc) > 0.75) or (isIrradiated and npc.Variant ~= data.uraniumSpiderOriginalVariant) then
		IrradiateRockSpider(npc)
	end
	
	if isIrradiated then
		mod:SetRadioactiveAura(npc, 60)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.UraniumSpiderUpdate, EntityType.ENTITY_ROCK_SPIDER)

function mod:UraniumSpiderTakeDamage(npc, damageAmount, damageFlags, damageSource)
	local canIgnite = CanRockSpiderBeIrradiated(npc) or (npc.Variant == 0 and npc.SubType == mod.FF.UraniumSpider.Sub)
	if canIgnite and damageSource and damageSource.Entity
			and damageSource.Type == EntityType.ENTITY_EFFECT and damageSource.Variant == EffectVariant.FIRE_JET 
			and damageSource.Entity:GetSprite():GetFilename() == "gfx/effects/radioactive_fire_jet.anm2" then
		IrradiateRockSpider(npc:ToNPC(), true)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY-1, mod.UraniumSpiderTakeDamage, EntityType.ENTITY_ROCK_SPIDER)

function mod:UraniumSpiderParticle(eff)
	if eff.SpawnerType > 0 then return end
	
	for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_ROCK_SPIDER, 2, mod.FF.UraniumSpider.Sub)) do
		if ent.Position:Distance(eff.Position) < 5 then
			eff.Color = PARTICLE_COLOR
		end
	end
	
	for _, ent in ipairs(Isaac.FindByType(mod.FF.UraniumChunk.ID, mod.FF.UraniumChunk.Var)) do
		if ent.Position:Distance(eff.Position) < 5 then
			eff.Color = PARTICLE_COLOR
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.UraniumSpiderParticle, EffectVariant.EMBER_PARTICLE)

function mod:UraniumSpiderDeath(npc)
	if npc.SubType == mod.FF.UraniumSpider.Sub then
		npc.SplatColor = GIB_COLOR
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPIDER_EXPLOSION, 0, npc.Position, mod.nilvector, npc):ToEffect()
		eff.Color = npc.SplatColor
		for _, splat in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT)) do
			if splat.Position:Distance(npc.Position) < 1 and splat.FrameCount <= 1 then
				splat:Remove()
			end
		end
		local rock = Isaac.Spawn(mod.FF.UraniumChunk.ID, mod.FF.UraniumChunk.Var, mod:GetEntityData(npc).uraniumSpiderOriginalSubType or 0, npc.Position, npc.Velocity, npc)
		rock:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		local aura = mod:GetEntityData(npc).ffRadioactiveAura
		if aura then
			aura.SpawnerEntity = rock
			aura:FollowParent(rock)
			mod:GetEntityData(rock).ffRadioactiveAura = aura
		end
		npc:Remove()
	else
		mod:GetEntityData(npc).ffAbsorbRadiation = false
		mod:GetEntityData(npc).ffRadioactiveEnemy = false
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.UraniumSpiderDeath, EntityType.ENTITY_ROCK_SPIDER)

function mod:UraniumChunkInit(npc)
	if npc.Variant ~= mod.FF.UraniumChunk.Var then return end
	
	mod:GetEntityData(npc).ffRadioactiveEnemy = true
	npc.SplatColor = SPLAT_COLOR
	
	local subt = npc.SubType
	if subt == 0 then
		subt = (npc.InitSeed % 3) + 1
	end
	
	if subt == 2 or subt == 3 then
		npc:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/uraniumspider/uranium_chunk_" .. subt ..".png")
		npc:GetSprite():LoadGraphics()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.UraniumChunkInit, mod.FF.UraniumChunk.ID)

function mod:UraniumChunk(npc)
	if npc.Variant ~= mod.FF.UraniumChunk.Var then return end
	
	mod:SetRadioactiveAura(npc, 30)
	
	npc.Velocity = mod:Lerp(npc.Velocity, mod.nilvector, 0.2)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.UraniumChunk, mod.FF.UraniumChunk.ID)

function mod:UraniumChunkDeath(npc)
	if npc.Variant ~= mod.FF.UraniumChunk.Var then return end
	
	for i=1,6 do 
		local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TOOTH_PARTICLE, 0, npc.Position, RandomVector()*mod:RandomInt(1,4), npc):ToEffect()
		gib.Color = GIB_COLOR
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.UraniumChunkDeath, mod.FF.UraniumChunk.ID)
