local mod = FiendFolio
local kingWorm = mod.ITEM.COLLECTIBLE.KING_WORM
local kingWormCacheFlags = CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_SHOTSPEED | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_FIREDELAY

mod.KingWormTrinkets = {
	TrinketType.TRINKET_PULSE_WORM,
	TrinketType.TRINKET_WIGGLE_WORM,
	TrinketType.TRINKET_RING_WORM,
	TrinketType.TRINKET_FLAT_WORM,
	TrinketType.TRINKET_HOOK_WORM,
	TrinketType.TRINKET_WHIP_WORM,
	TrinketType.TRINKET_TAPE_WORM,
	TrinketType.TRINKET_LAZY_WORM,
	TrinketType.TRINKET_OUROBOROS_WORM,
	TrinketType.TRINKET_BRAIN_WORM,
	mod.ITEM.TRINKET.TRINITY_WORM,
	mod.ITEM.TRINKET.TAN_WORM,
}

function mod.HasTrinityWorm(player)
	return player:HasTrinket(mod.ITEM.TRINKET.TRINITY_WORM)
end

function mod.GetTrinityWormMultiplier(player)
	return player:GetTrinketMultiplier(mod.ITEM.TRINKET.TRINITY_WORM)
end

function mod.HasTanWorm(player)
	return player:HasTrinket(mod.ITEM.TRINKET.TAN_WORM)
end

function mod.GetTanWormMultiplier(player)
	return player:GetTrinketMultiplier(mod.ITEM.TRINKET.TAN_WORM)
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player)
	local worm = mod.KingWormTrinkets[rng:RandomInt(#mod.KingWormTrinkets) + 1]
	mod:AddInnateTrinketForRoom(player, worm)

	-- Affect both Briends
	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		mod:AddInnateTrinketForRoom(player:GetOtherTwin(), worm)
	end
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		local wisp = player:AddWisp(kingWorm, player.Position)
		if wisp then
			mod:GetEntityData(wisp).wormWispEffect = worm
			SFXManager():Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
		end
	end

	player:AnimateTrinket(worm, "UseItem")
	player:AddCacheFlags(kingWormCacheFlags, true)

	return {Discharge = true, ShowAnim = false}
end, kingWorm)


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local wormWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, kingWorm)
	for _, wisp in ipairs(wormWisps) do
		wisp:Remove()
	end
end)


mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_FIRE_PROJECTILE, function(_, tear)
	if tear and tear:ToTear() and tear.SpawnerEntity and tear.SpawnerEntity.SubType == kingWorm then
		local spawnerdata = mod:GetEntityData(tear.SpawnerEntity)
		local effect = spawnerdata.wormWispEffect
		
		if effect == TrinketType.TRINKET_PULSE_WORM then
			tear:AddTearFlags(TearFlags.TEAR_PULSE)
		elseif effect == TrinketType.TRINKET_WIGGLE_WORM then
			tear:AddTearFlags(TearFlags.TEAR_WIGGLE | TearFlags.TEAR_SPECTRAL)
		elseif effect == TrinketType.TRINKET_RING_WORM then
			tear:AddTearFlags(TearFlags.TEAR_SPIRAL | TearFlags.TEAR_SPECTRAL)
		elseif effect == TrinketType.TRINKET_FLAT_WORM then
			tear:AddTearFlags(TearFlags.TEAR_FLAT)
		elseif effect == TrinketType.TRINKET_HOOK_WORM then
			tear:AddTearFlags(TearFlags.TEAR_SQUARE | TearFlags.TEAR_SPECTRAL)
			tear.FallingSpeed = tear.FallingSpeed - 0.5
		elseif effect == TrinketType.TRINKET_WHIP_WORM then
			tear.Velocity = tear.Velocity:Resized(tear.Velocity:Length() * 1.5)
			tear.FallingSpeed = tear.FallingSpeed + 1.2
		elseif effect == TrinketType.TRINKET_TAPE_WORM then
			tear.FallingSpeed = tear.FallingSpeed - 1.0
		elseif effect == TrinketType.TRINKET_LAZY_WORM then
			tear.Velocity = tear.Velocity:Resized(tear.Velocity:Length() * 0.6)
			tear.FallingSpeed = tear.FallingSpeed - 1.6
		elseif effect == TrinketType.TRINKET_OUROBOROS_WORM then
			tear:AddTearFlags(TearFlags.TEAR_BIG_SPIRAL | TearFlags.TEAR_SPECTRAL)
			tear.FallingSpeed = tear.FallingSpeed - 0.5
		elseif effect == TrinketType.TRINKET_BRAIN_WORM then
			tear:AddTearFlags(TearFlags.TEAR_TURN_HORIZONTAL)
		elseif effect == mod.ITEM.TRINKET.TRINITY_WORM then
			TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.TRINITY)
			tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
			tear.Velocity = tear.Velocity:Rotated(-25) * 1.5
			tear.FallingSpeed = tear.FallingSpeed - 5
		elseif effect == mod.ITEM.TRINKET.TAN_WORM then
            mod:GetEntityData(tear).isTanWorm = true
            mod:GetEntityData(tear).tanWormShotSpeed = tear.Velocity:Length() / 10
			tear.FallingSpeed = tear.FallingSpeed - 7.4
		elseif ConWorm and effect == FiendFolio.ConWormTrinketID then
			mod.ApplyConWorm(tear.SpawnerEntity:ToFamiliar().Player, tear)
		end
	end
end, FamiliarVariant.WISP)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, wisp)
	if wisp.SubType == kingWorm then
		local data = mod:GetEntityData(wisp)
		local effect = data.wormWispEffect
		
		if effect == TrinketType.TRINKET_WIGGLE_WORM or 
		   effect == TrinketType.TRINKET_RING_WORM or
		   effect == TrinketType.TRINKET_HOOK_WORM or
		   effect == TrinketType.TRINKET_OUROBOROS_WORM or
		   effect == mod.ITEM.TRINKET.TRINITY_WORM or
		   effect == mod.ITEM.TRINKET.TAN_WORM
		then
			if wisp.FireCooldown >= 25 then
				wisp.FireCooldown = 25
			end
		end
	end
end, FamiliarVariant.WISP)