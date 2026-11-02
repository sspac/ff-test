local mod = FiendFolio
local game = Game()

local function playerTryShootGodheadJr(player)
    if player:HasTrinket(mod.ITEM.TRINKET.GODHEADJR) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.GODHEADJR)
        local chance = math.max(math.min(5 + (player.Luck * 2), 20), 1) * player:GetTrinketMultiplier(mod.ITEM.TRINKET.GODHEADJR)
        if rng:RandomFloat() * 50 < chance then
            return true
        end
    end
end

-- Cool repentogon callback for most things
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, mod.ITEM.TRINKET.GODHEADJR, function(_, player, params, weaponType, damageScale, tearDisplacement, source)
    if playerTryShootGodheadJr(player) then
         params.TearFlags =  params.TearFlags | TearFlags.TEAR_GLOW
         params.TearFlags =  params.TearFlags | TearFlags.TEAR_HOMING
    end
end)

-- Mom's Knife specifically is still kinda dumb (Forgotten is fine)
mod:AddTrinketCallback(ModCallbacks.MC_POST_TRIGGER_WEAPON_FIRED, mod.ITEM.TRINKET.GODHEADJR, function(_, fireDirection, fireAmount, owner, weapon)
    local player = owner and owner:ToPlayer()
    if player then
        local data = mod:GetEntityData(player)
        if playerTryShootGodheadJr(player) then
            if not data.CurrentlyGodheadJrd then
                data.CurrentlyGodheadJrd = true
                player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG, true)
            end
        elseif data.CurrentlyGodheadJrd then
            data.CurrentlyGodheadJrd = nil
            player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG, true)
        end
    end
end, WeaponType.WEAPON_KNIFE)

mod:AddTrinketCallback(ModCallbacks.MC_POST_WEAPON_FIRE, mod.ITEM.TRINKET.GODHEADJR, function(_, weapon)
    local owner = weapon:GetOwner()
    local player = owner and owner:ToPlayer()
    if player then
        local data = mod:GetEntityData(player)
        if data.CurrentlyGodheadJrd then
            local knife = weapon:GetMainEntity() and weapon:GetMainEntity():ToKnife()
            if knife and not knife:IsFlying() then
                data.CurrentlyGodheadJrd = nil
                player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG, true)
            end
        end
    end
end, WeaponType.WEAPON_KNIFE)

mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ITEM.TRINKET.GODHEADJR, function(_, player)
    local data = mod:GetEntityData(player)
    if data.CurrentlyGodheadJrd then
        if player:HasTrinket(mod.ITEM.TRINKET.GODHEADJR) and player:HasWeaponType(WeaponType.WEAPON_KNIFE) then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_GLOW
            player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
        else
            data.CurrentlyGodheadJrd = nil
        end
    end
end, CacheFlag.CACHE_TEARFLAG)

--[[
function mod:godheadJrPostFireTear(player, tear, rng, pdata, tdata, ignorePlayerEffects, isLudo)
    if playerTryShootGodheadJr(player) then
        if not tear:HasTearFlags(TearFlags.TEAR_GLOW) then
            tear:AddTearFlags(TearFlags.TEAR_GLOW)
        end
        if not tear:HasTearFlags(TearFlags.TEAR_HOMING) then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end
        tear:Update()
    end
end

function mod:godheadjrPostFireBomb(player, bomb, rng, pdata, bdata)
    if playerTryShootGodheadJr(player) then
        if not bomb:HasTearFlags(TearFlags.TEAR_GLOW) then
            bomb:AddTearFlags(TearFlags.TEAR_GLOW)
        end
        if not bomb:HasTearFlags(TearFlags.TEAR_HOMING) then
            bomb:AddTearFlags(TearFlags.TEAR_HOMING)
        end
    end
end

function mod:godheadJrHell(player, data)
    --God help me, fuck knives, lasers, etc.
    local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata

    if (not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)) then
        if playerTryShootGodheadJr(player) then
            if not sdata.CurrentlyGodheadJrd then
                sdata.CurrentlyGodheadJrd = true
                player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
                player:EvaluateItems()
            end
        elseif sdata.CurrentlyGodheadJrd then
            sdata.CurrentlyGodheadJrd = nil
            player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
            player:EvaluateItems()
        end
    end
end

function mod:godheadJrKnifeHell(player, knife, kdata)
    if not knife:IsFlying() then
        local data = mod:GetEntityData(player)
        local sdata = data.ffsavedata
        if playerTryShootGodheadJr(player) then
            if not sdata.CurrentlyGodheadJrd then
                sdata.CurrentlyGodheadJrd = true
                player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
                player:EvaluateItems()
            end
        elseif sdata.CurrentlyGodheadJrd then
            sdata.CurrentlyGodheadJrd = nil
            player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
            player:EvaluateItems()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
    local basedata = mod:GetEntityData(player)
	local data = basedata.ffsavedata
	if not data or (data and not data.RunEffects) then
		return
	end
	if data.CurrentlyGodheadJrd then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_GLOW
		player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
	end
end, CacheFlag.CACHE_TEARFLAG)
]]
