local mod = FiendFolio

local costume = Isaac.GetCostumeIdByPath("gfx/characters/briend_megablast.anm2")

---@param config ItemConfigItem
---@param player EntityPlayer
function mod:AddMegaBlastCostume(config, player)
    if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
        return
    end

    if not (config.Type == ItemType.ITEM_NULL and config.ID == NullItemID.ID_MEGABLAST) then
        return
    end

    return Isaac.GetItemConfig():GetNullItem(costume)
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_ADD_COSTUME, mod.AddMegaBlastCostume)

---@param config ItemConfigItem
---@param player EntityPlayer
function mod:RemoveMegaBlastCostume(config, player)
    if player:GetPlayerType() ~= mod.PLAYER.BRIEND then
        return
    end

    if not (config.Type == ItemType.ITEM_NULL and config.ID == NullItemID.ID_MEGABLAST) then
        return
    end

	local othertwin = player:GetOtherTwin()
    if not (player:GetMegaBlastDuration() > 0 or (othertwin and othertwin:GetMegaBlastDuration() > 0)) then
        player:TryRemoveNullCostume(costume)        
    end

end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_REMOVE_COSTUME, mod.RemoveMegaBlastCostume)