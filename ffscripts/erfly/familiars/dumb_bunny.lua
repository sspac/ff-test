local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar.IsFollower = true
end, mod.ITEM.FAMILIAR.DUMB_BUNNY)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
    local player = familiar.Player
	local sprite = familiar:GetSprite()
    local isSuperpositioned = mod:isSuperpositionedPlayer(familiar.Player)
	--local isSirenCharmed = mod:isSirenCharmed(familiar)

    familiar.FireCooldown = familiar.FireCooldown - ((player and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2) or 1)
    familiar.FireCooldown = math.max(0, familiar.FireCooldown)

    local vel = familiar.Velocity

    --Mainly uses player instead of the familiar itself because of getting caught in long familiar chains
    if player.Velocity:Length() > 2 and familiar.FireCooldown <= 0 then
        local tearVec = familiar.Velocity:Resized(-9)
        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, familiar.Position, tearVec, familiar):ToTear()
        tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        tear.Color = Color(1.5, 2, 2, 0.5, 0, 0, 0)
        tear.Height = -23
        tear.FallingSpeed = 0.1 + (math.random() * 2 - 1) * 0.1
        tear.FallingAcceleration = 0
        
        local familiarMult = familiar:GetMultiplier()
        tear.Scale = 0.6
        if familiarMult > 1 then
            tear.Scale = tear.Scale + 0.2 * (familiarMult-1)
        end
        tear.CollisionDamage = 2 * familiarMult
        tear:ResetSpriteScale()
        if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
            local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
            tear.Color = tearcolor
        end
        if isSuperpositioned then
            local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
            tearcolor.A = tearcolor.A / 4
            tear.Color = tearcolor
        end

        familiar.FireCooldown = 10 - (math.floor(vel:Length() / 1.5))
    end

    local anim = "Float"
    sprite.FlipX = false
    --if familiar.FireCooldown > 2 then
        --anim = anim .. "Shoot"
    --end
    if math.abs(vel.X) > math.abs(vel.Y) then
        if vel.X > 0 then
            anim = anim .. "Left"
        else
            anim = anim .. "Right"
        end
    else
        if vel.Y > 0 then
            anim = anim .. "Up"
        else
            anim = anim .. "Down"
        end
    end
    local frame = sprite:GetFrame()
    sprite:Play(anim, true)
    sprite:SetFrame(frame)

    familiar:FollowParent()
end, mod.ITEM.FAMILIAR.DUMB_BUNNY)