local mod = FiendFolio

mod.OverheadHeldActives = {
    [CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD] = true,
        --wait why am I doing this
		--[[mod.scheduleForUpdate(function()
			local anim = player:GetSprite():GetAnimation()
            print(anim)
			if string.find(anim, "Pickup") then
                print("pickup")
				data.overheadActiveItem = true
				data.overheadActiveItemID = CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD
            else
                print("reset")
                data.overheadActiveItem = nil
				data.overheadActiveItemID = nil
            end
		end, 2)]]
    [CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP] = true,
    [CollectibleType.COLLECTIBLE_NOTCHED_AXE] = true,
    [CollectibleType.COLLECTIBLE_CANDLE] = true,
    [CollectibleType.COLLECTIBLE_RED_CANDLE] = true,
    [CollectibleType.COLLECTIBLE_BOOMERANG] = true,
    [CollectibleType.COLLECTIBLE_GLASS_CANNON] = true,
    [CollectibleType.COLLECTIBLE_FRIEND_BALL] = true,
    [CollectibleType.COLLECTIBLE_BLACK_HOLE] = true,
    [CollectibleType.COLLECTIBLE_SHARP_KEY] = true,
    [CollectibleType.COLLECTIBLE_ERASER] = true,
    [CollectibleType.COLLECTIBLE_GELLO] = true,
    [CollectibleType.COLLECTIBLE_DECAP_ATTACK] = true,
    [mod.ITEM.COLLECTIBLE.D2] = true,
    [mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR] = true,
    [mod.ITEM.COLLECTIBLE.GREEN_CANDLE] = true,
    [mod.ITEM.COLLECTIBLE.HOT_SHOT] = true,
    [mod.ITEM.COLLECTIBLE.SANGUINE_HOOK] = true,
    [mod.ITEM.COLLECTIBLE.GRAPPLING_HOOK] = true,
    [mod.ITEM.COLLECTIBLE.TOY_CAMERA] = true,
    [mod.ITEM.COLLECTIBLE.LEMON_MISHUH] = true,
    [mod.ITEM.COLLECTIBLE.KALUS_HEAD] = true,
    [mod.ITEM.COLLECTIBLE.GAPER_IN_A_JAR] = true,
    [mod.ITEM.COLLECTIBLE.GREEN_CANDLE] = true,
    [mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY] = true,
    [mod.ITEM.COLLECTIBLE.FLIP_PHONE] = true,
}

function mod:overheadHeldActive(item, rng, player, useFlags, activeSlot)
	if mod.OverheadHeldActives[item] then
        local donot = false
        if item == CollectibleType.COLLECTIBLE_SHARP_KEY and player:GetNumKeys() == 0 then
            donot = true
        end
        local data = mod:GetEntityData(player)
        if donot then
            data.overheadActiveItem = nil
			data.overheadActiveItemID = nil
            data.overheadActiveItemExtraInfo = nil
		elseif not data.overheadActiveItem or (data.overheadActiveItemID and item ~= data.overheadActiveItemID) then
            data.overheadActiveItem = true
			data.overheadActiveItemID = item
            data.overheadActiveItemExtraInfo = {useFlags, activeSlot}
        else
            data.overheadActiveItem = nil
			data.overheadActiveItemID = nil
            data.overheadActiveItemExtraInfo = nil
        end
	end
end

function mod:overheadHeldActiveUpdate(player, data)
    if data.overheadActiveItem then
        local frames = player.FrameCount-(data.LastFirePress or 0)
        if data.overheadActiveItemID ~= CollectibleType.COLLECTIBLE_NOTCHED_AXE then
            if frames == 1 then
                local tab = data.overheadActiveItemExtraInfo
                mod:FerriumGlobalThrownActive(data.overheadActiveItemID, player:GetCollectibleRNG(data.overheadActiveItemID), player, tab[1], tab[2])
                
                data.justThrewActive = data.overheadActiveItemID
                data.justThrewActiveFrames = player.FrameCount
                data.justThrewActiveExtraInfo = mod:makeCopiedTable(tab)
                data.overheadActiveItem = nil
                data.overheadActiveItemID = nil
                data.overheadActiveItemExtraInfo = nil
            end
        else
            local slot = 0
			for i=0,2 do
				if player:GetActiveItem(i) == CollectibleType.COLLECTIBLE_NOTCHED_AXE then
					slot = i
					break
				end
			end
            if player:GetActiveCharge(slot) == 0 then
                data.overheadActiveItem = nil
                data.overheadActiveItemID = nil
            end
        end
    end
    if data.justThrewActiveFrames and player.FrameCount-data.justThrewActiveFrames > 3 then
        data.justThrewActive = nil
        data.justThrewActiveFrames = nil
    end
end