local mod = FiendFolio
local game = Game()
local TRINKET = FiendFolio.ITEM.TRINKET.CIRCADIAN_RHYTHM

local LUCK = 1
local DAMAGE = 0.6
local TEARS = 0.6
local SPEED = 0.2

local MINUTES_IN_A_DAY = 24 * 60

local oldMinutes
local crop = Vector(0, 0)
local deathCertCooldown = 0
local deathCertTarget = 0
local deathCertTargetOld = 0
local deathCertChange = 15

local anyGoldenBlasphemous

-- isDay (boolean), minutes (int), cropOffset (Vector)
local function getTime()
    local time = os.time()
    time = os.date("*t", time)
    local minutes = time.hour * 60 + time.min
    local offset = math.floor(math.abs(minutes / MINUTES_IN_A_DAY - 0.5) * 64)
    if time.hour < 18 and time.hour >= 6 then
        return true, minutes, Vector(offset, 0) * 32
    else
        return false, minutes, Vector(offset, 0) * 32
    end
end

function mod:CircadianRhythmStats(player, flag)
    if player:HasTrinket(TRINKET) then
        local mult = player:GetTrinketMultiplier(TRINKET)
        local isDay = getTime()
        if isDay then
            if flag == CacheFlag.CACHE_SPEED then
                player.MoveSpeed = player.MoveSpeed + SPEED * mult
            end
        elseif flag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + LUCK * mult
        end
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_CACHE, TRINKET, mod.CircadianRhythmStats)

function mod:CircadianRhythmDamageTears(player, flag, og)
    if player:HasTrinket(TRINKET) then
        local mult = player:GetTrinketMultiplier(TRINKET)
        local isDay = getTime()
        if isDay then
            if flag == EvaluateStatStage.FLAT_TEARS then
                return og + TEARS * mult
            end
        elseif flag == EvaluateStatStage.FLAT_DAMAGE then
            return og + DAMAGE * mult
        end
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_STAT, TRINKET, mod.CircadianRhythmDamageTears)

function mod:AnyGoldenBlasphemousCircadianRhythm()
    if anyGoldenBlasphemous ~= nil then
        return anyGoldenBlasphemous
    end

    for _, player in ipairs(PlayerManager.GetPlayers()) do
        for i = 0, 1 do
            if player:GetTrinket(i) == TRINKET + TrinketType.TRINKET_GOLDEN_FLAG
            or (player:GetTrinket(i) == TRINKET and mod:IsPlayerTrinketBlasphemous(player, i)) then
                anyGoldenBlasphemous = true
            end
        end
    end

    for _, v in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, -1, true)) do
        if v.SubType == TRINKET + TrinketType.TRINKET_GOLDEN_FLAG
        or (v.SubType == TRINKET and mod:IsPickupTrinketBlasphemous(v)) then
            anyGoldenBlasphemous = true
        end
    end

    anyGoldenBlasphemous = false
end

function mod:CircadianRhythmRender()
    local _, _, vec = getTime()

    local specialExists = mod:AnyGoldenBlasphemousCircadianRhythm()

    if game:GetLevel():GetDimension() == Dimension.DEATH_CERTIFICATE and not specialExists then
        if deathCertCooldown > deathCertChange then
            deathCertCooldown = 0
            deathCertTarget = math.random() * 127 % 64
            deathCertChange = deathCertTarget / 64 * 30
        end

        deathCertTargetOld = mod:Lerp(deathCertTargetOld, deathCertTarget, 0.05)
        crop = mod:Lerp(crop, Vector(deathCertTargetOld * 32, 0), 1)
        deathCertCooldown = deathCertCooldown + 1
    elseif not specialExists then
        crop = mod:Lerp(crop, vec, 0.15)
    else
        crop = vec
    end
end

function mod:CircadianRhythmUpdate()
    local _, minutes, _ = getTime()
    if oldMinutes ~= minutes then
        oldMinutes = minutes

        for _, player in ipairs(PlayerManager.GetPlayers()) do
            if player:HasTrinket(TRINKET) then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK, true)
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_UPDATE, TRINKET, mod.CircadianRhythmUpdate)

---@param player EntityPlayer
function mod:CircadianRhythmCrop(slot, pos, scale, player, cropOffset)
    if mod:GetRealTrinketId(player:GetTrinket(slot)) == TRINKET then
        local clampedCrop = Vector(math.ceil(math.floor(crop.X + 0.5) / 32) * 32, 0)
        return {CropOffset = clampedCrop}
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, mod.CircadianRhythmCrop)

---@param trinket EntityPickup
function mod:CircadianRhythmTrinketUpdate(trinket)
    if mod:GetRealTrinketId(trinket.SubType) == TRINKET then
        local sprite = trinket:GetSprite()
        local clampedCrop = Vector(math.ceil(math.floor(crop.X + 0.5) / 32) * 32, 0)
        sprite:GetLayer(0):SetCropOffset(clampedCrop)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.CircadianRhythmTrinketUpdate, PickupVariant.PICKUP_TRINKET)

function mod:ResetCircadianRhythmCache()
    anyGoldenBlasphemous = nil
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.ResetCircadianRhythmCache, PickupVariant.PICKUP_TRINKET)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.ResetCircadianRhythmCache)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.ResetCircadianRhythmCache)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function (_, ent)
    if ent.Variant == PickupVariant.PICKUP_TRINKET then
        mod:ResetCircadianRhythmCache()
    end
end, EntityType.ENTITY_PICKUP)