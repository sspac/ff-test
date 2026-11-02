local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:tryOpenFFChest(pickup)
	if mod:GetEntityData(pickup).payToPlayMode and pickup.Variant == 711 then
		pickup:GetSprite():Play("OpenP2P")
	else
		pickup:GetSprite():Play("Open")
	end

	pickup.SubType = mod.shopChestStates.Opening
	mod:GetEntityData(pickup).Opened = true
	sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 0, false, 1)
	sfx:Play(SoundEffect.SOUND_UNLOCK00, 1, 0, false, 1)

	if pickup.Variant == 713 then
		mod:openGlassChest(pickup)
	else
		--Included as part of the openGlassChest function
		if REPENTOGON and game:GetRoom():GetType() == RoomType.ROOM_CHALLENGE then
			Ambush.StartChallenge()
		end
	end

	if pickup.OptionsPickupIndex ~= 0 then
		local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
		for _, entity in ipairs(pickups) do
			if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
			   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
			then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
				entity:Remove()
			end
		end

		pickup.OptionsPickupIndex = 0
	end
end

function mod:FFChestOpening(pickup, collider)
	if collider.Type == 1 then
		collider = collider:ToPlayer()
		if (not mod:GetEntityData(pickup).Opened) and (pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") or pickup:GetSprite():IsPlaying("IdleP2P")) then
			if (mod:GetEntityData(pickup).payToPlayMode and collider:GetNumCoins() > 0)
			or ((not mod:GetEntityData(pickup).payToPlayMode) and (collider:HasTrinket(TrinketType.TRINKET_PAPER_CLIP) or collider:TryUseKey())) then
				if mod:GetEntityData(pickup).payToPlayMode then
					collider:AddCoins(-1)
				end	
				mod:tryOpenFFChest(pickup)

    			Isaac.RunCallback(ModCallbacks.MC_POST_OPEN_CHEST, pickup, collider)
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.FFChestOpening, mod.PICKUP.VARIANT.REHEATED_CHEST)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.FFChestOpening, mod.PICKUP.VARIANT.SHOP_CHEST)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.FFChestOpening, mod.PICKUP.VARIANT.GLASS_CHEST)

local sharpKeyChests = {
	[mod.PICKUP.VARIANT.REHEATED_CHEST] = true,
	[mod.PICKUP.VARIANT.SHOP_CHEST] = true,
	[mod.PICKUP.VARIANT.GLASS_CHEST] = true,
}

function mod:sharpKeyTearUpdate(tear)
	for _, pickup in ipairs(Isaac.FindInRadius(tear.Position, tear.Size, EntityPartition.PICKUP)) do
		pickup = pickup:ToPickup()
		if sharpKeyChests[pickup.Variant] then
			if (not mod:GetEntityData(pickup).Opened) and (pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") or pickup:GetSprite():IsPlaying("IdleP2P")) then
				mod:tryOpenFFChest(pickup)
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.sharpKeyTearUpdate, TearVariant.KEY)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.sharpKeyTearUpdate, TearVariant.KEY_BLOOD)