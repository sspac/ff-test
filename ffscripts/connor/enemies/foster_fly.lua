local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local POST_EXPLOSION_RADIATION_RADIUS = 80
local POST_EXPLOSION_RADIATION_DURATION = 30 * 10 -- 10 seconds

local function IsFosterFly(npc)
	return npc and npc.Type == mod.FF.FosterFly.ID and npc.SubType == mod.FF.FosterFly.Sub
end

function mod:FosterFlyInit(npc)
	if not IsFosterFly(npc) then return end
	
	if npc.Variant > 0 then
		npc:Morph(mod.FF.FosterFly.ID, 0, mod.FF.FosterFly.Sub, -1)
	end
	
	npc.SplatColor = mod.ColorBobsGreen
	mod:GetEntityData(npc).ffRadioactiveEnemy = true
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.FosterFlyInit, mod.FF.FosterFly.ID)

function mod:FosterFlyDeath(npc)
	if not IsFosterFly(npc) then return end
	if not mod:shouldDoDeathEffect(npc) then return end
	
	local data = mod:GetEntityData(npc)
	
	local radZone = mod:SpawnRadioactiveAura(npc, npc.Position, POST_EXPLOSION_RADIATION_RADIUS, POST_EXPLOSION_RADIATION_DURATION)
	radZone.Size = 40
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.FosterFlyDeath, mod.FF.FosterFly.ID)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
	if IsFosterFly(eff.SpawnerEntity) then
		mod:GetEntityData(eff).isRadioactiveExplosion = true
	end
end, EffectVariant.BOMB_EXPLOSION)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.FrameCount <= 1 and mod:GetEntityData(eff).isRadioactiveExplosion then
		eff.Color = mod.ColorRadiationExplosion
	end
end, EffectVariant.BOMB_EXPLOSION)

-- Allied radioactive enemies do not take damage from Foster Fly's explosion.
mod:AddPreNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, damageFlags, sourceEnt, sourceData, sourceRef)
	if damageFlags & DamageFlag.DAMAGE_EXPLOSION ~= 0 and not mod:AllowRadioactiveExplosionFireDamage(npc, data, sourceRef) then
		return false
	end
end, mod.FF.FosterFly.ID, -1, mod.FF.FosterFly.Sub)
