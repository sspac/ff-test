local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local ITEM = mod.ITEM.COLLECTIBLE.PLASMA_BALL
local FAMILIAR = mod.ITEM.FAMILIAR.PLASMA_BALL
local CONFIG = Isaac.GetItemConfig():GetCollectible(ITEM)

local MAX_OFFSET = -300
local APPEAR_LENGTH = 30 * 1.33
local MAX_ZAP_RANGE = 100
local MAX_ZAP_RANGE_BFFS = 140
local LASER_TIMEOUT = 3
local LASER_COLOR = Color(1, 1, 1, 1, 0, 0, 0, 1.5, 0.2, 1.5, 1)
local NEARBY_ZAP_INTERVAL = 60
local NEARBY_ZAP_INTERVAL_BFFS = 30
local PLAYER_TOUCH_COOLDOWN = 25
local PLAYER_TOUCH_COOLDOWN_BFFS = 12

local PlasmaBallStates = {
    APPEAR = 0,
    IDLE = 1,
}



-- https://stackoverflow.com/a/79216534
local function multiplyBounce(currentBounce, bounceMult)
    return 1 - ((1 - currentBounce) * bounceMult)
end

local function oneBounce(x, previousCutoff, thisCutoff, thisBounce)
    local height = previousCutoff + (thisCutoff - previousCutoff) / 2
    local inverseHeight = height - previousCutoff
    local multiplier = (1 - thisBounce) / (inverseHeight * inverseHeight)
    return multiplier * ((x - height) ^ 2) + thisBounce
end

local function easeOutBounceAtPoint(x, bounceMult)
    local cutoff0 = 1 / 2.75
    local cutoff1 = 2 / 2.75
    local cutoff2 = 2.5 / 2.75

    local bounce1 = multiplyBounce(.9675, bounceMult)
    local bounce2 = multiplyBounce(.9875, bounceMult)
    local bounce3 = multiplyBounce(.9998, bounceMult)



    if x < cutoff0 then
        return x * x / (cutoff0 * cutoff0), 0
    elseif x < cutoff1 then
        return oneBounce(x, cutoff0, cutoff1, bounce1), 1
    elseif x < cutoff2 then
        return oneBounce(x, cutoff1, cutoff2, bounce2), 2
    else
        return oneBounce(x, cutoff2, 1, bounce3), 3
    end
end

---@param familiar EntityFamiliar
function mod:ShootPlasmaBallLaser(familiar, angleOrEnemy)
    local player = familiar.Player

    local angle = angleOrEnemy
    if type(angle) ~= "number" then
        angle = (angleOrEnemy.Position - familiar.Position):GetAngleDegrees()
    end

    local laser = EntityLaser.ShootAngle(LaserVariant.ELECTRIC, familiar.Position, angle, LASER_TIMEOUT, Vector.Zero, familiar)
    laser.DisableFollowParent = true
    laser.Parent = player
    laser.OneHit = true
    laser:ClearTearFlags(laser.TearFlags)
    laser.Color = LASER_COLOR

    local range = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and MAX_ZAP_RANGE_BFFS or MAX_ZAP_RANGE
    if type(angleOrEnemy) ~= "number" then
        laser.MaxDistance = math.min(range, (angleOrEnemy.Position - familiar.Position):Length())
    else
        laser.MaxDistance = range
    end

    laser.CollisionDamage = player.Damage
    laser:Update()

    return laser
end

function mod:PlasmaBallAppear(familiar)
    local data = mod:GetEntityData(familiar)
    familiar.State = PlasmaBallStates.APPEAR

    data.PlasmaBallAppear = 0
    data.PlasmaBallSlam = 0
    familiar.PositionOffset = Vector(0, -MAX_OFFSET)
end

---@param player EntityPlayer
function mod:PlasmaBallCacheEvaluate(player)
    local count = player:GetCollectibleNum(ITEM) + player:GetEffects():GetCollectibleEffectNum(ITEM)
    player:CheckFamiliar(FAMILIAR, count, player:GetCollectibleRNG(ITEM), CONFIG)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.PlasmaBallCacheEvaluate, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
function mod:PlasmaBallInit(familiar)
    mod:PlasmaBallAppear(familiar)
    familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    familiar:GetSprite():SetOverlayAnimation("Shine")
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.PlasmaBallInit, FAMILIAR)

function mod:PlasmaBallNewLevel()
    local room = game:GetRoom()
    local pos = room:GetCenterPos()
    for _, plasmaBall in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FAMILIAR)) do
        plasmaBall.Position = room:FindFreePickupSpawnPosition(pos)
        mod:PlasmaBallAppear(plasmaBall:ToFamiliar())
    end
end

---@param familiar EntityFamiliar
function mod:PlasmaBallUpdate(familiar)
    local data = mod:GetEntityData(familiar)
    local sprite = familiar:GetSprite()
    local player = familiar.Player

    familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

    if familiar.State == PlasmaBallStates.APPEAR then
        local easing, slam = easeOutBounceAtPoint(data.PlasmaBallAppear, 1)
        familiar.PositionOffset = Vector(0, MAX_OFFSET * (1 - easing))

        if easing < 0.25 then
            familiar.Color = Color(1, 1, 1, easing / 0.25)
        else
            familiar.Color = Color.Default
        end

        familiar.Velocity = Vector.Zero

        if familiar.PositionOffset.Y <= 1 and slam ~= data.PlasmaBallSlam then
            if data.PlasmaBallSlam == 0 then
                sfx:Play(SoundEffect.SOUND_ROCKET_EXPLOSION)

                for _ = 1, 4 do
                    mod:ShootPlasmaBallLaser(familiar, math.random(0, 360))
                end

                local particleCount = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 13 or 8
                local speed = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and 6 or 3
                local height = player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and -30 or -20
                game:SpawnParticles(familiar.Position, EffectVariant.ROCK_PARTICLE, particleCount, speed, Color.Default, height)

                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, familiar.Position, Vector.Zero, nil):ToEffect()
                
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                    effect.SpriteScale = Vector.One * 0.5
                else
                    effect.SpriteScale = Vector.One * 0.7
                end
            elseif data.PlasmaBallSlam > 0 then
                sfx:Play(SoundEffect.SOUND_STONE_IMPACT, 0.8)
            end
        end

		local shouldProgressSlam = (familiar.Player and familiar.Player:GetPlayerType() ~= FiendFolio.PLAYER.IMAGE) or (Isaac.CountEnemies() < 1 and game:GetRoom():IsClear())
        data.PlasmaBallAppear = data.PlasmaBallAppear + ((shouldProgressSlam and (1 / APPEAR_LENGTH)) or 0)
        data.PlasmaBallSlam = slam
        if data.PlasmaBallAppear >= 1 then
            familiar.PositionOffset = Vector.Zero
            familiar.Color = Color.Default
            familiar.State = PlasmaBallStates.IDLE
        end
		familiar.Visible = shouldProgressSlam

    elseif data.PlasmaBallAppear < 1 then
        familiar.State = PlasmaBallStates.APPEAR

    else
        if familiar.FrameCount % (data.PlasmaBallBFFs and NEARBY_ZAP_INTERVAL_BFFS or NEARBY_ZAP_INTERVAL) == 0 then
            for _, entity in ipairs(Isaac.FindInRadius(familiar.Position, player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and MAX_ZAP_RANGE_BFFS or MAX_ZAP_RANGE, EntityPartition.ENEMY)) do
                if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                    local enemy = entity:ToNPC()
                    mod:ShootPlasmaBallLaser(familiar, enemy)
                end
            end
        end
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        if not data.PlasmaBallBFFs then
            data.PlasmaBallBFFs = true
            sprite:ReplaceSpritesheet(0, "gfx/familiar/plasmaball/plasmaball_base_bff.png")
            sprite:ReplaceSpritesheet(1, "gfx/familiar/plasmaball/plasmaball_shine_bff.png")
            sprite:LoadGraphics()
        end
        familiar.SpriteScale = Vector(0.8,0.8)

    elseif data.PlasmaBallBFFs then
        data.PlasmaBallBFFs = nil
        sprite:ReplaceSpritesheet(0, "gfx/familiar/plasmaball/plasmaball_base.png")
        sprite:ReplaceSpritesheet(1, "gfx/familiar/plasmaball/plasmaball_shine.png")
        sprite:LoadGraphics()
        familiar.SpriteScale = Vector.One
    end

    local overlayFrames = sprite:GetAnimationData("Shine"):GetLength()
    local add = 0
    if familiar.Velocity:Length() > 0.2 then
        add = add + 1
    end
    local frame = (sprite:GetOverlayFrame() + add) % overlayFrames
    sprite:SetOverlayFrame("Shine", frame)

    familiar.FireCooldown = math.max(familiar.FireCooldown - 1, 0)
    familiar.Velocity = familiar.Velocity * 0.9
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.PlasmaBallUpdate, FAMILIAR)

-- Place in front of the player
function mod:PlasmaBallNewRoom()
    local room = game:GetRoom()
    for _, plasmaBall in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FAMILIAR)) do
        local door = room:GetDoor(game:GetLevel().EnterDoor)
        if not door then
            return
        end

        local direction = mod.DirectionToVector[door.Direction]:Rotated(180):Resized(70)
        local position = door.Position + direction

        -- Scatter them a little if there's more than one
        if Isaac.CountEntities(nil, EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.PLASMA_BALL) > 1 then
            local variance = direction:Rotated(mod:RandomInt(-25, 25)):Resized(40)
            position = position + variance
        end

        plasmaBall.Position = position
	
		local plasmaBall = plasmaBall:ToFamiliar()
		if plasmaBall.Player and plasmaBall.Player:GetPlayerType() == FiendFolio.PLAYER.IMAGE then
			if Isaac.CountEnemies() >= 1 then
				mod:PlasmaBallAppear(plasmaBall)
			end
		end
    end
end

---@param familiar EntityFamiliar
---@param collider Entity
function mod:PlasmaBallCollision(familiar, collider)
    if familiar:ToFamiliar().State ~= PlasmaBallStates.IDLE then
        return
    end

    local player = familiar:ToFamiliar().Player
    if collider.Type == EntityType.ENTITY_PLAYER and familiar.FireCooldown == 0 then
        familiar.FireCooldown = (familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and PLAYER_TOUCH_COOLDOWN_BFFS or PLAYER_TOUCH_COOLDOWN)
        local foundEnemy = false
        for _, entity in ipairs(Isaac.FindInRadius(familiar.Position, player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) and MAX_ZAP_RANGE_BFFS or MAX_ZAP_RANGE, EntityPartition.ENEMY)) do
            if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                local enemy = entity:ToNPC()
                mod:ShootPlasmaBallLaser(familiar, enemy)
                foundEnemy = true
            end
        end

        if not foundEnemy then
            mod:ShootPlasmaBallLaser(familiar, math.random(0, 360))
        end
    end

    local direction = (familiar.Position - collider.Position)
    familiar:AddVelocity(direction:Resized(1))

    if collider:IsEnemy() or collider.Type == EntityType.ENTITY_PLAYER and collider.Position:Distance(familiar.Position) > 0.5 then
        collider:AddVelocity(-direction:Resized(0.5))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, mod.PlasmaBallCollision, FAMILIAR)