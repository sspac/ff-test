local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local function getPlanetariumMonas(player)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA)
    local item = mod.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA
    while item == mod.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA do
        item = mod.PlanetariumItems[rng:RandomInt(#mod.PlanetariumItems) + 1]
        --Maybe add a check for if it's unlocked idk
    end
    return item
end

function mod:monasHieroglyphicaUpdate(player, newStage)
    local savedata = mod:GetEntityData(player).ffsavedata
    if newStage or not savedata.MonasHieroglyphicaItem then
        savedata.MonasHieroglyphicaItem = getPlanetariumMonas(player)
    end
    local count = player:HasCollectible(mod.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA) and 1 or 0
    player:SetInnateCollectibleGroup("FF_MONAS_HIEROGLYPHICA", {[savedata.MonasHieroglyphicaItem] = count})
end

function mod:monasHieroglyphicaAddRemove(player)
    mod:monasHieroglyphicaUpdate(player, false)
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_ADDED, mod.monasHieroglyphicaAddRemove, mod.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.monasHieroglyphicaAddRemove, mod.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA)

function mod:monasHieroglyphicaNewStage(player, _, postLevelInitFinished)
    if postLevelInitFinished then
        mod:monasHieroglyphicaUpdate(player, true)
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, mod.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA, mod.monasHieroglyphicaNewStage)

-- This fixes this silly Mars null costume globally, because whatever.
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function(_, player, _, _, wispOrInnate)
    if wispOrInnate and not player:HasCollectible(CollectibleType.COLLECTIBLE_MARS) then
        player:TryRemoveNullCostume(NullItemID.ID_MARS)
    end
end, CollectibleType.COLLECTIBLE_MARS)