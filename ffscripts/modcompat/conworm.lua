local mod = FiendFolio
local conwormTrinket = 0

-- "Huge" -ConBoi 2024/04/06 22:25 BST

FiendFolio.scheduleForUpdate(function()
    if ConWorm then
        conwormTrinket = Isaac.GetTrinketIdByName("ConWorm")
        FiendFolio.ConWormTrinketID = conwormTrinket

        table.insert(FiendFolio.KingWormTrinkets, conwormTrinket)
        FiendFolio.getFieldInit(FiendFolio.ShampooBottleTextItems.Trinkets, conwormTrinket, "Found", {})
        FiendFolio.ShampooBottleTextItems.Trinkets[conwormTrinket].Found = {
            {"Conboi is bad at Balatro. Very bad actually.",
            "Like unimaginable levels of throwing are happening.",
            "The most complex variables are being calculated",
            "in his head just to figure out the dumbest way to lose"
            }
        }
        table.insert(mod.TrashBagMiscs.Worms,conwormTrinket)
    end
end, 1, ModCallbacks.MC_INPUT_ACTION, true)

--None of these were exposed as part of ConWorm but I was determined okay
local function AttachTrail(entity, length, size, color, offset)
    local trail = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.SPRITE_TRAIL,
        0,
        entity.Position,
        Vector.Zero,
        entity
    ):ToEffect() ---@cast trail EntityEffect

    length = length or 0.15
    size = size or 1

    trail:FollowParent(entity)
    trail:SetRadii(length, length)
    trail.SpriteScale = Vector(size, size)
    trail.ParentOffset = offset or Vector.Zero
    trail:GetSprite().Color = color or Color.Default
    trail:Update()

    return trail
end

local function GetData(entity, identifier)
    local data = mod:GetEntityData(entity)
    data.____CONWORM = data.____CONWORM or {}
    data.____CONWORM[identifier] = data.____CONWORM[identifier] or {}
    return data.____CONWORM[identifier]
end

function FiendFolio.ApplyConWorm(player, entity)
    if entity.Type == EntityType.ENTITY_BOMB then
        if not entity.IsFetus then return end
        entity:SetExplosionCountdown(999999)
    end

    local data = GetData(entity, "ConWorm")
    local trail = AttachTrail(entity, 0.015, nil, entity.Color, entity.PositionOffset)

    data.ConWorm = true

    entity.Position = player.Position
    entity.Velocity = entity.Velocity:Resized(player.ShotSpeed * 10)
    entity.Velocity = entity.Velocity:Rotated(-90)

    data.State = 0
    data.Angle = 0
    data.AngleOffset = entity.Velocity:GetAngleDegrees()

    if entity.Type == EntityType.ENTITY_TEAR then
        entity.FallingSpeed = 0
        entity.FallingAcceleration = -0.1
    end

    if entity.Type == EntityType.ENTITY_BOMB or (entity.Type == EntityType.ENTITY_TEAR and (
        entity:HasTearFlags(TearFlags.TEAR_FETUS)
        or entity:HasTearFlags(TearFlags.TEAR_POP)
    )) then
        data.VelLen = entity.Velocity:Length()
    end

    trail:GetSprite().Color.A = 0.33
end