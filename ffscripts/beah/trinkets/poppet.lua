local mod = FiendFolio

local flagsBlacklist = {
    TearFlags.TEAR_GISH,
    TearFlags.TEAR_GLITTER_BOMB,
    TearFlags.TEAR_SCATTER_BOMB,
    TearFlags.TEAR_TRACTOR_BEAM,
    TearFlags.TEAR_CROSS_BOMB,
    TearFlags.TEAR_BLOOD_BOMB,
    TearFlags.TEAR_BRIMSTONE_BOMB,
    TearFlags.TEAR_GHOST_BOMB,
    TearFlags.TEAR_BUTT_BOMB,
    TearFlags.TEAR_CREEP_TRAIL,
    --blame sin (he's right though)
    TearFlags.TEAR_CARD_DROP_DEATH,
    TearFlags.TEAR_RUNE_DROP_DEATH,
    TearFlags.TEAR_MIDAS,
    TearFlags.TEAR_COIN_DROP_DEATH,
    TearFlags.TEAR_ECOLI
}
local rarerFlags = {
    TearFlags.TEAR_NEEDLE,
    TearFlags.TEAR_LASERSHOT,
    TearFlags.TEAR_GREED_COIN,
    TearFlags.TEAR_HORN
}

local function getPoppetTearFlags(player)
    local newFlags = TearFlags.TEAR_NORMAL
    if player:HasTrinket(mod.ITEM.TRINKET.POPPET) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.POPPET)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.POPPET)
        if rng:RandomFloat() < 0.20*mult then
            newFlags = newFlags | (TearFlags.TEAR_PIERCING | TearFlags.TEAR_BELIAL)
        end
    end
    return newFlags
end

local flagsToGive = 3
local function getFruitMilkTearFlags(player)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.FRUIT_MILK) then
        return TearFlags.TEAR_NORMAL
    end
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.FRUIT_MILK)
    local flags = math.min(flagsToGive + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.FRUIT_MILK)-1, 80)
    local newFlags = TearFlags.TEAR_NORMAL
    for i = 1, flags, 1 do
        local flagToAdd = TearFlags.TEAR_NORMAL
        while flagToAdd == TearFlags.TEAR_NORMAL or (newFlags & flagToAdd) == 0
        or mod:Contains(flagsBlacklist, flagToAdd)
        or (mod:Contains(rarerFlags, flagToAdd) and rng:RandomFloat()<0.5) do
            flagToAdd = mod:TEARFLAG(rng:RandomInt(TearFlags.TEAR_EFFECT_COUNT))
        end

        if flagToAdd == TearFlags.TEAR_BELIAL then
            newFlags = newFlags | TearFlags.TEAR_PIERCING
        end
        newFlags = newFlags | flagToAdd
    end
    return newFlags
end

for i = 1, 2, 1 do
    local func = getFruitMilkTearFlags
    local cbackFunc = "AddCollectibleCallback"
    local id = mod.ITEM.COLLECTIBLE.FRUIT_MILK

    local poppet = i==2
    if poppet then
        func=getPoppetTearFlags
        cbackFunc = "AddTrinketCallback"
        id = mod.ITEM.TRINKET.POPPET
    end
    
    local function addThing(_, player)
        local p_data = mod:GetEntityData(player)
        if player.FrameCount % 10 == 0 or p_data.resetFlagsThisFrame then
            if i==1 or not player:HasCollectible(mod.ITEM.COLLECTIBLE.FRUIT_MILK) then
                p_data.ffsavedata.RunEffects.WickedBonusVanillaFlags = nil
            end
            p_data.ffsavedata.RunEffects.WickedBonusVanillaFlags = (p_data.ffsavedata.RunEffects.WickedBonusVanillaFlags or TearFlags.TEAR_NORMAL) | func(player)
            player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
            player:EvaluateItems()
        end
        if p_data.resetFlagsThisFrame then
            p_data.resetFlagsThisFrame = false
        end
    end

    mod[cbackFunc](mod, ModCallbacks.MC_POST_PEFFECT_UPDATE, id, addThing)
    
    local func2 = function ()
    end
    if poppet then
        func2 = function (tear)
            if tear.Type == EntityType.ENTITY_TEAR and tear:ToTear().TearFlags & TearFlags.TEAR_BELIAL > 0 then
                mod:makeTearBloody(tear)
            end
        end
    end
    mod[cbackFunc](mod, TearFlagsLib.Callback.POLL_TEARFLAGS, id, function (_, tear, player, weapon)
        if player then
            local p_data = mod:GetEntityData(player)
            p_data.resetFlagsThisFrame = true
            func2(tear)
            addThing(_, player)
        end
    end)
end

--[[function mod:fruitMilkTilk(player)
    local p_data = mod:GetEntityData(player)
    p_data.ffsavedata.RunEffects.FlagCheckTimer = (p_data.ffsavedata.RunEffects.FlagCheckTimer or 6) - 1
    if p_data.ffsavedata.RunEffects.FlagCheckTimer <= 0 then
        p_data.ffsavedata.RunEffects.WickedBonusVanillaFlags = getPoppetTearFlags(player)
        p_data.ffsavedata.RunEffects.FlagCheckTimer = 20
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
        player:EvaluateItems()
    end
    if player:HasCollectible(mod.ITEMS.FRUIT_MILK) then
        if p_data.ffsavedata.RunEffects.FruitMilkFlags == nil then
            local c_rng = player:GetCollectibleRNG(mod.ITEMS.FRUIT_MILK)
            local newFlags = mod:GenerateFruitFlag(c_rng)
            p_data.ffsavedata.RunEffects.FruitMilkFlags = newFlags
            player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
            player:EvaluateItems()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.fruitMilkTilk)
mod:AddCustomCBack(mod.CustomCallbacks.SWCB_ON_FIRE_PURE, function (_, _, _, _, player)
    local p_data = mod:GetEntityData(player)
    p_data.ffsavedata.RunEffects.FlagCheckTimer = 0
end)]]

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.FRUIT_MILK] = {
	TearDamage = 0.7,
	BodyColor = Color(1,1,1,1,62.084/255,-53.920/255,22.416/255,0.721,0.894,0.779,1),
	EyeAColor = Color(1,1,1,1,-75.703/255,-75.703/255,-75.703/255,1.297,1.297,1.297,1),
	EyeBColor = Color(1,1,1,1,-75.703/255,-75.703/255,-75.703/255,1.297,1.297,1.297,1)}

local function getFruitMilkTearFlagsSewing(familiar)
	local rng = familiar.Player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.FRUIT_MILK)
	local newFlags = TearFlags.TEAR_NORMAL
	for i = 1, 3, 1 do
		local flagToAdd = TearFlags.TEAR_NORMAL
		while flagToAdd == TearFlags.TEAR_NORMAL or (newFlags & flagToAdd) == 0
		or mod:Contains(flagsBlacklist, flagToAdd)
		or (mod:Contains(rarerFlags, flagToAdd) and rng:RandomFloat()<0.5) do
			flagToAdd = mod:TEARFLAG(rng:RandomInt(TearFlags.TEAR_EFFECT_COUNT))
		end

		if flagToAdd == TearFlags.TEAR_BELIAL then
			newFlags = newFlags | TearFlags.TEAR_PIERCING
		end
		newFlags = newFlags | flagToAdd
	end
	return newFlags
end

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	tear.TearFlags = tear.TearFlags | getFruitMilkTearFlagsSewing(familiar)
	tear.Scale = tear.Scale - 0.3
end, FiendFolio.ITEM.COLLECTIBLE.FRUIT_MILK)