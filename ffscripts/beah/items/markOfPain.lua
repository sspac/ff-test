local mod = FiendFolio
local sfx = SFXManager()

local function isInCombat()
    local r = Game():GetRoom()
    if r:GetAliveEnemiesCount() == 0 then
        return false
    end
    return true
end

local inc = 8
local cap = 600
local function peffectUpdate(_, player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.MARK_OF_PAIN) then
        local p_data = mod:GetEntityData(player)
        local effects = player:GetEffects()
        if isInCombat() then
            p_data.ff_ironcladTick = (p_data.ff_ironcladTick or 0) + 1
            if p_data.ff_ironcladTick >= inc and effects:GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.MARK_OF_PAIN) <= cap then
                p_data.ff_ironcladTick = 0

                effects:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.MARK_OF_PAIN)
                player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
            end
        elseif effects:HasCollectibleEffect(mod.ITEM.COLLECTIBLE.MARK_OF_PAIN) then
            effects:RemoveCollectibleEffect(mod.ITEM.COLLECTIBLE.MARK_OF_PAIN, -1)
            player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
            --fire extingiush

            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 0.4)
        end
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.MARK_OF_PAIN, peffectUpdate)