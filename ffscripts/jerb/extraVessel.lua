local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

FiendFolio.Vessels = {
	mod.ITEM.TRINKET.EXTRA_VESSEL,
	mod.ITEM.TRINKET.HALF_VESSEL,
	mod.ITEM.TRINKET.FULL_VESSEL
}

for i, trink in ipairs(FiendFolio.Vessels) do
	FiendFolio.AddTrinketPickupCallback(nil, nil, trink, function(player)
		player:AddMaxHearts(2)
		player:AddHearts(i - 1)
	end)
end

FiendFolio.RockVessels = {
	FiendFolio.ITEM.ROCK.VESSEL_ROCK,
	FiendFolio.ITEM.ROCK.HALF_VESSEL_ROCK,
	FiendFolio.ITEM.ROCK.FULL_VESSEL_ROCK
}

for i, trink in ipairs(FiendFolio.RockVessels) do
	FiendFolio.AddTrinketPickupCallback(nil, nil, trink, function(player)
		player:AddMaxHearts(2)
		player:AddHearts(i - 1)
	end)
end

-- returns spill-over amount, false if no trinket change happened, and nil if there are no trinkets
-- if a player ever has more than one of these trinkets, it will break
function FiendFolio.HandleVesselTrinketChange(player, amount, dontChangeTrinkets)
	local defaultReturnVal = nil
	for idx, checking in ipairs(FiendFolio.Vessels) do
		local slot, gold = FiendFolio.GetTrinketSlot(player, checking)
		if slot >= 0 then
			local hasTwoTrinkets = player:GetTrinket(1) ~= 0
			local ret = 0 -- normal processing

			local newidx = math.ceil(idx + amount)
			if newidx < 1 then
				ret = newidx - 1 -- went below vessel
				newidx = 1
			end
			local len = #FiendFolio.Vessels
			if newidx > len then
				ret = newidx - len -- went above vessel
				newidx = len
			end

			local newtrink = FiendFolio.Vessels[newidx]
			if newtrink ~= checking then
				if not dontChangeTrinkets then
					local oldTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, slot, false)
					local data
					if oldTrinket then
						data = oldTrinket.Data
						oldTrinket.Data = {}
					end
					player:TryRemoveTrinket(checking)
					if gold then
						newtrink = newtrink + TrinketType.TRINKET_GOLDEN_FLAG
					end
					player:AddTrinket(newtrink)
					if amount > 0 then mod:GetEntityData(player).ffFrameVesselHealed = game:GetFrameCount() end
					if data then
						local newTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, (hasTwoTrinkets and 1) or slot, true)
						newTrinket.Data = data
					end
				end
				return ret
			end

			defaultReturnVal = false
		end
	end
	return defaultReturnVal
end

--For Vessel Rock
function FiendFolio.HandleVesselTrinketChange2(player, amount, dontChangeTrinkets)
	local defaultReturnVal = nil
	for idx, checking in ipairs(FiendFolio.RockVessels) do
		local slot, gold = FiendFolio.GetTrinketSlot(player, checking)

		if slot >= 0 then
			local hasTwoTrinkets = player:GetTrinket(1) ~= 0
			local ret = 0 -- normal processing

			local newidx = math.ceil(idx + amount)
			if newidx < 1 then
				if not dontChangeTrinkets then
					local oldTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, slot, false)
					local data
					if oldTrinket then
						data = oldTrinket.Data
						oldTrinket.Data = {}
					end
					player:TryRemoveTrinket(checking)
					sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)
					for i=1,3 do
						local gibs = Isaac.Spawn(1000, 35, 0, player.Position, RandomVector():Resized(math.random(10,20)/6), player):ToEffect()
						gibs.Color = mod.ColorRockGibs
						gibs:Update()
						local smoke = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, player.Position, RandomVector()*3, player):ToEffect()
						smoke:SetTimeout(15)
						smoke.SpriteScale = Vector(0.05,0.05)
					end
					if gold then
						player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND + TrinketType.TRINKET_GOLDEN_FLAG)
					else
						player:AddTrinket(FiendFolio.ITEM.ROCK.POCKET_SAND)
					end
					if data then
						local newTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, (hasTwoTrinkets and 1) or slot, true)
						newTrinket.Data = data
					end
				end
				return 0
			end
			local len = #FiendFolio.RockVessels
			if newidx > len then
				ret = newidx - len -- went above vessel
				newidx = len
			end

			local newtrink = FiendFolio.RockVessels[newidx]
			if newtrink ~= checking then
				if not dontChangeTrinkets then
					local oldTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, slot, false)
					local data
					if oldTrinket then
						data = oldTrinket.Data
						oldTrinket.Data = {}
					end
					player:TryRemoveTrinket(checking)
					if gold then
						newtrink = newtrink + TrinketType.TRINKET_GOLDEN_FLAG
					end
					player:AddTrinket(newtrink)
					if amount > 0 then mod:GetEntityData(player).ffFrameVesselRockHealed = game:GetFrameCount() end
					if data then
						local newTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, (hasTwoTrinkets and 1) or slot, true)
						newTrinket.Data = data
					end
				end
				return ret
			end

			defaultReturnVal = false
		end
	end
	return defaultReturnVal
end

function FiendFolio.HandleVesselHeartCollision(pickup, player, alreadyDealtSpikesDamage)
	local heal = 0
	local dealtSpikesDamage = false

	if not (pickup and player) then
		return nil, dealtSpikesDamage
	end

	if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_HEART then
		if pickup:GetSprite():IsPlaying("Collect") or pickup.Touched then
			return nil, dealtSpikesDamage
		end

		if pickup.SubType == HeartSubType.HEART_FULL or
		   pickup.SubType == HeartSubType.HEART_SCARED
		then
			if not player:CanPickRedHearts() then
				heal = 2
			end
		elseif pickup.SubType == HeartSubType.HEART_HALF then
			if not player:CanPickRedHearts() then
				heal = 1
			end
		elseif pickup.SubType == HeartSubType.HEART_DOUBLEPACK then
			if not player:CanPickRedHearts() then
				heal = 4
			end
		elseif pickup.SubType == HeartSubType.HEART_BLENDED then
			if not (player:CanPickRedHearts() or player:CanPickSoulHearts()) or
			   player:GetPlayerType() == PlayerType.PLAYER_THELOST or
			   player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
			then
				heal = 2
			end
		end
	elseif pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART then
		if not (player:CanPickRedHearts() or player:CanPickBlackHearts()) or
		   player:GetPlayerType() == PlayerType.PLAYER_THELOST or
		   player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		then
			heal = 2
		end
	elseif pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART then
		if not (player:CanPickRedHearts() or CustomHealthAPI.Library.CanPickKey(player, "IMMORAL_HEART")) or
		   player:GetPlayerType() == PlayerType.PLAYER_THELOST or
		   player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
		then
			heal = 2
		end
	end

	if heal == 0 then
		return nil, dealtSpikesDamage
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGGYS_BOW) then
		heal = heal * 2
	end

	local dexterityHeal = 0
	if player:HasTrinket(FiendFolio.ITEM.ROCK.ODDLY_SMOOTH_STONE) then
		dexterityHeal = math.max(0, math.ceil(mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ODDLY_SMOOTH_STONE)))
	end
	heal = heal + dexterityHeal

	if mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.EXTRA_VESSEL) or
	   mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.HALF_VESSEL) or
	   mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.FULL_VESSEL) or
	   mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.VESSEL_ROCK) or
	   mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.HALF_VESSEL_ROCK) or
	   mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.FULL_VESSEL_ROCK)
	then
		if pickup.Price == PickupPrice.PRICE_SPIKES and
		   not (alreadyDealtSpikesDamage or
		        player:GetPlayerType() == PlayerType.PLAYER_JACOB2_B or
		        player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE))
		then
			local tookDamage = player:TakeDamage(2.0, 268435584, EntityRef(nil), 30)
			dealtSpikesDamage = true

			if not tookDamage then
				return nil, dealtSpikesDamage
			end
		end
	end

	local spill = FiendFolio.HandleVesselTrinketChange2(player, heal)
	if not (spill and spill >= 0) then
		spill = FiendFolio.HandleVesselTrinketChange(player, heal)
	end
	if spill and spill >= 0 then
		if pickup.OptionsPickupIndex ~= 0 then
			local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
			for _, entity in ipairs(pickups) do
				if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
				   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
				then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
					entity:Remove()
				end
			end
		end

		SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES, 1, 0, false, 1)

		if pickup:IsShopItem() then
			local pickupSprite = pickup:GetSprite()
			local holdSprite = Sprite()

			holdSprite:Load(pickupSprite:GetFilename(), true)
			holdSprite:Play(pickupSprite:GetAnimation(), true)
			holdSprite:SetFrame(pickupSprite:GetFrame())
			player:AnimatePickup(holdSprite)

			if pickup.Price > 0 then
				player:AddCoins(-1 * pickup.Price)
			end

			CustomHealthAPI.Library.TriggerRestock(pickup)
			CustomHealthAPI.Helper.TryRemoveStoreCredit(player)

			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			pickup:Remove()
		else
			pickup:GetSprite():Play("Collect", true)
			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			pickup:Die()
		end

		Game():GetLevel():SetHeartPicked()
		Game():ClearStagesWithoutHeartsPicked()
		Game():SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)

		local overheal = spill
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.HEART_OF_CHINA) then
			local persistentData = mod.GetPersistentPlayerData(player)
			persistentData.shardOfChinaHearts = persistentData.shardOfChinaHearts + overheal
			overheal = 0
		elseif mod.IsPlayerHoldingTrinket(player, mod.ITEM.ROCK.SHARD_OF_GOLEM) then
			local persistentData = mod.GetPersistentPlayerData(player)
			local overhealToUse = math.min(overheal, 8 - persistentData.shardOfChinaHearts)
			persistentData.shardOfChinaHearts = persistentData.shardOfChinaHearts + overhealToUse
			overheal = overheal - overhealToUse
		elseif mod.IsPlayerHoldingTwoTrinkets(player, mod.ITEM.TRINKET.SHARD_OF_CHINA) then
			local persistentData = mod.GetPersistentPlayerData(player)
			local overhealToUse = math.min(overheal, 12 - persistentData.shardOfChinaHearts)
			persistentData.shardOfChinaHearts = persistentData.shardOfChinaHearts + overhealToUse
			overheal = overheal - overhealToUse
		elseif mod.IsPlayerHoldingTrinket(player, mod.ITEM.TRINKET.SHARD_OF_CHINA) then
			local persistentData = mod.GetPersistentPlayerData(player)
			local overhealToUse = math.min(overheal, 6 - persistentData.shardOfChinaHearts)
			persistentData.shardOfChinaHearts = persistentData.shardOfChinaHearts + overhealToUse
			overheal = overheal - overhealToUse
		end

		if player:HasTrinket(FiendFolio.ITEM.TRINKET.LEFTOVERS) then
			overheal = math.max(0, overheal - dexterityHeal)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGGYS_BOW) then
				overheal = math.floor(overheal / 2)
			end
			if overheal > 0 then
				mod:setLeftovers(pickup, overheal)
			end
		end

		return true, dealtSpikesDamage
	end
	return nil, dealtSpikesDamage
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.IMPORTANT, function(_, pickup, collider, low)
	local player = collider:ToPlayer()
	if player == nil then
		return
	end

	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
		if player:GetOtherTwin() ~= nil then
			player = player:GetOtherTwin()
		end
	end

	local data = mod:GetEntityData(pickup)

	local collisionPlayer = collider:ToPlayer()
	if collisionPlayer:GetPlayerType() == PlayerType.PLAYER_THESOUL_B and CustomHealthAPI.Helper.IsHoldingTaintedForgotten(collisionPlayer) then
		collisionPlayer = collisionPlayer:GetOtherTwin()
	end
	if pickup:IsShopItem() and
	   (pickup.Price > player:GetNumCoins() or
	   (not player:IsExtraAnimationFinished() and not data.CHAPIHeartPickupSpentSpikesCostAlready))
	then
		return
	end

	if not ((pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType >= 1 and pickup.SubType <= 12) or
	        pickup.Variant == FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART or
	        pickup.Variant == FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART or
	        pickup.Variant == FiendFolio.PICKUP.VARIANT.IMMORAL_HEART or
	        pickup.Variant == FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART or
	        pickup.Variant == FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART or
	        pickup.Variant == FiendFolio.PICKUP.VARIANT.MORBID_HEART or
	        pickup.Variant == FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART or
	        pickup.Variant == FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART)
	then
		return
	end

	local returnVal = nil

	local returnValOfFunc, dealtSpikesDamageOfFunc = FiendFolio.HandleVesselHeartCollision(pickup, player, data.CHAPIHeartPickupSpentSpikesCostAlready)
	data.CHAPIHeartPickupSpentSpikesCostAlready = data.CHAPIHeartPickupSpentSpikesCostAlready or dealtSpikesDamageOfFunc
	if returnValOfFunc ~= nil then
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
		return returnValOfFunc
	end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, src, frames)
	local player = entity:ToPlayer()
	local data = mod:GetEntityData(player)

	if player:GetPlayerType() == PlayerType.PLAYER_JACOB_B and src.Type == EntityType.ENTITY_DARK_ESAU then
		return
	end

	if flags & DamageFlag.DAMAGE_FAKE == 0 and not (data.MaliceMinion or data.MaliceHidden) then
		local spill = FiendFolio.HandleVesselTrinketChange(player, -amount)
		if spill then
			return {Damage = 1, DamageFlags = DamageFlag.DAMAGE_FAKE}
		end

		local spill = FiendFolio.HandleVesselTrinketChange2(player, -amount)
		if spill then
			return {Damage = 1, DamageFlags = DamageFlag.DAMAGE_FAKE}
		end
	end
end, EntityType.ENTITY_PLAYER)

-- forcing blood oath to stab for extra vessel
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_)
	local oaths = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_OATH)
	for _, oath in ipairs(oaths) do
		if oath:ToFamiliar().Player then
			local player = oath:ToFamiliar().Player
			if mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.HALF_VESSEL) or
			   mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.FULL_VESSEL) or
			   mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.HALF_VESSEL_ROCK) or
			   mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.FULL_VESSEL_ROCK)
			then
				oath:ToFamiliar().State = 4
				oath:GetSprite():Play("Stab", true)
				oath.Position = oath:ToFamiliar().Player.Position
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, oath)
	if oath:GetSprite():IsEventTriggered("Hit") then
		local player = oath.Player
		while mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.HALF_VESSEL) or
		      mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.FULL_VESSEL) or
		      mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.HALF_VESSEL_ROCK) or
		      mod.IsPlayerHoldingTrinket(player, FiendFolio.ITEM.TRINKET.FULL_VESSEL_ROCK)
		do
			if player:GetDamageCooldown() > 0 then
				player:ResetDamageCooldown() -- WHY IS DAMAGE INVINCIBLE NOT WORKING
			end

			CustomHealthAPI.PersistentData.OverrideCustomBloodOathHandling = true
			local tookDamage = player:TakeDamage(1,
			                                     DamageFlag.DAMAGE_NOKILL +
			                                     DamageFlag.DAMAGE_RED_HEARTS +
			                                     DamageFlag.DAMAGE_ISSAC_HEART +
			                                     DamageFlag.DAMAGE_INVINCIBLE +
			                                     DamageFlag.DAMAGE_IV_BAG +
			                                     DamageFlag.DAMAGE_NO_MODIFIERS,
			                                     EntityRef(oath),
			                                     30)
			CustomHealthAPI.PersistentData.OverrideCustomBloodOathHandling = false

			if not tookDamage then
				break
			end

			oath.Hearts = oath.Hearts + 1
			player:GetEffects():AddNullEffect(NullItemID.ID_BLOOD_OATH)
		end
	end
end, FamiliarVariant.BLOOD_OATH)

local isExtraVessel = {
	[mod.ITEM.TRINKET.EXTRA_VESSEL] = true,
	[mod.ITEM.TRINKET.HALF_VESSEL] = true,
	[mod.ITEM.TRINKET.FULL_VESSEL] = true,
}

local isVesselRock = {
	[mod.ITEM.ROCK.VESSEL_ROCK] = true,
	[mod.ITEM.ROCK.HALF_VESSEL_ROCK] = true,
	[mod.ITEM.ROCK.FULL_VESSEL_ROCK] = true,
}

function mod.shouldRenderExtraVesselIcon(player, playerSlot)
	-- need to ignore smelted vessels
	return isExtraVessel[player:GetTrinket(0) % TrinketType.TRINKET_GOLDEN_FLAG] or isExtraVessel[player:GetTrinket(1) % TrinketType.TRINKET_GOLDEN_FLAG]
end

function mod.onRenderExtraVesselIcon(player, playerSlot, healthIndex, renderInfo)
	-- need to ignore smelted vessels
	local t0, t1 = player:GetTrinket(0) % TrinketType.TRINKET_GOLDEN_FLAG, player:GetTrinket(1) % TrinketType.TRINKET_GOLDEN_FLAG
	local numFull = ((t0 == mod.ITEM.TRINKET.FULL_VESSEL and 1) or 0) + ((t1 == mod.ITEM.TRINKET.FULL_VESSEL and 1) or 0)
	local numHalf = ((t0 == mod.ITEM.TRINKET.HALF_VESSEL and 1) or 0) + ((t1 == mod.ITEM.TRINKET.HALF_VESSEL and 1) or 0)
	local numEmpty = ((t0 == mod.ITEM.TRINKET.EXTRA_VESSEL and 1) or 0) + ((t1 == mod.ITEM.TRINKET.EXTRA_VESSEL and 1) or 0)
	if numFull + numHalf + numEmpty <= 0 then return end

	-- render only two icons
	local icons = {}
	for i = 1, numHalf do
		table.insert(icons, "ExtraVesselHalf")
	end
	for i = 1, numFull do
		table.insert(icons, "ExtraVesselFull")
	end
	for i = 1, numEmpty do
		table.insert(icons, "ExtraVesselEmpty")
	end

	local shouldHealFlash = game:GetFrameCount() - (mod:GetEntityData(player).ffFrameVesselHealed or (game:GetFrameCount() - 5)) < 4
	if #icons > 1 then
		mod.ExtraHealthIconSprite:Play(icons[2], true)
		mod.ExtraHealthIconSprite.Color = (shouldHealFlash and Color(1,1,1,0.5,128/255,0,0)) or Color(1,1,1,0.5,0,0,0)
		CustomHealthAPI.Helper.RenderHealth(mod.ExtraHealthIconSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset + Vector(3, -2))
	end
	mod.ExtraHealthIconSprite:Play(icons[1], true)
	mod.ExtraHealthIconSprite.Color = (shouldHealFlash and Color(1,1,1,1,128/255,0,0)) or Color(1,1,1,1,0,0,0)
	CustomHealthAPI.Helper.RenderHealth(mod.ExtraHealthIconSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset)
end

CustomHealthAPI.Library.RegisterAfterHealthIcon("EXTRA_VESSEL",
	{SortOrder = -100,
	 ShouldRenderFunc = mod.shouldRenderExtraVesselIcon,
	 OnRenderFunc = mod.onRenderExtraVesselIcon,})

function mod.shouldRenderVesselRockIcon(player, playerSlot)
	-- need to ignore smelted vessels
	return isVesselRock[player:GetTrinket(0) % TrinketType.TRINKET_GOLDEN_FLAG] or isVesselRock[player:GetTrinket(1) % TrinketType.TRINKET_GOLDEN_FLAG]
end

function mod.onRenderVesselRockIcon(player, playerSlot, healthIndex, renderInfo)
	-- need to ignore smelted vessels
	local t0, t1 = player:GetTrinket(0) % TrinketType.TRINKET_GOLDEN_FLAG, player:GetTrinket(1) % TrinketType.TRINKET_GOLDEN_FLAG
	local numFull = ((t0 == mod.ITEM.ROCK.FULL_VESSEL_ROCK and 1) or 0) + ((t1 == mod.ITEM.ROCK.FULL_VESSEL_ROCK and 1) or 0)
	local numHalf = ((t0 == mod.ITEM.ROCK.HALF_VESSEL_ROCK and 1) or 0) + ((t1 == mod.ITEM.ROCK.HALF_VESSEL_ROCK and 1) or 0)
	local numEmpty = ((t0 == mod.ITEM.ROCK.VESSEL_ROCK and 1) or 0) + ((t1 == mod.ITEM.ROCK.VESSEL_ROCK and 1) or 0)
	if numFull + numHalf + numEmpty <= 0 then return end

	-- render only two icons
	local icons = {}
	for i = 1, numEmpty do
		table.insert(icons, "VesselRockEmpty")
	end
	for i = 1, numHalf do
		table.insert(icons, "VesselRockHalf")
	end
	for i = 1, numFull do
		table.insert(icons, "VesselRockFull")
	end

	local shouldHealFlash = game:GetFrameCount() - (mod:GetEntityData(player).ffFrameVesselRockHealed or (game:GetFrameCount() - 5)) < 4
	if #icons > 1 then
		mod.ExtraHealthIconSprite:Play(icons[2], true)
		mod.ExtraHealthIconSprite.Color = (shouldHealFlash and Color(1,1,1,0.5,128/255,0,0)) or Color(1,1,1,0.5,0,0,0)
		CustomHealthAPI.Helper.RenderHealth(mod.ExtraHealthIconSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset + Vector(3, -2))
	end
	mod.ExtraHealthIconSprite:Play(icons[1], true)
	mod.ExtraHealthIconSprite.Color = (shouldHealFlash and Color(1,1,1,1,128/255,0,0)) or Color(1,1,1,1,0,0,0)
	CustomHealthAPI.Helper.RenderHealth(mod.ExtraHealthIconSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset)
end

CustomHealthAPI.Library.RegisterAfterHealthIcon("VESSEL_ROCK",
	{SortOrder = -200,
	 ShouldRenderFunc = mod.shouldRenderVesselRockIcon,
	 OnRenderFunc = mod.onRenderVesselRockIcon,})
