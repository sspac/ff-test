local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- King of Pentacles? (Converts trinkets to ROCKS)
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	local success

	for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
		pickup = pickup:ToPickup()
		local golden = mod:IsGoldTrinket(pickup.SubType)
		local blasphemous = mod:IsPickupTrinketBlasphemous(pickup)
		if not mod.IsRockTrinket(pickup.SubType) then
			game:SpawnParticles(pickup.Position, EffectVariant.ROCK_PARTICLE, 7, 5, nil, nil, 1)

			local newid = mod.GetGolemTrinket()
			if golden then
				newid = newid | TrinketType.TRINKET_GOLDEN_FLAG
			end
			local newTrinket = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, mod.GetGolemTrinket(), pickup.Position, pickup.Velocity, nil):ToPickup()
			if blasphemous then
				mod:MakePickupTrinketBlasphemous(newTrinket)
			end
			newTrinket:GetSprite():SetFrame(6)
			pickup:Remove()
			success = true
		end
	end

	for slot=0,1 do
		local tid = player:GetTrinket(slot)
		if tid > 0 and not mod.IsRockTrinket(tid) then
			local newid = mod.GetGolemTrinket()
			if mod:IsGoldTrinket(tid) then
				newid = newid | TrinketType.TRINKET_GOLDEN_FLAG
			end
			local blasphemous = mod:IsPlayerTrinketBlasphemous(player, slot)
			player:TryRemoveTrinket(tid)
			player:AddTrinket(newid)
			if blasphemous then
				mod:MakePlayerTrinketBlasphemous(player, slot)
			end
			game:SpawnParticles(player.Position, EffectVariant.ROCK_PARTICLE, 5, 4, nil, nil, 1)
			success = true
		end
	end

	if success then
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)
	end

	mod:trySayAnnouncerLine(mod.Sounds.VACardPlayingKingPentaclesReverse, flags, 50)
end, mod.ITEM.CARD.REVERSE_KING_OF_PENTACLES)


-- Misprinted King of Pentacles (turns trinkets BLASPHEMOUS)
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	local success

	for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
		pickup = pickup:ToPickup()
		if not mod:IsPickupTrinketBlasphemous(pickup) then
			mod:MakePickupTrinketBlasphemous(pickup)
			mod:GetEntityData(pickup).BlasphemousTransform = 0
			success = true
		end
	end

	for slot=0,1 do
		if player:GetTrinket(slot) > 0 and not mod:IsPlayerTrinketBlasphemous(player, slot) then
			mod:MakePlayerTrinketBlasphemous(player, slot)
			success = true
		end
	end

	if success then
		sfx:Play(mod.Sounds.FlashDevilCard, 1, 0, false, 1.2)
	end

	mod:trySayAnnouncerLine(mod.Sounds.VACardPlayingKingPentacles, flags, 50)
end, mod.ITEM.CARD.MISPRINTED_KING_OF_PENTACLES)

-- Blasphemous transformation effect.
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local data = mod:GetEntityData(pickup)

	if data.BlasphemousTransform then
		local r = math.min(data.BlasphemousTransform / 100, 1.0)
		local c = Color(1,1,1, 1, r)
		pickup:SetColor(c, 2, 1, true, true)
		data.BlasphemousTransform = data.BlasphemousTransform + 5

		if pickup.FrameCount % 2 == 0 then
			local pos = pickup.Position + Vector(Random() % pickup.Size * 2, 0):Rotated(Random() % 360) + Vector(0, -pickup.Size*2)
			local vel = Vector(0, -4)
			local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, pos, vel, pickup)
			local col = Color(1,1,1,1)
			col:SetColorize(r*2,0,0,1)
			particle.Color = col
		end

		pickup:GetSprite().Offset = Vector(math.cos(math.pi * pickup.FrameCount / 1) * r * 1.5, -r*5)

		if r >= 1.0 then
			local c1 = Color(0,0,0, 0.9, 1)
			local c2 = Color(0,0,0, 0.6)
			local d = 8

			local poof1 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pickup.Position, mod.nilvector, nil)
			poof1.Color = c2
			poof1:SetColor(c1, d, 1, true, true)
			poof1.SpriteScale = Vector(0.4, 0.4)

			local poof2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, pickup.Position + Vector(0, -10), mod.nilvector, nil)
			poof2.Color = c2
			poof2:SetColor(c1, d, 1, true, true)
			poof2.SpriteScale = Vector(0.5, 0.5)

			pickup:GetSprite().Offset = mod.nilvector
			pickup:GetSprite():Play("Appear", true)
			pickup:GetSprite():SetFrame(6)

			sfx:Play(SoundEffect.SOUND_BLACK_POOF)
			data.BlasphemousTransform = nil
			data.DidBlasphemousTransform = true
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, function(_, pickup, collider)
	if collider.Type == EntityType.ENTITY_PLAYER and not pickup:Exists() and mod:IsQueuedTrinketBlasphemous(collider) then
		collider:ToPlayer():GetHeldSprite().Color = Color(1,1,1,1)
	end
end, PickupVariant.PICKUP_TRINKET)
