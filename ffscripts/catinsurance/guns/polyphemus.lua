local mod = FiendFolio

local costume = Isaac.GetCostumeIdByPath("gfx/characters/briend_polyphemus.anm2")

---@param config ItemConfigItem
---@param player EntityPlayer
function mod:AddPolyphemusCostume(config, player)
    if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
        return
    end

    if not (config.Type == ItemType.ITEM_PASSIVE and config.ID == CollectibleType.COLLECTIBLE_POLYPHEMUS) then
        return
    end

    return Isaac.GetItemConfig():GetNullItem(costume)
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_COSTUME, mod.AddPolyphemusCostume)

---@param config ItemConfigItem
---@param player EntityPlayer
function mod:RemovePolyphemusCostume(config, player)
    if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
        return
    end

    if not (config.Type == ItemType.ITEM_PASSIVE and config.ID == CollectibleType.COLLECTIBLE_POLYPHEMUS) then
        return
    end

    if not player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
        player:TryRemoveNullCostume(costume)        
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_COSTUME, mod.RemovePolyphemusCostume)