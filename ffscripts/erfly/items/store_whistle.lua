local mod = FiendFolio
local sfx = SFXManager()
local nilvector = mod.nilvector

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player)
	local chest = Isaac.Spawn(EntityType.ENTITY_PICKUP,711,0,Isaac.GetFreeNearPosition(player.Position,40), nilvector, player):ToPickup()
		mod:GetEntityData(chest).funny = true
	local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 15, chest.Position, nilvector, nil)

	local rand = math.random(31)
	if rand == 1 then
		sfx:Play(mod.Sounds.BusterWhistle, 1, 0, false, 1)
	elseif rand < 12 then
		sfx:Play(SoundEffect.SOUND_DANGLE_WHISTLE,1,0,false,1)
	else
		sfx:Play(SoundEffect.SOUND_WHISTLE,1,0,false,1)
	end
	return true
end, mod.ITEM.COLLECTIBLE.STORE_WHISTLE)