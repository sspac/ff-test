local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

include("ffscripts.xalum.pickups.medley_pickup_effects._load")

local function shouldDowngradeToGoldenCursed()
	return (
		not mod.ACHIEVEMENT.HAUNTED_PENNY:IsUnlocked() or
		not Isaac.GetPersistentGameData():Unlocked(Achievement.LUCKY_PENNIES) or
		not Isaac.GetPersistentGameData():Unlocked(Achievement.THE_CELLAR)
	)
end

function mod.CanSpawnMedleyPenny()
	return (
		mod.ACHIEVEMENT.GOLDEN_CURSED_PENNY:IsUnlocked() and
		mod.ACHIEVEMENT.HAUNTED_PENNY:IsUnlocked() and
		Isaac.GetPersistentGameData():Unlocked(Achievement.LUCKY_PENNIES) and
		Isaac.GetPersistentGameData():Unlocked(Achievement.THE_CELLAR)
	)
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SubType == mod.PICKUP.COIN.MEDLEY_STICKY then
		local data = mod:GetEntityData(pickup)
		data.homePosition = pickup.Position
		pickup:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
		pickup.Mass = 1000

		if game:GetRoom():GetFrameCount() ~= 0 then
			if not mod.ACHIEVEMENT.GOLDEN_CURSED_PENNY:IsUnlocked() then
				pickup:Morph(5, 20, mod.PICKUP.COIN.CURSED, true, true, true)
			elseif shouldDowngradeToGoldenCursed() then
				pickup:Morph(5, 20, mod.PICKUP.COIN.GOLDENCURSED, true, true, true)
			end
		end
	end
end, PickupVariant.PICKUP_COIN)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup.SubType == mod.PICKUP.COIN.MEDLEY_STICKY or pickup.SubType == mod.PICKUP.COIN.MEDLEY then
		local sprite = pickup:GetSprite()

		if sprite:IsFinished("Appear") or sprite:IsFinished("Reappear") or sprite:IsFinished("Touched") then
			sprite:Play("Idle")
		end

		if sprite:IsEventTriggered("DropSound") then
			sfx:Play(SoundEffect.SOUND_DIMEDROP, 1, 0, false, 1)
		end

		mod:pennyThatDoublesInSizeEveryDayBehaviour(pickup)
	end

	if pickup.SubType == mod.PICKUP.COIN.MEDLEY_STICKY and not pickup:IsDead() then
		local data = mod:GetEntityData(pickup)
		pickup.Velocity = data.homePosition - pickup.Position
	elseif pickup.SubType == mod.PICKUP.COIN.MEDLEY then
		mod:mobilePennyMovement(pickup)
	end
end, PickupVariant.PICKUP_COIN)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pickup, collider, low)
	local player = collider:ToPlayer()
	local familiar = collider:ToFamiliar()
	if player or familiar then
		if pickup.SubType == mod.PICKUP.COIN.MEDLEY_STICKY then
			if pickup:GetSprite():IsPlaying("Idle") then
				local sprite = pickup:GetSprite()
				sprite:Play("Touched")
			end

			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return true
		elseif pickup.SubType == mod.PICKUP.COIN.MEDLEY then
			local sprite = pickup:GetSprite()
			local rng = pickup:GetDropRNG()

			Isaac.RunCallback(mod.CALLBACK.MEDLEY_PENNY_PICKUP, pickup, collider)

			if rng:RandomFloat() < 0.9 then
				local room = game:GetRoom()
				local spawnPosition = room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition(), 0, true)
				local new = Isaac.Spawn(5, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.MEDLEY_STICKY, spawnPosition, Vector.Zero, pickup.SpawnerEntity)
				new:GetSprite():Play("Reappear")
			end

			mod:triggerPennyPickup(player or familiar.Player, pickup, mod:GetEntityData(pickup).trinketEffectValue or 1)
			game:SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)

			if pickup.OptionsPickupIndex ~= 0 then
				for _, entity in ipairs(Isaac.FindByType(5)) do
					if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed) then
						Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
						entity:Remove()
					end
				end
			end

			sprite:Play("Collect")
			pickup:Die()
			pickup.EntityCollisionClass = 0
			pickup.Velocity = Vector.Zero

			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return true
		end
	end
end, PickupVariant.PICKUP_COIN)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, CallbackPriority.EARLY, function(_, player, collider)
	if collider.Type == 5 and collider.Variant == PickupVariant.PICKUP_COIN and collider.SubType == mod.PICKUP.COIN.MEDLEY_STICKY then
		return true
	end
end)

mod:AddEntityCallback(ModCallbacks.MC_POST_BOMB_DAMAGE, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.MEDLEY_STICKY, function(_, position, damage, radius, lineCheck, source, tearFlags, damageFlags, canDamageSource)
	for _, pickup in pairs(Isaac.FindInRadius(position, radius, EntityPartition.PICKUP)) do
		if pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType == mod.PICKUP.COIN.MEDLEY_STICKY and pickup:Exists() then
			local blastSpeed = math.max(1, 15 - position:Distance(pickup.Position) / 10)
			local new = Isaac.Spawn(5, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.MEDLEY, pickup.Position, (pickup.Position - position):Resized(blastSpeed), pickup.SpawnerEntity)
			mod:copyPennyThatDoublesSize(pickup,new)
			new:GetSprite():Play("Idle")
			new.EntityCollisionClass = 4
			new:Update()
			pickup:Remove()
		end
	end
end)