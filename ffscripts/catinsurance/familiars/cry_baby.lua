local mod = FiendFolio
local sfx = SFXManager()

local CryBabyState = {
    IDLE = 0,
    ASLEEP = 1,
    CRYING = 2,
}

local Constants = {
    CRYING_DURATION = 30 * 5,
    CRYING_AMOUNT = 12,
    CRYING_RADIUS = 40 * 3.5,
    DEFLECT_RADIUS = 40 * 2,
    ASLEEP_DURATION = 30 * 8,
    PACIFY_DURATION = 30 * 4,
    TRIGGER_MAX = 10,

    DEFAULT_COLOR = Color(1, 1, 1, 1),
    SOILED_COLOR = Color(1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0.5),
}

local config = Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.CRY_BABY)

local function spawnSweat(position, offset)
    local velocity = math.random(1, 3)
    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_VERYSMALL, 0, position + offset, RandomVector():Resized(velocity), nil):ToEffect()
    effect.DepthOffset = -5
end

---@param familiar EntityFamiliar
function mod:CryBabyUpdate(familiar)
    local player = familiar.Player
    local sprite = familiar:GetSprite()
    local diaper = sprite:GetLayer("diaper")

    familiar:FollowParent()
    familiar.FireCooldown = math.max(familiar.FireCooldown - 1, 0)

    local progress = familiar.Coins / Constants.TRIGGER_MAX
    sprite:SetOverlayFrame(sprite:GetFrame())

    if familiar.State == CryBabyState.IDLE then
        if not sprite:IsPlaying("Disturbed") then
            mod:spritePlay(sprite, "Idle")
            mod:spriteOverlayPlay(sprite, "IdleDiaper")
        end

        diaper:SetColor(Color.Lerp(Constants.DEFAULT_COLOR, Constants.SOILED_COLOR, progress))
    elseif familiar.State == CryBabyState.ASLEEP then
        mod:spritePlay(sprite, "Asleep")
        mod:spriteOverlayPlay(sprite, "IdleDiaper")
        diaper:SetColor(Constants.DEFAULT_COLOR)

        if familiar.FireCooldown == 0 then
            familiar.State = CryBabyState.IDLE
        end
    elseif familiar.State == CryBabyState.CRYING then
        local data = mod:GetEntityData(familiar)
        if familiar.FireCooldown == 0 then
            data.CryBabyDeflects = nil
            data.CryBabySoundCooldown = nil
            familiar.State = CryBabyState.ASLEEP
            familiar.FireCooldown = Constants.ASLEEP_DURATION
            sprite:Play("Asleep", true)
        else
            diaper:SetColor(Constants.SOILED_COLOR)
            mod:spriteOverlayPlay(sprite, "IdleDiaper")

            data.CryBabyDeflects = data.CryBabyDeflects or {}
            data.CryBabySoundCooldown = data.CryBabySoundCooldown and math.max(data.CryBabySoundCooldown - 1, 0) or 0

            -- Ring effect + pacify
            if familiar.FireCooldown % (Constants.CRYING_DURATION // Constants.CRYING_AMOUNT) == 0 then
                local halo = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FFID.Effect, mod.FF.CryBabyScream.Sub, familiar.Position, Vector.Zero, familiar):ToEffect()
                halo:FollowParent(familiar)
                halo.SpriteScale = Vector(0.8, 0.8)
                halo.Timeout = halo:GetSprite():GetCurrentAnimationData():GetLength()

                spawnSweat(familiar.Position, Vector(0, -37))

                -- Pacify now
                for _, ent in ipairs(Isaac.FindInRadius(familiar.Position, Constants.DEFLECT_RADIUS, EntityPartition.ENEMY)) do
                    local npc = ent:ToNPC()
                    if npc and npc.Mass < 100 and not npc:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) then
                        npc:AddKnockback(EntityRef(familiar), (npc.Position - familiar.Position):Resized(6), 20, false)
                    end
                end

                -- Deflect projectiles
                for _, ent in ipairs(Isaac.FindInRadius(familiar.Position, Constants.DEFLECT_RADIUS, EntityPartition.BULLET)) do
                    local projectile = ent:ToProjectile()
                    if projectile then
                        local hash = GetPtrHash(projectile)
                        if not data.CryBabyDeflects[hash] then
                            data.CryBabyDeflects[hash] = true
                            projectile:Deflect(projectile.Velocity:Rotated(180))
                        end
                    end
                end
            end

            -- Pacify now
            for _, ent in ipairs(Isaac.FindInRadius(familiar.Position, Constants.CRYING_RADIUS, EntityPartition.ENEMY)) do
                local npc = ent:ToNPC()
                if npc and not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
                    mod.AddPacified(npc, player, Constants.PACIFY_DURATION)
                end
            end

            diaper:SetColor(Color.Lerp(Constants.SOILED_COLOR, Constants.DEFAULT_COLOR, 1 - familiar.FireCooldown / Constants.CRYING_DURATION))
            
            -- Sounds
            if not sfx:IsPlaying(mod.Sounds.CryBabyTantrum) and data.CryBabySoundCooldown == 0 then
                sfx:Play(mod.Sounds.CryBabyTantrum, 1.3, 2, false, 1.5)
                data.CryBabySoundCooldown = 40
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.CryBabyUpdate, mod.ITEM.FAMILIAR.CRY_BABY)

---@param familiar EntityFamiliar
function mod:CryBabyCollision(familiar, collider)
    if collider.Type == EntityType.ENTITY_PROJECTILE and familiar.State == CryBabyState.IDLE then
        local data = mod:GetEntityData(collider)
        if data.CryBabyChecked then
            return
        end

        data.CryBabyChecked = true

        if collider.Parent then
            local parent = collider.Parent:ToNPC()
            if parent then
                if parent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or parent:HasEntityFlags(EntityFlag.FLAG_CHARM) then
                    return
                end
            end
        end

        familiar:AddCoins(1)
        spawnSweat(familiar.Position, Vector(0, -37))

        local sprite = familiar:GetSprite()
        if familiar.Coins >= Constants.TRIGGER_MAX then
            familiar.State = CryBabyState.CRYING
            sprite:Play("Cry", true)
            sprite:PlayOverlay("CryDiaper", true)
            familiar.FireCooldown = Constants.CRYING_DURATION
            familiar.Coins = 0
        else
            sprite:Play("Disturbed", true)
            sprite:PlayOverlay("DisturbedDiaper", true)
            --sfx:Play(SoundEffect.SOUND_BABY_HURT, 1, 2, false, 0.5)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, mod.CryBabyCollision, mod.ITEM.FAMILIAR.CRY_BABY)

---@param familiar EntityFamiliar
function mod:CryBabyInit(familiar)
    familiar:AddToFollowers()
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.CryBabyInit, mod.ITEM.FAMILIAR.CRY_BABY)

---@param player EntityPlayer
function mod:CryBabyCacheEvaluate(player)
    local count = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CRY_BABY) + player:GetEffects():GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.CRY_BABY)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CRY_BABY)
    player:CheckFamiliar(mod.ITEM.FAMILIAR.CRY_BABY, count, rng, config)
    for _ = 1, count do
        rng:Next()
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.CryBabyCacheEvaluate, CacheFlag.CACHE_FAMILIARS)