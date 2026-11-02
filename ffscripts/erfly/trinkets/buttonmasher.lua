local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

--The item should also make friend instant shoot her bullets / insta chocolate milk / insta use cards/pills

mod.buttonMasherLists = {
    Blacklist = {
        [CollectibleType.COLLECTIBLE_BREATH_OF_LIFE] = true,
        [CollectibleType.COLLECTIBLE_SPIN_TO_WIN] = true,
        [CollectibleType.COLLECTIBLE_RECALL] = true,
        [CollectibleType.COLLECTIBLE_HOLD] = true,
        [mod.ITEM.COLLECTIBLE.ALPHA_COIN] = true,
        [mod.ITEM.COLLECTIBLE.GRAPPLING_HOOK] = true,
        [mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B] = true,
        [mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R] = true,
        [mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y] = true,
    },
    ProcWheneverAvailable = {
        [CollectibleType.COLLECTIBLE_TELEPORT] = true,
        [CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER] = true,
        [CollectibleType.COLLECTIBLE_FORGET_ME_NOW] = true,
        [CollectibleType.COLLECTIBLE_PORTABLE_SLOT] = true,
        [CollectibleType.COLLECTIBLE_GUPPYS_PAW] = true,
        [CollectibleType.COLLECTIBLE_CONVERTER] = true,
        [CollectibleType.COLLECTIBLE_D100] = true,
        [CollectibleType.COLLECTIBLE_D4] = true,
        [CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS] = true,
        [CollectibleType.COLLECTIBLE_UNDEFINED] = true,
        [CollectibleType.COLLECTIBLE_DIPLOPIA] = true,
        [CollectibleType.COLLECTIBLE_D8] = true,
        [CollectibleType.COLLECTIBLE_TELEPORT_2] = true,
        [CollectibleType.COLLECTIBLE_JAR_OF_FLIES] = true,
        [CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON] = true,
        [CollectibleType.COLLECTIBLE_SMELTER] = true,
        [CollectibleType.COLLECTIBLE_COMPOST] = true,
        [CollectibleType.COLLECTIBLE_DATAMINER] = true,
        [CollectibleType.COLLECTIBLE_CLICKER] = true,
        [CollectibleType.COLLECTIBLE_D_INFINITY] = true,
        [CollectibleType.COLLECTIBLE_EDENS_SOUL] = true,
        [CollectibleType.COLLECTIBLE_MYSTERY_GIFT] = true,
        [CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD] = true,
        [CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1] = true,
        [CollectibleType.COLLECTIBLE_MOMS_SHOVEL] = true,
        [CollectibleType.COLLECTIBLE_FORTUNE_COOKIE] = true,
        [CollectibleType.COLLECTIBLE_DAMOCLES] = true,
        [CollectibleType.COLLECTIBLE_RED_KEY] = true,
        [CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = true,
        [CollectibleType.COLLECTIBLE_ALABASTER_BOX] = true,
        [CollectibleType.COLLECTIBLE_GENESIS] = true,
        [CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE] = true,
        [CollectibleType.COLLECTIBLE_R_KEY] = true,
        [CollectibleType.COLLECTIBLE_MAGIC_SKIN] = true,
        [CollectibleType.COLLECTIBLE_ESAU_JR] = true,
        [CollectibleType.COLLECTIBLE_FLIP] = true,
        [CollectibleType.COLLECTIBLE_LEMEGETON] = true,
        [CollectibleType.COLLECTIBLE_KEEPERS_BOX] = true,
        [CollectibleType.COLLECTIBLE_EVERYTHING_JAR] = true,
        [mod.ITEM.COLLECTIBLE.RISKS_REWARD] = true,
        [mod.ITEM.COLLECTIBLE.GOLEMS_ROCK] = true,
        [mod.ITEM.COLLECTIBLE.FIDDLE_CUBE] = true,
        [mod.ITEM.COLLECTIBLE.FIEND_MIX] = true,
        [mod.ITEM.COLLECTIBLE.WRONG_WARP] = true,
        [mod.ITEM.COLLECTIBLE.DAZZLING_SLOT] = true,
        [mod.ITEM.COLLECTIBLE.RAT_POISON] = true,
        [mod.ITEM.COLLECTIBLE.HORSE_PASTE] = true,
        [mod.ITEM.COLLECTIBLE.YICK_HEART] = true,
        [mod.ITEM.COLLECTIBLE.ERRORS_CRAZY_SLOTS] = true,
        [mod.ITEM.COLLECTIBLE.MAMMONITE_CODEX] = true,
        [mod.ITEM.COLLECTIBLE.TOYBOX] = true,
        [mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK] = true,
        [mod.ITEM.COLLECTIBLE.OLD_TESTAMENT] = true,
        [mod.ITEM.COLLECTIBLE.EARTH_OF_ADAM] = true,
        [mod.ITEM.COLLECTIBLE.BAPHOMETS_EXCHANGE] = true,
        [mod.ITEM.COLLECTIBLE.GOLEMS_WISHLIST] = true,
    },
    ProcWheneverRoomInactive = {
        [CollectibleType.COLLECTIBLE_HOW_TO_JUMP] = true,
        [mod.ITEM.COLLECTIBLE.AVGM] = true,
        [mod.ITEM.COLLECTIBLE.HOW_TO_ROLL] = true,
    },
    ProcOnlyAtRoomStart = {
        [CollectibleType.COLLECTIBLE_RAZOR_BLADE] = true,
        [CollectibleType.COLLECTIBLE_THE_JAR] = true,
        [CollectibleType.COLLECTIBLE_VENTRICLE_RAZOR] = true,
        [CollectibleType.COLLECTIBLE_PLAN_C] = true,
        [CollectibleType.COLLECTIBLE_POTATO_PEELER] = true,
        [CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR] = true,
        [CollectibleType.COLLECTIBLE_GOLDEN_RAZOR] = true,
        [CollectibleType.COLLECTIBLE_WAVY_CAP] = true,
        [CollectibleType.COLLECTIBLE_URN_OF_SOULS] = true,
        [mod.ITEM.COLLECTIBLE.CONTRABAND] = true,
        [mod.ITEM.COLLECTIBLE.THE_WAR_HORN] = true,
        [mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN] = true,
        [mod.ITEM.COLLECTIBLE.LASER_POINTER] = true,
    },
    ProcOnlyAtRoomStartDontKill = {
        [CollectibleType.COLLECTIBLE_RAZOR_BLADE] = true,
        [CollectibleType.COLLECTIBLE_BLOOD_RIGHTS] = true,
    },
    HasRedHearts = {
        [CollectibleType.COLLECTIBLE_IV_BAG] = true,
        [CollectibleType.COLLECTIBLE_SUMPTORIUM] = true,
    },
    HasHeartContainers = {
        [CollectibleType.COLLECTIBLE_POTATO_PEELER] = true,
    },
    OnHit = {
        [CollectibleType.COLLECTIBLE_KAMIKAZE] = true,
        [CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS] = true,
    },
    CollidesWithGrid = {
        [CollectibleType.COLLECTIBLE_MOMS_BRACELET] = true,
    },
    SeeItem = {
        [CollectibleType.COLLECTIBLE_D6] = true,
        [CollectibleType.COLLECTIBLE_VOID] = true,
        [CollectibleType.COLLECTIBLE_CROOKED_PENNY] = true,
        [CollectibleType.COLLECTIBLE_ABYSS] = true,
        [CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = true,
        [mod.ITEM.COLLECTIBLE.LOADED_D6] = true,
        [mod.ITEM.COLLECTIBLE.SHREDDER] = true,
    },
}

local itemSlots = {
    ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET
}

local CHARGETYPES = {
    Normal              = 0,
    Timed               = 1,
    Special             = 2,
    ProcWhenever        = 100,
    ProcWhenRoomInactive= 101,
    ProcAtRoomStart     = 102,
    HasRedHeart         = 103,
    OnHit               = 104,
    CollidesWithGrid    = 105,
    SeeItem             = 106,
    ProcAtRoomStartDontKill= 107,
    HasHeartContainers  = 108,
}

local function tryUseActiveItem(player, chargeType)
    local config = Isaac:GetItemConfig()
    for i = 1, #itemSlots do
        local slot = itemSlots[i]
        local item = player:GetActiveItem(slot)
        if item > 0 then
            local heldItem = config:GetCollectible(item)
            if not mod.buttonMasherLists.Blacklist[item]
            and (
                (
                    (chargeType and heldItem.ChargeType == chargeType)
                    and not mod.buttonMasherLists.ProcWheneverRoomInactive[item]
                    and not mod.buttonMasherLists.ProcOnlyAtRoomStart[item]
                    and not mod.buttonMasherLists.HasRedHearts[item]
                    and not mod.buttonMasherLists.OnHit[item]
                    and not mod.buttonMasherLists.CollidesWithGrid[item]
                    and not mod.buttonMasherLists.SeeItem[item]
                    and not mod.buttonMasherLists.ProcOnlyAtRoomStartDontKill[item]
                    and not mod.buttonMasherLists.HasHeartContainers[item]
                )
                or chargeType == CHARGETYPES.ProcWhenever and mod.buttonMasherLists.ProcWheneverAvailable[item]
                or chargeType == CHARGETYPES.ProcWhenRoomInactive and mod.buttonMasherLists.ProcWheneverRoomInactive[item]
                or chargeType == CHARGETYPES.ProcAtRoomStart and mod.buttonMasherLists.ProcOnlyAtRoomStart[item]
                or chargeType == CHARGETYPES.HasRedHeart and mod.buttonMasherLists.HasRedHearts[item]
                or chargeType == CHARGETYPES.OnHit and mod.buttonMasherLists.OnHit[item]
                or chargeType == CHARGETYPES.CollidesWithGrid and mod.buttonMasherLists.CollidesWithGrid[item]
                or chargeType == CHARGETYPES.SeeItem and mod.buttonMasherLists.SeeItem[item]
                or chargeType == CHARGETYPES.ProcAtRoomStartDontKill and mod.buttonMasherLists.ProcOnlyAtRoomStartDontKill[item]
                or chargeType == CHARGETYPES.HasHeartContainers and mod.buttonMasherLists.HasHeartContainers[item]
            )
            then
                if (player:IsExtraAnimationFinished() and not mod:GetEntityData(player).holdingFFItem)
                or chargeType == CHARGETYPES.ProcWhenever and mod.buttonMasherLists.ProcWheneverAvailable[item]
                or chargeType == CHARGETYPES.ProcWhenRoomInactive and mod.buttonMasherLists.ProcWheneverRoomInactive[item]
                or chargeType == CHARGETYPES.HasRedHeart and mod.buttonMasherLists.HasRedHearts[item]
                or chargeType == CHARGETYPES.OnHit and mod.buttonMasherLists.OnHit[item]
                then
                    mod:GetEntityData(player).buttonMashActiveItem = slot
                    break
                end
            end
        end
    end
end

function mod:getItemActiveSlot(player, item)
    if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == item then
        return ActiveSlot.SLOT_PRIMARY
    elseif player:GetActiveItem(ActiveSlot.SLOT_POCKET) == item then
        return ActiveSlot.SLOT_POCKET
    end
end

mod:AddTrinketCallback("FF_PLAYER_INPUT_ACTION", mod.ITEM.TRINKET.BUTTON_MASHER, function(_, player, d, hook, buttonaction)
	if hook == InputHook.IS_ACTION_TRIGGERED then
        if buttonaction == ButtonAction.ACTION_ITEM then
            if d.buttonMashActiveItem == ActiveSlot.SLOT_PRIMARY then
                d.buttonMashActiveItem = nil
                return true
            end
        end
        if buttonaction == ButtonAction.ACTION_PILLCARD then
            --print(player.FrameCount)
            if d.buttonMashActiveItem == ActiveSlot.SLOT_POCKET
            or d.buttonMasherUsePill then
                --WHY THE FUCK DO I NEED TO DO THIS AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                --I DON'T GET IT ONE BIT
                mod.scheduleForUpdate(function()
                    d.buttonMashActiveItem = nil
                    d.buttonMasherUsePill = nil
                end, 2, ModCallbacks.MC_INPUT_ACTION, true)
                --WHY DO I NEED TO LET IT RETURN TWICE
                --I'M LOSING MY FUCKING MIIIIIIIIIIIIIIND
                --print("hi")
                return true
            end
        end
	end
end, InputHook.IS_ACTION_TRIGGERED)

function mod:buttonMasherPlayerUpdate(player)
    local data = mod:GetEntityData(player)
    if data.buttonMasherTrySoon then
        data.buttonMasherTrySoon = nil
        --tryUseActiveItem(player, CHARGETYPES.Normal)
        tryUseActiveItem(player, CHARGETYPES.ProcAtRoomStart)
        local hearts = player:GetHearts()
        local otherHearts = player:GetBoneHearts() + player:GetSoulHearts()
        if hearts + otherHearts > 1 then
            tryUseActiveItem(player, CHARGETYPES.ProcAtRoomStartDontKill)
        end
    end
    if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
        if player.FrameCount % 3 == 1 then
            if mod.IsActiveRoom() then
                tryUseActiveItem(player, CHARGETYPES.Normal)
                tryUseActiveItem(player, CHARGETYPES.Timed)
            elseif not Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
                tryUseActiveItem(player, CHARGETYPES.ProcWhenRoomInactive)
            end
            local hearts = player:GetHearts()
            local otherHearts = player:GetBoneHearts() + player:GetSoulHearts()
            if hearts + otherHearts > 1 then
                tryUseActiveItem(player, CHARGETYPES.HasRedHeart)
            end

            tryUseActiveItem(player, CHARGETYPES.ProcWhenever)
        end
        if player:GetPill(0) > 0 or player:GetCard(0) > 0 then
            data.buttonMasherUsePill = true
        end
        if player:CollidesWithGrid() then
            tryUseActiveItem(player, CHARGETYPES.CollidesWithGrid)
        end
    end
    --If player has a no maxcharge active / timed active ready, try to use it every 3 frames
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.TRINKET.BUTTON_MASHER, mod.buttonMasherPlayerUpdate)

function mod:buttonMasherPlayerHurt(player)
    if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
        tryUseActiveItem(player, CHARGETYPES.OnHit)
    end
end

function mod:buttonMasherNewRoom(player, d, savedata)
    if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
        d.buttonMasherTrySoon = true
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.ITEM.TRINKET.BUTTON_MASHER, function(_, pickup)
    mod.AnyPlayerDo(function(player)
        if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
            mod.scheduleForUpdate(function()
                tryUseActiveItem(player, CHARGETYPES.SeeItem)
            end, 1, ModCallbacks.MC_POST_UPDATE, true)
        end
    end)
end, 100)