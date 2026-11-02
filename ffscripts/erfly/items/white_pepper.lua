local mod = FiendFolio
local sfx = SFXManager()
local nilvector = mod.nilvector

--No clue why but this wasn't triggering eternal car battery so it's late now ig
mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.LATE, function(_, ItemID, rng, player, useflags)
	local vec = Vector(0, -10)
	if player.Velocity:Length() > 0 then
		vec = player.Velocity:Resized(10)
	end
	if useflags == useflags | UseFlag.USE_CARBATTERY then
		vec = vec:Rotated(36)
	end
	for i = 72, 360, 72 do
		local vecUse = vec:Rotated(i)
		if player:HasTrinket(mod.ITEM.TRINKET.ETERNAL_CAR_BATTERY) then
			vecUse = vecUse:Rotated(math.random(72))
		end
		local fire = Isaac.Spawn(1000, 10, 0, player.Position, vecUse, player):ToEffect()
		fire.Parent = player
		fire.Color = mod.ColorNormal
		fire.CollisionDamage = player.Damage
		fire.Timeout = 300
		fire:Update()
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		for i = 1, 5 do
			player:AddWisp(CollectibleType.COLLECTIBLE_CANDLE, player.Position)
		end
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
	end

	sfx:Play(SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, math.random(90, 110)/100)

	for _, griddle in pairs (Isaac.FindByType(mod.FF.GriddleHorn.ID, mod.FF.GriddleHorn.Var, 0)) do
		griddle:BloodExplode()
		local death = Isaac.Spawn(1000, 77, 0, griddle.Position, nilvector, player)
		death:Update()
		if Game():GetRoom():GetType() == RoomType.ROOM_BOSS then
			Isaac.Spawn(5,100,mod.ITEM.COLLECTIBLE.SPATULA_BADGE,griddle.Position, nilvector, nil)
			sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
		end
		griddle:Remove()
	end

	return true
end, mod.ITEM.COLLECTIBLE.WHITE_PEPPER)