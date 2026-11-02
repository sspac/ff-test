local mod = FiendFolio

if not false then --set this to false when not testing the item
    return
end

local id = CollectibleType.COLLECTIBLE_BELT 
local itemconfig = Isaac.GetItemConfig()
local item = itemconfig:GetCollectible(id)
item.CacheFlags = item.CacheFlags | CacheFlag.CACHE_WEAPON

--DIED 2022. BORN 2025
--WELCOME BACK, DAD'S BOTTLE
--I THINK
local function evaluateCache(_, player)
    if player:HasCollectible(id) then
        player:EnableWeaponType(4, true)
        player:EnableWeaponType(WeaponType.WEAPON_TEARS, false)
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, id, evaluateCache, CacheFlag.CACHE_WEAPON)

--return 2 tables, one with ones in the sweet spot, one with everyone else
local function getEnemiesToHit(position)
    
end

local collisionOkay = false
local function weaponProcess(_, weapon, direction, shooting, interp)
    local o = weapon:GetOwner()
    local p = o
    if p == nil then return end
    if p.Type == 3 then
        p = p:ToFamiliar().Player
    end
    p = p:ToPlayer()
    if weapon:GetCharge() > 0 and p:HasCollectible(id) then
        weapon:SetCharge(0)
        if p.FireDelay <= 0 then
            p.FireDelay = p.MaxFireDelay

            local knife 
            for index, value in ipairs(Isaac.FindByType(EntityType.ENTITY_KNIFE)) do
                if GetPtrHash(value.Parent) == GetPtrHash(o) then
                    knife = value
                end
            end
            local nearestFoe = mod:FindNearestVulnerableEnemy(knife.Position, 180)
            if nearestFoe then
                collisionOkay = true
                knife:ForceCollide(nearestFoe, true)
                collisionOkay = false
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_WEAPON_FIRE, weaponProcess, WeaponType.WEAPON_KNIFE)

local function knifeUpdate(_, knife)
    local o = knife.Parent
    local p = o
    if p == nil then return end
    if p.Type == 3 then
        p = p:ToFamiliar().Player
    end
    p = p:ToPlayer()
    
    if not p then
        return
    end
    local k_data = mod:GetEntityData(knife)
    if p:HasCollectible(id) then
        k_data.ff_cosmoKnife = true
    elseif k_data.ff_cosmoKnife then
        knife:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, knifeUpdate)

mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, function (_, knife)
    local k_data = mod:GetEntityData(knife)
    if k_data.ff_cosmoKnife and not collisionOkay then
        return true
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_RENDER, function (_, knife)
    local k_data = mod:GetEntityData(knife)
    if k_data.ff_cosmoKnife then
        return false
    end
end)