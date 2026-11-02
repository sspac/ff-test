local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local flagsManager = TearFlagsLib
flagsManager.RegisterTearFlag("BEREAVEMENT")

--Used to be called dusty grimoire before a retheme, enjoy all the old code.
local dustyGrimoireCycle = {
    {--[[Flag = TearFlags.TEAR_BURN,]]      Color = FiendFolio.ColorFunkyRed,       LaserCol = mod.ColorNormal},
    {--[[Flag = TearFlags.TEAR_SLOW,]]      Color = FiendFolio.ColorFunkyBlue,      LaserCol = Color(0,1,1,1,0,0,1)},
    {--[[Flag = TearFlags.TEAR_POISON,]]    Color = FiendFolio.ColorCorpseGreen2,   LaserCol = Color(0,1,1,1,0,1,0)},
    {--[[Flag = TearFlags.TEAR_CONFUSION,]] Color = FiendFolio.ColorGreyscaleLight, LaserCol = mod.ColorGreyscaleLightLaser},
    {--[[Flag = TearFlags.TEAR_FREEZE,]]    Color = FiendFolio.ColorPiss2,          LaserCol = Color(1,1,1,1,0,1,0)},
    {Flag = TearFlags.TEAR_GLOW,      Color = FiendFolio.ColorLegoOrange,           LaserCol = Color(1,1,1,1,0,0.5,0)},
    {Flag = TearFlags.TEAR_SHIELDED,  Color = FiendFolio.ColorGreyscaleDark,        LaserCol = mod.ColorGreyscaleDarkLaser},
}

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEREAVEMENT) then
        local d = mod:GetEntityData(player)
        local sdata = d.ffsavedata
        if sdata then
            sdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle or 0
            if flag == CacheFlag.CACHE_TEARFLAG then
                if dustyGrimoireCycle[sdata.dustyGrimoireCycle + 1].Flag then
                    player.TearFlags = player.TearFlags | dustyGrimoireCycle[sdata.dustyGrimoireCycle + 1].Flag
                end
            elseif flag == CacheFlag.CACHE_TEARCOLOR then
                if dustyGrimoireCycle[sdata.dustyGrimoireCycle + 1].Color then
                    player.TearColor = dustyGrimoireCycle[sdata.dustyGrimoireCycle + 1].Color
                    player.LaserColor = dustyGrimoireCycle[sdata.dustyGrimoireCycle + 1].LaserCol
                end
            end
        end
    end
end)

function mod:dustyGrimoireCheckPlayer(player, pdata)
    pdata = pdata or mod:GetEntityData(player)
    local sdata = pdata.ffsavedata
    if sdata and sdata.TryCycleDustyGrimoire then
        sdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle or 0
        sdata.dustyGrimoireCycle = (sdata.dustyGrimoireCycle + 1) % #dustyGrimoireCycle
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR)
		player:EvaluateItems()
        sdata.TryCycleDustyGrimoire = nil
    end
end

local function checkCanGrimoireApply(player)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BEREAVEMENT)
    local rand = rng:RandomFloat() * 7 * 7
    --print(rand)
    if rand <= math.max(player.Luck * 7, 14) then
        return true
    end
end

local function applyGrimoireStatus(source, entity, data, forceCycle, damage)
    local cycleNum
    if data then
        cycleNum = data.dustyGrimoireCycle
    else
        cycleNum = forceCycle
    end
    local setDamage
    if damage then
        setDamage = damage
    else
        setDamage = data.dustyGrimoireDamage
    end
    if cycleNum == 0 then
        entity:AddBurn(source, 65, setDamage)
    elseif cycleNum == 1 then
        entity:AddSlowing(source, 65, 0.5, Color(1,1,1,1,0.2,0.2,0.2))
    elseif cycleNum == 2 then
        entity:AddPoison(source, 65, setDamage)
    elseif cycleNum == 3 then
        entity:AddConfusion(source, 65, false)
    elseif cycleNum == 4 then
        entity:AddFreeze(source, 65)
    end
end

function mod:dustyGrimoirePostDamage(source,entity,data)
    if data.dustyGrimoireCycle then
        applyGrimoireStatus(source, entity, data)
    end
end

function mod:dustyGrimoirePostFire(player, tear, rng, pdata, tdata, secondHandMultiplier, ignorePlayerEffects, isLudo)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEREAVEMENT) then
        pdata = pdata or mod:GetEntityData(player)
        local sdata = pdata.ffsavedata
        if sdata then
            sdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle or 0
            if checkCanGrimoireApply(player) then
                tdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle
                tdata.dustyGrimoireDamage = player.Damage
            end
            if sdata.dustyGrimoireCycle == 6 then
                if tear.Type == 2 then
                    if tear.Variant ~= TearVariant.LOST_CONTACT then
                        mod:changeTearVariant(tear, TearVariant.LOST_CONTACT)
                    end
                end
            end
            if isLudo then
                if tear.Parent and tear.Parent.Type == 1 then
                    sdata.TryCycleDustyGrimoire = true
                end
            else
                sdata.TryCycleDustyGrimoire = true
            end
        end
    end
end

mod:AddCallback("FF_POST_LUDO_TEAR_RESET", function(tear, data)
    data.dustyGrimoireCycle = nil
    data.dustyGrimoireDamage = nil
end)

function mod:dustyGrimoirePostAquarius(player,creep)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEREAVEMENT) then
        local pdata = mod:GetEntityData(player)
        local sdata = pdata.ffsavedata
        if sdata and checkCanGrimoireApply(player) then
            local cdata = mod:GetEntityData(creep)
            sdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle or 0
            cdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle
            cdata.dustyGrimoireDamage = player.Damage
        end
    end
end

function mod:dustyGrimoireDarkArts(player, entity)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEREAVEMENT) then
        local pdata = mod:GetEntityData(player)
        local sdata = pdata.ffsavedata
        if sdata and checkCanGrimoireApply(player) then
            sdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle or 0
            applyGrimoireStatus(EntityRef(source), entity, nil, sdata.dustyGrimoireCycle, player.Damage)
        end
    end
end

local function addGrimoireFlags(_, entity, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEREAVEMENT) then
        local pdata = mod:GetEntityData(player)
        local sdata = pdata.ffsavedata
        if checkCanGrimoireApply(player) then
            sdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle or 0
            flagsManager.AddTearFlags(entity, flagsManager.Flag.BEREAVEMENT)
            mod:GetEntityData(entity).dustyGrimoireCycle = sdata.dustyGrimoireCycle
        end
        sdata.TryCycleDustyGrimoire = true
	end
end

local function addGrimoireFlagsDelayed(_, entity, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEREAVEMENT) then
        local pdata = mod:GetEntityData(player)
        local sdata = pdata.ffsavedata
        if checkCanGrimoireApply(player) then
            sdata.dustyGrimoireCycle = sdata.dustyGrimoireCycle or 0
            local usedGrimoireCycle = (sdata.dustyGrimoireCycle + 1) % 7
            flagsManager.AddTearFlags(entity, flagsManager.Flag.BEREAVEMENT)
            mod:GetEntityData(entity).dustyGrimoireCycle = usedGrimoireCycle
        end
        sdata.TryCycleDustyGrimoire = true
	end
end

mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, function(_, entity, player, weaponFlag)
    local data = mod:GetEntityData(entity)
    if not data.hasPolledBereavement then
        addGrimoireFlags(_, entity, player)
    end

    data.hasPolledBereavement = true
end, TearFlagsLib.WeaponFlag.LASER)

mod:AddCallback(flagsManager.Callback.PRE_SWING_CLUB, addGrimoireFlags)
mod:AddCallback(flagsManager.Callback.POST_THROW_KNIFE, addGrimoireFlagsDelayed)

mod:AddCallback(flagsManager.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source)
    applyGrimoireStatus(EntityRef(source), entity, nil, mod:GetEntityData(source).dustyGrimoireCycle, player.Damage)
end, flagsManager.Flag.BEREAVEMENT)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.BEREAVEMENT] = {
	BodyColor = Color(1,1,1,1,12.159/255,19.159/255,88.345/255,0.788,0.788,0.540,1),
	EyeAColor = Color(1,1,1,1,128.628/255,135.938/255,86.327/255,0.496,0.416,0.230,1),
	EyeBColor = Color(1,1,1,1,128.628/255,135.938/255,86.327/255,0.496,0.416,0.230,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
    local data = mod:GetEntityData(familiar)
    data.dustyGrimoireCycle = data.dustyGrimoireCycle or 0
	
	local cycleInfo = dustyGrimoireCycle[data.dustyGrimoireCycle + 1]
	tear.Color = cycleInfo.Color
	if cycleInfo.Flag then
		tear:AddTearFlags(cycleInfo.Flag)
	end
	if checkCanGrimoireApply(familiar.Player) then
		local tdata = mod:GetEntityData(tear)
        tdata.dustyGrimoireCycle = data.dustyGrimoireCycle
        tdata.dustyGrimoireDamage = 3.5
    end
    if data.dustyGrimoireCycle == 6 then
        if tear.Variant ~= TearVariant.LOST_CONTACT then
            mod:changeTearVariant(tear, TearVariant.LOST_CONTACT)
        end
    end
	
	data.dustyGrimoireCycle = (data.dustyGrimoireCycle + 1) % #dustyGrimoireCycle
end, FiendFolio.ITEM.COLLECTIBLE.BEREAVEMENT)