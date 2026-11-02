local mod = FiendFolio
local sfx = SFXManager()
local game = Game()
local hud = game:GetHUD()

local function ItemUse(_, id, _, player, flags)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.DEVI) then
        return
    end
    if flags & UseFlag.USE_CARBATTERY ~= 0 or flags & UseFlag.USE_OWNED == 0 then
        return
    end

    local iconfig = Isaac.GetItemConfig()
    local cc = iconfig:GetCollectible(id)
    if cc.ChargeType == ItemConfig.CHARGE_SPECIAL then
        return
    end

    local c = mod:BeahCheckPlayerForActiveData(player, id)
    mod:GetEntityData(player).savedDeviData = { charge = c, id = id}
end
mod:AddCollectibleCallback(ModCallbacks.MC_USE_ITEM, mod.ITEM.COLLECTIBLE.DEVI, ItemUse)

local function PlayerUpdate(_, player)
    if game:IsPaused() then
        return
    end

    local p_data = mod:GetEntityData(player)
    if p_data.ffFlashDevi then
        p_data.ffFlashDevi = p_data.ffFlashDevi - 1
        if p_data.ffFlashDevi == 0 then
            p_data.ffFlashDevi = nil
            p_data.ffDeviSlot = nil
        end
    end
    
    if p_data.savedDeviData then
        local id = p_data.savedDeviData.id
        local c = p_data.savedDeviData.charge
        local nc, ns = mod:BeahCheckPlayerForActiveData(player, id)
        if nc < c and ns ~= -1 then
            local d = mod:GetEntityData(player).ffsavedata.RunEffects
            d.devaItems = d.devaItems or {}
            local buff = (d.devaItems[""..id] or 0) + 1
            d.devaItems[""..id] = buff
            
            local iconfig = Isaac.GetItemConfig()
            local cc = iconfig:GetCollectible(id)
            if cc.ChargeType == ItemConfig.CHARGE_TIMED then
                d.devaTimedItems = d.devaTimedItems or {}
                d.devaTimedItems[""..id] = true
            end

            if buff % 2 == 0 and c > 1 and c ~= 30 then
                sfx:Play(SoundEffect.SOUND_SUPERHOLY)
                mod:GetEntityData(player).ffFlashDevi = 30
                mod:GetEntityData(player).ffDeviSlot = ns
            end
            p_data.savedDeviData = nil
        end
        if player:IsExtraAnimationFinished() then
            p_data.savedDeviData = nil
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.DEVI, PlayerUpdate)

mod:AddCollectibleCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, mod.ITEM.COLLECTIBLE.DEVI, function (_, item, player, _, maxCharge)
    local d = mod:GetEntityData(player).ffsavedata.RunEffects
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.DEVI) and d.devaItems and (d.devaItems[""..item] or (d.creativeAIItem and d.creativeAICleanupTable[""..item] and d.devaItems[""..d.creativeAIItem])) then
        local minus = math.floor((d.devaItems[""..item] or d.devaItems[""..d.creativeAIItem])/2)
        local iconfig = Isaac.GetItemConfig()
        local cc = iconfig:GetCollectible(item)
        if cc.ChargeType == ItemConfig.CHARGE_TIMED then
            maxCharge = math.max(math.min(45, maxCharge), maxCharge-(30*minus))
        else
            for i = 1, minus, 1 do
                if maxCharge == 12 then
                    maxCharge = 8
                elseif maxCharge == 8 then
                    maxCharge = 6
                elseif maxCharge > 1 then
                    maxCharge = maxCharge - 1
                end
            end
        end
        return maxCharge
    end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.ITEM.COLLECTIBLE.DEVI, function (_,player, slot, offset, alpha, scale, chargeOffset)
    local p_data = mod:GetEntityData(player)
    if p_data.ffDeviSlot and p_data.ffDeviSlot == slot then
        local cbarSprite = hud:GetChargeBarSprite()
        local rPos = chargeOffset
        cbarSprite.Color = Color(1,1,1,p_data.ffFlashDevi/30,1,1,1)
        cbarSprite:Play("BarEmpty")
        cbarSprite:Render(rPos)
        cbarSprite.Color = Color(1,1,1)
    end
end)