local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

FiendFolio.DadsUSBBlacklist = {}

local function getTechItem(rng)
    local techItems = Isaac.GetItemConfig():GetTaggedItems(ItemConfig.TAG_TECH)
    local techCollectibles = {}
    for i = 1, #techItems do
        if techItems[i]:IsCollectible() then
            if techItems[i]:IsAvailable()
            and (techItems[i].Type ~= ItemType.ITEM_ACTIVE)
            and (not FiendFolio.DadsUSBBlacklist[techItems[i].ID])
            then
                table.insert(techCollectibles, techItems[i].ID)
            end
        end
    end
    local item = rng:RandomInt(#techCollectibles) + 1
    --print(techCollectibles[item])
    return techCollectibles[item]
end

function mod:dadsUSBPostNewRoom(player)
    player:ClearInnateItemGroup("FF_DADS_USB")

    if player:HasTrinket(mod.ITEM.TRINKET.DADS_USB) then
        local rng = RNG()
        rng:SetSeed(game:GetRoom():GetSpawnSeed(), 5)
        local mult = math.min(player:GetTrinketMultiplier(mod.ITEM.TRINKET.DADS_USB),3)
        local chance = 4
        if mult > 1 then
            for i = 1, mult - 1 do
                chance = chance / 2
            end
        end
        --print(chance)
        if rng:RandomInt(chance) == 0 then
            local chosenItem = getTechItem(rng)
            player:AddInnateCollectible(chosenItem, 1, "FF_DADS_USB")
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_NEW_ROOM_TEMP_EFFECTS, mod.ITEM.TRINKET.DADS_USB, mod.dadsUSBPostNewRoom)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, function(_, player)
    if not player:HasTrinket(mod.ITEM.TRINKET.DADS_USB) then
        player:ClearInnateItemGroup("FF_DADS_USB")
    end
end, mod.ITEM.TRINKET.DADS_USB)