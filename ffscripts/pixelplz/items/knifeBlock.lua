local mod = FiendFolio

local Settings = {
	Knives = 3,
	CarBatteryMulti = 1.5,
	TotalSpreadAngle = 45,
	ChargeAmount = 0.65,
}



-- Update the position offset of the given helper entity
local function updateHelperOffset(helper, owner)
	-- Set the position offset
	local aim = Vector.FromAngle(helper.Rotation)
	local ownerOffset = aim:Resized(owner.Size) * owner.SizeMulti
	local helperOffset = aim:Resized(helper.Size) * helper.SizeMulti
	helper.ParentOffset = ownerOffset + helperOffset

	-- Match the flying offset for players
	local player = owner:ToPlayer()

	if player then
		helper:GetSprite().Offset = player:GetFlyingOffset()
	end
end



-- Use the item
function mod:KnifeBlockUse(id, rng, player, flags, slot, varData)
	if flags & UseFlag.USE_CARBATTERY > 0 then
		return
	end

	-- Put it away if already holding it
	if player:GetItemState() == mod.ITEM.COLLECTIBLE.KNIFE_BLOCK then
		player:AnimateCollectible(mod.ITEM.COLLECTIBLE.KNIFE_BLOCK, "HideItem")
		player:ResetItemState()

	-- Start holding it
	else
		player:AnimateCollectible(mod.ITEM.COLLECTIBLE.KNIFE_BLOCK, "LiftItem")
		player:SetItemState(mod.ITEM.COLLECTIBLE.KNIFE_BLOCK)
	end

	return {
		Discharge = false,
		ShowAnim = false,
		Remove = false,
	}
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.KnifeBlockUse, mod.ITEM.COLLECTIBLE.KNIFE_BLOCK)





--[[ Handle using the item while its held ]]--
function mod:KnifeBlockHeldUpdate(player)
	-- Put it away if it's interrupted by a different animation
	if player:GetItemState() == mod.ITEM.COLLECTIBLE.KNIFE_BLOCK and player:IsExtraAnimationFinished() then
		player:ResetItemState()
	end


	-- Try throwing the knives
	local aim = player:GetAimDirection()

	if player:GetItemState() == mod.ITEM.COLLECTIBLE.KNIFE_BLOCK and aim:Length() > 0.1 then
		player:AnimateCollectible(mod.ITEM.COLLECTIBLE.KNIFE_BLOCK, "HideItem", "")
		player:ResetItemState()
		mod:PlaySoundCool(nil, SoundEffect.SOUND_SHELLGAME)

		-- Discharge the item
		local slot = player:GetActiveItemSlot(mod.ITEM.COLLECTIBLE.KNIFE_BLOCK)

		if slot ~= -1 then
			player:DischargeActiveItem(slot)
		end


		-- Create the helper
		local helper = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.ITEM.FAMILIAR.KNIFE_BLOCK, 0, player.Position, Vector.Zero, player):ToEffect()
		helper.Rotation = aim:GetAngleDegrees()
		helper.Parent = player
		helper:FollowParent(player)

		updateHelperOffset(helper, player)
		helper:Update()
		helper:GetSprite():Play("Shoot", true)

		-- Create its tracker
		local helperData = mod:GetEntityData(helper)
		helperData.KnifeBlockKnives = {}


		-- Get the amount and spread angle of the knives
		local carBatteryMulti = player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) and Settings.CarBatteryMulti or 1
		local amount = math.ceil(carBatteryMulti * Settings.Knives)
		local half = (amount / 2) - 0.5
		local spreadAngle = Settings.TotalSpreadAngle / (amount - 1)

		-- Throw the knives
		for i = -half, half do
			local offset = spreadAngle * i
			local angle = aim:GetAngleDegrees() + offset
			local knife = player:FireKnife(helper, angle, true, 0, KnifeVariant.MOMS_KNIFE)
			table.insert(helperData.KnifeBlockKnives, EntityPtr(knife))

			-- Update its angle and offset before throwing it
			local knifeData = mod:GetEntityData(knife)
			knifeData.KnifeBlockKnife = true
			knife:Update()

			knife:Shoot(Settings.ChargeAmount, player.TearRange)
			knifeData.WasFlying = true
		end


		-- Electrum zap
		if player:HasTrinket(FiendFolio.ITEM.ROCK.ELECTRUM) then
			local electrumMulti = player:GetTrinketMultiplier(mod.ITEM.ROCK.ELECTRUM)
			local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.KNIFE_BLOCK)
			local itemConfig = Isaac:GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.KNIFE_BLOCK)
			mod:electrumShock(player, electrumMulti, rng, itemConfig, nil, nil, nil, slot)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.KnifeBlockHeldUpdate)





--[[ Handle thrown knives ]]--
function mod:KnifeBlockBrimmyRemove(knife)
	if knife.Variant == KnifeVariant.MOMS_KNIFE then
		local data = mod:GetEntityData(knife)

		-- Remove extra knives from Brimstone
		if knife.SubType == KnifeSubType.PROJECTILE then
			if knife.Parent and mod:GetEntityData(knife.Parent).KnifeBlockKnife then
				knife.Visible = false
				knife.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				knife:Remove()
			end

		elseif data.KnifeBlockKnife then
			local helper = knife.Parent

			-- Update its position offset
			if helper then
				knife.PositionOffset = helper.PositionOffset + Vector(0, -10)
				knife.SpriteOffset = helper.SpriteOffset
			end

			-- Remove the knife when it returns
			if data.WasFlying and not knife:IsFlying() then
				knife.Visible = false
				knife:Remove()

				if helper and helper.Type == EntityType.ENTITY_EFFECT and helper.Variant == mod.ITEM.FAMILIAR.KNIFE_BLOCK then
					helper:GetSprite():Play("Return", true)
					mod:PlaySoundCool(nil, SoundEffect.SOUND_GOOATTACH0, 0.9, 0.97, 2)
				end
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, CallbackPriority.IMPORTANT, mod.KnifeBlockBrimmyRemove)





--[[ Helper ]]--
function mod:KnifeBlockHelperUpdate(effect)
	local owner = effect.Parent

	if owner and owner:Exists() then
		local sprite = effect:GetSprite()
		local data = mod:GetEntityData(effect)


		-- Update the position offset and animation
		updateHelperOffset(effect, owner)

		if not sprite:IsPlaying() then
			mod:LoopingAnim(sprite, "Idle")
		end


		-- Set the frame based on the direction
		local animationData = sprite:GetAnimationData("ref")
		local targetFrame = mod:GoRoundNumber(effect.Rotation / 90) % animationData:GetLength()
		local frameData = animationData:GetLayer(0):GetFrame(targetFrame)
		sprite:GetLayer(0):SetCropOffset( frameData:GetCrop() )


		-- Update its tracker
		if not sprite:IsPlaying("Return") and data.KnifeBlockKnives then
			for i = #data.KnifeBlockKnives, 1, -1 do
				local entry = data.KnifeBlockKnives[i]

				if entry and not entry.Ref then
					data.KnifeBlockKnives[i] = nil
				end
			end

			-- Get removed if all knives have returned
			if #data.KnifeBlockKnives <= 0 then
				effect:Remove()
			end
		end

	else
		effect:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.KnifeBlockHelperUpdate, mod.ITEM.FAMILIAR.KNIFE_BLOCK)