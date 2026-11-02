local mod = FiendFolio
local wispsStuff = {}

-- Putting all of the wisps I make in here instead of the respective item's file.
-- This keeps things organized and allows me to reuse systems easier.

local WISP_DEATH = {
    -- Spawn rare Grotto Beast
    ---@param wisp EntityFamiliar
    [mod.ITEM.COLLECTIBLE.FIEND_FOLIO] = function (wisp)
        local r = wisp:GetDropRNG()
        local monster = mod.GrottoBeasts["Rares"][r:RandomInt(#mod.GrottoBeasts["Rares"] + 1)]
        local buddy = Isaac.Spawn(monster[1], monster[2], monster[3] or 0, wisp.Position, Vector.Zero, wisp.Player):ToNPC()
        buddy:AddCharmed(EntityRef(player), -1)
        buddy.SpawnerEntity = player
        buddy:Update()
    end,
    -- Evaluate items
    [mod.ITEM.COLLECTIBLE.TORTURE_COOKIE] = function (wisp)
        Isaac.CreateTimer(function ()
            wisp.Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end, 1, 1, true)
    end,
    [mod.ITEM.COLLECTIBLE.WRONG_WARP] = function (wisp)
        local player = wisp.Player
        player:AddWisp(mod.ITEM.COLLECTIBLE.WRONG_WARP, player.Position)
    end
}

local WISP_UPDATE = {
    ---@param wisp EntityFamiliar
    [mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN] = function (wisp)
        local player = wisp.Player
        local pData = mod:GetEntityData(player)
        if not pData.GatlingGunPreventShoot then
            if not wisp:IsDead() then
                wisp:Kill()
            end

            return
        end

        local index = wisp.Coins
        local threshold = mod:GetGGGWispCount(player)
        if threshold < index and not wisp:IsDead() then
            wisp:Kill()
        end
    end
}

local WISP_SHOOT = {
    [mod.ITEM.COLLECTIBLE.SHADOW_CLUSTER] = function (wisp, tear)
        mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), {
            death = function (tear2)
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.ShadowClusterCreep.Var, mod.FF.ShadowClusterCreep.Sub, tear2.Position, Vector.Zero, wisp.Player):ToEffect()
                creep.SpriteScale = Vector.One * 0.25
                creep:GetSprite():PlayRandom(creep.InitSeed)
                creep.SortingLayer = SortingLayer.SORTING_BACKGROUND
                mod:GetEntityData(creep).ShadowCreepFromWisp = true
            end
        })
    end
}

local WISP_INIT = {
    -- Evaluate items
    [mod.ITEM.COLLECTIBLE.TORTURE_COOKIE] = function (wisp)
        Isaac.CreateTimer(function ()
            wisp.Player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
        end, 1, 1, true)
    end,
    [mod.ITEM.COLLECTIBLE.WRONG_WARP] = function (wisp)
        local sprite = wisp:GetSprite()
        local rng = wisp:GetDropRNG()
        local path = "gfx/familiar/wisps/ff/wrongwarp_" .. rng:RandomInt(1, 4) .. ".png"
        sprite:ReplaceSpritesheet(0, path, true)
    end
}

local WISP_PRE_COLLIDE = {
    [mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN] = function (wisp)
        return true
    end,
}

local WISP_TEAR_INIT = {
    [mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN] = function (wisp, tear)
        tear:ChangeVariant(mod.TEAR.M90_BULLET)

        TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
        TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag["BULLET_GATLING"])

        tear.Velocity = tear.Velocity:Rotated(mod:RandomInt(-15, 15))

        Isaac.CreateTimer(function ()
            if tear:Exists() then
                tear:ClearTearFlags(TearFlags.TEAR_SPECTRAL)
                tear.FallingSpeed = -0.1
                tear.FallingAcceleration = -0.05
                tear.Height = -7
            end
        end, 1, 1, false)
    end,
}

function wispsStuff:WispTearInit(tear)
    local spawner = tear.SpawnerEntity
    if spawner and spawner.Type == EntityType.ENTITY_FAMILIAR and spawner.Variant == FamiliarVariant.WISP then
        local wisp = spawner:ToFamiliar()
        local tearFunc = WISP_TEAR_INIT[wisp.SubType]
        if tearFunc then
            tearFunc(wisp, tear)
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_TEAR_INIT, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, nil, wispsStuff.WispTearInit)

---@param wisp EntityFamiliar
function wispsStuff:WispDeath(wisp)
    if wisp.Variant ~= FamiliarVariant.WISP then
        return
    end
    
    local deathFunc = WISP_DEATH[wisp.SubType]
    if deathFunc then
        deathFunc(wisp:ToFamiliar())
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_ENTITY_KILL, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, nil, wispsStuff.WispDeath, EntityType.ENTITY_FAMILIAR)

function wispsStuff:WispInit(wisp)
    local initFunc = WISP_INIT[wisp.SubType]
    if initFunc then
        initFunc(wisp)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, wispsStuff.WispInit, FamiliarVariant.WISP)

function wispsStuff:WispUpdate(wisp)
    local updateFunc = WISP_UPDATE[wisp.SubType]
    if updateFunc then
        updateFunc(wisp)
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, wispsStuff.WispUpdate, FamiliarVariant.WISP)

function wispsStuff:WispUpdate(wisp)
    local colFunc = WISP_PRE_COLLIDE[wisp.SubType]
    if colFunc then
        return colFunc(wisp)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, wispsStuff.WispUpdate, FamiliarVariant.WISP)

function wispsStuff:CacheEvaluationDamage(player, _, dmg)
    for _, wisp in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.TORTURE_COOKIE)) do
        if GetPtrHash(player) == GetPtrHash(wisp:ToFamiliar().Player) then
            return dmg + 0.1
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, wispsStuff.CacheEvaluationDamage, EvaluateStatStage.FLAT_DAMAGE)

function mod:WispTearFired(tear)
    local spawner = tear.SpawnerEntity
    if spawner
    and spawner.Type == EntityType.ENTITY_FAMILIAR
    and spawner.Variant == FamiliarVariant.WISP
    and WISP_SHOOT[spawner.SubType] then
        WISP_SHOOT[spawner.SubType](spawner:ToFamiliar(), tear)
    end
end