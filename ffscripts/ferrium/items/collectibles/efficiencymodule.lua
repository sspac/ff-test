local mod = FiendFolio

local bal = {
    ProdTimes = 2, --Is used twice more (original use + one from natural multiplier)
    SpeedTimer = 150,
}

local blacklistedFlags = UseFlag.USE_CARBATTERY | UseFlag.USE_VOID

--Efficiency Module

function mod:EfficiencyModuleUseActive(item, rng, player, useFlags, activeSlot)
    if useFlags == useFlags | UseFlag.USE_OWNED and player:HasCollectible(mod.ITEM.COLLECTIBLE.EFFICIENCY_MODULE) and useFlags & blacklistedFlags == 0 and activeSlot > -1 then
        local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.EFFICIENCY_MODULE)
        local config = Isaac.GetItemConfig():GetCollectible(item)
        local maxCharge = player:GetActiveMaxCharge(activeSlot)
        if config.ChargeType == 0 and maxCharge > 1 then --Standard charges
            local charge = 0
            for i=1,num do
                charge = charge+mod:RandomInt(100)
            end
            local max = maxCharge/2+1
            charge = math.floor(max*math.min(1, charge/100))
            local over = (player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and true) or false
            mod.scheduleForUpdate(function()
                player:AddActiveCharge(charge, activeSlot, true, over, false)
            end, 1)
        elseif config.ChargeType == 1 then --Timed Charges, AddActiveCharge doesn't work well for this
            local charge = 0
            for i=1,num do
                charge = charge+mod:RandomInt(100)
            end
            local max = maxCharge/2+1
            charge = math.floor(max*math.min(1, charge/100))
            local over = (player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and true) or false
            mod.scheduleForUpdate(function()
                charge = player:GetActiveCharge(activeSlot)+charge
                if not over then
                    charge = math.min(charge, maxCharge)
                end
                player:SetActiveCharge(charge, activeSlot)
            end, 1)
        end
    end
end


--Productivity Module

--Some code borrowed from Eternal Car Battery & Excelsior
local productivitySprite = Sprite()
productivitySprite:Load("gfx/effects/effect_productivity_module_sparkles.anm2", true)
productivitySprite:Play("Sparkle", true)

local speedSprite = Sprite()
speedSprite:Load("gfx/effects/effect_speed_module_sparkles.anm2", true)
speedSprite:Play("Sparkle", true)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    productivitySprite:Update()
    speedSprite:Update()
end)

function mod:ProductivityModuleRenderActive(player, slot, offset, alpha, scale, d)
    local item = player:GetActiveItem(slot)
    if d.ffsavedata and d.ffsavedata.RunEffects then
        local sd = d.ffsavedata.RunEffects
        sd.ProductivityModuleCharges = sd.ProductivityModuleCharges or {}
        if sd.ProductivityModuleCharges[item] then
            local charge = math.max(2, player:GetActiveMaxCharge(slot))
            if sd.ProductivityModuleCharges[item] >= charge-1 then
                productivitySprite.Scale = Vector(scale, scale)
                productivitySprite.Color.A = alpha
                productivitySprite:Render(offset + Vector(16,16) * scale)
            end
        end
    end
    if d.SpeedModuleCharges then
        if d.SpeedModuleCharges[item] and d.SpeedModuleCharges[item].Timer > 0 then
            speedSprite.Scale = Vector(scale, scale)
            speedSprite.Color.A = alpha
            speedSprite:Render(offset + Vector(16,16) * scale)
        end
    end
end

function mod:ProductivityModuleUseActive(item, rng, player, useFlags, activeSlot)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.PRODUCTIVITY_MODULE) and useFlags & blacklistedFlags == 0 and activeSlot > -1 then
        local d = mod:GetEntityData(player).ffsavedata.RunEffects
        d.ProductivityModuleCharges = d.ProductivityModuleCharges or {}
        d.ProductivityModuleCharges[item] = d.ProductivityModuleCharges[item] or 0
        local num = d.ProductivityModuleCharges[item]
        local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PRODUCTIVITY_MODULE)
        local config = Isaac.GetItemConfig():GetCollectible(item)
        local maxCharge = player:GetActiveMaxCharge(activeSlot)
        if config.ChargeType == 0 and maxCharge > 0 then --Standard charges
            local charge = math.max(2, maxCharge)
            if maxCharge == 1 then
                mult = mult-1
            end
            d.ProductivityModuleCharges[item] = num+1
            num = num+1
            if num >= charge then
                d.ProductivityModuleCharges[item] = 0

                for i=1, bal.ProdTimes+mult do
                    mod.scheduleForUpdate(function()
                        local originalPos = player.Position
                        player.Position = originalPos + Vector(mod:RandomInt(20, 60, rng), 0):Rotated(rng:RandomInt(360))
                        player:UseActiveItem(item, UseFlag.USE_CARBATTERY, activeSlot)
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
                            player:TriggerBookOfVirtues(item)
                        end
                        player.Position = originalPos
                    end, i*4)
                end
            end
        --elseif config.ChargeType == 1 then
        end
    end
end


--Speed Module

function mod:SpeedModuleUseActive(item, rng, player, useFlags, activeSlot, data)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.SPEED_MODULE) and useFlags & blacklistedFlags == 0 and activeSlot > -1 then
        if data.SpeedModuleCharges and data.SpeedModuleCharges[item] then
            local tab = data.SpeedModuleCharges[item]
            if tab.Timer > 0 then
                local config = Isaac.GetItemConfig():GetCollectible(item)
                local maxCharge = player:GetActiveMaxCharge(activeSlot)
                local ignore
                if player:HasCollectible(CollectibleType.COLLECTIBLE_9_VOLT) and maxCharge == 2 then
                    ignore = true
                end
                if not ignore then
                    local charge = math.floor(maxCharge/2)
                    local over = (player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) and true) or false
                    mod.scheduleForUpdate(function()
                        player:AddActiveCharge(charge, activeSlot, true, over, false)
                    end, 1)
                    tab.Timer = 0
                end
            end
        end
    end
end

function mod:SpeedModuleUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.SPEED_MODULE) then
        local data = mod:GetEntityData(player)
        local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SPEED_MODULE)
        data.SpeedModuleCharges = data.SpeedModuleCharges or {}
        for slot=0,2 do
            local item = player:GetActiveItem(slot)
            local config = Isaac.GetItemConfig():GetCollectible(item)
            local maxCharge = player:GetActiveMaxCharge(slot)
            if item > 0 and config.ChargeType == 0 then
                local charge = player:GetActiveCharge(slot)
                data.SpeedModuleCharges[item] = data.SpeedModuleCharges[item] or
                    {IsCharged = charge >= maxCharge, Timer = 0}
                local tab = data.SpeedModuleCharges[item]
                if not tab.IsCharged and charge >= maxCharge then
                    tab.Timer = bal.SpeedTimer*mult
                    tab.IsCharged = true
                elseif tab.IsCharged and charge < maxCharge then
                    tab.IsCharged = nil
                end
                if tab.Timer > 0 then
                    tab.Timer = tab.Timer-1
                end
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.SPEED_MODULE, mod.SpeedModuleUpdate)