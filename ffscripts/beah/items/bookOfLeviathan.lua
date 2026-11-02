local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local bolSprite = Sprite()
bolSprite:Load("gfx/effects/effect_leviathanitemoverlay.anm2", true)
bolSprite:Play("Idle", true)

local function IsCurseOnFloor()
    local level = game:GetLevel()
    local curses = level:GetCurses()

    if curses ~= 0 then
        return true
    end
    return false
end

local function UseItem(_, _, _, player, flags)
    --ceffects:AddNullEffect(mod.NULL.VIATHAN)
    --player:AddCacheFlags(CacheFlag.CACHE_ALL, true)
    player:AddBlackHearts(2)
    
    sfx:Play(SoundEffect.SOUND_DEVIL_CARD, 1, 0)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, player.Position, Vector.Zero, player)
    local poof2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, player.Position, Vector.Zero, player)
    poof2.Color = Color(0.7, 0, 0.7)
    poof.Color = Color(0.7, 0, 0.7)
    mod.scheduleForUpdate(function ()
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED, true)
    end, 1)
    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN)

--[[mod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, function (_, item)
    if not IsCurseOnFloor() then
        return 0
    end
end, mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN)]]

local pulseSpeed = 0.1
function mod:LeviathanPlayerUpdate(player)
    local p_data = mod:GetEntityData(player)
    p_data.sw_leviathanRenderTab = nil 
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN) then
        local curseOnFloor = IsCurseOnFloor()
        if p_data.lastLeviathanCurse ~= curseOnFloor then
            p_data.lastLeviathanCurse = curseOnFloor
            --update to make it hot potato book like
            
            local ic = Isaac.GetItemConfig()
            local i = ic:GetCollectible(mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN)
            i.ChargeType = curseOnFloor and ItemConfig.CHARGE_NORMAL or ItemConfig.CHARGE_SPECIAL
            local charge, slot = mod:BeahCheckPlayerForActiveData(player, mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN)
            if slot ~= -1 then --tainted fiend proofing
                player:RemoveCollectible(mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN, false, slot, false)
                player:AddCollectible(mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN, charge, false, slot)
            end

            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED, true)
        end

        local tab = nil

        if curseOnFloor then
            tab = {}
            local frame = game:GetFrameCount()
            frame = (math.sin(frame*pulseSpeed)/2)+0.5
            tab.alpha = frame
        end

        local tabsTab = {}
        for i = 0, 3, 1 do
            if player:GetActiveItem(i) == mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN then
                tabsTab[i] = tab
            end
        end

        p_data.sw_leviathanRenderTab = tabsTab
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN, mod.LeviathanPlayerUpdate)

--[[function mod:BookOfLeviathanOnDamage(player, effects)
end]]

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN, function (_,player, slot, offset, alpha, scale, chargeOffset)
    local p_data = mod:GetEntityData(player)
    if p_data.sw_leviathanRenderTab then
        local tab = p_data.sw_leviathanRenderTab[slot]
        if tab then
            bolSprite.Scale = scale*Vector.One
            bolSprite.Color = Color(1,1,1,alpha*tab.alpha, 0.1, 0, 0.2)
            bolSprite:Render(offset+(Vector(16,16)*scale))
        end
    end
end)
--[[mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, CallbackPriority.EARLY, function (_,player, slot, offset, alpha, scale)
    local p_data = mod:GetEntityData(player)
    if p_data.sw_leviathanRenderTab then
        local tab = p_data.sw_leviathanRenderTab[slot]
        if tab then
            bolSprite.Scale = scale*Vector.One
            bolSprite.Color = Color(1,1,1,alpha*tab.alpha)
            --print(tab.alpha, alpha)

            local pos = offset+(Vector(16,16)*scale)
            --bolSprite:Play("BackGlow")
            bolSprite:Render(pos)
            --bolSprite:Play("Idle")
            --bolSprite:Render(pos)
        end
    end
end)]]