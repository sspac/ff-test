-- Wrong Warp --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local normalStages = {
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_1, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_1, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_1, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_1, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_1, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_REPENTANCE_B, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_1, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_1, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_1, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_2, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_2, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_2, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_3, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_3, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_3, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_3, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE5, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE5, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE5, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE5, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE6, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE6, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE6, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE6, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE7, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE7, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE7, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE7, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = true},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = true},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = true},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = true},
	{LevelStage = LevelStage.STAGE3_1, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = true},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = true},
	{LevelStage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = true},
	{LevelStage = LevelStage.STAGE1_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = true},
	{LevelStage = LevelStage.STAGE2_1, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = true},
	{LevelStage = LevelStage.STAGE2_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = true},
	{LevelStage = LevelStage.STAGE3_2, StageType = StageType.STAGETYPE_REPENTANCE, IsAscent = true},
	{LevelStage = LevelStage.STAGE8, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE8, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE8, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE8, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
}

local greedStages = {
	{LevelStage = LevelStage.STAGE1_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_GREED, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE1_GREED, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_GREED, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE2_GREED, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_GREED, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE3_GREED, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_GREED, StageType = StageType.STAGETYPE_WOTL, IsAscent = false},
	{LevelStage = LevelStage.STAGE4_GREED, StageType = StageType.STAGETYPE_AFTERBIRTH, IsAscent = false},
	{LevelStage = LevelStage.STAGE5_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE5_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE5_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE6_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE6_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE6_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE7_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE7_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false},
	{LevelStage = LevelStage.STAGE7_GREED, StageType = StageType.STAGETYPE_ORIGINAL, IsAscent = false}
}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	local rundata = FiendFolio.savedata.run
	
	local level = game:GetLevel()
	local levelstage = level:GetStage()
	local stagetype = level:GetStageType()
	local isAscent = game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
	local ascentUnlocked = Isaac.GetPersistentGameData():Unlocked(Achievement.A_STRANGE_DOOR)
	
	::getWrongWarpLevel::
	
	local newlevel
	if game:IsGreedMode() then
		repeat
			newlevel = greedStages[rng:RandomInt(#greedStages) + 1]
		until (newlevel.LevelStage ~= levelstage or newlevel.StageType ~= stagetype)
	else
		repeat
			newlevel = normalStages[rng:RandomInt(#normalStages) + 1]
		until (newlevel.LevelStage ~= levelstage or newlevel.StageType ~= stagetype or newlevel.IsAscent ~= isAscent)
	end
	
	if newlevel.IsAscent and not ascentUnlocked then
		goto getWrongWarpLevel
	end
	
	player:UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
	level:SetStage(newlevel.LevelStage, newlevel.StageType)
	game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH, newlevel.IsAscent and newlevel.LevelStage ~= LevelStage.STAGE8)
	rundata.isaacAndHisMotherLivedAloneInASmallHouseOnAHill = newlevel.LevelStage == LevelStage.STAGE8 and (not ascentUnlocked or rng:RandomInt(100) == 1)
	
	game:SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, false)
	game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT, false)
	game:SetStateFlag(GameStateFlag.STATE_MAUSOLEUM_HEART_KILLED, false)

	return {Remove = true, ShowAnim = useflags ~= useflags | UseFlag.USE_NOANIM}
end, FiendFolio.ITEM.COLLECTIBLE.WRONG_WARP)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
	local rundata = FiendFolio.savedata.run
	if pickup.SubType == 10 and
	   rundata.isaacAndHisMotherLivedAloneInASmallHouseOnAHill and
	   collider.Type == EntityType.ENTITY_PLAYER
	then
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
		return false
	end
end, PickupVariant.PICKUP_BED)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
	local rundata = FiendFolio.savedata.run
	if rundata.isaacAndHisMotherLivedAloneInASmallHouseOnAHill and
	   collider.Type == EntityType.ENTITY_PLAYER
	then
		local collectible = game:GetItemPool():GetCollectible(ItemPoolType.POOL_MOMS_CHEST, true)
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible)
		pickup:SetAlternatePedestal(11)
		pickup.Wait = 20
		sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1.0, 2, false, 1.0, 0.0)
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 2, pickup.Position, nilvector, nil)
		poof.DepthOffset = 4
		
		local posDiff = pickup.Position - collider.Position
        local dist = posDiff:Length()
        if dist < 40 then
			local pushDist = (40 - dist) * 0.4
			collider.Velocity = (collider.Velocity - posDiff:Resized(pushDist)) * 0.5
        end
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
		return false
	end
end, PickupVariant.PICKUP_MOMSCHEST)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, function()
	local rundata = FiendFolio.savedata.run
	if rundata.isaacAndHisMotherLivedAloneInASmallHouseOnAHill then
		local level = game:GetLevel()
		if level:GetStage() ~= LevelStage.STAGE8 then
			rundata.isaacAndHisMotherLivedAloneInASmallHouseOnAHill = nil
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local rundata = FiendFolio.savedata.run
	if rundata.isaacAndHisMotherLivedAloneInASmallHouseOnAHill then
		local level = game:GetLevel()
		if level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
			StageAPI.SpawnCustomTrapdoor(game:GetRoom():GetCenterPos(), {NormalStage = true, Stage = LevelStage.STAGE1_1, StageType = StageType.STAGETYPE_ORIGINAL})
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
	local rundata = FiendFolio.savedata.run
	if rundata.isaacAndHisMotherLivedAloneInASmallHouseOnAHill then
		local level = game:GetLevel()
		if level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
			effect:Remove()
		end
	end
end, EffectVariant.ISAACS_CARPET)