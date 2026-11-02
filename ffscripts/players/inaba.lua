local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--[[
Please, please PLEASE do not LEAK me, I am but a humble little SECRET character
and would like to stay SECRET for AT LEAST a WEEK or so if I can.

⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⠐⠒⠶⠶⠒⢂⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣠⡶⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠁⠶⣄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢀⡴⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢦⡀⠀⠀⠀
⠀⠀⣰⠟⠁⠀⠀⣀⠤⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠘⢗⠢⢀⠀⠀⠈⢹⣄⠀⠀
⠀⣰⠏⠀⠀⠀⢀⣀⣬⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣄⣀⠀⠀⠀⢻⣆⠀
⢠⡿⠀⢀⣤⠞⠉⠀⠈⠙⣿⣿⣦⠀⠀⠀⠀⡴⠚⠉⠀⠈⠻⣿⣷⣄⠀⠀⣿⡀
⣼⡇⢀⣿⡇⠀⠀⠀⠀⠀⣿⣿⣿⣧⢃⢠⣿⡃⠀⠀⠀⠀⢀⣿⣿⣿⡇⠄⢨⡷
⣿⡇⢠⢸⣷⣄⣀⣀⣤⣾⣿⣿⣿⣿⢘⠀⢿⣧⣄⣀⣀⣴⣿⢿⣿⣿⡇⢰⢈⡟
⢻⡇⠘⡈⢿⣿⣿⣿⣿⣧⣠⣿⡿⠃⡜⢰⠘⢿⣿⣿⣿⣿⣧⣠⣿⡿⠁⡎⣸⡇
⠈⣷⡀⠐⠀⠙⠻⠿⠿⠿⠿⠋⢁⠔⠁⠀⠑⣈⠙⠻⠿⠿⠿⠿⠋⢀⠜⢀⡿⠀
⠀⠙⣇⡀⠀⠁⠒⠠⠤⠤⠔⠚⠁⣀⣀⣀⣀⠀⠑⠒⠤⠤⠤⠐⠊⠁⢀⣾⠁⠀
⠀⠀⠈⢷⡀⠀⠀⠀⠀⠀⠀⠀⠻⠿⠿⠿⠿⠇⠀⠀⠀⠀⠀⠀⠀⣠⡞⠁⠀⠀
⠀⠀⠀⠀⠙⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠾⠋⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠓⠶⣆⣠⡀⣀⣀⡀⢀⣀⣀⣀⣤⡴⠶⠛⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠋⠙⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀



⠀⠀⠀⠀⠀⠀⢀⡴⢲⡄⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⡞⠀⠀⡇⠀⢀⡴⠋⠁⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣸⠁⠀⠀⡇⣠⠟⠀⠀⠀⣼⣠⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⠀⢠⢤⡿⠃⣀⠀⢀⡞⠉⠁⠀⠀⠈⠙⠶⡄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣻⣰⡏⣼⢁⡴⠋⣰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠹⡄⣀⡀⠀⠀⠀⠀
⠀⠀⠀⢀⡾⠋⠉⠁⠀⠙⠁⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡈⢷⠀⠀⠀⠀
⠀⠀⠀⣼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⢀⣧⡾⠁⠀⠀⠀
⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀
⠀⠀⠀⣹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠁⠀⠀⡀⠀⠀⢰⡾⠋⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢻⡇⣀⡀⠀⠺⣿⠇⠀⣀⣤⣄⣀⣠⣬⣥⣤⠾⠛⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠉⠛⠓⠂⠤⠤⠖⠊⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

do not leak EVER, or we will cancel the next update
we know where you live probably
]]

mod.InabaBal = {
    -- Whether to grant a holy mantle when entering Migraine Mode.
    -- Inaba + Birthright currently still grants mantles regardless.
    MigraineModeMantle = false,

    -- Inaba Stats
    BaseDamageMulti = 0.75,
    BaseFlatTearsUp = 0.7,

    -- Binaba stats
    B_BaseDamageMulti = 0.95,
    B_BaseFlatTearsUp = 0.7,

    -- Migraine Mode Stats
    MigraineModeDamageMulti = 1.27,
    MigraineModeFlatTearsUp = -0.1,
    MigraineModeTearsMult = 1.0,

    -- Binaba Migraine Mode Stats
    B_MigraineModeDamageMulti = 0.8,
    B_MigraineModeFlatTearsUp = 0,
    B_MigraineModeTearsMult = 2,
    B_MigraineModeRangeUp = 40,

    MigraineTopPercent = 0.9, --How close to completion before bar eye opens
    MigraineBotPercent = 0.2, --How close to empty for warning

    -- Inaba Satellites (these don't apply to Binaba)
    SatelliteDamageMult = 0.25,
    MigraineSatelliteDamageMult = 0.5,
    ImperishableDamageMult = 2, -- damage mult on satellites in imperishable night challenge
    SatelliteSpread = 7,
    MigraineSatelliteSpread = 0,
    MigraineSatelliteFireDelayMult = 2,
    MigraineTearScaleMult = 1, -- since it's a pupula tear, set to 1 to disable
    MigraineTearScaleFlat = 0.6, -- mostly for use if mult disabled, applies before mult
    MigrainePiercePenalty = 1.0, --Multiplier on post-pierce Migraine Mode tears (1.0 to disable penalty)
    MigrainePiercePenaltyReduction = 0.1, --How much to add to the multiplier per power level (eg. x0.3 at pow 1.00, x0.4 at pow 2.00)
    -- MULTISHOT
    -- Inaba's satellites SHARE tears added by multishot, rather than each satellite inheriting the player's full multishot.
    -- This prevents satellites from up to quintupling the amount of tears fired when multishot effects get involved.
    -- When the amount cannot be cleanly divided, the remainder is converted to a proportional chance to fire an additional tear.
    -- For example, with Mutant Spider (and `SatelliteMaxSharedMultiShot=1`), a solo satellite would shoot 4 tears (+3), but a pair of satellites would shoot 2-3 tears each (+1.5).
    -- In practice they might shoot a bit more, since this configuration still allows having multiple satellites (ie, power levels) to multiply the amount of multishot tears shared.
    -- `SatelliteMinSharedMultiShot=1, SatelliteMaxSharedMultiShot=2` means a single satellite will gain full multishot, two satellites will share 1.33x the player's multishot,
    -- and 4 satellites will share 2x the player's multishot. This allows satellites to still benefit from multishot effects without getting excessive. Can be fine-tuned as needed.
    SatelliteMinSharedMultiShot = 1.0,
    SatelliteMaxSharedMultiShot = 2.0,
    -- How much DPS "lost" by the multishot limitations should be converted to damage.
    -- 100% compensation is unnecessary since not all tears would have it anyway.
    -- The compensation may not even be necessary at all, adjust as deemed appropriate.
    SatelliteMultiShotCompensation = 0.5,

    -- Binaba satellites
    B_SatelliteSpread = 7,
    B_MigraineSatelliteSpread = 12,
    B_MigraineRangeVariance = { MIN=0.5, MAX=2 },
    B_MigraineShotSpeedVariance = { MIN=0.5, MAX=2 },

    -- Shared satellite attributes
    SatelliteDistance = 30,
    SatelliteShotSpeed = 10,

    SatelliteRotationSpeed = 0.75, -- % closer the satellite gets to its target rotation each frame from current. as a general rule, lowering this will make the satellites rotate into their new position slower.
    SatellitePositionSpeed = 0.75, -- ditto, for position. these two interact with eachother, since rotation determines the position. as a general rule, lowering this will make the satellites lag behind the player more.

    SatelliteUnicornRotationalSpeed = 360 / 20, --How much the satellite rotates by frame, positive is clockwise
    SatelliteUnicornDistMult = 0.75, --Multiplier for distance from the player
    SatelliteLungDistMult = 1.5, --Multiplier for distance from the player

    --Spirit sword slash damage modifiers. Applied on top of the usual satellite damage modifiers.
    SatelliteMeleeDamageMult = 3,
    SatelliteMeleeFlatDamage = 1.7,
    -- Multiplier on the fire delay of satellite mini brimstones.
    -- This also affects how fast they rotate around the player.
    SatelliteMiniBrimstoneDelayMult = 6,
    -- Damage multiplier for satellite mini brimstones. Does not apply to Migraine Mode's continuous beam.
    -- May be used to offset the DelayMult above if needed.
    SatelliteMiniBrimstoneDamageMult = 1.5,
    -- How much of a bonus the player's power level adds to Mind Wave's continuous brimstone laser damage.
    -- 0.0 = no bonus, 1.0 = damage is multiplied by power level
    SatelliteBrimstoneMigrainePowerBonus = 0.25,
    -- How much of a bonus the player's fire rate adds to Mind Wave's continuous brimstone laser damage.
    -- 0.0 = no bonus, 1.0 = damage is multiplied by fire rate
    SatelliteBrimstoneMigraineFireRateBonus = 1/3,

    B_CuttingGazeLerpSpeed = 0.15, --Acceleration of returning gaze
    B_CuttingGazeMaxSpeed = 40, --Max speed that satellites can fly back to you
    B_CuttingGazeDistMult = 0.1, --Multiplier for distance from the player while held in place

    -- Cutting gaze return attack
    B_CuttingGazeChargeBarOffset = Vector(0, -45),
    -- Hold time required to trigger attack: B_SatelliteCuttingFlatChargeTime + (player.MaxFireDelay + 1) * B_SatelliteCuttingPlayerChargeTimeMult
    B_CuttingFlatChargeTime = 10,
    B_CuttingPlayerChargeTimeMult = 2.0,
    B_CuttingMigraineChargeTimeMult = 0.25,
    -- Note that the current implementation will often hit enemies twice each
    B_CuttingGazeReturnDamageMult = 1,
    B_CuttingGazeReturnFlatDamage = 2.5,
    -- How much "buffed charge" is added to Ocular Spectrum when an enemy is hit
    B_CuttingGazeOcularSpectrumInitialCharge = math.ceil(Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM).MaxCharges * 0.14),
    -- Multiplier to reduce the amount of buffed charge added for additional enemies hit with one attack
    B_CuttingGazeOcularSpectrumChargeDecay = 0.6,

    -- Ocular Spectrum
    B_OcularSpectrumDamageMult = 0.25,
    B_OcularSpectrumBuffDamageMult = 0.80,
    B_OcularSpectrumBuffGivesExtraSat = false,
    --B_OcularSpectrumBuffAddsHoming = true,
    B_OcularSpectrumHomingStrength = 0.08, --Used without cutting gaze buff
    B_OcularSpectrumBuffHomingStrength = 0.4,

    BaseKnockbackMulti = 0.9,
    SatelliteKnockbackMulti = 0.05,

    TearFlagGroups = {
        SatelliteAllowed = {
            TearFlags.TEAR_SPECTRAL,
            TearFlags.TEAR_PIERCING,
            TearFlags.TEAR_HOMING,
            TearFlags.TEAR_BOOMERANG,
            TearFlags.TEAR_PERSISTENT,
            TearFlags.TEAR_WIGGLE,
            TearFlags.TEAR_ORBIT,
            TearFlags.TEAR_WAIT,
            TearFlags.TEAR_BOUNCE,
            TearFlags.TEAR_SHRINK,
            TearFlags.TEAR_PULSE,
            TearFlags.TEAR_SPIRAL,
            TearFlags.TEAR_FLAT,
            TearFlags.TEAR_SQUARE,
            TearFlags.TEAR_CONTINUUM,
            TearFlags.TEAR_BIG_SPIRAL,
            TearFlags.TEAR_HYDROBOUNCE,
            TearFlags.TEAR_OCCULT,
            TearFlags.TEAR_ORBIT_ADVANCED,
            TearFlags.TEAR_TURN_HORIZONTAL,
            TearFlags.TEAR_DECELERATE,
            TearFlags.TEAR_ACCELERATE,
        },
        MigraineModeAdditions = {
            TearFlags.TEAR_PIERCING,
        },
    },
    FlagGroups = {
        NoPenalty = {
            DamageFlag.DAMAGE_FAKE,
            DamageFlag.DAMAGE_NO_PENALTIES,
            DamageFlag.DAMAGE_CHEST,
            DamageFlag.DAMAGE_CURSED_DOOR,
            DamageFlag.DAMAGE_RED_HEARTS,
            DamageFlag.DAMAGE_DEVIL,
            DamageFlag.DAMAGE_INVINCIBLE,
            DamageFlag.DAMAGE_IV_BAG,
        }
    },

    SatelliteChargeBarScale = Vector(0.75, 0.75),
    SatelliteChargeBarOffset = Vector(15, -30),

    MeterOffsets = {
        {
            Base = Vector(40, 32),
        },
        {
            Base = Vector(-210, 32),
        },
        {
            Base = Vector(96, -48),
        },
        {
            Base = Vector(-220, -48)
        }
    },

    -- colors
	Shadow_SatelliteTearColor = Color(0.1, 0.1, 0.1, 1, 0, 0, 0, 1, 1, 1, 1),

    MeterColor = Color(175 / 255, 61 / 255, 61 / 255, 1, 0, 0, 0),
    MeterColorActive = mod:ColorHSV(0.09, 0.8, 1.0, 1.0, 1.0, 0.9, 0.1), --Color(1, 82 / 255, 0, 1, 0, 0, 0),
    B_MeterColor = mod:ColorHSV(0.98, 0.65, 0.75, 1.0, 0.95, 0.6, 0.05),
    B_MeterColorActive = mod:ColorHSV(0.05, 0.8, 0.95, 1.0, 0.04, 0.9, 0.1),
    DropShadow = Color(1, 1, 1, 77 / 255, 0, 0, 0),
    PowerOffset = Vector(1, 10),

    PowerValue = 2,
    BigPowerValue = 6,

    PowerItemsPerRoom = {
        Min = 6,
        Max = 8
    },
    PowerItemBossThresholds = { -- additional power items are always spawned at 0 hp
        0.66,
        0.33
    },
    PowerItemsPerBossThreshold = 2,
    ChallengePowerItems = 3,
    BeastHorsemanPowerItems = 3,

    PowerItemsPerRoomGreed = {
        Min = 3,
        Max = 5
    },

    PowerItemChaseDistance = 160,
    PowerItemChaseSpeed = 2,
    PowerItemChaseFriction = 0.95,

    PowerDamagePenalty = .10, -- minimum percentage of power lost on hit
    PowerDamageLastTimePenalty = .25, -- percentage of power collected since last time lost on hit
    PowerDamageLimit = 100,
    PowerDeathPenalty = 200,
    B_PowerDamageBonus = 0.5, --Damage boost per 1 whole power (only relevant to Binaba)

    MigraineGain = {
        LowHealth = 2 / 30,
        TakeDamage = 10,
        EnemyKill = 7,
        Drain = 10 / 30,
        DamageDrain = 25,
    },
    MigraineGainBirthright = {
        LowHealth = 3 / 30,
        TakeDamage = 7,
        EnemyKill = 7,
        Drain = 7 / 30,
        DamageDrain = 20
    },
    SoulOfInabaDrainMult = 0.71,
    MigraineCap = 100,
    MigraineBirthrightMantle = 0.9, --Percentage of cap needed to bring back mantle

    ShadowSatelliteTimeExtra = 45,
    ShadowSatelliteRange = 40 * 2.5,
    ShadowSatelliteSub = 1
}

--mod.inabaHair = Isaac.GetCostumeIdByPath("gfx/characters/inaba_hair.anm2")

local inabaSatellite = mod.ITEM.FAMILIAR.INABA_SATELLITE
local powerItem = Isaac.GetEntityVariantByName("Power Item (Small)")

local function PreventSatelliteShooting(player)
    if player and mod:GetEntityData(player).GatlingGunPreventShoot then
        return true
    end
    return false
end

local function HideSatellites(player)
    return PreventSatelliteShooting(player)
end

--This is a bit particular
--Only minor / movement effects should occur here
--So worms are a big one (heart worm from ret would be good for example)
mod:AddCallback("SATELLITE_POST_FIRE_TEAR", function(_, player, tear)
    local pdata = mod:GetEntityData(player)
    local tdata = mod:GetEntityData(tear)
    local rng = tear:GetDropRNG()
    mod:trinityFlagGeneric(tear, player, TearFlagsLib.WeaponFlag.TEAR)
    mod:miPostFireTear(player, tear, rng, pdata, tdata)
    mod:grandpasWhiskeyFlagGeneric(tear, player, TearFlagsLib.WeaponFlag.TEAR)
    mod:tanFlagGeneric(tear, player, TearFlagsLib.WeaponFlag.TEAR)
end)

--Inaba funcs

if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.INABA, {
        Name = "gfx/ui/boss/inaba_name.png",
        Portrait = "gfx/ui/stage/playerportrait_inaba.png",
        NoShake = false
    })
end
if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.BINABA, {
        Name = "gfx/ui/boss/inaba_name.png",
        Portrait = "gfx/ui/stage/playerportrait_taintedinaba.png",
        NoShake = false
    })
end

function mod:isInaba(player)
    return player:GetPlayerType() == mod.PLAYER.INABA
end
function mod:isBinaba(player)
    return player:GetPlayerType() == mod.PLAYER.BINABA
end
function mod:isEitherInaba(player)
    local ptype = player:GetPlayerType()
    return ptype == mod.PLAYER.INABA or ptype == mod.PLAYER.BINABA
end

function mod:AnyInaba()
    local inabas = {}
    for i = 1, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1)
        if mod:isEitherInaba(player) then
            inabas[#inabas + 1] = player
        end
    end

    return #inabas > 0, inabas
end

function mod:entityValidationTechniqueFour()
    local savedata = FiendFolio.savedata
    if savedata and savedata.run then
        if savedata.run.checkedTechniqueFour then
            return savedata.run.checkedTechniqueFour
        else
            savedata.run.checkedTechniqueFour = (mod:AnyInaba() or mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.PARANOIA))
            return savedata.run.checkedTechniqueFour
        end
    end
end

--Lib funcs
local function GetBottomRightNoOffset()
    return game:GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442,286)
end

local function GetBottomLeftNoOffset()
    return Vector(0, GetBottomRightNoOffset().Y)
end

local function GetTopRightNoOffset()
    return Vector(GetBottomRightNoOffset().X, 0)
end

local function GetTopLeftNoOffset()
    return Vector(0, 0)
end

local function GetScreenBottomRight()
    local offset = DeadSeaScrollsMenu.GetHudOffsetSetting()
    local hudOffset = Vector(-offset * 1.6, -offset * 0.6)

    return GetBottomRightNoOffset() + hudOffset
end

local function GetScreenBottomLeft()
    local offset = DeadSeaScrollsMenu.GetHudOffsetSetting()
    local hudOffset = Vector(offset * 2.2, -offset * 1.6)

    return GetBottomLeftNoOffset() + hudOffset
end

local function GetScreenTopRight()
    local offset = DeadSeaScrollsMenu.GetHudOffsetSetting()
    local hudOffset = Vector(-offset * 2.2, offset * 1.2)

    return GetTopRightNoOffset() + hudOffset
end

local function GetScreenTopLeft()
    local offset = DeadSeaScrollsMenu.GetHudOffsetSetting()
    local hudOffset = Vector(offset * 2, offset * 1.2)

    return GetTopLeftNoOffset() + hudOffset
end

local function GetPlayerCorner(ind)
    if ind == 1 then
        return GetScreenTopLeft()
    elseif ind == 2 then
        return GetScreenTopRight()
    elseif ind == 3 then
        return GetScreenBottomLeft()
    else
        return GetScreenBottomRight()
    end
end

local function GetAngleDifference(a1, a2)
    local sub = a1 - a2
    return (sub + 180) % 360 - 180
end

local function InabaLerpAngleDegrees(aStart, aEnd, percent)
    return aStart + GetAngleDifference(aEnd, aStart) * percent
end

function mod:PairAnglesToAngles(anglesA, anglesB)
    local angleDists = {}
    local takenAngles = {}
    for _, angle in ipairs(anglesA) do
        local dists = {}
        local highest, lowest = {ind = nil, dist = nil}, {ind = nil, dist = nil}
        for i, angle2 in ipairs(anglesB) do
            dists[i] = math.abs(GetAngleDifference(angle, angle2))
            if not lowest.dist or lowest.dist > dists[i] then
                lowest.dist = dists[i]
            end
        end

        dists.angle = angle
        dists.lowest = lowest

        local insertInd = #angleDists + 1
        for j, angleDist in ipairs(angleDists) do
            if dists.lowest.dist > angleDist.lowest.dist then
                insertInd = j
            end
        end

        table.insert(angleDists, insertInd, dists)
    end

    local anglePairs = {}
    for _, angleDist in ipairs(angleDists) do
        local lowestNotTaken, lowestDist
        for i, dist in ipairs(angleDist) do
            if not takenAngles[i] and (not lowestDist or dist < lowestDist) then
                lowestNotTaken = i
                lowestDist = dist
            end
        end

        takenAngles[lowestNotTaken] = true
        anglePairs[#anglePairs + 1] = {angle = angleDist.angle, angleind = lowestNotTaken}
    end

    return anglePairs
end

local function getSign(rng)
    local r = rng:RandomInt(2)
    if r == 0 then
        return -1
    else
        return 1
    end
end

---------------------------------------------------------

local function MigraineStartEffect(player)
    sfx:Play(mod.Sounds.MigraineModeOn, 1, 0, false, mod:RandomInt(90,110)/100)

    local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ATTRACT, 10, player.Position, Vector.Zero, player):ToEffect()
    eff.MinRadius = 1
    eff.MaxRadius = 30
    eff.LifeSpan = 10
    eff.Timeout = 10
    eff.SpriteOffset = Vector(0, -15)
    if isPlayerInaba then
        eff.Color = Color(0.3,0.1,0.1,1,0.3,0,0)
    else
        eff.Color = Color(0.4,0.2,0.3,1,0.3,0,0.1)
    end
    eff.Visible = false
    eff:FollowParent(player)
    eff:Update()
    eff.Visible = true
end

local function MigraineEndEffect(player)
    sfx:Play(mod.Sounds.MigraineModeOff, 1, 0, false, mod:RandomInt(90,110)/100)
end

function mod:InabaInit(player)
    local isInaba = mod:isInaba(player)
    local isBinaba = mod:isBinaba(player)
    if isInaba then
        player:GetSprite():Load("gfx/characters/player_inaba.anm2", true)
        player:GetSprite():Play(player:GetSprite():GetDefaultAnimationName(), true)
        player:AddHearts(-2)
    elseif isBinaba then
        player:GetSprite():Load("gfx/characters/player_binaba.anm2", true)
        player:GetSprite():Play(player:GetSprite():GetDefaultAnimationName(), true)
    end
	if isInaba or isBinaba then
        local basedata = mod:GetEntityData(player)
        local data = basedata.ffsavedata
        data = data or {}
        data.Inaba = data.Inaba or {}
        data.Inaba.Power = 100
        data.Inaba.MigraineGauge = 0
    end
end
mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_INIT, mod.InabaInit, mod.PLAYER.INABA)
mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_INIT, mod.InabaInit, mod.PLAYER.BINABA)

mod.InabaWeaponTypeBlacklist = {
	WeaponType.WEAPON_BRIMSTONE,
}
mod.BinabaWeaponTypeBlacklist = {
	WeaponType.WEAPON_SPIRIT_SWORD,
}

function mod:InabaBlockWeaponTypes(player)
    if mod:isEitherInaba(player) then
        local data = mod:GetEntityData(player)
        if not data.InabaBlockedWeaponTypes then
            data.InabaBlockedWeaponTypes = {}
        end

        local blockedWeapon = false
        if mod:isInaba(player) then
            for _, weaponType in pairs(mod.InabaWeaponTypeBlacklist) do
                local hadWeapon = player:HasWeaponType(weaponType)
                data.InabaBlockedWeaponTypes[weaponType] = hadWeapon
                if hadWeapon then
                    player:EnableWeaponType(weaponType, false)
                    blockedWeapon = true
                end
            end
        elseif mod:isBinaba(player) then
            for _, weaponType in pairs(mod.BinabaWeaponTypeBlacklist) do
                local hadWeapon = player:HasWeaponType(weaponType)
                data.InabaBlockedWeaponTypes[weaponType] = hadWeapon
                if hadWeapon then
                    player:EnableWeaponType(weaponType, false)
                    blockedWeapon = true
                end
            end
        end

        if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
            player:EnableWeaponType(WeaponType.WEAPON_FETUS, true)
            player:EnableWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE, false)
        elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE) then
            player:EnableWeaponType(WeaponType.WEAPON_LUDOVICO_TECHNIQUE, true)
            player:EnableWeaponType(WeaponType.WEAPON_TEARS, false)
        elseif mod:isBinaba(player) and player:HasWeaponType(WeaponType.WEAPON_LASER) and player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
            player:EnableWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS, true)
            player:EnableWeaponType(WeaponType.WEAPON_LASER, false)
        elseif mod:isBinaba(player) and player:HasWeaponType(WeaponType.WEAPON_KNIFE) and player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
            player:EnableWeaponType(WeaponType.WEAPON_TECH_X, true)
        elseif mod:isBinaba(player) and player:HasWeaponType(WeaponType.WEAPON_KNIFE) and player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
            player:EnableWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS, true)
        elseif blockedWeapon then
            player:EnableWeaponType(WeaponType.WEAPON_TEARS, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.InabaBlockWeaponTypes, CacheFlag.CACHE_WEAPON)

function mod:InabaHasWeaponType(player, weaponType)
	local data = mod:GetEntityData(player)
	return player:HasWeaponType(weaponType) or (data.InabaBlockedWeaponTypes and data.InabaBlockedWeaponTypes[weaponType])
end

--Sometimes fails for whatever reason?
--I want to be doubly safe.
FiendFolio.AddItemPickupCallback(function(player, added)
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
end, nil, mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM, true)

-- Flat Tears
mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, function(_, player, _, tears)
    if mod:isInaba(player) then
        tears = tears + mod.InabaBal.BaseFlatTearsUp
    elseif mod:isBinaba(player) then
        tears = tears + mod.InabaBal.B_BaseFlatTearsUp
    end

    local data = mod:GetEntityData(player).ffsavedata
    if data and data.Inaba and data.Inaba.MigraineMode then
        tears = tears + (mod:isBinaba(player) and mod.InabaBal.B_MigraineModeFlatTearsUp or mod.InabaBal.MigraineModeFlatTearsUp)
    end

    return tears
end, EvaluateStatStage.FLAT_TEARS)

-- Tears Multiplier
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_STAT, CallbackPriority.LATE, function(_, player, _, tears)
    local data = mod:GetEntityData(player).ffsavedata
    if data and data.Inaba and data.Inaba.MigraineMode then
        return tears * (mod:isBinaba(player) and mod.InabaBal.B_MigraineModeTearsMult or mod.InabaBal.MigraineModeTearsMult)
    end
end, EvaluateStatStage.FLAT_TEARS)

-- Range
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flags)
    local data = mod:GetEntityData(player).ffsavedata
    if data and data.Inaba and data.Inaba.MigraineMode and mod:isBinaba(player) then
        player.TearRange = player.TearRange + mod.InabaBal.B_MigraineModeRangeUp
    end
end, CacheFlag.CACHE_RANGE)

-- Familiars
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, -1, function(_, player, flags)
    local basedata = mod:GetEntityData(player)
    local data = basedata.ffsavedata
    if not data or (data and not data.RunEffects) then
        return
    end

    data.Inaba = data.Inaba or {}
    data.Inaba.Power = data.Inaba.Power or 100

    local satCount = 0
    local shadowSatCount = 0
    local playerDeservesASat = data.Inaba.SoulOfInabaActive or player:HasCollectible(mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM) or basedata.binabaOcularSpectrumForce
    if mod:isEitherInaba(player) or playerDeservesASat then
        data.Inaba.PastMult = data.Inaba.PastMult or 1
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
            satCount = math.floor(data.Inaba.Power / 50)
        else
            satCount = math.floor(data.Inaba.Power / 100)
        end
        satCount = data.Inaba.Power / 100
        local mult = 1
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
            mult = mult * 2
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
            mult = mult / 1.5
        end
        satCount = math.max(math.floor(satCount * mult), 1)
        if data.Inaba.SoulOfInabaActive then
            satCount = satCount + 1
        end
        if mod:playerHasBirthcake(player) and mod:isInaba(player) then
            satCount = satCount + 1
        end
        if mult ~= data.Inaba.PastMult then
            data.Inaba.PastMult = mult
        end
    end
    if mod:isBinaba(player) then
        satCount = 1
        if data.Inaba.ocularSpectrumSats then
            satCount = 2
            if mod.InabaBal.B_OcularSpectrumBuffGivesExtraSat and (data.Inaba.ocularSpectrumBuff or 0) > 0 then
                satCount = satCount + 1
            end
            if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
                satCount = satCount * 2
            end
        elseif data.Inaba.SoulOfInabaActive then
            satCount = 2
        end

        -- Spawn a shadow satellite if one is placed
        if basedata.shadowGazePosition ~= nil then
            shadowSatCount = 1
        end
    elseif (player:HasCollectible(mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM) or basedata.binabaOcularSpectrumForce) and data.Inaba.ocularSpectrumSats then
        satCount = math.ceil(2,satCount)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
            satCount = satCount * 2
        end
    elseif mod:isInaba(player) or playerDeservesASat then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
            data.Inaba.EpicFetusSatCount = satCount
            satCount = 0
        else
            data.Inaba.EpicFetusSatCount = 0
        end
    end

    player:CheckFamiliar(inabaSatellite, satCount, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM), nil, 0)
    player:CheckFamiliar(inabaSatellite, shadowSatCount, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM), nil, mod.InabaBal.ShadowSatelliteSub)


    local isolateds = Isaac.FindByType(3, mod.ITEM.FAMILIAR.ISOLATED)
    for _, isolated in pairs(isolateds) do
        mod:GetEntityData(isolated).primeSubject = false
    end
end, CacheFlag.CACHE_FAMILIARS)

-- Damage Multiplier
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player, flags)
    local basedata = mod:GetEntityData(player)
    local data = basedata.ffsavedata
    if not data or (data and not data.RunEffects) then
        return
    end

    data.Inaba = data.Inaba or {}
    data.Inaba.Power = data.Inaba.Power or 100

    if mod:isInaba(player) then
        player.Damage = player.Damage * mod.InabaBal.BaseDamageMulti
    end
    if mod:isBinaba(player) then
        player.Damage = player.Damage * mod.InabaBal.B_BaseDamageMulti
    end
    if data and data.Inaba.MigraineMode then
        player.Damage = player.Damage * (mod:isBinaba(player) and mod.InabaBal.B_MigraineModeDamageMulti or mod.InabaBal.MigraineModeDamageMulti)
    end
end, CacheFlag.CACHE_DAMAGE)
--Post anything else
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, 200, function(_, player, flags)
    if mod:isBinaba(player) then
        local basedata = mod:GetEntityData(player)
        local data = basedata.ffsavedata
        if not data or (data and not data.RunEffects) then
            return
        end

        data.Inaba = data.Inaba or {}
        data.Inaba.Power = data.Inaba.Power or 100

        local power = math.floor(data.Inaba.Power / 100) * 100
        power = (power/100) - 1
        player.Damage = player.Damage + mod.InabaBal.B_PowerDamageBonus * power
    end
end, CacheFlag.CACHE_DAMAGE)

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, math.huge, function(_, player, flags)
    mod:rabbitsFootCache(player, flags)
end)

local function AddPower(player, count, set)
    local basedata = mod:GetEntityData(player)
    local data = basedata.ffsavedata
    local save = data.Inaba
    save.Power = save.Power or 100

    if count > 0 then
        count = count * mod.GetPakChoiMultiplier(player) -- Power pips charge faster
    end

    local oldPow = save.Power
    local newPow = save.Power + count
    if set then
        newPow = count
    end

    save.Power = math.max(100, math.min(newPow, 400))

    if mod:isBinaba(player) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    end

    data.Inaba.PowerGainedSinceLastHit = data.Inaba.PowerGainedSinceLastHit or 0
    data.Inaba.PowerGainedSinceLastHit = data.Inaba.PowerGainedSinceLastHit + (save.Power - oldPow)
end

local function AddMigraineGauge(player, count, set, bypassMigraineMode)
    local basedata = mod:GetEntityData(player)
    local data = basedata.ffsavedata
    local save = data.Inaba
    save.MigraineGauge = save.MigraineGauge or 0

    if count > 0 then
        count = count * mod.GetPakChoiMultiplier(player) -- Gauge charges faster
    elseif count < 0 then
        count = count / mod.GetPakChoiMultiplier(player) -- Gauge lasts longer once full
    end

    if mod:isInaba(player) and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        bypassMigraineMode = true
    end

    if save.MigraineMode and not bypassMigraineMode then
        return
    end

    local newGauge = save.MigraineGauge + count
    if set then
        newGauge = count
    end

    save.MigraineGauge = math.max(0, math.min(newGauge, mod.InabaBal.MigraineCap))
end

--Now this is bizarre
local itemsThatMakeYouFireWithOneEye = {
    CollectibleType.COLLECTIBLE_DR_FETUS,           --052
    CollectibleType.COLLECTIBLE_TECHNOLOGY,         --068
    CollectibleType.COLLECTIBLE_MOMS_KNIFE,         --114
    CollectibleType.COLLECTIBLE_BRIMSTONE,          --118
    CollectibleType.COLLECTIBLE_EPIC_FETUS,         --168
    CollectibleType.COLLECTIBLE_MONSTROS_LUNG,      --229
    CollectibleType.COLLECTIBLE_CURSED_EYE,         --319
    CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE, --329
    CollectibleType.COLLECTIBLE_TECH_X,             --395
    CollectibleType.COLLECTIBLE_LEAD_PENCIL,        --444
    CollectibleType.COLLECTIBLE_SPIRIT_SWORD,       --579
    CollectibleType.COLLECTIBLE_C_SECTION,          --678
    CollectibleType.COLLECTIBLE_STAPLER,            --708
}

local function ifPlayerHasItemThatAutomatesOneEyeDamage(player)
    --only binaba, so not gonna worry about cain/azazel/forgotten
    for i = 1, #itemsThatMakeYouFireWithOneEye do
        if player:HasCollectible(itemsThatMakeYouFireWithOneEye[i]) then
            return true
        end
    end
end

-- Sets `save.SecondEyeShot` with info to help account for right/left eye effects for the next shot(s) fired by Binaba.
local function CheckBinabaSecondEyeShot(player, save)
    if save.SecondEyeShot then
        save.SecondEyeShot = nil
    elseif not ifPlayerHasItemThatAutomatesOneEyeDamage(player) then
        local damagemult = 1
        local flatdamage = 0
        local color = nil
        --Multiplier addition
        if player:HasCollectible(CollectibleType.COLLECTIBLE_PEEPER) then
            damagemult = damagemult * 1.35
        end
        if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_SCOOPER) then
            damagemult = damagemult * 1.35
        end
        --Flat damage addition
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_CLOT) then
            flatdamage = flatdamage + 1
            color = Color.Lerp(Color(), Color(0.8,0.01,0.01,1,0.5,0,0), 0.75)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CHEMICAL_PEEL) then
            flatdamage = flatdamage + 2
            color = Color.Lerp(Color(), Color(0.8,0.01,0.01,1,0.5,0,0), 0.75)
        end
        save.SecondEyeShot = {
            DamageMult = damagemult,
            FlatDamage = flatdamage,
            Color = color,
        }
    end
end

-- Additional multiplier for Binaba's tears related to certain item effects.
-- May not apply to all damage sourced from her satellite.
local function calculateBinabaMultiplier(player, save)
    local binabaMulti = 1
    -- Ocular spectrum
    if save.ocularSpectrumSats then
        binabaMulti = binabaMulti * ((save.ocularSpectrumBuff or 0) > 0 and mod.InabaBal.B_OcularSpectrumBuffDamageMult or mod.InabaBal.B_OcularSpectrumDamageMult)
    end
    -- Second eye shots
    if save.SecondEyeShot then
        binabaMulti = binabaMulti * save.SecondEyeShot.DamageMult
        if save.SecondEyeShot.FlatDamage > 0 then
            binabaMulti = binabaMulti + ((player.Damage + save.SecondEyeShot.FlatDamage) / player.Damage - 1)
        end
    end
    --Choco milk
    if save.storedChocolateMilkChargePercent then
        binabaMulti = binabaMulti * 5 * save.storedChocolateMilkChargePercent
    end
    return binabaMulti
end

function mod:GetBinabaCuttingGazeChargeTime(player)
	local t = mod.InabaBal.B_CuttingFlatChargeTime + (player.MaxFireDelay + 1) * mod.InabaBal.B_CuttingPlayerChargeTimeMult
	local data = mod:GetEntityData(player).ffsavedata
	if data and data.Inaba and data.Inaba.MigraineMode then
		t = t * mod.InabaBal.B_CuttingMigraineChargeTimeMult
	end
	return t
end

function mod:GetBinabaShadowGazeChargeTime(player)
	return mod.InabaBal.ShadowSatelliteTimeExtra
end

-- accounts for binaba, inaba, and shadow satellite
local LUM_R, LUM_G, LUM_B = 0.212671, 0.715160, 0.072169 -- luminance factors used for colorize operation
local function applyTearcolor(basecolor, tearcolor)
	local tearcolorize = tearcolor:GetColorize()
	local tearRT, tearGT, tearBT  = tearcolor.R, tearcolor.G, tearcolor.B
	local tearRO, tearGO, tearBO = tearcolor.RO, tearcolor.GO, tearcolor.BO
	local tearRC, tearGC, tearBC, tearAC = tearcolorize.R, tearcolorize.G, tearcolorize.B, tearcolorize.A

	local colorize = basecolor.R * tearRT * LUM_R + basecolor.G * tearGT * LUM_G + basecolor.B * tearBT * LUM_B
	return {R = math.min(math.max(0, basecolor.R * tearRT * (1 - tearAC) + colorize * tearRC * tearAC + tearRO * 255), 255),
	        G = math.min(math.max(0, basecolor.G * tearGT * (1 - tearAC) + colorize * tearGC * tearAC + tearGO * 255), 255),
	        B = math.min(math.max(0, basecolor.B * tearBT * (1 - tearAC) + colorize * tearBC * tearAC + tearBO * 255), 255)}
end

local function convertToHSV(rgb)
	local low = math.min(rgb.R, rgb.G, rgb.B)
	local high = math.max(rgb.R, rgb.G, rgb.B)
	local delta = high - low

	local hsv = {V = high}
	hsv.S = ((high <= 0) and 0) or (delta / high)

	if delta == 0.0 then
		hsv.H = 0.0
	elseif high == rgb.R then
		hsv.H = (rgb.G - rgb.B) / delta
	elseif high == rgb.G then
		hsv.H = (rgb.B - rgb.G) / delta + 2
	else
		hsv.H = (rgb.R - rgb.G) / delta + 4
	end

	hsv.H = (hsv.H % 6) * 60
	return hsv;
end

local function convertToRGB(hsv)
	if hsv.S < 0.0001 then
		return {R = hsv.V, G = hsv.V, B = hsv.V}
	end

	local j = hsv.S * hsv.V
	local k = j * (1 - math.abs(((hsv.H / 60) % 2) - 1))
	local l = hsv.V - j

	if hsv.H < 60 then
		return {R = j + l, G = k + l, B = l}
	elseif hsv.H < 120 then
		return {R = k + l, G = j + l, B = l}
	elseif hsv.H < 180 then
		return {R = l, G = j + l, B = k + l}
	elseif hsv.H < 240 then
		return {R = l, G = k + l, B = j + l}
	elseif hsv.H < 300 then
		return {R = k + l, G = l, B = j + l}
	else
		return {R = j + l, G = l, B = k + l}
	end
end

local function getColorizeAndOffset(a, b, c, d)
	local x, y = 0, 0
	local xy, x2 = 0, 0
	local n = 0
	if a and a.Y > 0 then
		x = x + a.X
		y = y + a.Y
		xy = xy + a.X * a.Y
		x2 = x2 + a.X * a.X
		n = n + 1
	end
	if b and b.Y > 0 then
		x = x + b.X
		y = y + b.Y
		xy = xy + b.X * b.Y
		x2 = x2 + b.X * b.X
		n = n + 1
	end
	if c and c.Y > 0 then
		x = x + c.X
		y = y + c.Y
		xy = xy + c.X * c.Y
		x2 = x2 + c.X * c.X
		n = n + 1
	end
	if d and d.Y > 0 then
		x = x + d.X
		y = y + d.Y
		xy = xy + d.X * d.Y
		x2 = x2 + d.X * d.X
		n = n + 1
	end

	if n == 0 then
		return 0, 0
	end

	local colorize = (n * xy - x * y) / (n * x2 - x * x)
	local offset = (y - colorize * x) / n
	return colorize, offset
end

function mod:GetInabaTearColor(itsBinaba, satellite, migraine, tearcolor)
    local baseA = {R = 210, G = 101, B = 6}
	local baseB = {R = 202, G = 4, B = 4}
	local baseC = {R = 118, G = 0, B = 0}
	local baseD = {R = 45, G = 0, B = 0}

	local baseAV, baseBV, baseCV, baseDV = 82, 79, 46, 17
	local baseAC, baseBC, baseCC, baseDC = 255, 243, 114, 2
    if satellite and satellite.SubType == mod.InabaBal.ShadowSatelliteSub then
        return mod.InabaBal.Shadow_SatelliteTearColor
    elseif itsBinaba then
        baseA = {R = 171, G = 80, B = 94}
		baseB = {R = 139, G = 40, B = 75}
		baseC = {R = 81, G = 0, B = 41}
		baseD = {R = 32, G = 0, B = 13}

		baseAV, baseBV, baseCV, baseDV = 67, 54, 31, 12
		baseAC, baseBC, baseCC, baseDC = 255, 196, 91, 2
	end

	local hsvA = convertToHSV(applyTearcolor(baseA, tearcolor))
	local hsvB = convertToHSV(applyTearcolor(baseB, tearcolor))
	local hsvC = convertToHSV(applyTearcolor(baseC, tearcolor))
	local hsvD = convertToHSV(applyTearcolor(baseD, tearcolor))

	if migraine and itsBinaba then
		local averHue = ((hsvA.H + hsvB.H + hsvC.H + hsvD.H) / 4) % 360
		local hueShiftMult = math.max(0, math.abs(180 - averHue) * -1/120 + 1) + 1
		local hueShift = (math.random() * 36 - 18) * hueShiftMult
		hsvA.H = (hsvA.H + hueShift) % 360
		hsvB.H = (hsvB.H + hueShift) % 360
		hsvC.H = (hsvC.H + hueShift) % 360
		hsvD.H = (hsvD.H + hueShift) % 360

		local satShift = math.random() * 0.05 - 0.025
		hsvA.S = math.max(0, math.min(hsvA.S + satShift, 1))
		hsvB.S = math.max(0, math.min(hsvB.S + satShift, 1))
		hsvC.S = math.max(0, math.min(hsvC.S + satShift, 1))
		hsvD.S = math.max(0, math.min(hsvD.S + satShift, 1))

		local valShift = math.random() * 38.25 - 19.125
		hsvA.V = math.max(0, math.min(hsvA.V + valShift, 255))
		hsvB.V = math.max(0, math.min(hsvB.V + valShift, 255))
		hsvC.V = math.max(0, math.min(hsvC.V + valShift, 255))
		hsvD.V = math.max(0, math.min(hsvD.V + valShift, 255))
	end
	if hsvD.V > hsvA.V then
		hsvA.V = hsvA.V * baseDV / baseAV
		hsvB.V = hsvA.V * baseCV / baseAV
		hsvC.V = hsvA.V * baseBV / baseAV
	else
		hsvB.V = hsvA.V * baseBV / baseAV
		hsvC.V = hsvA.V * baseCV / baseAV
		hsvD.V = hsvA.V * baseDV / baseAV
	end

	local targetA = convertToRGB(hsvA)
	local targetB = convertToRGB(hsvB)
	local targetC = convertToRGB(hsvC)
	local targetD = convertToRGB(hsvD)

	local colorRC, colorRO = getColorizeAndOffset(
		{X = baseAC, Y = targetA.R},
		{X = baseBC, Y = targetB.R},
		{X = baseCC, Y = targetC.R},
		{X = baseDC, Y = targetD.R}
	)
	local colorGC, colorGO = getColorizeAndOffset(
		{X = baseAC, Y = targetA.G},
		{X = baseBC, Y = targetB.G},
		{X = baseCC, Y = targetC.G},
		{X = baseDC, Y = targetD.G}
	)
	local colorBC, colorBO = getColorizeAndOffset(
		{X = baseAC, Y = targetA.B},
		{X = baseBC, Y = targetB.B},
		{X = baseCC, Y = targetC.B},
		{X = baseDC, Y = targetD.B}
	)
	return Color(1,1,1,tearcolor.A,colorRO/255,colorGO/255,colorBO/255,colorRC,colorGC,colorBC,1), ((hsvA.H + hsvB.H + hsvC.H + hsvD.H) / 4) % 360
end

function mod:GetInabaLaserColor(itsBinaba, satellite, migraine, lasercolor)
    local baseA = {R = 202, G = 4, B = 4}
	local baseB = {R = 137, G = 2, B = 2}

	local baseAV, baseBV = 79, 54
    if satellite and satellite.SubType == mod.InabaBal.ShadowSatelliteSub then
        return mod.InabaBal.Shadow_SatelliteTearColor
    elseif itsBinaba then
		baseA = {R = 139, G = 40, B = 75}
		baseB = {R = 94, G = 27, B = 51}

		baseAV, baseBV = 54, 36
	end

	local hsvA = convertToHSV(applyTearcolor(baseA, lasercolor))
	local hsvB = convertToHSV(applyTearcolor(baseB, lasercolor))

	if migraine and itsBinaba then
		local hueShift = math.random() * 36 - 18
		hsvA.H = (hsvA.H + hueShift) % 360
		hsvB.H = (hsvB.H + hueShift) % 360

		local satShift = math.random() * 0.05 - 0.025
		hsvA.S = math.max(0, math.min(hsvA.S + satShift, 1))
		hsvB.S = math.max(0, math.min(hsvB.S + satShift, 1))

		local valShift = math.random() * 38.25 - 19.125
		hsvA.V = math.max(0, math.min(hsvA.V + valShift, 255))
		hsvB.V = math.max(0, math.min(hsvB.V + valShift, 255))
	end
	if hsvB.V > hsvA.V then
		hsvA.V = hsvA.V * baseBV / baseAV
	else
		hsvB.V = hsvA.V * baseBV / baseAV
	end

	local targetA = convertToRGB(hsvA)
	local targetB = convertToRGB(hsvB)

	local colorRC, colorRO = getColorizeAndOffset(
		{X = 54, Y = targetA.R},
		{X = 37, Y = targetB.R}
	)
	local colorGC, colorGO = getColorizeAndOffset(
		{X = 54, Y = targetA.G},
		{X = 37, Y = targetB.G}
	)
	local colorBC, colorBO = getColorizeAndOffset(
		{X = 54, Y = targetA.B},
		{X = 37, Y = targetB.B}
	)
	return Color(1,1,1,lasercolor.A,colorRO/255,colorGO/255,colorBO/255,colorRC,colorGC,colorBC,1)
end

function mod:FireSatelliteMonstroTearBurst(player, satellite, burstPos, burstVel, numTears, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
    local tears = {}

    local anabaMigraine = not itsBinaba and migraine

    for _, tearInfo in ipairs(mod:GetPlayerMonstroBurstInfo(player, burstPos, burstVel, numTears, true)) do
        local tear = mod:FireSatelliteTear(player, satellite, tearInfo.Pos, tearInfo.Vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)

        if anabaMigraine then
            tear.FallingSpeed = tear.FallingSpeed * 0.3
            tear.Scale = tear.Scale + 0.5
        else
            tear.FallingAcceleration = tearInfo.FallingAcceleration
            tear.FallingSpeed = tearInfo.FallingSpeed
            tear.Scale = math.max(tear.Scale * tearInfo.ScaleMult, 0.01)
        end
        tear:ResetSpriteScale()

        table.insert(tears, tear)
    end

    return tears
end

-- Binaba: Try to mimic Monstro's Lung + Dr Fetus accurately
-- Inaba: Just do your own thing to make hurting yourself less likely
function mod:FireSatelliteMonstroBombBurst(player, satellite, burstPos, burstVel, numBombs, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
    local bombs = {}

    if itsBinaba then
        for _, bombInfo in ipairs(mod:GetMonstroBombBurstInfo(burstPos, burstVel, numBombs)) do
            local bomb = mod:FireSatelliteBomb(player, satellite, bombInfo.Pos, bombInfo.Vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
            bomb.PositionOffset.Y = bombInfo.Height
            bomb:SetFallSpeed(bombInfo.FallSpeed)
            bomb:SetFallAcceleration(bombInfo.FallAcceleration)
            bomb:SetExplosionCountdown(bombInfo.ExplosionCountdown)
            bomb.RadiusMultiplier = bomb.RadiusMultiplier * bombInfo.ScaleMult
            bomb:SetScale(bomb:GetScale() * bombInfo.ScaleMult)
            bomb:SetLoadCostumes(true)

            table.insert(bombs, bomb)
        end
    else
        for i=1, (numBombs or 5) do
            local bombVel
            if migraine then
                bombVel = burstVel:Resized(player.ShotSpeed * 10)
            else
                bombVel = burstVel:Resized(player.ShotSpeed * 7.5 * mod:RandomFloat(0.8, 1.2)):Rotated(mod:RandomInt(-15, 15))
            end
            local bomb = mod:FireSatelliteBomb(player, satellite, burstPos, bombVel, save, migraine, damagemulti, itsBinaba, mod.nilvector)
            bomb.PositionOffset.Y = mod:RandomInt(-4, -8)

            local heightOffset = bomb.PositionOffset.Y
            local speed = bombVel:Length()
            local range = migraine and (speed * 5 * i) or (speed * 15)
            local maxHeight = range / 3
            local travelTime = range / speed
            if not migraine then
                maxHeight = maxHeight * mod:RandomFloat(0.8, 1.2)
                travelTime = travelTime * mod:RandomFloat(0.8, 1.2)
            end
            local fallSpeed, fallAccel = mod:CalculateFallSpeedAccel(heightOffset, maxHeight, travelTime)
            bomb:SetFallAcceleration(fallAccel)
            bomb:SetFallSpeed(fallSpeed)
            bomb:SetExplosionCountdown(math.ceil(travelTime) + 1)
            bomb.RadiusMultiplier = 0.35 + (migraine and (0.1*i) or 0)
            local scaleMult = mod:RandomFloat(0.4, 0.75)
            bomb:SetScale(mod:Lerp(scaleMult, bomb:GetScale(), 0.25) + (migraine and (0.05*i) or 0))
            bomb:SetLoadCostumes(true)

            table.insert(bombs, bomb)
        end
    end

    return bombs
end

function mod:FireSatelliteMonstroLaserBurst(player, satellite, burstPos, burstDir, numLasers, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
    local lasers = {}
    burstDir = burstDir:Normalized()

    for _, laserInfo in ipairs(mod:GetMonstroLaserBurstInfo(burstPos, burstDir, numLasers)) do
        local laser = mod:FireSatelliteLaser(player, satellite, laserInfo.Pos, laserInfo.Dir, laserInfo.Dir, save, migraine, damagemulti, itsBinaba, decapScissorOffset)

        laser:SetScale(laser:GetScale() * laserInfo.ScaleMult)
        laser:ResetSpriteScale()

        if laserInfo.RgonUpdated then
            laser.MaxDistance = laserInfo.ChainSegmentDistance
            laser:SetNumChainedLasers(laserInfo.NumChainedLasers)
            laser:SetInitSound(SoundEffect.SOUND_NULL)
        end

        table.insert(lasers, laser)
    end

    sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST)

    return lasers
end

--This function adds the whole C Section relevant tearflags ugh
function mod:tryAppendCSection(player, tear)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
        local pType = player:GetPlayerType()
        tear:AddTearFlags(TearFlags.TEAR_FETUS)
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SWORD) then
            tear:AddTearFlags(TearFlags.TEAR_FETUS_SWORD)
        end
        if pType == PlayerType.PLAYER_THEFORGOTTEN or pType == PlayerType.PLAYER_THEFORGOTTEN_B then
            tear:AddTearFlags(TearFlags.TEAR_FETUS_BONE)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
            tear:AddTearFlags(TearFlags.TEAR_FETUS_KNIFE)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then
            tear:AddTearFlags(TearFlags.TEAR_FETUS_TECHX)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
            tear:AddTearFlags(TearFlags.TEAR_FETUS_TECH)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
            tear:AddTearFlags(TearFlags.TEAR_FETUS_BRIMSTONE)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
            tear:AddTearFlags(TearFlags.TEAR_FETUS_BOMBER)
        end
    end
end

function mod:applyBinabaPostFireTear(player, tear, save, checkCSection)
    --C Section............................
    if checkCSection then
        mod:tryAppendCSection(player, tear)
    end
end

local mindRazorFlag = TearFlagsLib.RegisterTearFlag("MIND_RAZOR")
function mod:applySatellitePostFireTear(player, tear, data, save, migraine, itsBinaba, denyCSection, satellite)
    local data = data or mod:GetEntityData(tear)

    if satellite and satellite.SubType == mod.InabaBal.ShadowSatelliteSub then
        tear.Color = mod.InabaBal.Shadow_SatelliteTearColor
    elseif itsBinaba or save.ocularSpectrumSats then
        tear.Color = mod:GetInabaTearColor(itsBinaba, satellite, migraine, tear.Color)
        if save.ocularSpectrumSats then
            TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.YIN_YANG)
            if (save.ocularSpectrumBuff or 0) > 0 then
                tear:SetDeadEyeIntensity(tear:GetDeadEyeIntensity() + 0.2)
                TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.YIN_YANG, {Strength = mod.InabaBal.B_OcularSpectrumBuffHomingStrength})
                --tear:AddTearFlags(TearFlags.TEAR_HOMING)
            else
                TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.YIN_YANG, {Strength = mod.InabaBal.B_OcularSpectrumHomingStrength})
            end
        end
    else
        tear.Color = mod:GetInabaTearColor(itsBinaba, satellite, migraine, tear.Color)
    end

	local isFetus = itsBinaba and (not denyCSection) and player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) and tear.Variant ~= TearVariant.FETUS
    if migraine then
        if itsBinaba then
            -- Binaba Migraine Mode
            tear.FallingSpeed = mod:RandomFloat(tear.FallingSpeed * 0.8, tear.FallingSpeed * 1.2)
            tear.FallingAcceleration = mod:RandomFloat(tear.FallingAcceleration * 0.8, tear.FallingAcceleration * 1.2)
            tear.Height = mod:RandomFloat(tear.Height * 0.9, tear.Height * 1.1)
            tear.Scale = tear.Scale * mod:RandomFloat(0.9, 1.1)
			tear:ResetSpriteScale()

            --Ipecac
            --if tear:HasTearFlags(TearFlags.TEAR_EXPLOSIVE) then
                --tear:ClearTearFlags(TearFlags.TEAR_EXPLOSIVE)
            --end

			if not isFetus then
				local hasBirthcake, birthcakeMult = mod:playerHasBirthcake(player)
				if hasBirthcake then
					if not tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
						TearFlagsLib.AddTearFlags(tear, mindRazorFlag)
						TearFlagsLib.SetTearFlagParams(tear, mindRazorFlag, {BirthcakeMult = birthcakeMult})
					end
					tear.Scale = (tear.Scale + mod.InabaBal.MigraineTearScaleFlat) * mod.InabaBal.MigraineTearScaleMult
					tear:AddTearFlags(TearFlags.TEAR_PIERCING)
					if tear.Variant ~= TearVariant.PUPULA then
						mod:changeTearVariant(tear, TearVariant.PUPULA)
					end
				end
			end
        else
            -- Inaba Migraine Mode
            if mod.InabaBal.MigrainePiercePenalty ~= 1.0 and not tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
                TearFlagsLib.AddTearFlags(tear, mindRazorFlag)
				TearFlagsLib.SetTearFlagParams(tear, mindRazorFlag, {PowerLevel = math.floor(save.Power / 100)})
            end
            tear.Scale = (tear.Scale + mod.InabaBal.MigraineTearScaleFlat) * mod.InabaBal.MigraineTearScaleMult
            for i = 1, #mod.InabaBal.TearFlagGroups.MigraineModeAdditions do
                tear:AddTearFlags(mod.InabaBal.TearFlagGroups.MigraineModeAdditions[i])
            end
            if tear.Variant ~= TearVariant.PUPULA then
                mod:changeTearVariant(tear, TearVariant.PUPULA)
            end
        end
    else
        -- Inaba
        local tearVariant = tear:HasTearFlags(TearFlags.TEAR_PIERCING) and TearVariant.CUPID_BLUE or TearVariant.BLUE
        if tear.Variant ~= tearVariant then
            mod:changeTearVariant(tear, tearVariant)
        end
    end

	if itsBinaba then
        -- Binaba
        if isFetus then
            tear:ChangeVariant(TearVariant.FETUS)
        end
	end
end

function mod:FireSatelliteTear(player, satellite, satFirePos, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
    if itsBinaba then
		local wasBlockingStye = player:IsCollectibleBlocked(CollectibleType.COLLECTIBLE_STYE)
		if save.SecondEyeShot ~= nil then player:BlockCollectible(CollectibleType.COLLECTIBLE_STYE) end
        tear = player:FireTear(satFirePos - decapScissorOffset, vel, true, false, true, player, damagemulti)
        if not wasBlockingStye then player:UnblockCollectible(CollectibleType.COLLECTIBLE_STYE) end
		mod:applyBinabaPostFireTear(player, tear, save, true)
		tear.Color = (save.SecondEyeShot and save.SecondEyeShot.Color) or tear.Color
	else
        local allowedTearflags = 0
        for i = 1, #mod.InabaBal.TearFlagGroups.SatelliteAllowed do
            allowedTearflags = allowedTearflags | (player.TearFlags & mod.InabaBal.TearFlagGroups.SatelliteAllowed[i])
        end
        tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, satFirePos, vel, player):ToTear()
        tear.CollisionDamage = player.Damage * damagemulti
        tear:AddTearFlags(allowedTearflags)
        tear.Scale = (0.55 + math.sqrt(tear.CollisionDamage) * 0.23 + tear.CollisionDamage / 100)
        tear.FallingAcceleration = player.TearFallingAcceleration
        tear.FallingSpeed = -player.TearFallingSpeed
        tear.Height = player.TearHeight
        if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
            tear:SetKnockbackMultiplier(0)
        else
            tear:SetKnockbackMultiplier(mod.InabaBal.SatelliteKnockbackMulti)
        end
		tear.Color = player.TearColor
        Isaac.RunCallback("SATELLITE_POST_FIRE_TEAR", player, tear)
    end
    local data = mod:GetEntityData(tear)
    mod:applySatellitePostFireTear(player, tear, data, save, migraine, itsBinaba, nil, satellite)

    data.inabaSatelliteTear = true
    return tear
end

function mod:FireSatelliteBomb(player, satellite, satFirePos, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
    local bomb
    if itsBinaba then
		local wasBlockingStye = player:IsCollectibleBlocked(CollectibleType.COLLECTIBLE_STYE)
		if save.SecondEyeShot ~= nil then player:BlockCollectible(CollectibleType.COLLECTIBLE_STYE) end
        bomb = player:FireBomb(satFirePos - decapScissorOffset, vel, player)
		if not wasBlockingStye then player:UnblockCollectible(CollectibleType.COLLECTIBLE_STYE) end
        bomb.ExplosionDamage = bomb.ExplosionDamage * damagemulti
        if save.ocularSpectrumSats then
            bomb.RadiusMultiplier = bomb.RadiusMultiplier * 0.5
        end
		bomb.Color = (save.SecondEyeShot and save.SecondEyeShot.Color) or bomb.Color
        bomb.Color = mod:GetInabaTearColor(itsBinaba, satellite, migraine, bomb.Color)

		local hasBirthcake, birthcakeMult = mod:playerHasBirthcake(player)
		if migraine and hasBirthcake then
			if not bomb:HasTearFlags(TearFlags.TEAR_PIERCING) then
				local data = mod:GetEntityData(bomb)
				TearFlagsLib.AddTearFlags(bomb, mindRazorFlag)
				TearFlagsLib.SetTearFlagParams(bomb, mindRazorFlag, {BirthcakeMult = birthcakeMult})
			end
			bomb:AddTearFlags(TearFlags.TEAR_PIERCING)
			bomb.CollisionDamage = player.Damage * 2.5 * damagemulti
		end
    else
        bomb = Isaac.Spawn(4,14,0,satFirePos, vel, satellite):ToBomb()
        bomb.ExplosionDamage = player.Damage * 10 * damagemulti
        bomb.RadiusMultiplier = 0.5
        bomb:SetScale(0.75)
        bomb:SetExplosionCountdown(30)
        bomb.IsFetus = true
        bomb:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        if migraine then
            for i = 1, #mod.InabaBal.TearFlagGroups.MigraineModeAdditions do
                bomb:AddTearFlags(mod.InabaBal.TearFlagGroups.MigraineModeAdditions[i])
            end
			bomb.CollisionDamage = player.Damage * 2.5 * damagemulti
        end
        bomb.Color = mod:GetInabaTearColor(itsBinaba, satellite, migraine, player.TearColor)
    end

    bomb:SetLoadCostumes(true)
    mod:GetEntityData(bomb).inabaSatelliteTear = true
    return bomb
end

-- Prevent damage from A-side satellite bombs
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, function(_, player, damage, flags, source, countdown)
    if source.Type == EntityType.ENTITY_BOMB and source.SpawnerType == EntityType.ENTITY_FAMILIAR and source.SpawnerVariant == inabaSatellite then
        return false
    end
end)

function mod:FireSatelliteLaser(player, satellite, satFirePos, dir, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
    if itsBinaba then
        local laserInwardness = 0 --Sink it inside the eye a bit (disabled for now, seems OK with tweaks to Position and offsets?)
        local followerCheck = player
        local followerEffectiveness = 10
        --Check whether it should respond to player movement
        local d = mod:GetEntityData(player)
        if d.binabaCuttingGazeHoldPoint then
            followerCheck = satellite
            followerEffectiveness = 0
        elseif d.inabaLudoTear and d.inabaLudoTear:Exists() then
            followerCheck = d.inabaLudoTear
        end
        --Basically, if you're firing in the same axis you're moving, make sure it accepts it
        --Done because firing upwards and moving to the side made it weirdly offset
        local velEffectiveness = math.abs(dir:Normalized():Dot(followerCheck.Velocity:Normalized()))
        -- decapScissorOffset doesn't need to be applied here actually since we re-set the laser's position immediately after firing it
        local firePos = satFirePos + -vel:Resized(laserInwardness) + (followerCheck.Velocity * followerEffectiveness * velEffectiveness)
        local laser = player:FireTechLaser(firePos, LaserOffset.LASER_TRACTOR_BEAM_OFFSET, vel, false, true, player, damagemulti)
        laser.Position = firePos
        laser.Parent = satellite
        laser.ParentOffset = mod.nilvector
        laser.PositionOffset = Vector(0, -20)
        laser.MaxDistance = player.TearRange + laserInwardness --Range plus how much it's sunk in
        if save.ocularSpectrumSats then
            laser.MaxDistance = laser.MaxDistance * 0.5
        end
        laser.DepthOffset = -10 --So it's a little behind the eye
        laser.Color = mod:GetInabaLaserColor(itsBinaba, satellite, migraine, laser.Color)
        return laser
    else
        local newVel = vel
        if migraine then
            local targPos = player.Position + dir:Resized(player.TearRange * 0.5)
            newVel = targPos - satFirePos
        end
        local laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, satFirePos, newVel:GetAngleDegrees(), 1, Vector(0, -20), player):ToLaser()
        laser.Parent = satellite
        laser.CollisionDamage = player.Damage * damagemulti
        laser.MaxDistance = player.TearRange * 0.75
        local allowedTearflags = 0
        for i = 1, #mod.InabaBal.TearFlagGroups.SatelliteAllowed do
            allowedTearflags = allowedTearflags | (player.TearFlags & mod.InabaBal.TearFlagGroups.SatelliteAllowed[i])
        end
        laser:AddTearFlags(allowedTearflags)
        laser.Color = mod:GetInabaLaserColor(itsBinaba, satellite, migraine, player.LaserColor)
        return laser
    end
end

function mod:FireSatelliteTechX(player, satellite, satFirePos, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
    local laser = nil
    if itsBinaba then
        local powerScale = math.min(math.max(0, (save.Power - 100) / 300), 1)
        local radius = 20
        local scale = 1 + 0.5 * powerScale
        if save.storedTechXChargePercent then
            radius = mod:Lerp(15, 55, save.storedTechXChargePercent)
            if migraine then
                radius = radius * mod:RandomFloat(0.6, 1.0)
            end
        end
        laser = player:FireTechXLaser(satFirePos, vel, radius, player, damagemulti)
        laser:SetScale(laser:GetScale() * scale)
    else
        laser = EntityLaser.ShootAngle(LaserVariant.THIN_RED, satFirePos, vel:GetAngleDegrees(), 0, Vector(0, -20), player):ToLaser()
        laser.Velocity = vel * (migraine and 0.75 or 1)
        laser.Radius = migraine and 25 or 15
        laser:SetScale(migraine and 1.5 or 0.85)
        laser.SubType = LaserSubType.LASER_SUBTYPE_RING_PROJECTILE
        laser.CollisionDamage = player.Damage * damagemulti
        laser:Update()
        if laser.Child and laser.Child.Type == EntityType.ENTITY_EFFECT and laser.Child.Variant == EffectVariant.LASER_IMPACT then
            laser.Child.Visible = false
            laser.Child:Remove()
        end
		laser.Color = player.LaserColor
    end
    laser.Color = mod:GetInabaLaserColor(itsBinaba, satellite, migraine, laser.Color)
    return laser
end

function mod:FireSatelliteBrimstone(player, satellite, satFirePos, dir, save, migraine, damagemulti, itsBinaba)
    if not itsBinaba then
        damagemulti = damagemulti * mod.InabaBal.SatelliteMiniBrimstoneDamageMult
    end
    local sizemulti = 1.0
    if itsBinaba and migraine then
        sizemulti = 1.0 + save.Power / 100
    end
    if not itsBinaba or save.ocularSpectrumSats then
        sizemulti = sizemulti * 0.25
    end
    local laser = itsBinaba and player:FireBrimstone(dir, player, sizemulti) or EntityLaser.ShootAngle(LaserVariant.THICK_RED, satFirePos, dir:GetAngleDegrees(), 9, mod.nilvector, satellite)
    laser:SetDamageMultiplier(damagemulti)
    laser.Parent = satellite
    laser.ParentOffset = mod.nilvector
    laser.PositionOffset = Vector(0, -20) + dir:Resized(12)
    if not itsBinaba or save.ocularSpectrumSats then
        laser.MaxDistance = (player.TearRange / 2)
    end
    laser.Color = mod:GetInabaLaserColor(itsBinaba, satellite, migraine, laser.Color)
end

function mod:FireSatelliteCuttingGazeSpinAttack(player, satellite, pos, dir, save, migraine, damagemulti, itsBinaba)
    local knife = Isaac.Spawn(EntityType.ENTITY_KNIFE, KnifeVariant.SPIRIT_SWORD, KnifeSubType.CLUB_HITBOX, pos, mod.nilvector, player):ToKnife()
    local sprite = knife:GetSprite()
    sprite:Play("SpinDown", true)

    knife.Visible = true
    knife:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    knife.Parent = satellite
    knife.PositionOffset = Vector(0, -20)
    knife.SpawnerEntity = player
    knife:SetIsSwinging(true)
    knife:SetIsSpinAttack(true)

    local powerScale = math.min(math.max(0, (save.Power - 100) / 300), 1)
    local scale = migraine and mod:Lerp(0.5, 0.75, powerScale) or 0.5
    if mod:InabaHasWeaponType(player, WeaponType.WEAPON_SPIRIT_SWORD) then
        scale = scale + 0.25
    end
    knife.SpriteScale = Vector(scale, scale)
    knife.SpriteRotation = dir:GetAngleDegrees() - 90
    knife.Color = mod:GetInabaTearColor(itsBinaba, satellite, false, player.TearColor)

	local params = player:GetTearHitParams(WeaponType.WEAPON_SPIRIT_SWORD)
    local targetDamage = params.TearDamage * damagemulti * mod.InabaBal.B_CuttingGazeReturnDamageMult + mod.InabaBal.B_CuttingGazeReturnFlatDamage
    knife.CollisionDamage = (targetDamage - 10) / 8
	knife.TearFlags = params.TearFlags
	TearFlagsLib.CallPollTearFlagCallback(knife, player, TearFlagsLib.WeaponFlag.SWORD)
	mod:ApplyFetalFriendToSword(knife, player)
    knife.Color = mod:GetInabaTearColor(itsBinaba, satellite, false, player.TearColor)

    sfx:Play(SoundEffect.SOUND_SWORD_SPIN, 0.8, 0, false, mod:RandomFloat(1.4, 1.6))

    return knife
end

function mod:FireSatelliteMeleeSwing(player, satellite, satFirePos, dir, save, migraine, damagemulti, itsBinaba, isBerserk)
    local variant, swing1anim, swing2anim
    if isBerserk then
        variant = KnifeVariant.DONKEY_JAWBONE
        swing1anim = "Swing"
        swing2anim = "Swing2"
    else
        variant = KnifeVariant.SPIRIT_SWORD
        swing1anim = "AttackRight"
        swing2anim = "AttackLeft"
    end

    local knife = Isaac.Spawn(EntityType.ENTITY_KNIFE, variant, KnifeSubType.CLUB_HITBOX, satFirePos, mod.nilvector, player):ToKnife()
    local sprite = knife:GetSprite()
    --sprite:Load("gfx/008.001_bone club.anm2", true)
    local data = mod:GetEntityData(satellite)
    if data.MeleeSwing2 == nil then
        data.MeleeSwing2 = satellite.InitSeed % 2 == 0
    end
    sprite:Play(data.MeleeSwing2 and swing2anim or swing1anim, true)
    data.MeleeSwing2 = not data.MeleeSwing2

    knife.Visible = true
    knife:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    knife.Parent = satellite
    knife.SpawnerEntity = player
    knife:SetIsSwinging(true)

    local powerScale = math.min(math.max(0, (save.Power - 100) / 300), 1)
    local scale = (itsBinaba and migraine) and mod:Lerp(0.85, 1.75, powerScale) or 0.75
    if isBerserk then
        scale = scale + 0.25
    end
    knife.SpriteScale = Vector(scale, scale)
    knife.SpriteRotation = dir:GetAngleDegrees() - 90

	local params = player:GetTearHitParams(WeaponType.WEAPON_SPIRIT_SWORD, nil, (math.random(2) == 1 and -1) or 1)
    local targetDamage = params.TearDamage * damagemulti * mod.InabaBal.SatelliteMeleeDamageMult + mod.InabaBal.SatelliteMeleeFlatDamage
    knife.CollisionDamage = (targetDamage - 3.5) / 3
	knife.TearFlags = params.TearFlags
	knife.Color = params.TearColor
	TearFlagsLib.CallPollTearFlagCallback(knife, player, TearFlagsLib.WeaponFlag.SWORD)
	mod:ApplyFetalFriendToSword(knife, player)
    knife.Color = mod:GetInabaTearColor(itsBinaba, satellite, migraine, knife.Color)

    sfx:Play(SoundEffect.SOUND_SHELLGAME, 0.8, 0, false, mod:RandomFloat(1.4, 1.6))
end

mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_UPDATE, function(_, knife)
    local parent = knife.Parent
    if parent and parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == inabaSatellite then
        local data = mod:GetEntityData(parent)
        if data.SwordFlurry then
            knife.SpriteRotation = data.SwordFlurry.Dir:GetAngleDegrees() - 90
        elseif data.BerserkingBaseAim then
            knife.SpriteRotation = data.CurrentAngle - 90
        end
        knife.Position = parent.Position
        knife.Velocity = parent.Velocity
    end
end, KnifeSubType.CLUB_HITBOX)

local function GetSatelliteDamageMult(player, save, migraine, satellite)
    local mult = 1.0
	local isBinaba = mod:isBinaba(player)
    if not isBinaba and game.Challenge == FiendFolio.challenges.imperishableNight then
        mult = mult * mod.InabaBal.ImperishableDamageMult
    end
    if not satellite then
        local d = mod:GetEntityData(player)
        satellite = d.InabaSatellites and mod:BinabaGetPrimarySatellite(d.InabaSatellites)
    end
    if satellite then
        mult = mult * satellite:GetMultiplier()
    end
    if isBinaba then
        return mult
    end
    return mult * (migraine and mod.InabaBal.MigraineSatelliteDamageMult or mod.InabaBal.SatelliteDamageMult)
end

function mod:FireSatellite(player, satellite, satFirePos, dir, save, migraine, velMult, decapScissorOffset, chargeWeapon, isBerserk, compensationMult, monstrosLungBonusTears)
    local preFireRet = Isaac.RunCallback("SATELLITE_PRE_FIRE", player, satellite, satFirePos, dir, save, migraine, velMult, decapScissorOffset, chargeWeapon, isBerserk, compensationMult, monstrosLungBonusTears)
    if preFireRet == true then
        return
    end

    local shotSpeed = mod.InabaBal.SatelliteShotSpeed
    local vel = dir:Resized(player.ShotSpeed * shotSpeed)
    if velMult then
        vel = vel * velMult
    end

    local itsBinaba = mod:isBinaba(player)
    local damagemulti = GetSatelliteDamageMult(player, save, migraine, satellite) * (compensationMult or 1)

    if itsBinaba then
        damagemulti = damagemulti * calculateBinabaMultiplier(player, save)
    end

    local spread = 0
    if migraine then
        spread = itsBinaba and mod.InabaBal.B_MigraineSatelliteSpread or mod.InabaBal.MigraineSatelliteSpread
    else
        spread = itsBinaba and mod.InabaBal.B_SatelliteSpread or mod.InabaBal.SatelliteSpread
    end
    if spread ~= 0 then
        vel = vel:Rotated(mod:RandomInt(-spread, spread))
    end

    if migraine and itsBinaba then
        local speed = vel:Length()
        vel = vel:Resized(mod:RandomFloat(speed * 0.75, speed * 1.5))
    end

    local fetalFriendIsFireDelayed = false
	local fireFunc -- i dont wanna repeat a bunch of expensive api checks just for the sake of fetal friend so hell code it is then
	local weaponType, weaponModifiers = nil, 0
    if itsBinaba and player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
        fireFunc = function()
			mod:FireSatelliteTear(player, satellite, satFirePos, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
		end
		weaponType = WeaponType.WEAPON_FETUS
    elseif mod:InabaHasWeaponType(player, WeaponType.WEAPON_SPIRIT_SWORD) or isBerserk then
        fireFunc = function()
			mod:FireSatelliteMeleeSwing(player, satellite, satFirePos, dir, save, migraine, damagemulti, itsBinaba, isBerserk)
		end
		weaponType = WeaponType.WEAPON_SPIRIT_SWORD
    --elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
    elseif chargeWeapon.MonstrosLung or (not itsBinaba and mod:InabaHasWeaponType(player, WeaponType.WEAPON_MONSTROS_LUNGS)) then
        fireFunc = function()
			local monstroVolleyMult = itsBinaba and 1.0 or (migraine and 0.75 or 0.5)
			monstrosLungBonusTears = monstrosLungBonusTears or 0
			local monstroVelMult = itsBinaba and 1.0 or 2/3
			local monstroVel = vel:Resized(player.TearRange / 20) * monstroVelMult * velMult
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
			local playsound = true
			if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
				mod:FireSatelliteMonstroBombBurst(player, satellite, satFirePos, monstroVel, math.ceil((5 + monstrosLungBonusTears * 0.5) * monstroVolleyMult), save, migraine, damagemulti, itsBinaba, decapScissorOffset)
				weaponType = WeaponType.WEAPON_MONSTROS_LUNGS
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
				mod:FireSatelliteMonstroLaserBurst(player, satellite, satFirePos, monstroVel, math.ceil((6 + monstrosLungBonusTears * 0.5) * monstroVolleyMult), save, migraine, damagemulti, itsBinaba, decapScissorOffset)
				playsound = false
				weaponType = WeaponType.WEAPON_LASER
				weaponModifiers = weaponModifiers | WeaponModifier.MONSTROS_LUNG
			else
				mod:FireSatelliteMonstroTearBurst(player, satellite, satFirePos, monstroVel, math.ceil((12 + monstrosLungBonusTears) * monstroVolleyMult), save, migraine, damagemulti, itsBinaba, decapScissorOffset)
				weaponType = WeaponType.WEAPON_MONSTROS_LUNGS
			end
			if playsound then
				local monstroPitchMult = itsBinaba and 1.0 or 1.5
				sfx:Play(891, 0.8, 0, false, mod:RandomFloat(1.3, 1.5) * monstroPitchMult)
			end
        end
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
		fireFunc = function()
			mod:FireSatelliteBomb(player, satellite, satFirePos, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
		end
		weaponType = WeaponType.WEAPON_BOMBS
    elseif player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
		fireFunc = function()
			mod:FireSatelliteTechX(player, satellite, satFirePos, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
		end
		weaponType = WeaponType.WEAPON_TECH_X
    elseif mod:InabaHasWeaponType(player, WeaponType.WEAPON_BRIMSTONE) then
		fetalFriendIsFireDelayed = true
		fireFunc = function()
			mod:FireSatelliteBrimstone(player, satellite, satFirePos, vel, save, migraine, damagemulti, itsBinaba)
		end
		weaponType = WeaponType.WEAPON_BRIMSTONE
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
		fireFunc = function()
			mod:FireSatelliteLaser(player, satellite, satFirePos, dir, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
		end
		weaponType = WeaponType.WEAPON_LASER
    else
		fireFunc = function()
			mod:FireSatelliteTear(player, satellite, satFirePos, vel, save, migraine, damagemulti, itsBinaba, decapScissorOffset)
		end
		weaponType = WeaponType.WEAPON_TEARS
    end

	if itsBinaba and player:HasCollectible(mod.ITEM.COLLECTIBLE.FETAL_FRIEND) then
        mod:TryFireFetalFriendGun(player, fetalFriendIsFireDelayed)
    end
	mod.IsBinabaSatelliteTear = {Save = save, Migraine = migraine}
	fireFunc()
	mod.IsBinabaSatelliteTear = nil

	return weaponType, weaponModifiers
end

function mod:handleBinabaSecondaryFireTearEffects(tear, player)
	if mod.IsBinabaSatelliteTear then
		mod:applySatellitePostFireTear(player, tear, mod:GetEntityData(tear), mod.IsBinabaSatelliteTear.Save, mod.IsBinabaSatelliteTear.Migraine, mod:isBinaba(player), true)
	end
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_FIRE_SECONDARY_TEAR, mod.handleBinabaSecondaryFireTearEffects)


mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
    local player = Isaac.GetPlayer(0)
    if player and mod:isEitherInaba(player) then
        if cmd == "pow" and tonumber(params) then
            local newPow = tonumber(params)
            AddPower(player, newPow, true)
        elseif (cmd == "migraine" or cmd == "lunatic") and tonumber(params) then
            local newMigraine = tonumber(params)
            AddMigraineGauge(player, newMigraine, true, true)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    if mod:GetEntityData(tear).inabaSatelliteTear then
        --tear.SpriteRotation = tear.Velocity:GetAngleDegrees() + 90
    end
end)

function mod:inabaTearColl(tear,ent,tdata)
    if tdata.binabaIpecac then
        tdata.binabaIpecacColls = tdata.binabaIpecacColls or {}
        if not tdata.binabaIpecacColls[ent.InitSeed] then
            tdata.binabaIpecacColls[ent.InitSeed] = true
            --PADRE FORGIVE ME FOR I HAVE SINNED
            local newTear = Isaac.Spawn(2,0,0,ent.Position,Vector.Zero,nil):ToTear()
            newTear:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
            newTear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            newTear.CollisionDamage = tear.CollisionDamage
            newTear.Height = 1
            newTear.Color = tear.Color
            newTear:Update()
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_TEAR_COLLISION, CallbackPriority.LATE, function(_, tear, ent, low)
	if TearFlagsLib.HasTearFlags(tear, mindRazorFlag) then
		local params = TearFlagsLib.GetTearFlagParams(tear, mindRazorFlag)
		if params.PowerLevel then
			local reduction = mod.InabaBal.MigrainePiercePenalty + (mod.InabaBal.MigrainePiercePenaltyReduction * (params.PowerLevel - 1))
			tear.CollisionDamage = tear.CollisionDamage * reduction
			tear.Scale = tear.Scale * 0.5
		else
			local reduction = math.min(1, 0.3 + 0.2 * ((params.BirthcakeMult or 1) - 1))
			tear.CollisionDamage = tear.CollisionDamage * reduction
			tear.Scale = tear.Scale * reduction
		end
		tear:ResetSpriteScale()
        TearFlagsLib.ClearTearFlags(tear, mindRazorFlag)
    end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_COLLISION, CallbackPriority.LATE, function(_, bomb, ent, low)
	if TearFlagsLib.HasTearFlags(bomb, mindRazorFlag) then
		local params = TearFlagsLib.GetTearFlagParams(tear, mindRazorFlag)
		local reduction = math.min(1, 0.3 + 0.2 * ((params.BirthcakeMult or 1) - 1))
		bomb.CollisionDamage = bomb.CollisionDamage * reduction
        TearFlagsLib.ClearTearFlags(bomb, mindRazorFlag)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player = tear.Parent
    if player:ToPlayer() and mod:isEitherInaba(player:ToPlayer()) then
        tear:SetKnockbackMultiplier(mod.InabaBal.BaseKnockbackMulti)
        if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
            mod:GetEntityData(player).inabaLudoTear = tear
        end
    end
end)

function mod:inabaHandlingRocketFire(player, target)
    if target.Variant == EffectVariant.TARGET and not mod:GetEntityData(target).beeSkinTarget then
        local basedata = mod:GetEntityData(player)
        local data = basedata.ffsavedata
        if not data or (data and not data.RunEffects) then
            return
        end
        data.Inaba = data.Inaba or {}
        if data.Inaba.EpicFetusSatCount and data.Inaba.EpicFetusSatCount > 0 then
            local playerTargDat = mod:GetEntityData(target)
            playerTargDat.StoredInabaTargets = {}
            for i = 1, data.Inaba.EpicFetusSatCount do
                local newTarget = Isaac.Spawn(1000,30,0, target.Position, Vector.Zero, target)
                local sprite = newTarget:GetSprite()
                sprite:ReplaceSpritesheet(0, "gfx/effects/effect_inaba_rocket_target.png")
				sprite:LoadGraphics()
                local tDat = mod:GetEntityData(newTarget)
                tDat.InabaFollowIndex = i
                tDat.InabaFollowMax = data.Inaba.EpicFetusSatCount
                tDat.InabaSpawner = player
                newTarget.Parent = target
                newTarget:Update()
                table.insert(playerTargDat.StoredInabaTargets, newTarget)
            end
        end
    end
end

function mod:InabaHandlingRocketNonsense(rocketdata, targetdata, rocket, target, player)
    if targetdata.StoredInabaTargets then
        for _, inabaTarg in pairs (targetdata.StoredInabaTargets) do
			mod.CurrentRocketTarget = inabaTarg
            local newRocket = Isaac.Spawn(1000, EffectVariant.ROCKET, 0, inabaTarg.Position, Vector.Zero, player):ToEffect()
            mod.CurrentRocketTarget = nil
			newRocket:FollowParent(inabaTarg)
            newRocket.Timeout = math.floor(rocket.Timeout * 1.5)
            local nrS = newRocket:GetSprite()
            newRocket.SpriteScale = newRocket.SpriteScale * 0.75
            newRocket.Scale = 0.1
            newRocket:Update()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
    local data = mod:GetEntityData(eff)
    if data.binabaFetusRocket then
        local sprite = eff:GetSprite()
        local blinkTime = 3

        if data.binabaRocketActive then
            eff.SpriteScale = mod:Lerp(eff.SpriteScale, Vector.One * ((data.beeSkinTarget and 0.5) or 1), 0.4)
            data.binabaActiveTime = data.binabaActiveTime or 0
            if data.binabaActiveTime >= 20 then
                blinkTime = 2
            end
            data.binabaActiveTime = data.binabaActiveTime + 1
            if not data.binabaSpawnedRocket then
                local player = eff.SpawnerEntity:ToPlayer()
                local shotCount = player:GetMultiShotParams(WeaponType.WEAPON_ROCKETS):GetNumTears()
                for i = 1, shotCount do
					mod.RerollFetalFriendAmmo = data.beeSkinTarget
					mod.NoFireFetalFriend = true
					mod.CurrentRocketTarget = eff
                    local newRocket = Isaac.Spawn(1000, EffectVariant.ROCKET, 0, eff.Position, Vector.Zero, eff.SpawnerEntity):ToEffect()
					mod.RerollFetalFriendAmmo = false
					mod.NoFireFetalFriend = false
                    mod.CurrentRocketTarget = nil
					mod:rollEpicFetusEffects(player, newRocket)
                    data.binabaMaxTime = 15 + (15 * i)
                    newRocket.Timeout = data.binabaMaxTime
                    newRocket.Parent = eff
                    data.binabaSpawnedRocket = true
					if data.beeSkinTarget then
						TearFlagsLib.AddTearFlags(newRocket, TearFlagsLib.Flag.BEE_SKIN)
						newRocket.SpriteScale = newRocket.SpriteScale * 0.5
					end
                    newRocket:Update()
                end
				mod.scheduleForUpdate(function()
					sfx:Play(SoundEffect.SOUND_DRSREMOTE_WARNING, 1, 2)
				end, 5)
            end
            if data.binabaActiveTime > data.binabaMaxTime then
                eff:Remove()
            end
        else
            blinkTime = 5
            local scale = Vector.One * (0.5 + (math.sin((-5 + eff.FrameCount)/10)/4)) * ((data.beeSkinTarget and 0.5) or 1)
            eff.SpriteScale = mod:Lerp(eff.SpriteScale, scale, 0.15)
        end
        sprite:SetFrame("Blink", (math.floor(eff.FrameCount / blinkTime) % 2))
    elseif data.InabaFollowIndex then
        local sprite = eff:GetSprite()
        if eff.Parent then
            local p = eff.Parent
            local ps = p:GetSprite()
            local pd = mod:GetEntityData(p)
            sprite:SetFrame(ps:GetAnimation(), ps:GetFrame())
            local rotAmount = data.InabaFollowIndex / data.InabaFollowMax
            local playerDat = mod:GetEntityData(data.InabaSpawner)
            local targPos
            local migraineActive = false
            if data.InabaSpawner and data.InabaSpawner:Exists() then
                local sdata = mod:GetEntityData(data.InabaSpawner).ffsavedata
                local save = sdata.Inaba
                if save and save.MigraineMode then
                    migraineActive = true
                end
            end
            local waveCount = data.InabaFollowMax
            if migraineActive and waveCount > 1 then
                local waveNum = data.InabaFollowIndex
                if waveCount == 2 then
                    waveCount = 4
                    waveNum = waveNum + 1
                end
                local offset = mod:Lerp(-90, 90, (waveNum - 1) / (waveCount - 1))
                targPos = p.Position + Vector(50,0):Rotated((offset) + p.Velocity:GetAngleDegrees())
            else
                targPos = p.Position + Vector(50,0):Rotated((rotAmount * 360) + p.Velocity:GetAngleDegrees())
            end
            eff.Velocity = mod:Lerp(eff.Velocity, targPos - eff.Position, 0.9)
            eff.SpriteScale = p.SpriteScale * 0.75 * ((data.beeSkinTarget and 0.5) or 1)
        else
            eff:Remove()
        end
    end
end, EffectVariant.TARGET)

local function findLudovicoTear(player, d)
    d = d or mod:GetEntityData(player)
    if d.inabaLudoTear and d.inabaLudoTear:Exists() then
        return d.inabaLudoTear
    else
        local phash = GetPtrHash(player)
        local tears = Isaac.FindByType(2, -1, -1, false, false)
        for _, tear in pairs(tears) do
            tear = tear:ToTear()
            if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
                if tear.Parent and GetPtrHash(tear.Parent) == phash then
                    d.inabaLudoTear = tear
                    return tear
                end
            end
        end
        local lasers = Isaac.FindByType(7, -1, -1, false, false)
        for _, laser in pairs(lasers) do
            laser = laser:ToLaser()
            if laser.SubType == 1 then
                if laser.Parent and GetPtrHash(laser.Parent) == phash then
                    d.inabaLudoTear = laser
                    return laser
                end
            end
        end
        local knives = Isaac.FindByType(8, -1, -1, false, false)
        for _, knife in pairs(knives) do
            knife = knife:ToKnife()
            if knife:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
                if knife.Parent and GetPtrHash(knife.Parent) == phash then
                    d.inabaLudoTear = knife
                    return knife
                end
            end
        end
        return player
    end
end

local directionToVec = {
    [Direction.NO_DIRECTION] = Vector(0, mod.InabaBal.SatelliteDistance),
    [Direction.LEFT] = Vector(-mod.InabaBal.SatelliteDistance, 0),
    [Direction.UP] = Vector(0, -mod.InabaBal.SatelliteDistance),
    [Direction.RIGHT] = Vector(mod.InabaBal.SatelliteDistance, 0),
    [Direction.DOWN] = Vector(0, mod.InabaBal.SatelliteDistance),
}

local directionToDir = {
    [Direction.NO_DIRECTION] = "Down",
    [Direction.LEFT] = "Left",
    [Direction.UP] = "Up",
    [Direction.RIGHT] = "Right",
    [Direction.DOWN] = "Down",
}

local function canShootRotationalShots(player, hasEye, hasHorns)
    if hasEye then
        local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_MOMS_EYE)
        if rng:RandomFloat() * 10 < 5 + player.Luck then
            return true
        end
    end
    --I believe this is a seperate calc and not an elseif?
    if hasHorns then
        local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_LOKIS_HORNS)
        if rng:RandomFloat() * 10 < (5 + player.Luck) * 0.5 then
            return true
        end
    end
end
local function DetermineRotationalShots(player)
    local hasEye = player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE)
    local hasHorns = player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS)
    if canShootRotationalShots(player, hasEye, hasHorns) then
        if hasHorns then
            return CollectibleType.COLLECTIBLE_LOKIS_HORNS
        elseif hasEye then
            return CollectibleType.COLLECTIBLE_MOMS_EYE
        end
    end
end

local function GetSwordFlurryFrameData(player, index, numSatellites)
    local swordAttackDelay = math.max(1, mod:LuaRound(player.MaxFireDelay / mod:Lerp(numSatellites, 1, 0.8)))
    local swordAttackInterval = numSatellites * swordAttackDelay
    local swordAttackIndex = index
    if swordAttackIndex % 2 == 0 and numSatellites % 2 == 0 then
        swordAttackIndex = (swordAttackIndex + 2) % numSatellites
    end
    local swordAttackFrame = swordAttackIndex * swordAttackDelay
    return swordAttackFrame, swordAttackInterval
end

local function HandleTech2(player, d, fireAim, isBinaba)
    if not isBinaba or fireAim:Length() <= 0.1 or not player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
        if d.InabaTech2 then
            d.InabaTech2 = nil
        end
        return
    end

    local laser = mod:GetPointee(d.InabaTech2)
    if not laser then
        laser = player:FireTechLaser(player.Position, LaserOffset.LASER_TECH2_OFFSET, fireAim, false, false, player)
        laser:SetDamageMultiplier(0.13)
        laser.Parent = player
        laser.DisableFollowParent = false
        d.InabaTech2 = EntityPtr(laser)
        if rgonUpdated then
            laser:SetInitSound(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK)
        end
    end

    local headDir = player:GetHeadDirection()
    local headVec = directionToVec[headDir]
    local offset = player:GetLaserOffset(LaserOffset.LASER_TECH2_OFFSET, headVec)
    laser.ParentOffset = Vector(offset.X, 0)
    laser.PositionOffset = Vector(0, offset.Y)
    laser.Angle = fireAim:GetAngleDegrees()
    if headDir == Direction.LEFT or headDir == Direction.UP then
        laser.DepthOffset =  -10
    else
        laser.DepthOffset = 3000
    end
    laser:SetTimeout(2)
end

-- Beeg laser
local function HandleMigraineBrimstone(player, d, save, aim, markTarg, canFire, hasBrimstone, migraine, powerLevel, isBinaba)
    if not hasBrimstone or not migraine or isBinaba then
        -- Clean up if needed.
        if d.SatelliteBrimstone then
            local laser = mod:GetPointee(d.SatelliteBrimstone)
            if laser then laser:Remove() end
            d.SatelliteBrimstone = nil
        end
        if d.SatelliteBrimstoneChargeEffect then
            local eff = mod:GetPointee(d.SatelliteBrimstoneChargeEffect)
            if eff then eff:Remove() end
            d.SatelliteBrimstoneChargeEffect = nil
        end
        return
    end

    local fireAim = aim
    if markTarg then
        fireAim = (markTarg.Position - player.Position)
    end
    -- Start by spawning a brimstone swirl
    if canFire and not mod:GetPointee(d.SatelliteBrimstone) and not mod:GetPointee(d.SatelliteBrimstoneChargeEffect) then
        local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BRIMSTONE_SWIRL, 0, player.Position, mod.nilvector, player):ToEffect()
        local spr = eff:GetSprite()
        spr:Load("gfx/effects/inaba_brimstoneswirl.anm2", true)
        spr:Play("IdleQuick", true)
        spr:SetOverlayRenderPriority(true)
        eff:FollowParent(player)
        eff.Position = player.Position
        eff.SpriteOffset = Vector(0, -20)
        eff.SpriteScale = Vector(0.8, 0.8)
        spr.Color = player.LaserColor
        d.SatelliteBrimstoneChargeEffect = EntityPtr(eff)
    end
    local eff = mod:GetPointee(d.SatelliteBrimstoneChargeEffect)
    if eff then
        local spr = eff:GetSprite()
        if not canFire then
            if eff.FrameCount > 10 then
                spr:Play("Disappear")
            else
                eff:Remove()
            end
            d.SatelliteBrimstoneChargeEffect = nil
        else
            eff.ParentOffset = fireAim:Resized(45)
            if eff.FrameCount == 3 then
                sfx:Play(SoundEffect.SOUND_SATAN_CHARGE_UP, 0.8, 0, false, 1.2)
            end
            if spr:IsEventTriggered("Shoot") then
                -- SHOOT THE LASER
                -- powerLevel here affects the size of the laser only, since we override the damage multiplier below.
                local laser = player:FireBrimstone(fireAim, player, powerLevel)
                laser.PositionOffset = Vector(0, -30)
                -- Grant damage bonuses to the laser based on power level and fire rate.
                local baseMult = GetSatelliteDamageMult(player, save, true)
                local powerBonus = mod:Lerp(1, powerLevel, mod.InabaBal.SatelliteBrimstoneMigrainePowerBonus)
                local fireRateBonus = mod:Lerp(1, 30 / (player.MaxFireDelay + 1), mod.InabaBal.SatelliteBrimstoneMigraineFireRateBonus)
                laser:SetDamageMultiplier(baseMult * fireRateBonus * powerBonus)
                laser.AngleDegrees = fireAim:GetAngleDegrees()
                d.SatelliteBrimstone = EntityPtr(laser)
            end
        end
        if canFire and mod:GetPointee(d.SatelliteBrimstone) then
            spr:Play("FireLoop")
            spr:PlayOverlay("SpiralDisappear")
        end
    end
    local laser = mod:GetPointee(d.SatelliteBrimstone)
    if laser then
        laser.Timeout = 5
        if canFire then
            laser.ParentOffset = fireAim:Resized(45)
            laser.AngleDegrees = InabaLerpAngleDegrees(laser.AngleDegrees, fireAim:GetAngleDegrees(), 0.5)
            laser.DepthOffset = laser.ParentOffset.Y + 5
        else
            d.SatelliteBrimstone = nil
        end
    end
end

function mod:UpdatePlayerHeadDirection(player, locktime, allowNonFireDirection)
	local headDir = player:GetFireDirection()
	if allowNonFireDirection and headDir == Direction.NO_DIRECTION then
		headDir = player:GetHeadDirection()
	end
	if headDir ~= Direction.NO_DIRECTION then
		player:SetHeadDirection(headDir, math.max(player:GetHeadDirectionLockTime(), locktime), true)
	end
end

local trinketDroppingCallbackActive

-- ignores shadow satellite
function mod:BinabaGetPrimarySatellite(satellites)
    for i, sat in ipairs(satellites) do
        if sat.SubType ~= mod.InabaBal.ShadowSatelliteSub then
            return sat
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local d = mod:GetEntityData(player)
    local sdata = d.ffsavedata
    local save = sdata.Inaba
    if not save then
        return
    end

    local isInaba = mod:isInaba(player)
    local isBinaba = mod:isBinaba(player)
    local isEitherInaba = isInaba or isBinaba

    if isEitherInaba or save.SoulOfInabaActive or player:HasCollectible(mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM) or d.binabaOcularSpectrumForce then
        local migraineSatelliteSystemUser = isEitherInaba or save.SoulOfInabaActive

        local power = save.Power
        if d.InabaPower ~= power then
            if d.InabaPower and math.floor(power / 100) > math.floor(d.InabaPower / 100) then
                sfx:Play(mod.Sounds.InabaPowerLevelUp, 1, 0, false, 1)

                local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ATTRACT, 10, player.Position, Vector.Zero, player):ToEffect()
                eff.MinRadius = 1
                eff.MaxRadius = 15
                eff.LifeSpan = 20
                eff.Timeout = 20
                eff.SpriteOffset = Vector(0, -15)
                eff.Color = Color(0.3,0.15,0.1,5,0.35,0.25,0.1)
                eff.Visible = false
                eff:FollowParent(player)
                eff:Update()
                eff.Visible = true
            end
            d.InabaPower = power
            player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
        end

        if player:IsDead() then
            if not d.inabadead then
                AddPower(player, -mod.InabaBal.PowerDeathPenalty)
                d.inabadead = true
            end
        elseif d.inabadead then
            d.inabadead = nil
        end

        if isInaba and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            d.migrainebal = mod.InabaBal.MigraineGainBirthright
        else
            d.migrainebal = mod.InabaBal.MigraineGain
        end

        local tempEffects = player:GetEffects()

        --For Inabas and Soul of Inaba users only
        if migraineSatelliteSystemUser then
            local hearts = player:GetHearts()
            local maxHearts = player:GetMaxHearts()
            if game:GetRoom():GetAliveEnemiesCount() > 0 then
                if maxHearts > 0 then
                    local healthPercent = hearts / maxHearts
                    local threshold = (isInaba and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 6) or 4
                    if healthPercent < 0.5 or hearts < threshold then
                        AddMigraineGauge(player, d.migrainebal.LowHealth)
                    end
                end

                if save.MigraineMode then
                    --Migraine doesn't go down when pause is active
                    --Doesn't account for timing out cos the item's coded weird so IDK have fun with that ig
                    if not (game:GetRoom():GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_PAUSE) > 0) then
                        local val = d.migrainebal.Drain
                        if save.SoulOfInabaActive then
                            val = val * mod.InabaBal.SoulOfInabaDrainMult
                        end
                        AddMigraineGauge(player, -val, nil, true)
                        --Blip on low migraine, dunno why it was set up elsewhere so it makes the noise only when decreasing
                        local migrainePercent = save.MigraineGauge / mod.InabaBal.MigraineCap
                        if migrainePercent <= mod.InabaBal.MigraineBotPercent then
                            if player.FrameCount % 10 == 0 then
                                sfx:Play(mod.Sounds.MigraineModeWarning, 1, 0, false, 1)
                            end
                        end
                    end
                end
            end
            save.MigraineGauge = save.MigraineGauge or 0
            if save.MigraineGauge == mod.InabaBal.MigraineCap and not save.MigraineMode then
                MigraineStartEffect(player)
                save.MigraineMode = true
                if isBinaba then
                    player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                end
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
                if mod.InabaBal.MigraineModeMantle or (isInaba and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)) then
                    tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                    save.MigraineStoredMantles = tempEffects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                end
            elseif save.MigraineGauge <= 0 and save.MigraineMode then
                MigraineEndEffect(player)
                if save.SoulOfInabaActive then
                    save.SoulOfInabaActive = nil
                    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
                end
                save.MigraineMode = nil
                if isBinaba then
                    player:AddCacheFlags(CacheFlag.CACHE_RANGE)
                end
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
                if save.MigraineStoredMantles then
                    local currentNum = tempEffects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                    if currentNum >= save.MigraineStoredMantles then
                        tempEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                    end
                    save.MigraineStoredMantles = nil
                end
            end

            if save.MigraineMode then
                if save.MigraineStoredMantles then
                    local currentNum = tempEffects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                    local room = game:GetRoom()
                    if room:GetFrameCount() > 0 and currentNum < save.MigraineStoredMantles then
                        AddMigraineGauge(player, -mod.InabaBal.MigraineCap/2, nil, true)
                        save.MigraineStoredMantles = nil
                    end
                elseif isInaba and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                    if save.MigraineGauge >= mod.InabaBal.MigraineCap * mod.InabaBal.MigraineBirthrightMantle then
                        sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_STRONG, 0.5, 0, false, 2)
                        tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                        save.MigraineStoredMantles = tempEffects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                    end
                end

                --Visuals
                if playerIsInaba and player.FrameCount % 5 == 1 then
                    local emberParticle = Isaac.Spawn(1000,66, 0, player.Position + Vector(0, -30), Vector(0,-mod:Random(4,7)):Rotated(-35 + mod:Random(70)), player):ToEffect()
                    emberParticle.Color = Color(0.5,0.5,0.5,1,0.5,-0.5,-0.5)
                    --emberParticle.DepthOffset = 0 --I'll have a think about this one
                    emberParticle:Update()
                end
            end
        end

        local ocularSpectrumActive
        local powerLevel = math.floor(save.Power / 100)
        if not isEitherInaba then
            powerLevel = 2
        end
        local ocularSpectrumDrain = 6 - powerLevel
        if d.binabaOcularSpectrumForce then
            d.binabaOcularSpectrumForce = d.binabaOcularSpectrumForce - ocularSpectrumDrain
            if d.binabaOcularSpectrumForce <= 0 then
                d.binabaOcularSpectrumForce = nil
                --Checking here since it can be granted from void
                player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
            end
            ocularSpectrumActive = true
        elseif d.binabaOcularSpectrumSlot then
            local slot = d.binabaOcularSpectrumSlot
            local isPressed = d.binabaOcularSpectrumCommitment
            if not isPressed or player:GetSprite():IsPlaying("Death") then
                d.binabaOcularSpectrumSlot = nil
                d.binabaOcularSpectrumCommitment = nil
                d.binabaOcularSpectrumDenied = nil
            elseif player:GetActiveItem(slot) == mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM
            and not player:IsHoldingItem() --and not player:IsPlayingExtraAnimation()
            and player.ControlsEnabled then
                local baseCharge = player:GetActiveCharge(slot)
                local maxCharge = player:GetActiveMaxCharge(slot)
                local overcharge = player:GetBatteryCharge(slot)
                local itemCharge = baseCharge+overcharge
                if d.binabaOcularSpectrumChargeDelay and d.binabaOcularSpectrumChargeDelay > 0 then
                    d.binabaOcularSpectrumChargeDelay = d.binabaOcularSpectrumChargeDelay - 1
                    itemCharge = itemCharge - 1
                    player:SetActiveCharge(itemCharge, slot)
                end
                if isPressed then
                    if d.binabaOcularSpectrumDenied then
                        if itemCharge > 30 then
                            d.binabaOcularSpectrumDenied = false
                        end
                    else
                        if itemCharge - ocularSpectrumDrain > 0 then
                            d.binabaOcularSpectrumChargeDelay = 15
                            ocularSpectrumActive = true
                            player:SetActiveCharge(itemCharge-ocularSpectrumDrain,slot)
                            if (save.ocularSpectrumBuff or 0) > 0 then
                                save.ocularSpectrumBuff = math.max(math.min(save.ocularSpectrumBuff or 0, maxCharge) - ocularSpectrumDrain, 0)
                                if save.ocularSpectrumBuff <= 0 then
                                    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
                                end
                            end
                        else
                            d.binabaOcularSpectrumDenied = true
                            d.binabaOcularSpectrumCommitment = nil
                        end
                    end
                end
            end
        end

        if ocularSpectrumActive then
            if not save.ocularSpectrumSats then
                save.ocularSpectrumSats = true
                player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
            end
        else
            if save.ocularSpectrumSats then
                save.ocularSpectrumSats = nil
                player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
            end
        end
        local allsatellites = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, inabaSatellite, -1, false, false)
        local sats = {}
        local regroupSatellites = false
        for _, sat in ipairs(allsatellites) do
            sat = sat:ToFamiliar()
            if GetPtrHash(sat.Player) == GetPtrHash(player) then
                local satHash = GetPtrHash(sat)
                if not d.InabaSatellites or not d.InabaSatellites[satHash] then
                    regroupSatellites = true
                end

                sats[#sats + 1] = sat
            end
        end

        if d.InabaSatellites then
            for i = #d.InabaSatellites, 1, -1 do
                local sat = d.InabaSatellites[i]
                if not sat:Exists() then
                    d.InabaSatellites[GetPtrHash(sat)] = nil
                    table.remove(d.InabaSatellites, i)
                    regroupSatellites = true
                end
            end
        end

        if not d.InabaSatellites or #sats ~= #d.InabaSatellites then
            regroupSatellites = true
        end

        local hasWiz = player:HasCollectible(CollectibleType.COLLECTIBLE_THE_WIZ)
        local isBerserk = tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
        local hasSpiritSword = mod:InabaHasWeaponType(player, WeaponType.WEAPON_SPIRIT_SWORD)
        local hasBrimstone = not hasSpiritSword and not isBerserk and mod:InabaHasWeaponType(player, WeaponType.WEAPON_BRIMSTONE)

        --Is the unicorn an active effect
        local unicornActive
        if tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN)
        or ocularSpectrumActive then
            unicornActive = true
        else
            d.inabaUnicornOrbit = nil
        end

        local isChargeWeapon
        local chargeWeapon = {}
        local chargeWeaponMult = 1

        local isKidneyStoneCharging
        local isKidneyStoneFiring

        if isBinaba then
            mod:UpdatePlayerHeadDirection(player, 1, false)

            if player:IsCoopGhost() then
                player.FireDelay = 10
            end

            --Player is blocked from firing while charging
            if player:GetBladderCharge() > 0 then
                isKidneyStoneCharging = true
            --Player is forced to shoot while firing
            elseif player:GetPeeBurstCooldown() > 0 then
                isKidneyStoneFiring = true
            else
                if not unicornActive then
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) then
                        isChargeWeapon = true
						chargeWeapon.CSection = true
                        chargeWeapon.AutoFiresWhenFull = true
                        chargeWeaponMult = chargeWeaponMult * 3.5
                    else
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
                            isChargeWeapon = true
                            chargeWeapon.ChocolateMilk = true
                            chargeWeaponMult = chargeWeaponMult * 2.5
                        end
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
                            isChargeWeapon = true
                            chargeWeapon.CursedEye = true
                            chargeWeaponMult = chargeWeaponMult * 2
                        end
                        if player:HasWeaponType(WeaponType.WEAPON_MONSTROS_LUNGS) then
                            isChargeWeapon = true
                            chargeWeapon.MonstrosLung = true
                        end
                        if player:HasWeaponType(WeaponType.WEAPON_BRIMSTONE) then
                            isChargeWeapon = true
                            chargeWeapon.Brimstone = true
                        end
                        if player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                            isChargeWeapon = true
                            chargeWeapon.TechX = true
                            chargeWeaponMult = chargeWeaponMult * 3
                        end
                    end
                    chargeWeapon.AutoFiresWhenFull = chargeWeapon.AutoFiresWhenFull or save.MigraineMode
                end
            end
        else
            if player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) then
                isChargeWeapon = true
                chargeWeapon.CursedEye = true
                chargeWeaponMult = chargeWeaponMult * 2
            end
        end

        local markTarg = mod.IsPlayerMarkedFiring(player)
        local shootInput = mod.GetCorrectedFiringInput(player, false)
        local unclampedShootInput = mod.GetCorrectedFiringInput(player, true)
        local unmodifiedShootInput = shootInput
        if d.binabaCuttingGazeHoldPoint and player.ControllerIndex == 0 and not markTarg and Options.MouseControl and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_1) then
            shootInput = (Input.GetMousePosition(true) - d.binabaCuttingGazeHoldPoint):Resized(shootInput:Length())
            unclampedShootInput = shootInput
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) and not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                shootInput = mod:SnapVector(shootInput, 90)
            end
        end
        local usingStoredCharge = false
        --If player has a charge weapon, keep the sats aiming that way for a bit after firing
        if isChargeWeapon then
            if isBinaba then
                local headDir = player:GetHeadDirection()
                if shootInput:Length() < 0.1 then
                    if d.storedSatChargeDir then
                        shootInput = Vector(d.storedSatChargeDir.X, d.storedSatChargeDir.Y)
                        if not d.storedSatelliteCursedEyeShots then
                            d.storedSatChargeTimer = d.storedSatChargeTimer - 1
                        end
                        player:SetHeadDirection(d.storedSatChargeHeadDir, 5)
                        usingStoredCharge = true
                        if d.storedSatChargeTimer <= 0 then
                            d.storedSatChargeTimer = nil
                            d.storedSatChargeDir = nil
                        end
                    end
                else
                    if d.storedSatelliteCursedEyeShots then
                        d.storedSatelliteCursedEyeShots = nil
                    end
                    d.storedSatChargeDir = Vector(shootInput.X, shootInput.Y)
                    d.storedSatChargeHeadDir = headDir
                    player:SetHeadDirection(player:GetFireDirection(), 2, true)
                    d.storedSatChargeTimer = 5
                end
            else
                if shootInput:Length() > 0.1 then
                    if d.storedSatelliteCursedEyeShots then
                        d.storedSatelliteCursedEyeShots = nil
                    end
                end
            end
        end
        local shootLength = shootInput:Length()

        HandleTech2(player, d, unmodifiedShootInput, isBinaba)

        local satelliteAim
        if shootLength < 0.1 then
            local headDir = player:GetHeadDirection()
            satelliteAim = directionToVec[headDir]
        else
            satelliteAim = ((shootInput / shootLength) * mod.InabaBal.SatelliteDistance)
            if not hasBrimstone then
                if not d.binabaCuttingGazeHoldPoint then
                    satelliteAim = satelliteAim + player:GetTearMovementInheritance(unclampedShootInput)
                elseif d.binabaCuttingGazeVelocity then
                    satelliteAim = satelliteAim + player:GetTearMovementInheritance(d.binabaCuttingGazeVelocity)
                end
            end
            --Tech 0.5
            --Slightly awkward spot but IDK it makes sense here I think.
            if isBinaba
            and player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5)
            and player:GetHeadDirection() == player:GetFireDirection()
            --I don't feel like gettign this exact uhhh just take what Friend did teehee
            and player.FrameCount % 4 == 0
            and player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TECH_5):RandomFloat() < 1/6
            then
                local laser = player:FireTechLaser(player.Position, LaserOffset.LASER_TECH5_OFFSET, shootInput, false, true, player, 1)
                laser.Color = player.LaserColor
            end
        end
        if unicornActive then
            if not d.inabaUnicornOrbit then
                local headDir = player:GetHeadDirection()
                satelliteAim = directionToVec[headDir]
                d.inabaUnicornOrbit = satelliteAim
            end
            local orbitSpeed = mod.InabaBal.SatelliteUnicornRotationalSpeed
            if ocularSpectrumActive then
                orbitSpeed = orbitSpeed * 1.25
            end
            d.inabaUnicornOrbit = d.inabaUnicornOrbit:Rotated(orbitSpeed)
            satelliteAim = d.inabaUnicornOrbit
        end

        if regroupSatellites then
            d.InabaSatellites = {}

            -- remove the shadow satellite from the list
            -- then add it back in after positions are calculated
            local shadowSat
            for i, sat in ipairs(sats) do
                if sat.SubType == mod.InabaBal.ShadowSatelliteSub then
                    shadowSat = table.remove(sats, i)
                end
            end

            local satCount = #sats
            local positions = {}
            local offsets = {}
            local migraineOffsets = {}

            local waveCount = satCount
            if satCount == 2 then
                waveCount = 4
            end

            for i = 1, waveCount do
                local migraineOffset = 0
                if satCount > 1 then
                    migraineOffset = mod:Lerp(-90, 90, (i - 1) / (waveCount - 1))
                end

                if satCount ~= 2 or (i == 2 or i == 3) then
                    migraineOffsets[#migraineOffsets + 1] = migraineOffset
                end
            end

            for i = 1, satCount do
                local offset = (360 / satCount) * (i - 1)
                positions[i] = player.Position + satelliteAim:Rotated(offset)
                offsets[i] = offset
            end

            local pairs = mod:PairEntitiesToPositions(sats, positions)
            local anglePairs = mod:PairAnglesToAngles(offsets, migraineOffsets)
            for i, pair in ipairs(pairs) do
                d.InabaSatellites[i] = pair.ent
                d.InabaSatellites[GetPtrHash(pair.ent)] = true
                local satData = mod:GetEntityData(pair.ent)
                satData.SatelliteOffset = offsets[pair.posind]

                for _, apair in ipairs(anglePairs) do
                    if apair.angle == satData.SatelliteOffset then
                        satData.MigraineOffset = migraineOffsets[apair.angleind]
                    end
                end

                satData.CurrentAngle = satelliteAim:GetAngleDegrees() + satData.SatelliteOffset
                satData.FireDelay = 0
                satData.ShootFrameDelay = 0
            end

            if shadowSat then
                local shadowData = mod:GetEntityData(shadowSat)
                shadowData.SatelliteOffset = 0
                shadowData.CurrentAngle = 0
                shadowData.FireDelay = 0
                shadowData.ShootFrameDelay = 0

                d.InabaSatellites[#pairs+1] = shadowSat
                d.InabaSatellites[GetPtrHash(shadowSat)] = true
            end
        end

        local hasLudo = player:HasCollectible(CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE)
        local migraine = save.MigraineMode --[[and shootLength > 0.1]]
        local blockBinabaFromMigraine = (isBinaba and not save.SoulOfInabaActive)

        --When player has Ludovico, make satellites orbit the ludo
        local satTarg = player.Position
        local priorityHead --So I don't have to refind decap/scissor heads in the future
        if hasLudo then
            satTarg = findLudovicoTear(player, d).Position
        else
            --if there's an active scissor or decap head, use that
            priorityHead = mod:GetActiveScissorDecapHead(player)
            if priorityHead then
                satTarg = priorityHead.Position
            end
        end
        --Epic Fetus cooldown (relevant to below code)
        if d.binabaEpicFetusCooldown then
            d.binabaEpicFetusCooldown = d.binabaEpicFetusCooldown - 1
            if d.binabaEpicFetusCooldown <= 0 then
                d.binabaEpicFetusCooldown = nil
            end
        end

        local ctrlHeld = isBinaba and Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex)
        --When CTRL is held as Binaba, keep a held point for the satellites
        local cuttingGazeChargeTime = mod:GetBinabaCuttingGazeChargeTime(player)
        local shadowGazeChargeTime = mod:GetBinabaShadowGazeChargeTime(player)
        if isBinaba and (ctrlHeld or hasLudo) then
            d.binabaCuttingGazeHoldPoint = d.binabaCuttingGazeHoldPoint or satTarg
            d.binabaCuttingGazeHoldTime = (d.binabaCuttingGazeHoldTime or 0) + 1


            local hasBirthright = player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            if hasBirthright and d.binabaCuttingGazeHoldTime >= cuttingGazeChargeTime then
                d.binabaShadowGazeHoldTime = math.min((d.binabaShadowGazeHoldTime or 0) + 1, shadowGazeChargeTime)
            end

            if d.binabaCuttingGazeHoldTime > 5 and d.binabaCuttingGazeHoldPoint:Distance(player.Position) > 10 then
                d.binabaPreventTrinketDrop = true
                if not trinketDroppingCallbackActive then
                    mod:EnableManualCallback(mod.CALLBACK.FF_PLAYER_INPUT_ACTION, mod.binabaInputHandling)
                    trinketDroppingCallbackActive = true
                end
            else
                d.binabaPreventTrinketDrop = false
                --Disabling this because I want to be safe regarding multiple players even if it's a bit more load on the code
                --[[if trinketDroppingCallbackActive then
                    mod:DisableManualCallback(mod.CALLBACK.FF_PLAYER_INPUT_ACTION, mod.binabaInputHandling)
                    trinketDroppingCallbackActive = false
                end]]
            end
            --Before setting satTarg off of player pos
            if player:HasCollectible(CollectibleType.COLLECTIBLE_EPIC_FETUS) then
                if (not d.binabaSpawnedFetus) or (d.binabaSpawnedFetus and not d.binabaSpawnedFetus:Exists()) then
                    if (not d.binabaEpicFetusCooldown) and (d.binabaCuttingGazeHoldPoint:Distance(satTarg) > 30) then
                        local newTarget = Isaac.Spawn(1000,30,0, d.binabaCuttingGazeHoldPoint, Vector.Zero, player)
                        local sprite = newTarget:GetSprite()
                        sprite:ReplaceSpritesheet(0, "gfx/effects/effect_inaba_rocket_target.png")
                        sprite:LoadGraphics()
                        local tDat = mod:GetEntityData(newTarget)
                        tDat.binabaFetusRocket = true
                        newTarget.SpriteScale = Vector.Zero
                        newTarget:Update()
						mod:fireBeeSkinEpicFetus(newTarget, player)
                        d.binabaSpawnedFetus = newTarget
                        d.binabaEpicFetusCooldown = 30
                    end
                end
            end
            --Okay set it now
            satTarg = d.binabaCuttingGazeHoldPoint + RandomVector()
            if ctrlHeld then
                d.binabaCuttingGazeVelocity = nil
            end
        else
            d.binabaPreventTrinketDrop = false
        end

        --Even though this overrides SatTarg, I need it set as where it flies towards
        if d.binabaCuttingGazeHoldPoint and not ctrlHeld then

            -- Spawn a shadow satellite
            if (d.binabaShadowGazeHoldTime or 0) >= shadowGazeChargeTime then
                -- spawn a poof on the old shadow satellite
                for _, shadowSats in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, inabaSatellite, mod.InabaBal.ShadowSatelliteSub)) do
                    local fam = shadowSats:ToFamiliar()
                    if fam.Player:GetPlayerIndex() == player:GetPlayerIndex() then
                        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, fam.Position, Vector.Zero, nil)
                        poof.SpriteScale = Vector(0.5, 0.5)
                        poof.SpriteOffset = Vector(0, -12)
                        poof.Color = mod.InabaBal.Shadow_SatelliteTearColor

                        break
                    end
                end

                local mainSat = mod:BinabaGetPrimarySatellite(d.InabaSatellites)
                d.shadowGazePosition = mainSat.Position
                player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
            end

            if (d.binabaCuttingGazeHoldTime or 0) > cuttingGazeChargeTime then
                local sat = mod:BinabaGetPrimarySatellite(d.InabaSatellites)
                local spinAim = Vector.FromAngle(Random() % 360)
				if player:HasCollectible(mod.ITEM.COLLECTIBLE.FETAL_FRIEND) then
					mod:TryFireFetalFriendGun(player)
				end
                local spin1 = mod:FireSatelliteCuttingGazeSpinAttack(player, sat, sat.Position, spinAim, save, migraine, 1.0, isBinaba)
                local spin2 = mod:FireSatelliteCuttingGazeSpinAttack(player, sat, sat.Position, spinAim:Rotated(180), save, migraine, 1.0, isBinaba)
                d.binabaCuttingGazeSpinAttack = { EntityPtr(spin1), EntityPtr(spin2) }
            end

            d.binabaCuttingGazeHoldTime = nil
            d.binabaShadowGazeHoldTime = nil

            if d.binabaSpawnedFetus and d.binabaSpawnedFetus:Exists() then
                mod:GetEntityData(d.binabaSpawnedFetus).binabaRocketActive = true
				for _, targ in ipairs(mod:GetEntityData(d.binabaSpawnedFetus).StoredBeeSkinTargets or {}) do
					mod:GetEntityData(targ).binabaRocketActive = true
				end
                d.binabaSpawnedFetus = nil
            end
            if hasLudo then
                local intendedVec = unclampedShootInput * player.MoveSpeed * 8
                d.binabaCuttingGazeVelocity = mod:Lerp(d.binabaCuttingGazeVelocity or mod.nilvector, intendedVec, 0.2)
                d.binabaCuttingGazeHoldPoint = game:GetRoom():GetClampedPosition(d.binabaCuttingGazeHoldPoint + d.binabaCuttingGazeVelocity, 0)
                satTarg = d.binabaCuttingGazeHoldPoint
            elseif d.binabaCuttingGazeHoldPoint:Distance(satTarg) > 30 then
                d.binabaCuttingGazeVelocity = d.binabaCuttingGazeVelocity or Vector.Zero
                local intendedVec = (satTarg + player.Velocity * 2) - d.binabaCuttingGazeHoldPoint
                if intendedVec:Length() > mod.InabaBal.B_CuttingGazeMaxSpeed then
                    intendedVec = intendedVec:Resized(mod.InabaBal.B_CuttingGazeMaxSpeed)
                end
                d.binabaCuttingGazeVelocity = mod:Lerp(Vector.FromAngle(intendedVec:GetAngleDegrees()) * d.binabaCuttingGazeVelocity:Length(), intendedVec, mod.InabaBal.B_CuttingGazeLerpSpeed)
                d.binabaCuttingGazeHoldPoint = d.binabaCuttingGazeHoldPoint + d.binabaCuttingGazeVelocity
                satTarg = d.binabaCuttingGazeHoldPoint

                if d.binabaCuttingGazeSpinAttack then
                    local pos = d.binabaCuttingGazeHoldPoint + RandomVector() * mod:RandomFloat(20, 40)
                    local vel = mod.nilvector
                    local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, pos, vel, player):ToEffect()
					local trailSprite = trail:GetSprite()
                    trailSprite.PlaybackSpeed = 0.5
                    trail.SpriteScale = Vector.One * mod:Lerp(0.2, 0.4, mod:RandomFloat())
					trailSprite:ReplaceSpritesheet(0, "gfx/familiar/inabasatellite/tear_bloodytrail.png", true)
                    trail.PositionOffset = Vector(0, -20)
                    trail.Color = mod:GetInabaTearColor(true, nil, false, player.TearColor)
                    trail:Update()
                end
            else
                d.binabaCuttingGazeHoldPoint = nil
                d.binabaCuttingGazeVelocity = nil
            end
        end

        if d.binabaCuttingGazeSpinAttack and (ctrlHeld or not d.binabaCuttingGazeHoldPoint) then
            if not d.binabaCuttingGazeHoldPoint then
                for _, ptr in pairs(d.binabaCuttingGazeSpinAttack) do
                    local spin = mod:GetPointee(ptr)
                    if spin then spin:Remove() end
                end
            end
            d.binabaCuttingGazeSpinAttack = nil
        end

        local gameFrame = game:GetFrameCount()
        local numSatellites = #d.InabaSatellites

        -- Handle making the satellites rotate around the player
        local targetSatelliteRotationSpeed = 0

        --[[if isBerserk then
            targetSatelliteRotationSpeed = 10
        else]]if migraine and hasSpiritSword and not blockBinabaFromMigraine then
            targetSatelliteRotationSpeed = 10
        elseif hasBrimstone and not blockBinabaFromMigraine then
            local maxDelay = (player.MaxFireDelay + 1) * mod.InabaBal.SatelliteMiniBrimstoneDelayMult
            if migraine and shootLength > 0.1 then
                targetSatelliteRotationSpeed = mod:Lerp(d.satelliteRotationSpeed or 0, 20 + 6 * math.max((4 - numSatellites) / numSatellites, 0), 0.2)
            else
                targetSatelliteRotationSpeed = math.min(360 / maxDelay, 20)
            end
        end

        if targetSatelliteRotationSpeed > 0 then
            d.satelliteRotationSpeed = mod:Lerp(d.satelliteRotationSpeed or 0, targetSatelliteRotationSpeed, 0.2)
            d.satelliteRotation = ((d.satelliteRotation or 0) + d.satelliteRotationSpeed) % 360
        else
            d.satelliteRotationSpeed = 0
            if (d.satelliteRotation or 0) > 0.1 then
                d.satelliteRotation = InabaLerpAngleDegrees(d.satelliteRotation or 0, 0, mod.InabaBal.SatelliteRotationSpeed * 0.5)
            else
                d.satelliteRotation = 0
            end
        end

        -- Check/handle core migraine brimstone laser firing.
        HandleMigraineBrimstone(player, d, save, satelliteAim, markTarg, shootLength > 0.1, hasBrimstone, migraine, powerLevel, isBinaba)

        for _, sat in ipairs(d.InabaSatellites) do
            local satData = mod:GetEntityData(sat)
            local index = satData.SatelliteOffset / (360/numSatellites)
            local satSprite = sat:GetSprite()

            local satAim = satelliteAim
            if shootLength < 0.1 and satData.SwordFlurry then
                satAim = satData.SwordFlurry.Dir
            --[[elseif isBerserk then
                if not satData.BerserkingBaseAim then
                    satData.BerserkingBaseAim = satAim
                else
                    satAim = satData.BerserkingBaseAim
                end]]
            elseif satData.BerserkingBaseAim then
                satData.BerserkingBaseAim = nil
            end

            local targetAngle = satAim:GetAngleDegrees() + (d.satelliteRotation or 0)
            if migraine and not unicornActive and not hasSpiritSword and not isBerserk and not hasBrimstone and not blockBinabaFromMigraine then
                targetAngle = targetAngle + satData.MigraineOffset
            else
                targetAngle = targetAngle + satData.SatelliteOffset
            end
            satData.CurrentAngle = InabaLerpAngleDegrees(satData.CurrentAngle, targetAngle, mod.InabaBal.SatelliteRotationSpeed) % 360

            local satVec = (Vector.FromAngle(satData.CurrentAngle) * mod.InabaBal.SatelliteDistance)
            if unicornActive then --Tuck in closer with my little unicorn
                satVec = satVec * mod.InabaBal.SatelliteUnicornDistMult
            elseif d.binabaCuttingGazeHoldPoint then
                satVec = satVec * mod.InabaBal.B_CuttingGazeDistMult
            elseif not isBinaba and mod:InabaHasWeaponType(player, WeaponType.WEAPON_MONSTROS_LUNGS) and not player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
                satVec = satVec * mod.InabaBal.SatelliteLungDistMult
            end

            local targetPos = satTarg + satVec
            local targetLerpStrength = 0.95

            -- shadow satellites remain stationary
            if sat.SubType == mod.InabaBal.ShadowSatelliteSub and d.shadowGazePosition then
                local moveDist = d.shadowGazePosition:Distance(sat.Position)
                if sat.FrameCount > 1 and d.shadowGazePosition:Distance(sat.Position) > 40 then
                    local amount = moveDist // 70
                    for i = 1, amount do
                        local afterimagePos = mod:Lerp(sat.Position, d.shadowGazePosition, i / amount)
                        mod:CreateShadowSatelliteAfterimage(sat, afterimagePos, RandomVector():Resized(0.5))
                    end
                end
                targetPos = d.shadowGazePosition
            end

            -- Check if migraine sword attack should end
            if satData.SwordFlurry then
                satData.SwordFlurry.Timer = satData.SwordFlurry.Timer - 1
                if not migraine or (satData.SwordFlurry.Timer <= 0 and shootLength <= 0.1) then
                    satData.SwordFlurry = nil
                    satData.FireDelay = player.MaxFireDelay
                end
            end

            -- Handle movement for migraine sword
            if migraine and hasSpiritSword and (shootLength > 0.1 or satData.SwordFlurry) and not isBinaba then
                local swordAttackFrame, swordAttackInterval = GetSwordFlurryFrameData(player, index, numSatellites)
                local t = gameFrame % swordAttackInterval - swordAttackFrame
                local chargeForwardIntensity = 2 * math.ceil(numSatellites / 2)
                local chargeForwardDistance = 40 * math.cos(math.pi * t / swordAttackInterval) ^ (2*chargeForwardIntensity)
                local swordAttackDir = satData.SwordFlurry and satData.SwordFlurry.Dir or shootInput
                targetPos = satTarg + (satVec * Vector(0.25 + 0.15 * math.sin(2 * math.pi * gameFrame / 60), 0.2 + numSatellites / 7) + Vector(chargeForwardDistance, 0)):Rotated(swordAttackDir:GetAngleDegrees()) + swordAttackDir:Resized(35)
                targetLerpStrength = 0.65
            end

            -- Handle targetPos/PositionOffset for migraine brimstone visuals
            if migraine and not isBinaba and hasBrimstone then
                local dir = shootLength > 0.1 and shootInput or satAim
                targetPos = satTarg + (satVec * Vector(0, 0.6)):Rotated(dir:GetAngleDegrees()) + dir:Resized(35)
                satData.TargetPositionOffset = Vector(0, -10 + 20 * math.sin(2 * math.pi * ((targetAngle + 90) % 360) / 360))
                targetLerpStrength = 0.65
            else
                satData.TargetPositionOffset = mod.nilvector
            end

            -- Snap directly to the targetPos on init, or if the Position/Velocity somehow break.
            if sat.FrameCount == 0 or not (sat.Position.X == sat.Position.X) then
                sat.Position = targetPos
                sat.Velocity = mod.nilvector
            end

            -- We are three lerps deep
            satData.LerpStrength = mod:Lerp(math.min(satData.LerpStrength or targetLerpStrength, targetLerpStrength), targetLerpStrength, 0.1)
            sat.Velocity = mod:Lerp(sat.Velocity, mod:Lerp(sat.Position, targetPos, mod.InabaBal.SatellitePositionSpeed) - sat.Position, satData.LerpStrength)

            --FireDelay cooldown
            if satData.FireDelay > 0 then
                if ocularSpectrumActive then
                    satData.FireDelay = satData.FireDelay - 2
                else
                    satData.FireDelay = satData.FireDelay - 1
                end
            end

            --When player has quadshot/inner eye, make eyes shoot offset
            --This only really affects normal Inaba
            local orderMode = (player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER))
            local orderModeTime
            if orderMode then
                local fireTime = (index + 1)/(numSatellites + 2) * player.MaxFireDelay
                local fireDelay = math.max(0, player.FireDelay)
                orderModeTime = math.floor(fireDelay) == math.floor(fireTime)
            end

            local fireAim
            if markTarg then
                fireAim = (markTarg.Position - sat.Position)
            elseif unicornActive then
                fireAim = satVec
            elseif satData.SwordFlurry then
                fireAim = satData.SwordFlurry.Dir
            elseif isBerserk then
                fireAim = Vector.FromAngle(satData.CurrentAngle)
            elseif hasSpiritSword then
                fireAim = satelliteAim:Rotated(satData.SatelliteOffset)
            else
                fireAim = satAim
            end

            -- check if nearby enemies
            -- if so, do a new fireaim
            if sat.SubType == mod.InabaBal.ShadowSatelliteSub then
                local enemies = Isaac.FindInRadius(sat.Position, mod.InabaBal.ShadowSatelliteRange, EntityPartition.ENEMY)
                local closestDist, closestEnt
                for _, ent in ipairs(enemies) do
                    local npc = ent:ToNPC()
                    if npc and npc:IsVulnerableEnemy() and npc:IsActiveEnemy() then
                        if not closestDist then
                            closestDist = npc.Position:DistanceSquared(sat.Position)
                            closestEnt = npc
                        else
                            local dist = npc.Position:DistanceSquared(sat.Position)
                            if dist < closestDist then
                                closestDist = dist
                                closestEnt = npc
                            end
                        end
                    end
                end

                -- only change aim direction if they were already firing
                if closestEnt and fireAim:Length() > 0.1 then
                    fireAim = (closestEnt.Position - sat.Position)
                end
            end

            if isBinaba then
                --Ocular spectrum or unicorn
                local shouldHaveUnicornKnife
                local shouldHaveHoldPointKnife
                if player:HasWeaponType(WeaponType.WEAPON_KNIFE)
                --C Section check becuase otherwise the knife keeps despawning
                and not player:HasWeaponType(WeaponType.WEAPON_FETUS) then
                    if unicornActive then
                        shouldHaveUnicornKnife = true
                        if not satData.inabaKnife
                        or (satData.inabaKnife and not satData.inabaKnife:Exists())
                        then
                            satData.inabaKnife = player:FireKnife(sat)
                            satData.inabaKnife.Parent = sat
                            satData.inabaKnife.Rotation = fireAim:GetAngleDegrees()
                            satData.inabaKnife:Update()
                        end
                        if satData.inabaKnife then
                            satData.inabaKnife.Rotation = fireAim:GetAngleDegrees()
                        end
                    --Overridden by ocular spectrum basically
                    else
                        if d.binabaCuttingGazeHoldPoint then
                            shouldHaveHoldPointKnife = true
                            if (not satData.holdPointKnife)
                            or (satData.holdPointKnife and not satData.holdPointKnife:Exists())
                            then
                                satData.holdPointKnife = player:FireKnife(sat)
                                satData.holdPointKnife.Parent = sat
                                satData.holdPointKnife.Rotation = fireAim:GetAngleDegrees()
                                satData.holdPointKnife:Update()
                            end
                            if satData.holdPointKnife then
                                if not satData.holdPointKnifeRotationDirection then
                                    if fireAim.X < -0.5 then
                                        satData.holdPointKnifeRotationDirection = -1
                                    elseif fireAim.X > 0.5 then
                                        satData.holdPointKnifeRotationDirection = 1
                                    elseif player.Velocity.X < -0.5 then
                                        satData.holdPointKnifeRotationDirection = -1
                                    else
                                        satData.holdPointKnifeRotationDirection = 1
                                    end
                                end
                                local rot = 30
                                rot = rot * satData.holdPointKnifeRotationDirection
                                satData.holdPointKnife.Rotation = satData.holdPointKnife.Rotation + rot
                                satData.holdPointKnife:Update()
                            end
                        end
                    end
                end

                if not shouldHaveUnicornKnife then
                    if satData.inabaKnife then
                        if satData.inabaKnife:Exists() then
                            satData.inabaKnife:Remove()
                        end
                        satData.inabaKnife = nil
                    end
                end
                if not shouldHaveHoldPointKnife then
                    satData.holdPointKnifeRotationDirection = nil
                    if satData.holdPointKnife then
                        if satData.holdPointKnife:Exists() then
                            satData.holdPointKnife:Remove()
                        end
                        satData.holdPointKnife = nil
                    end
                end

            end

            --Where should the tears actually fire from, regarding the eye
            --Put in place to fix tears always starting from below inaba when fired from a standstill
            local satFirePos = targetPos
            if d.binabaCuttingGazeHoldPoint then --Binaba
                satFirePos = sat.Position
            end

            --Satellite shooting handling
            satData.ShootFrameDelay = satData.ShootFrameDelay - 1

            --Check so charge doesn't get lost if still holding while hurt
            local inabaBeenHurt = player:GetSprite():IsPlaying("Hit")
            local extraAnimDone = player:IsExtraAnimationFinished()

            local canFire

            local isChargeWeaponReady
            if isChargeWeapon then
                --How long does the player have to charge?
                local chargeDelay = player.MaxFireDelay * chargeWeaponMult
                if migraine and not isBinaba then
                    chargeDelay = chargeDelay * mod.InabaBal.MigraineSatelliteFireDelayMult
                end
                satData.chargeBuildup = satData.chargeBuildup or 0
                satData.chargeBuildupPercent = satData.chargeBuildupPercent or 0
                --Is player trying to shoot
                if (shootLength > 0.1 and not usingStoredCharge) then
                    satData.chargeBuildup = math.min(satData.chargeBuildup + 1, chargeDelay)
                    satData.chargeBuildupPercent = satData.chargeBuildup / chargeDelay
                    if (markTarg or chargeWeapon.AutoFiresWhenFull) and satData.chargeBuildup >= chargeDelay then
                        canFire = true
                    end
                --Animations don't break your charge
                elseif extraAnimDone and not ocularSpectrumActive then
                    if satData.chargeBuildup >= chargeDelay --Fully charged
                    or (chargeWeapon.ChocolateMilk and satData.chargeBuildup > 0) --Choco milk lets you fire anytime
                    or (chargeWeapon.CursedEye and satData.chargeBuildupPercent >= 0.19) --Cursed eye lets you fire at those 20% intervals
                    or (chargeWeapon.TechX and satData.chargeBuildupPercent >= 1/3) --Tech X lets you fire starting at 1/3rd charge
                    then
                        canFire = true
                    else
                        if not d.storedSatelliteCursedEyeShots then
                            d.storedSatChargeTimer = nil
                            d.storedSatChargeDir = nil
                        end
                        satData.chargeBuildup = 0
                        satData.chargeBuildupPercent = 0
                    end
                end
            --Normal weapons / Forced by kidney stone / unicorn
            else
                if not ocularSpectrumActive then
                    satData.chargeBuildup = 0
                    satData.chargeBuildupPercent = 0
                end
                if (shootLength > 0.1 or unicornActive or isKidneyStoneFiring) then
                    if (satData.FireDelay <= 0 or orderModeTime) then
                        canFire = true
                    end
                end
            end
            --Force blocked by kidney stone needing to charge
            if isKidneyStoneCharging then
                canFire = false
            elseif d.storedSatelliteCursedEyeShots then
                canFire = true
            end

            if migraine and hasSpiritSword and not isBinaba then
                local swordAttackFrame, swordAttackInterval = GetSwordFlurryFrameData(player, index, numSatellites)
                local isCorrectFrame = (gameFrame + 3) % swordAttackInterval == swordAttackFrame
                canFire = (shootLength > 0.1 and not satData.SwordFlurry) or (satData.SwordFlurry and isCorrectFrame)
                if canFire and shootLength > 0.1 then
                    satData.SwordFlurry = {
                        Timer = 15,
                        Dir = shootInput,
                    }
                end
            end

            local brimstoneCharging = false
            if hasBrimstone and not isBinaba then
                if migraine then
                    -- Migraine brimstone is one laser, handled separately.
                    canFire = false
                else
                    -- Standard satellite brimstones are fired based on their rotation, when they reach the front.
                    -- Should be roughly aligned with fire rate though.
                    local brimCurrentAngle = (targetAngle - satAim:GetAngleDegrees()) % 360
                    local brimBuffer = math.min((d.satelliteRotationSpeed or 0) * 6, 90)
                    local isValidFrame = brimCurrentAngle <= brimBuffer or brimCurrentAngle >= 360 - brimBuffer
                    brimstoneCharging = shootLength > 0.1 and not isValidFrame
                    canFire = canFire and isValidFrame
                end
            end

            local canFireCallbackRet = Isaac.RunCallback(mod.CALLBACK.SATELLITE_EVALUATE_CAN_SHOOT, player)
            if canFireCallbackRet == true then
                canFire = nil
            end

            if canFire and not PreventSatelliteShooting(player) then
                local maxDelay = player.MaxFireDelay
                if ocularSpectrumActive then
                    maxDelay = maxDelay / 5
                end
                --EYE DROPS AAAAAAAAAAAAAAAAAAAAAAA
                --Not quite how the item works but honestly fuck it
                if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_DROPS) then
                    save.EyeDropMult = save.EyeDropMult or 1
                    save.EyeDropMult = (save.EyeDropMult - 0.4) % 1
                    if save.SecondEyeShot then
                        maxDelay = maxDelay * save.EyeDropMult
                    end
                end
                if hasBrimstone and not isBinaba then
                    -- Not the whole delay, leaves a little buffer since fire rate is tied to rotation speed too.
                    maxDelay = maxDelay * mod.InabaBal.SatelliteMiniBrimstoneDelayMult * 2 / 3
                end
                if migraine and not isBinaba then
                    maxDelay = maxDelay * mod.InabaBal.MigraineSatelliteFireDelayMult
                end
                if not isBinaba and player:HasWeaponType(WeaponType.WEAPON_TECH_X) then
                    maxDelay = maxDelay * (migraine and 1.5 or 2)
                end
                --satData.FireDelay = satData.FireDelay + maxDelay + 1
                satData.FireDelay = maxDelay + 1
                satData.ShootFrameDelay = math.min(2, maxDelay / 2)
                if isBinaba and not d.binabaCuttingGazeHoldPoint then
                    mod:UpdatePlayerHeadDirection(player, math.floor(satData.FireDelay), true)
                end
                --Storing to use for Chocolate Milk
                if not d.storedSatelliteCursedEyeShots then
                    save.storedChocolateMilkChargePercent = nil --Clearing to be safe
                    save.storedTechXChargePercent = nil
                end
                if satData.chargeBuildupPercent and satData.chargeBuildupPercent > 0 then
                    if chargeWeapon.ChocolateMilk then
                        save.storedChocolateMilkChargePercent = satData.chargeBuildupPercent
                    end
                    if chargeWeapon.TechX then
                        save.storedTechXChargePercent = satData.chargeBuildupPercent
                    end
                    if chargeWeapon.CursedEye then
                        --This chocolate milk synergy is so wacky?
                        if chargeWeapon.ChocolateMilk then
                            if satData.chargeBuildupPercent >= 0.5 then
                                local curseEyeChocoCharge = (satData.chargeBuildupPercent - 0.5) * 2
                                d.storedSatelliteCursedEyeShots = math.floor(curseEyeChocoCharge * 5)
                            end
                        else
                            d.storedSatelliteCursedEyeShots = math.floor(satData.chargeBuildupPercent * 5)
                        end
                    end
                end
				local storedChargeBuildupPercent = satData.chargeBuildupPercent or 0
                if not ocularSpectrumActive then
                    satData.chargeBuildup = 0
                    satData.chargeBuildupPercent = 0
                    d.storedSatChargeTimer = 5
                end

                -- If you have soy/almond milk, regular Inaba has less shots (so it's not as spammy)
                local hasSoyOrAlmondMilk = not hasSpiritSword and not isBerserk
                        and (player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK))
                if isBinaba or (not hasSoyOrAlmondMilk or mod:RandomInt(1) == 0) then
                    --This is kinda dumb, if you have decap attack or scissors and player as a source, it frustratingly relocates what you fire
                    local decapScissorOffset = mod:GetShootPosThatRespectsDecapAttackAndScissors(player, player.Position, priorityHead, true)

                    CheckBinabaSecondEyeShot(player, save)

                    local weapon = player:GetWeapon(1)
                    local weaponType = weapon and weapon:GetWeaponType() or WeaponType.WEAPON_TEARS
                    local multiShotParams = player:GetMultiShotParams(weaponType)

                    local isMonstrosLung = chargeWeapon.MonstrosLung or (not isBinaba and mod:InabaHasWeaponType(player, WeaponType.WEAPON_MONSTROS_LUNGS))

                    local compensationMult = 1

                    -- Inaba's satellites "share" multishot, rather than up to quintupling the number of tears fired.
                    if not isBinaba and not hasBrimstone then
                        local numTears = multiShotParams:GetNumTears()

                        -- 20/20 has a special synergy.
                        local num2020s = math.max(player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20), 0)
                        if num2020s > 0 and not isMonstrosLung and not mod:InabaHasWeaponType(player, WeaponType.WEAPON_LASER) then
                            -- For each 20/20, fire an additional shot at a fraction of the shot speed (ie, 50% with one).
                            for i=1, num2020s do
                                mod:FireSatellite(player, sat, satFirePos, fireAim, save, migraine, i/(num2020s+1), decapScissorOffset, chargeWeapon, isBerserk)
                            end
                            -- Remove tears from the primary total that were added by 20/20.
                            local the2020penalty = num2020s
                            if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) then
                                the2020penalty = the2020penalty - 1
                            end
                            numTears = numTears - math.min(15, the2020penalty, numTears-1)
                        end

                        -- Reduce the tears gained by multishot, effectively splitting the extra tears among all satellites.
                        -- Extra shared multishot can still be gained via power level, if configured that way.
                        local sharedMultiShotMult = mod:Lerp(mod.InabaBal.SatelliteMinSharedMultiShot, mod.InabaBal.SatelliteMaxSharedMultiShot, (powerLevel-1) / 3)
                        numTears = 1 + (numTears-1) * sharedMultiShotMult / numSatellites
                        -- Convert decimal remainder into a % chance to add an additional tear (ie, 2.25 means 25% chance for 3, otherwise 2)
                        numTears = math.floor(numTears) + ((mod:RandomFloat() < (numTears % 1)) and 1 or 0)

                        -- Recalculate NumLanesPerEye, adjusting for Wiz.
                        local numEyes = multiShotParams:GetNumEyesActive()
                        local numTearsPerEye = numTears
                        if numEyes > 1 then
                            numTearsPerEye = math.min(math.ceil(numTears / numEyes), math.floor(16 / numEyes))
                            numTears = numTearsPerEye * numEyes
                        end

                        -- Adjust the spread angle to account for any removed tears.
                        local ratio = numTearsPerEye / multiShotParams:GetNumLanesPerEye()

                        -- Potentially add some damage as compensation for lost tears.
                        compensationMult = 1 + (1 - ratio) * mod.InabaBal.SatelliteMultiShotCompensation

                        -- Update the MultiShotParams
                        if mod:WeaponTypeCanChangeSpreadAngle(weaponType) then
                            multiShotParams:SetSpreadAngle(weaponType, multiShotParams:GetSpreadAngle(weaponType) * ratio)
                        end
                        multiShotParams:SetNumLanesPerEye(numTearsPerEye)
                        multiShotParams:SetNumTears(numTears)
                    end

					local secondaryFireWeaponType, secondaryFireWeaponModifiers, secondaryFireNumTears = nil, nil, 0
                    if isMonstrosLung then
                        local multiEyeAngle = multiShotParams:GetMultiEyeAngle()
                        local numEyes = multiShotParams:GetNumEyesActive()
                        for i=0, numEyes-1 do
                            local angle = (numEyes <= 1) and 0 or mod:Lerp(-multiEyeAngle, multiEyeAngle, i/(numEyes-1))
                            local bonusTears = (multiShotParams:GetNumLanesPerEye() - 1) * 2.4
                            secondaryFireWeaponType, secondaryFireWeaponModifiers = mod:FireSatellite(player, sat, satFirePos, fireAim:Rotated(angle), save, migraine, 1.0, decapScissorOffset, chargeWeapon, isBerserk, compensationMult, bonusTears)
							if secondaryFireWeaponType ~= nil then
                                secondaryFireNumTears = secondaryFireNumTears + 1
                            end
                        end
                    else
                        for i=0, multiShotParams:GetNumTears()-1 do
                            local posvel = player:GetMultiShotPositionVelocity(i, weaponType, fireAim:Normalized(), fireAim:Length(), multiShotParams)
                            --MAIN SHOOTING CODE IS HERE--
                            secondaryFireWeaponType, secondaryFireWeaponModifiers = mod:FireSatellite(player, sat, satFirePos + posvel.Position * 10, posvel.Velocity, save, migraine, 1.0, decapScissorOffset, chargeWeapon, isBerserk, compensationMult, 0)
							if secondaryFireWeaponType ~= nil then
                                secondaryFireNumTears = secondaryFireNumTears + 1
                            end
                        end
                    end

                    -- Mom's Eye & Loki's Horns
					-- note for future reference, secondary fire effects typically ignore these shots
                    local rotationalShots = {}
                    if multiShotParams:IsShootingBackwards() then
                        table.insert(rotationalShots, 180)
                    end
                    if multiShotParams:IsShootingSideways() then
                        table.insert(rotationalShots, 90)
                        table.insert(rotationalShots, -90)
                    end
                    for _, angle in pairs(rotationalShots) do
                        mod:FireSatellite(player, sat, satFirePos, fireAim:Rotated(angle), save, migraine, 1, decapScissorOffset, chargeWeapon, isBerserk)
                    end

                    if hasBrimstone then
                        if sat.SubType == mod.InabaBal.ShadowSatelliteSub then
                            sat:SetColor(Color(1,1,1,1,0.3,0.3,0.3),15,0,true,false)
                        else
							local color, hue = mod:GetInabaTearColor(isBinaba, sat, false, player.TearColor)

							color.R = color.R - 0.25
							color.G = color.G - 0.25
							color.B = color.B - 0.25

							local offset = convertToRGB({H = hue, S = 0.5, V = 0.3 * 255})
							color.RO = color.RO + offset.R / 255
							color.GO = color.GO + offset.G / 255
							color.BO = color.BO + offset.B / 255

							sat:SetColor(color,15,0,true,false)
                        end
                    end

                    --Shots that don't stack, only fire once
                    if isBinaba then
                        --Random eye sore tears
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and Random() % 3 == 0 then
                            for i = 1, mod:RandomInt(1, 3) do
                                mod:FireSatellite(player, sat, satFirePos, fireAim:Rotated(Random() % 360), save, migraine, 1, decapScissorOffset, chargeWeapon, isBerserk)
                            end
                        end
                        --Random Monstro's Lung shots, when the active weapon is not Monstro's Lung
                        if not chargeWeapon.MonstrosLung and player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
                            local angle = player:HasWeaponType(WeaponType.WEAPON_TECH_X) and 30 or 180
                            local techXCharge = save.storedTechXChargePercent
                            for i = 1, mod:RandomInt(3, 5) do
                                if techXCharge then
                                    save.storedTechXChargePercent = techXCharge * mod:RandomFloat(0.5, 1.0)
                                end
                                mod:FireSatellite(player, sat, satFirePos, fireAim:Rotated(mod:RandomFloat(-angle, angle)), save, migraine, 1, decapScissorOffset, chargeWeapon, isBerserk)
                            end
                            save.storedTechXChargePercent = techXCharge
                        end
                        --First ever use of DoZitEffect
						--im sorry isaac
                        --[[if player:HasCollectible(CollectibleType.COLLECTIBLE_LARGE_ZIT) then
                            local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_LARGE_ZIT)
                            if rng:RandomFloat() < 1/3 then
                                player:DoZitEffect(fireAim:Normalized())
                            end
                        end]]--

						local amount = secondaryFireNumTears
						if secondaryFireWeaponType == WeaponType.WEAPON_MONSTROS_LUNGS then
							amount = (player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) and 5) or 12
						end
						local params = {
							DoBasegameEffects = true,
							BinabaSatellite = sat,
							BinabaDamageMulti = calculateBinabaMultiplier(player, save),
							BinabaPower = save.Power,
							BinabaSecondEyeShot = save.SecondEyeShot,
							BinabaMigraine = migraine,
							BinabaOcularSpectrumSats = save.ocularSpectrumSats,
							BinabaOcularSpectrumBuff = save.ocularSpectrumSats and (save.ocularSpectrumBuff or 0) > 0,
							WeaponType = secondaryFireWeaponType,
							WeaponModifiers = secondaryFireWeaponModifiers,
							NumTears = secondaryFireNumTears
						}
						-- trying to match basegame values wherever possible
						if chargeWeapon.CSection or secondaryFireWeaponType == WeaponType.WEAPON_FETUS then
							params.WeaponCharge = math.ceil(storedChargeBuildupPercent * player.MaxFireDelay * 3)
						elseif secondaryFireWeaponType == WeaponType.WEAPON_SPIRIT_SWORD then
							params.WeaponCharge = nil
						elseif chargeWeapon.MonstrosLung or secondaryFireWeaponType == WeaponType.WEAPON_MONSTROS_LUNGS or (weaponModifiers or 0) & WeaponModifier.MONSTROS_LUNG ~= 0 then
							local chocolateMilkMult = (chargeWeapon.ChocolateMilk and 2.5) or 1
							if secondaryFireWeaponType == WeaponType.WEAPON_LASER then
								local cursedEyeMult = (chargeWeapon.CursedEye and 2) or 1
								params.WeaponCharge = math.floor(storedChargeBuildupPercent * (player.MaxFireDelay + 1) * 4.3 * cursedEyeMult * chocolateMilkMult)
							else
								params.WeaponCharge = math.ceil(storedChargeBuildupPercent * player.MaxFireDelay * chocolateMilkMult)
							end
						elseif secondaryFireWeaponType == WeaponType.WEAPON_BOMBS then
							params.WeaponCharge = nil
						elseif chargeWeapon.TechX or secondaryFireWeaponType == WeaponType.WEAPON_TECH_X then
							params.WeaponCharge = math.ceil(storedChargeBuildupPercent * player.MaxFireDelay * 3)
						elseif chargeWeapon.Brimstone or secondaryFireWeaponType == WeaponType.WEAPON_BRIMSTONE then
							params.WeaponCharge = math.ceil(storedChargeBuildupPercent * player.MaxFireDelay * ((chargeWeapon.ChooolateMilk and 2.5) or 1))
						elseif secondaryFireWeaponType == WeaponType.WEAPON_LASER or secondaryFireWeaponType == WeaponType.WEAPON_TEARS then
							if chargeWeapon.ChocolateMilk then
								params.WeaponCharge = (params.WeaponCharge or player.MaxFireDelay) * 2.5 + 1.5
							end
							if chargeWeapon.CursedEye then
								params.WeaponCharge = (params.WeaponCharge or player.MaxFireDelay) * 2 + 1
							end
						end
						if params.WeaponCharge then
							params.WeaponCharge = math.max(1, params.WeaponCharge)
						end
						mod:SecondaryFire(player, fireAim:Normalized(), amount, sat, params)
						if params.WeaponType == WeaponType.WEAPON_BRIMSTONE then
							mod:fireBeeSkinBrimstone(player, 9, 1,
								{BinabaSatellite = sat,
								 BinabaDamageMulti = params.BinabaDamageMulti,
								 BinabaPower = save.Power,
								 BinabaMigraine = migraine,
								 BinabaOcularSpectrumSats = save.ocularSpectrumSats}
							)
						end
                    end
                end
                --Post fire everything
                if not d.storedSatelliteCursedEyeShots then
                    save.storedChocolateMilkChargePercent = nil
                    save.storedTechXChargePercent = nil
                end
            end

            local satCharge = satData.chargeBuildupPercent

            local anim
            if satData.ShootFrameDelay >= -1
            and not player:HasCollectible(mod.ITEM.COLLECTIBLE.EMPTY_GAZE)
            and not hasBrimstone
            then
                anim = "Shoot"
            elseif (satCharge and satCharge > 0) or inabaBeenHurt or brimstoneCharging then
                anim = "Pained"
            else
                anim = "Idle"
            end
            local usedVec = fireAim
            if d.storedSatChargeDir then
                usedVec = d.storedSatChargeDir
            end

            local dir
            if d.binabaCuttingGazeSpinAttack then
                dir = "Down"
            elseif shootLength < 0.1 and not (unicornActive or d.storedSatChargeDir or satData.SwordFlurry) then
                if sat.SubType == mod.InabaBal.ShadowSatelliteSub and player:GetHeadDirectionLockTime() <= -1 then
                    dir = directionToDir[Direction.DOWN]
                else
                    local headDir = player:GetHeadDirection()
                    dir = directionToDir[headDir]
                end
            else
                if math.abs(usedVec.X) > math.abs(usedVec.Y) then
                    if usedVec.X > 0 then
                        dir = "Right"
                    else
                        dir = "Left"
                    end
                else
                    if usedVec.Y < 0 then
                        dir = "Up"
                    else
                        dir = "Down"
                    end
                end
            end
            satSprite:Play(anim .. dir, false)
            --Sat gets bigger the more power you have as binaba
            if isBinaba then
                local layer = satSprite:GetLayer(0)
                if layer then
                    local offset = Vector.Zero
                    if power >= 400 then
                        offset = Vector(192, 0)
                    elseif power >= 200 then
                        offset = Vector(96, 0)
                    end
                    layer:SetCropOffset(offset)
                end
            end

            if isChargeWeapon and satCharge then
                if sat.SubType == mod.InabaBal.ShadowSatelliteSub then
                    sat:SetColor(Color(1 - (satCharge * 0.25),1 - (satCharge * 0.25),1 - (satCharge * 0.25),1,satCharge * 0.15,satCharge * 0.15,satCharge * 0.15),2,1,false,false)
                else
					local color, hue = mod:GetInabaTearColor(isBinaba, sat, false, player.TearColor)

					color.R = color.R - satCharge * 0.25
					color.G = color.G - satCharge * 0.25
					color.B = color.B - satCharge * 0.25

					local offset = convertToRGB({H = hue, S = 0.5, V = 0.3 * 255})
					color.RO = color.RO + satCharge * offset.R / 255
					color.GO = color.GO + satCharge * offset.G / 255
					color.BO = color.BO + satCharge * offset.B / 255

                    sat:SetColor(color,2,1,false,false)
                end
            end

            if isBinaba and migraine and sat.FrameCount % 5 == 1 then
                local emberParticle = Isaac.Spawn(1000,66, 0, sat.Position + Vector(0, -30), Vector(0,-mod:Random(4,7)):Rotated(-35 + mod:Random(70)), sat):ToEffect()

                if sat.SubType == mod.InabaBal.ShadowSatelliteSub then
                    emberParticle.Color = Color(0,0,0,1)
                else
                    --emberParticle.Color = Color(0.5,0.5,0.5,1,0.5,-0.5,-0.5)
                    local col = Color(1,1,1,1)
                    col:SetColorize(1.0, 0.3, 0.4, 1.0)
                    emberParticle.Color = col
                end

                emberParticle:Update()
            end
        end

        --Cursed eye stuff
        if d.storedSatelliteCursedEyeShots then
            d.storedSatelliteCursedEyeShots = d.storedSatelliteCursedEyeShots - 1
            if d.storedSatelliteCursedEyeShots <= 0 then
                d.storedSatelliteCursedEyeShots = nil
            end
        end

        --Inaba Exclusives
        --She will get NO black hearts, only soul hearts.
        if isEitherInaba then
            if player:GetBlackHearts() > 0 then
                --TLBH should handle this by itself
                if not player:HasCollectible(mod.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART) then
                    for i = 1, player:GetSoulHearts(), 2 do
                        if player:IsBlackHeart(i) then
                            player:RemoveBlackHeart(i-1)  -- Why is IsBlackHeart 1-indexed and RemoveBlackHeart 0-indexed, hello?
                        end
                    end
                end
            end

            --Little cosmetic thing
            local sprite = player:GetSprite()
            if sprite:IsPlaying("Happy") and sprite:GetFrame() == 5 then
                if not d.fientWhipcracked then
                    sfx:Play(mod.Sounds.FingerSnapCool, 1, 0, false, mod:RandomInt(80,120)/100)
                    d.fientWhipcracked = true
                end
            elseif sprite:IsPlaying("Sad") and sprite:GetFrame() == 1 then
                sfx:Play(mod.Sounds.StretchEye, 0.3, 0, false, mod:RandomInt(270,330)/100)
                if not d.fientWhipcracked then
                    d.fientWhipcracked = true
                end
            else
                d.fientWhipcracked = false
            end
        end
    end
end)

function mod:CreateShadowSatelliteAfterimage(sat, position, vec)
    vec = vec or RandomVector():Resized(1.5)
    local afterimage = Isaac.Spawn(mod.FF.GenericAfterimage.ID, mod.FF.GenericAfterimage.Var, mod.FF.GenericAfterimage.Sub, position, vec, sat):ToEffect()
    mod:GetEntityData(afterimage).customAfterimageData = {
        timeout = 6, color = Color(1, 1, 1, 1), fade = true, sprite = sat:GetSprite(),
        spritesheet = {{num = 0, file="gfx/familiar/inabasatellite/inabab_satellite_shadow.png"}},
    }
    afterimage.Parent = sat
    afterimage.DepthOffset = -100
    afterimage:Update()
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, sat)
    local player = sat.Player
    if player and mod:isBinaba(player) then
        local suffix = sat.SubType == 1 and "_shadow" or ""
        sat:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/inabasatellite/inabab_satellite" .. suffix .. ".png", true)

        local d = mod:GetEntityData(player)
        if d.shadowGazePosition then
            sat.Position = d.shadowGazePosition


        end
    end
end, inabaSatellite)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, sat)
    sat:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    sat.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    sat.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	if sat.SubType == mod.InabaBal.ShadowSatelliteSub then
		if sat.Player:IsDead() then
			sat.Color = Color(1,1,1, sat.Color.A - 0.1)
			sat.Velocity = sat.Velocity * 0.8
			if sat.Color.A < 0 then
				sat:Remove()
			end
		else
			sat.Color = Color()
		end
	else
		if sat.Player:IsDead() then
			local color = mod:GetInabaTearColor(mod:isBinaba(sat.Player), sat, false, sat.Player.TearColor)
			color.A = sat.Color.A - (color.A * 0.1)
			sat.Color = color
			sat.Velocity = sat.Velocity * 0.8
			if sat.Color.A < 0 then
				sat:Remove()
			end
		else
			sat.Color = mod:GetInabaTearColor(mod:isBinaba(sat.Player), sat, false, sat.Player.TearColor)
		end
	end
    sat.Visible = not HideSatellites(sat.Player)

    if sat.SubType == mod.InabaBal.ShadowSatelliteSub then
        if sat.FrameCount % 3 == 0 then
            mod:CreateShadowSatelliteAfterimage(sat, sat.Position)
        end
    end
end, inabaSatellite)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, function(_, sat)
    if not game:IsPaused() then
        sat.PositionOffset = mod:Lerp(sat.PositionOffset, mod:GetEntityData(sat).TargetPositionOffset or mod.nilvector, 0.5)
    end
end, inabaSatellite)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, function(_, sat)
    sat:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end, inabaSatellite)

local chargeBarSprite = Sprite()
chargeBarSprite:Load("gfx/chargebar.anm2", true)
chargeBarSprite.PlaybackSpeed = 0.5
chargeBarSprite.Scale = mod.InabaBal.SatelliteChargeBarScale

local shadowGazeChargeBarSprite = Sprite()
shadowGazeChargeBarSprite:Load("gfx/ui/chargebars/chargebar_cutting_gaze.anm2", true)
shadowGazeChargeBarSprite.PlaybackSpeed = 0.5
shadowGazeChargeBarSprite.Scale = mod.InabaBal.SatelliteChargeBarScale

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
    if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then return end
    if not mod:isBinaba(player) then return end
    local pdata = mod:GetEntityData(player)
    local sats = pdata.InabaSatellites
    if not sats then return end
    local sat = mod:BinabaGetPrimarySatellite(sats)
    if not sat or not sat:Exists() or not sat.Visible then return end

    local data = mod:GetEntityData(sat)
    local charge = (data.chargeBuildupPercent or 0) * 100
    if charge > 0 then
        if charge < 100 then
            chargeBarSprite:SetFrame("Charging", math.floor(charge))
        else
            chargeBarSprite:Play("Charged", false)
            if not game:IsPaused() then
                chargeBarSprite:Update()
            end
        end
        chargeBarSprite:Render(Isaac.WorldToScreen(sat.Position + mod.InabaBal.SatelliteChargeBarOffset))
    end

    if pdata.binabaCuttingGazeHoldTime then
        local maxCharge = mod:GetBinabaCuttingGazeChargeTime(player)
        local charge = math.min(pdata.binabaCuttingGazeHoldTime / maxCharge, 1.0) * 100
        if charge > 0 then
            local hasBirthright = player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            local targetSprite = shadowGazeChargeBarSprite
            if charge < 100 then
                local targetAnim = hasBirthright and "Charging1Birthright" or "Charging1"
                targetSprite:SetFrame(targetAnim, math.floor(charge))
            else
                if hasBirthright then
                    local secondCharge = math.min(pdata.binabaShadowGazeHoldTime / mod:GetBinabaShadowGazeChargeTime(player), 1.0) * 100
                    if secondCharge < 100 then
                        targetSprite:SetFrame("Charging2", math.floor(secondCharge))
                    else
                        targetSprite:Play("Charged2", false)
                        if not game:IsPaused() then
                            targetSprite:Update()
                        end
                    end
                else
                    targetSprite:Play("Charged1", false)
                    if not game:IsPaused() then
                        targetSprite:Update()
                    end
                end
            end

            targetSprite:Render(Isaac.WorldToScreen(sat.Position + mod.InabaBal.B_CuttingGazeChargeBarOffset))
		end
    end
end)

-- Allow use regardless of current charge
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, CallbackPriority.IMPORTANT, mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM, function(_, slot, player, current)
    return 30
end, mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM)

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, item, rng, player, flags, slot)
    local data = mod:GetEntityData(player)
    if flags & UseFlag.USE_CARBATTERY ~= 0 then
        return false
    elseif flags & UseFlag.USE_VOID ~= 0 then
        --print("hi")
        data.binabaOcularSpectrumForce = 150
    elseif slot == ActiveSlot.SLOT_PRIMARY or slot == ActiveSlot.SLOT_SECONDARY then
        data.binabaOcularSpectrumSlot = slot
    elseif slot == ActiveSlot.SLOT_POCKET then
        data.binabaOcularSpectrumSlot = slot
    else
        data.binabaOcularSpectrumForce = 150
    end
    data.binabaOcularSpectrumCommitment = true
    return false
end, mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, flags, slot)
    mod:playerCheckM(player,mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM)
    return {Discharge = false, Remove = false, ShowAnim = false}
end, mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM)

mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, function(_, player, slot, offset, alpha, scale, chargeBarOffset)
	local sprite = game:GetHUD():GetChargeBarSprite()
	sprite:SetFrame("BarFull", 0)
	sprite:RemoveOverlay()
	local a = alpha * mod:Lerp(0.8, 1.0, 0.5 + 0.5 * math.sin(2 * math.pi * game:GetFrameCount() / 60))
	sprite.Color = Color(1,1,1,math.min(a, 1.0), 0,0,0, 0.95,0.6,0.3,1.5)
	local basedata = mod:GetEntityData(player)
	local data = basedata.ffsavedata
	local save = data.Inaba
	local maxCharge = player:GetActiveMaxCharge(slot)
	local chargePct = player:GetActiveCharge(slot) / maxCharge
	local buffedPct = math.min((save.ocularSpectrumBuff or 0) / maxCharge, 1.0)
	local total = 23
	local topOffset = total * (1-chargePct)
	local bottomOffset = total - topOffset - total * buffedPct
	local topLeftClamp = Vector(0, 3 + topOffset)
	local bottomRightClamp = Vector(0, 6 + bottomOffset)
	sprite:Render(chargeBarOffset, topLeftClamp, bottomRightClamp)
	sprite.Color = Color.Default
end, mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM)

local meterSprite = Sprite()
meterSprite:Load("gfx/ui/inaba_ui.anm2", true)
local meterIsBinaba = false

function mod.shouldRenderMigraineMeter(player, playerSlot)
	local basedata = mod:GetEntityData(player)
	local data = basedata.ffsavedata
	if data then
		local save = data.Inaba
		return save and (mod:isEitherInaba(player) or save.SoulOfInabaActive)
	end
end

-- How much the health bars moved between rep and rep+
local REPENTANCE_PLUS_OFFSETS = {
	[0] = Vector(0, 6),   -- P1
	[1] = Vector(-16, 6), -- P2
	[2] = Vector(0, 0),   -- P3
	[3] = Vector(-16, 0), -- P4
}

local function getHealthBarPos(player, playerSlot, numOtherHearts)
	local bottomRight = Game():GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442,286) -- thank-q stageapi
	local hudOffset = Options.HUDOffset * 10

	local esauFlipped = playerSlot == 4 -- P1's Esau when in the bottom right corner
	if esauFlipped and REPENTANCE_PLUS and CustomHealthAPI.PersistentData.NumOccupiedPlayerHUDs > 3 then
		-- In REP+ P1's Esau's health moves up under Jacob's if there are >3 occupied PlayerHUDs
		esauFlipped = false
	end

	local pos = Vector.Zero

	if playerSlot == -1 then -- Soulstones / Strawman / etc.
		pos = Isaac.WorldToScreen(player.Position) - Game():GetRoom():GetRenderScrollOffset() + Vector(-5 * (math.max(1, math.min(numOtherHearts, 6)) - 1), -30)
	elseif playerSlot == 4 and esauFlipped then -- P1's Esau when in the bottom right corner
		pos = Vector(bottomRight.X - 48 - math.floor(hudOffset * 1.6 + 0.5),
		             bottomRight.Y - 27 - math.floor(hudOffset * 1.2 + 0.5) / 2)
	elseif playerSlot % 4 == 0 then -- Player 1
		pos = Vector(48 + hudOffset * 2,
		             12 + math.floor(hudOffset * 2.4 + 0.5) / 2)
	elseif playerSlot % 4 == 1 then -- Player 2
		pos = Vector(bottomRight.X - 111 - math.floor(hudOffset * 2.4 + 0.5),
		             12 + math.floor(hudOffset * 2.4 + 0.5) / 2)
	elseif playerSlot % 4 == 2 then -- Player 3
		pos = Vector(58 + math.floor(hudOffset * 2.2 + 0.5),
		             bottomRight.Y - 27 - math.floor(hudOffset * 1.2 + 0.5) / 2)
	elseif playerSlot % 4 == 3 then -- Player 4
		pos = Vector(bottomRight.X - 119 - math.floor(hudOffset * 1.6 + 0.5),
		             bottomRight.Y - 27 - math.floor(hudOffset * 1.2 + 0.5) / 2)
	end

	if REPENTANCE_PLUS then
		local repPlusOffset = REPENTANCE_PLUS_OFFSETS[playerSlot]
		if playerSlot > 3 and not esauFlipped then  -- Esau, except P1's Esau when in the bottom right corner
			pos = pos + Vector(0, 34)
			repPlusOffset = REPENTANCE_PLUS_OFFSETS[playerSlot-4]
		end
		if repPlusOffset then
			pos = pos + repPlusOffset
		end
	end

	return pos, esauFlipped
end

local function renderHealth(sprite, player, playerSlot, i, renderOffset, numOtherHearts, extraOffset, bottomRightClamp)
	renderOffset = renderOffset or Vector.Zero
	extraOffset = extraOffset or Vector.Zero

	local numOtherHearts = math.max(numOtherHearts or 0, 1)
	local barPos, esauFlipped = getHealthBarPos(player, playerSlot, numOtherHearts)
	barPos = barPos + Vector(-8, -1.5)

	local heartDistanceX = CustomHealthAPI.Constants.HEART_PIXEL_WIDTH_DEFAULT
	local heartDistanceY = CustomHealthAPI.Constants.HEART_PIXEL_HEIGHT_DEFAULT

	if esauFlipped then
		heartDistanceX = -heartDistanceX
		extraOffset = Vector(-extraOffset.X, extraOffset.Y)
	end

	-- In REP+, co-op health bars are no longer rendered in rows of 3.
	local numColumns = 6
	if not REPENTANCE_PLUS and playerSlot ~= 0 and playerSlot ~= 4 then
		numColumns = 3
	end
	local heartOffset = Vector(heartDistanceX * (i % numColumns), heartDistanceY * math.floor(i / numColumns))
	sprite:Render(barPos + heartOffset + renderOffset + extraOffset, Vector.Zero, bottomRightClamp)
end

local function RenderPower(player, playerSlot, healthIndex, renderInfo, num)
    local small = num % 100
    local smallSecond = small % 10
    local smallFirst = (small - smallSecond) / 10
    local big = (num - small) / 100

    local bigFrame = 10 + big
    meterSprite:SetFrame("Numbers", bigFrame)

	local esauFlipped = playerSlot == 4 -- P1's Esau when in the bottom right corner
	if esauFlipped and REPENTANCE_PLUS and CustomHealthAPI.PersistentData.NumOccupiedPlayerHUDs > 3 then
		-- In REP+ P1's Esau's health moves up under Jacob's if there are >3 occupied PlayerHUDs
		esauFlipped = false
	end

	local extraOffset = renderInfo.ExtraOffset + mod.InabaBal.PowerOffset
	if esauFlipped then
		extraOffset.X = extraOffset.X * -1
	end
    renderHealth(meterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, extraOffset)

    extraOffset = extraOffset + Vector((esauFlipped and -26) or 26, 0)

    if num == 400 then
        meterSprite:SetFrame("Numbers", 15)
        renderHealth(meterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, extraOffset)
    else
        meterSprite:SetFrame("Numbers", smallFirst)
        renderHealth(meterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, extraOffset)

        extraOffset = extraOffset + Vector((esauFlipped and -5) or 5, 0)

        meterSprite:SetFrame("Numbers", smallSecond)
        renderHealth(meterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, extraOffset)

        extraOffset = extraOffset + Vector((esauFlipped and -5) or 5, 0)

        meterSprite:SetFrame("Numbers", 10)
        renderHealth(meterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, extraOffset)
    end
end

function mod.onRenderMigraineMeter(player, playerSlot, healthIndex, renderInfo)
	local basedata = mod:GetEntityData(player)
	local data = basedata.ffsavedata
	local save = data.Inaba

	meterSprite.Color = Color.Default
	if mod:isBinaba(player) then
		if not meterIsBinaba then
			meterSprite:ReplaceSpritesheet(0, "gfx/ui/inabab_ui.png")
			meterSprite:LoadGraphics()
			meterIsBinaba = true
		end
	else
		if meterIsBinaba then
			meterSprite:ReplaceSpritesheet(0, "gfx/ui/inaba_ui.png")
			meterSprite:LoadGraphics()
			meterIsBinaba = false
		end
	end

	for frame = 0, 2 do
		if frame == 0 then
			meterSprite.Color = mod.InabaBal.DropShadow
		else
			meterSprite.Color = Color.Default
		end

		meterSprite:SetFrame("Meter", frame)
		renderHealth(meterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset)
	end

	local fullLength = 96
	local barLength = 64
	local startLength = 3
	local cropX = fullLength - barLength - startLength
	save.MigraineGauge = save.MigraineGauge or 0
	local migrainePercent = save.MigraineGauge / mod.InabaBal.MigraineCap
	cropX = cropX + ((1 - migrainePercent) * barLength)

	local eyeFrame = 0
	if (not save.MigraineMode) then
		if (migrainePercent >= mod.InabaBal.MigraineTopPercent) then
			eyeFrame = 1
		end
	elseif (save.MigraineMode) then
		eyeFrame = 2
	end
	meterSprite.Color = mod.ColorNormal
	meterSprite:SetFrame("Eye", eyeFrame)
	renderHealth(meterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset)

	if (save.MigraineMode) then
        if meterIsBinaba then
		    meterSprite.Color = mod.InabaBal.B_MeterColorActive
        else
            meterSprite.Color = mod.InabaBal.MeterColorActive
        end
	else
        if meterIsBinaba then
		    meterSprite.Color = mod.InabaBal.B_MeterColor
        else
            meterSprite.Color = mod.InabaBal.MeterColor
        end
	end
	meterSprite:SetFrame("Meter", 3)
	renderHealth(meterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset, Vector(cropX, 0))

	meterSprite.Color = Color.Default

	RenderPower(player, playerSlot, healthIndex, renderInfo, math.floor(save.Power))
end

CustomHealthAPI.Library.RegisterBelowHealthIcon("MIGRAINE_METER",
	{SortOrder = 9999,
	 ShouldRenderFunc = mod.shouldRenderMigraineMeter,
	 OnRenderFunc = mod.onRenderMigraineMeter,
	 RowsUsed = 2,
	 IgnoreUnknownCurse = true,})

local function PickPowerItemTarget(pos, isLilInaba)
    local needsPower = {}
    local playerIsInaba = {}
    if not isLilInaba then
        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            if mod:isEitherInaba(player) then
                local basedata = mod:GetEntityData(player)
                local data = basedata.ffsavedata
                local save = data.Inaba
                if save then
                    if save.Power < 400 then
                        needsPower[#needsPower + 1] = player
                    end

                    playerIsInaba[#playerIsInaba + 1] = player
                end
            end
        end
    else
        for _, lilInaba in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.LIL_INABA)) do
            playerIsInaba[#playerIsInaba+1] = lilInaba
        end
    end

    local closest, closestDist, searching
    if #needsPower > 0 then
        searching = needsPower
    else
        searching = playerIsInaba
    end

    for _, player in ipairs(searching) do
        local dist = player.Position:Distance(pos)
        if not closest or dist < closestDist then
            closest = player
            closestDist = dist
        end
    end

    return closest, needsPower, playerIsInaba, closestDist
end

local function collectPower(eff, entity)
    local collide
    local colliderPower
    if eff.SubType < 2 then
        local count = mod.InabaBal.PowerValue
        if eff.SubType == 1 then
            count = mod.InabaBal.BigPowerValue
        end
        --Ugh
        local player = entity:ToPlayer()

        local basedata = mod:GetEntityData(player)
        local data = basedata.ffsavedata
        data.Inaba = data.Inaba or {}
        data.Inaba.Power = data.Inaba.Power or 100

        AddPower(player, count)

        colliderPower = data.Inaba.Power
        collide = true
    else --Lil Inaba
        local fam = entity:ToFamiliar()
        fam.Coins = fam.Coins + 1

        colliderPower = 100
        collide = true
    end

    if collide then
        local pitch = (50 + (colliderPower - 100)/3)/100
        sfx:Play(mod.Sounds.CollectInabaPower, 1, 0, false, pitch)
        eff.Velocity = eff.Velocity * 0.25
        local sprite = eff:GetSprite()
        sprite:Play("Collect", true)
        sprite.PlaybackSpeed = 1
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
    local sprite = eff:GetSprite()
    local d = mod:GetEntityData(eff)
    if eff.FrameCount == 1 then
        sprite.PlaybackSpeed = mod:RandomFloat(0.5, 3.0)
        if not d.Trail then
            local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, eff.Position, Vector.Zero, eff):ToEffect()
            trail.MinRadius = 0.24
            trail.SpriteScale = Vector(1.5,1)
            trail.Color = Color(0.5,0.1,0.1,0.5)
            trail.ParentOffset = eff.SpriteOffset
            trail:FollowParent(eff)
            d.Trail = trail
        end
    end
    if d.Trail then
        d.Trail.ParentOffset = eff.SpriteOffset + Vector(0,-25)
    end
    if sprite:GetAnimation() == "Collect" then
        if sprite:IsFinished() then
            eff:Remove()
        else
            eff.Velocity = eff.Velocity * 0.8
            if d.Trail then
                local colorA = d.Trail.Color.A
                colorA = mod:Lerp(colorA, 0, 0.5)
                d.Trail.Color = Color(d.Trail.Color.R, d.Trail.Color.G, d.Trail.Color.B, colorA)
            end
        end

        return
    end

    if sprite:IsFinished("AppearFast") or sprite:IsFinished("Appear") then
        sprite:Play("Idle", true)
    end

    eff.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

    local target, needsPower, isInaba, targetDist = PickPowerItemTarget(eff.Position, eff.SubType == 2)

    eff.Velocity = eff.Velocity * mod.InabaBal.PowerItemChaseFriction

    if game:GetRoom():GetType() == RoomType.ROOM_DUNGEON then
        eff.Velocity = eff.Velocity + Vector(0, 0.3)
    end

    if target then
        if targetDist < mod.InabaBal.PowerItemChaseDistance or game:GetRoom():IsClear() then
            eff.Velocity = eff.Velocity + (target.Position - eff.Position):Resized(mod.InabaBal.PowerItemChaseSpeed)
        end

        local collide
        local colliderPower
        if eff.SubType < 2 then
            for _, player in ipairs(isInaba) do
                if player.Position:DistanceSquared(eff.Position) < (player.Size + eff.Size) ^ 2 then
                    collectPower(eff, player)
                    break
                end
            end
        -- Lil Inaba
        else
            for _, familiars in ipairs(isInaba) do
                if familiars.Position:DistanceSquared(eff.Position) < (familiars.Size + eff.Size) ^ 2 then
                    collectPower(eff, familiars)
                    break
                end
            end
        end
    else
        sprite:Play("Collect", true)
        sprite.PlaybackSpeed = 1
    end
end, powerItem)

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, function()
    for _, orb in ipairs(Isaac.FindByType(1000, powerItem, -1, false, false)) do
        local target, needsPower, isInaba, targetDist = PickPowerItemTarget(orb.Position, orb.SubType == 2)
        collectPower(orb, target)
    end
end)

local function GetEnemies()
	local ents = Isaac.GetRoomEntities()
	local enemies = {}
	for _, ent in ipairs(ents) do
		if ent:IsActiveEnemy(false) and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM) then
			enemies[#enemies + 1] = ent
		end
	end

	return enemies
end

local powerItemsToSpawn
local powerItemsPerBoss
local doneBossThresholds = {}
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    powerItemsToSpawn = nil
    powerItemsPerBoss = nil
    doneBossThresholds = {}

    local isPlayerInaba, countInaba = mod:AnyInaba()
    for i = 1, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1)
        local d = mod:GetEntityData(player)
        local sdata = d.ffsavedata
        if mod:isEitherInaba(player) then
            d.inabapowerlost = nil
            --Clear Cutting Gaze data
            d.binabaCuttingGazeHoldPoint = nil
            d.binabaCuttingGazeVelocity = nil
            --Clear Shadow Gaze data if it exists
            if d.shadowGazePosition then
                d.shadowGazePosition = nil
                player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
            end
        end
        if sdata then
            local save = sdata.Inaba
            if save and save.MigraineStoredMantles then
                local tempEffects = player:GetEffects()
                tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                save.MigraineStoredMantles = tempEffects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
            end
        end
    end

    countInaba = #countInaba
    if isPlayerInaba then
        local room = game:GetRoom()
        local roomType = room:GetType()
        if room:IsFirstVisit() and not room:IsClear() then
            if roomType == RoomType.ROOM_BOSS then
                for _, v in ipairs(mod.InabaBal.PowerItemBossThresholds) do
                    doneBossThresholds[v] = false
                end

                powerItemsPerBoss = mod.InabaBal.PowerItemsPerBossThreshold * countInaba
                powerItemsToSpawn = powerItemsPerBoss * (#mod.InabaBal.PowerItemBossThresholds + 1)
            elseif roomType == RoomType.ROOM_DEFAULT then
                local minMaxMulti = countInaba
                if room:IsLShapedRoom() or room:GetRoomShape() == RoomShape.ROOMSHAPE_2x2 then
                    minMaxMulti = minMaxMulti * 2
                end

                local numItems = mod:RandomInt(mod.InabaBal.PowerItemsPerRoom.Min * minMaxMulti, mod.InabaBal.PowerItemsPerRoom.Max * minMaxMulti)
                local enemies = GetEnemies()
                if #enemies > 0 then
                    for i = 1, numItems do
                        local assign = enemies[mod:RandomInt(1, #enemies)]
                        mod:GetEntityData(assign).Inabapoweritems = (mod:GetEntityData(assign).Inabapoweritems or 0) + 1
                    end
                end

                powerItemsToSpawn = numItems
            end
        end

        if roomType == RoomType.ROOM_CHALLENGE and not room:IsAmbushDone() then
            powerItemsToSpawn = mod.InabaBal.ChallengePowerItems
        end
    end
end)

mod:AddCallback(mod.CALLBACK.FF_POST_START_GREED_WAVE, function(_, waveNumber, isBossWave)
    local isPlayerInaba, countInaba = mod:AnyInaba()
    if isPlayerInaba then
        local minMaxMulti = #countInaba
        local numItems = mod:RandomInt(mod.InabaBal.PowerItemsPerRoomGreed.Min * minMaxMulti, mod.InabaBal.PowerItemsPerRoomGreed.Max * minMaxMulti)
        powerItemsToSpawn = powerItemsToSpawn or 0
        powerItemsToSpawn = powerItemsToSpawn + numItems
        local enemies = GetEnemies()
        if #enemies > 0 then
            for i = 1, numItems do
                local assign = enemies[mod:RandomInt(1, #enemies)]
                if assign:ToNPC() then
                    mod:GetEntityData(assign).Inabapoweritems = (mod:GetEntityData(assign).Inabapoweritems or 0) + 1
                    if isBossWave then
                        mod:GetEntityData(assign).Inabapoweritemsduringgreedboss = true
                    end
                end
            end
        end
        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            if mod:isEitherInaba(player) then
                mod:GetEntityData(player).inabapowerlost = nil
            end
        end
    end
end)

function mod:binabaInputHandling(player, data, hook, action)
    if action == ButtonAction.ACTION_DROP and data.binabaPreventTrinketDrop then
        if hook == InputHook.GET_ACTION_VALUE then
            return 0
        else
            return false
        end
    end
end
mod:AddManualCallback(mod.CALLBACK.FF_PLAYER_INPUT_ACTION, mod.binabaInputHandling)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    trinketDroppingCallbackActive = false
    mod:DisableManualCallback(mod.CALLBACK.FF_PLAYER_INPUT_ACTION, mod.binabaInputHandling)
end)

local function spawnPower(size, pos, vec)
    vec = vec or RandomVector() * 5
    local power = Isaac.Spawn(EntityType.ENTITY_EFFECT, powerItem, size, pos, vec, nil)

    -- lil inaba
    if size == 2 then
        power.Color = Color(1, 0, 0, 1)
    end
end

mod.SpawnInabaPowerItem = spawnPower

local lastEnemyHurtPosition
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local isInaba, countInaba = mod:AnyInaba()
    if not isInaba then
        return
    end

    countInaba = #countInaba

    if powerItemsToSpawn and powerItemsToSpawn > 0 then
        local room = game:GetRoom()
        if room:GetType() == RoomType.ROOM_BOSS and room:GetAliveBossesCount() <= 0 and lastEnemyHurtPosition then
            for i = 1, powerItemsToSpawn do
                spawnPower(1, lastEnemyHurtPosition)
            end

            powerItemsToSpawn = nil
        elseif room:GetType() == RoomType.ROOM_CHALLENGE then
            if room:IsAmbushDone() then
                for i = 1, powerItemsToSpawn do
                    spawnPower(1, lastEnemyHurtPosition)
                end

                powerItemsToSpawn = nil
            end
        elseif room:GetAliveEnemiesCount() <= 0 and lastEnemyHurtPosition then
            for i = 1, powerItemsToSpawn do
                spawnPower(0, lastEnemyHurtPosition)
            end

            powerItemsToSpawn = nil
        end
    end

    if game:GetLevel():GetStage() == LevelStage.STAGE8 then
        local dogmas = Isaac.FindByType(EntityType.ENTITY_DOGMA)
        for _, dogma in ipairs(dogmas) do
            if (dogma.Variant == 1 or dogma.Variant == 2) and not mod:GetEntityData(dogma).SetupDogmaPowerItems then
                doneBossThresholds = {}
                mod:GetEntityData(dogma).SetupDogmaPowerItems = true
                for _, v in ipairs(mod.InabaBal.PowerItemBossThresholds) do
                    doneBossThresholds[v] = false
                end

                powerItemsPerBoss = mod.InabaBal.PowerItemsPerBossThreshold * countInaba
                powerItemsToSpawn = powerItemsPerBoss * (#mod.InabaBal.PowerItemBossThresholds + 1)
            end
        end

        local beasts = Isaac.FindByType(EntityType.ENTITY_BEAST)
        for _, beast in ipairs(beasts) do
            if beast.Variant >= 10 and beast.Variant <= 40 and beast.Variant % 10 == 0 then
                if not mod:GetEntityData(beast).Inabapoweritems then
                    mod:GetEntityData(beast).Inabapoweritems = mod.InabaBal.BeastHorsemanPowerItems
                end
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_APPLY_TEARFLAG_EFFECTS, function(_, npc, pos, tearFlags, source, damage)
    local parent = source.Parent
    if parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == inabaSatellite then
        local player = parent:ToFamiliar().Player
        if player and mod:isBinaba(player) and player:HasCollectible(mod.ITEM.COLLECTIBLE.OCULAR_SPECTRUM) then
            local knifeData = mod:GetEntityData(source)
            if not knifeData.ocularSpectrumBuffAmount then
                knifeData.ocularSpectrumBuffAmount = mod.InabaBal.B_CuttingGazeOcularSpectrumInitialCharge
            else
                knifeData.ocularSpectrumBuffAmount = mod:LuaRound(knifeData.ocularSpectrumBuffAmount * mod.InabaBal.B_CuttingGazeOcularSpectrumChargeDecay)
            end
            local basedata = mod:GetEntityData(player)
            local data = basedata.ffsavedata
            local save = data.Inaba
            save.ocularSpectrumBuff = (save.ocularSpectrumBuff or 0) + knifeData.ocularSpectrumBuffAmount
        end
    end
end, EntityType.ENTITY_KNIFE)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, ent, amount, flags, source)
    if ent:IsEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM) then
        if powerItemsPerBoss then
            if ent:IsBoss() and powerItemsToSpawn and powerItemsToSpawn > 0 then
                local totalBossHP, totalBossMaxHP = 0, 0
                for _, enemy in ipairs(Isaac.FindInRadius(game:GetRoom():GetCenterPos(), 875, EntityPartition.ENEMY)) do
                    if enemy:IsBoss() and not enemy:HasEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP) then
                        totalBossHP = totalBossHP + enemy.HitPoints
                        totalBossMaxHP = totalBossMaxHP + enemy.MaxHitPoints
                    end
                end

                totalBossHP = math.max(totalBossHP - amount, 0)
                local percent = totalBossHP / totalBossMaxHP
                local spawnItems = 0
                for k, v in pairs(doneBossThresholds) do
                    if percent <= k and v == false then
                        doneBossThresholds[k] = true
                        spawnItems = spawnItems + powerItemsPerBoss
                    end
                end

                if percent == 0 and powerItemsToSpawn then
                    spawnItems = powerItemsToSpawn
                end

                if spawnItems > 0 then
                    for i = 1, spawnItems do
                        spawnPower(1, ent.Position)
                    end

                    powerItemsToSpawn = powerItemsToSpawn - spawnItems
                end

                lastEnemyHurtPosition = ent.Position
            end
        else
            lastEnemyHurtPosition = ent.Position
        end
    elseif ent.Type == EntityType.ENTITY_PLAYER and ent:ToPlayer() and mod:isEitherInaba(ent:ToPlayer()) then
        local player = ent:ToPlayer()
        local allGood = true
        for i = 1, #mod.InabaBal.FlagGroups.NoPenalty do
            if not (flags & mod.InabaBal.FlagGroups.NoPenalty[i] == 0) then
                allGood = false
            end
        end
        if allGood then
            local data = mod:GetEntityData(player)
            local sdata = data.ffsavedata
            local save = sdata.Inaba
            local losePower = math.floor(save.Power * mod.InabaBal.PowerDamagePenalty)
            data.inabapowerlost = data.inabapowerlost or 0
            local losePower = math.min(losePower, mod.InabaBal.PowerDamageLimit - data.inabapowerlost)
            local sinceLastHit = (save.PowerGainedSinceLastHit or 0) * mod.InabaBal.PowerDamageLastTimePenalty
            AddPower(player, -math.max(losePower,sinceLastHit))
            save.PowerGainedSinceLastHit = 0
            data.inabapowerlost = data.inabapowerlost + losePower

            if data.migrainebal  then
                if save.MigraineMode then
                    AddMigraineGauge(player, -data.migrainebal.DamageDrain, nil, true)
                else
                    AddMigraineGauge(player, data.migrainebal.TakeDamage)
                end
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, npc)
    local isInaba, inabas = mod:AnyInaba()
    for _, inaba in ipairs(inabas) do
        AddMigraineGauge(inaba, mod:GetEntityData(inaba).migrainebal.EnemyKill)
    end

    if mod:GetEntityData(npc).Inabapoweritems then
        local data = mod:GetEntityData(npc)
        if npc.Type == EntityType.ENTITY_BEAST then
            local target = PickPowerItemTarget(npc.Position)
            for i = 1, data.Inabapoweritems do
                spawnPower(1, npc.Position, (target.Position - npc.Position):Resized(15):Rotated(mod:RandomInt(-45, 45)) + Vector(0, -20))
            end
        else
            for i = 1, data.Inabapoweritems do
                if data.Inabapoweritemsduringgreedboss then
                    spawnPower(1, npc.Position)
                else
                    spawnPower(0, npc.Position)
                end
            end
        end

        if powerItemsToSpawn then
            powerItemsToSpawn = powerItemsToSpawn - data.Inabapoweritems
        end
        data.Inabapoweritems = nil
    end
end)

--Inaba can't get black hearts!
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, t, v, s, po, ve, sp, se)
    if mod:AnyInaba() then
        if t == EntityType.ENTITY_PICKUP then
            local replaceSub
            if (v == PickupVariant.PICKUP_HEART and s == HeartSubType.HEART_BLACK) then
                replaceSub = HeartSubType.HEART_SOUL
            elseif v == mod.PICKUP.VARIANT.HALF_BLACK_HEART then
                replaceSub = HeartSubType.HEART_HALF_SOUL
            elseif v == mod.PICKUP.VARIANT.BLENDED_BLACK_HEART then
                replaceSub = HeartSubType.HEART_BLENDED
            end

            if replaceSub then
                if mod:RoomForcesBlackHeart() then
                    return {t,PickupVariant.PICKUP_PILL,0,se}
                else
                    return {t,v,replaceSub,se}
                end
            end
        end
    end
end)

--Safety check
function mod:inabaHeartReplaceCheck(pickup)
    if pickup.FrameCount < 10 then
        if pickup.Variant ~= 10 or (pickup.Variant == 10 and pickup.SubType == HeartSubType.HEART_BLACK) then
            if mod:AnyInaba() then
                local replaceSub
                if pickup.Variant == 10 then
                    replaceSub = HeartSubType.HEART_SOUL
                elseif pickup.Variant == mod.PICKUP.VARIANT.HALF_BLACK_HEART then
                    replaceSub = HeartSubType.HEART_HALF_SOUL
                elseif pickup.Variant == mod.PICKUP.VARIANT.BLENDED_BLACK_HEART then
                    replaceSub = HeartSubType.HEART_BLENDED
                end

                if replaceSub then
                    if mod:RoomForcesBlackHeart() then
                        pickup:Morph(5, PickupVariant.PICKUP_PILL, 0, true)
                    else
                        pickup:Morph(5, 10, replaceSub, true)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.inabaHeartReplaceCheck, 10)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.inabaHeartReplaceCheck, FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.inabaHeartReplaceCheck, FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART)

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.InabaHurt, 1, 0, false, mod:RandomInt(90,110)/100)
    return true
end, mod.PLAYER.INABA)
mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.InabaHurt, 1, 0, false, mod:RandomInt(90,110)/100)
    return true
end, mod.PLAYER.BINABA)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.InabaHurt, 1, 0, false, mod:RandomInt(50,70)/100)
    return true
end, mod.PLAYER.INABA)
mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.InabaHurt, 1, 0, false, mod:RandomInt(50,70)/100)
    return true
end, mod.PLAYER.BINABA)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local basedata = mod:GetEntityData(player)
    local data = basedata.ffsavedata
    data = data or {}
    data.Inaba = data.Inaba or {}
    data.Inaba.SoulOfInabaActive = true
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
    AddMigraineGauge(player, mod.InabaBal.MigraineCap, nil, true)
end, mod.ITEM.CARD.SOUL_OF_INABA)

--Commented out just in case
--[[mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local level = game:GetLevel()
	local desc = level:GetCurrentRoomDesc()

	local playerType = Isaac.GetPlayer():GetPlayerType()

	if level:GetStage() == LevelStage.STAGE8 and desc.SafeGridIndex == 94 and mod.CanRunUnlockAchievements() and playerType == mod.PLAYER.INABA and not FiendFolio.ACHIEVEMENT.BINABA:IsUnlocked() then
		for _, shopkeeper in pairs(Isaac.FindByType(17)) do
			shopkeeper:Remove()
		end
		for _, item in pairs(Isaac.FindByType(5)) do
			item:Remove()
		end

		if #Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER) == 0 then
			Isaac.Spawn(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER, 0, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
		end
	end
end)]]

--[[mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, function(_, slot)
	local playerType = Isaac.GetPlayer():GetPlayerType()
	if playerType == mod.PLAYER.INABA then
		slot:GetSprite():ReplaceSpritesheet(0, EntityConfig.GetPlayer(playerType):GetTaintedCounterpart():GetSkinPath(), true)
	end
end, SlotVariant.HOME_CLOSET_PLAYER)]]

--[[mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
	if slot:GetSprite():IsFinished("PayPrize") then
		if Isaac.GetPlayer():GetPlayerType() == mod.PLAYER.INABA and not FiendFolio.ACHIEVEMENT.BINABA:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.BINABA:Unlock()
		end
	end
end, SlotVariant.HOME_CLOSET_PLAYER)]]
