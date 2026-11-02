local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local magicNumber = 7
local vel = 20.5

local flagsToClearOnHit = TearFlags.TEAR_HOMING | TearFlags.TEAR_ORBIT | TearFlags.TEAR_ORBIT_ADVANCED
local function updateMagicBullet(_, tear)
    local d = mod:GetEntityData(tear)
    local mult = d.mult
    mod:MultiplyTearFall(tear, "ff_magicBullet", 0.33)
    local c = Isaac.FindInCapsule(tear:GetCollisionCapsule(), 40)
    if #c > 0 then
        local hitlist = mod:GetEntityData(tear).ff_magicHitlist or {}
        for index, value in ipairs(c) do
            if hitlist[value.Index] == nil then
                hitlist[value.Index] = true
                game:BombExplosionEffects(tear.Position, 40, tear.TearFlags, tear.Color)

                if tear:HasTearFlags(flagsToClearOnHit) then
                    tear:ClearTearFlags(flagsToClearOnHit)
                    tear.Velocity = Vector(vel, 0)*mult
                end
            end
        end
        mod:GetEntityData(tear).ff_magicHitlist = hitlist
    end
    if tear:HasTearFlags(TearFlags.TEAR_OCCULT) then
        --what the fuck was i even writing here
        if mult > 0 then
            tear.Velocity = Vector(math.min(math.max(5, tear.Velocity.X*1.2), vel), tear.Velocity.Y)
        else
            tear.Velocity = Vector(math.max(math.min(-5, tear.Velocity.X*1.2), -vel), tear.Velocity.Y)
        end
    end

    --visual stuff, copied from ganymede
    local c = Color(0, 0.4, 0.8, 0.3, 0.2, 0.4, 0.6)
    local trail, init = mod:SetEasyTearTrail(tear)
    if init then
        trail.SpriteScale = Vector.One*0.75
        trail.MinRadius = 0.045
        trail.Color = c
    end

    EntityEffect.CreateLight(tear.Position + tear.PositionOffset, 1, 1, 6, c)
    local flickerAnim = tear.FrameCount % 18
    if flickerAnim >= 9 and flickerAnim ~= 10 and flickerAnim < 13 then
        tear:SetColor(Color(1.2,1.4,1.4, 0.8), 2, 2, false, false)
    end
end
local function FirePure(_, player, vector, amount, owner, params)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.MAGIC_BULLET) then
        return
    end
    local count = owner.Type == EntityType.ENTITY_PLAYER
    
    local p_data = mod:GetEntityData(player)
    p_data.ff_freischutzCount = p_data.ff_freischutzCount or 0
    if count then
        if p_data.ff_freischutzCount >= magicNumber then
            p_data.ff_freischutzCount = 0
        end
        p_data.ff_freischutzCount = p_data.ff_freischutzCount + 1
    end

    local targets = p_data.ff_freishcutzTargets

    if p_data.ff_freischutzCount == magicNumber then
        
        for index, target in ipairs(targets) do
        --[[for i = 1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.MAGIC_BULLET), 1 do        
            local y = mod:Lerp(160, (room:GetGridHeight()*40)+80, rng:RandomFloat()) --this, glitchcity, and sun cross need manual checking for closets. BLEHHHHH

            --get player X, flip to other side of the room if they are more left-bound than not
            local mult, x = 1, -160
            local roomWidth = room:GetGridWidth()*40+80
            if player.Position.X < roomWidth/2 then
                mult=-1
                x = roomWidth+160
            end]]
            local mult = target.SubType - magicNumber
            local tear = player:FireTear(target.Position, Vector(vel, 0)*mult, false, true, false, nil, 2.1) --no shotspeed movement scaling ,sorry
            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING
            tear:ClearTearFlags(TearFlags.TEAR_EXPLOSIVE)
            tear.Color = tear.Color * Color.TearSoy
            tear.Scale = (tear.Scale * 1.2) + 0.3
            --tear.EntityCollisionClass = 0 --this bullet can truly hit nothing? lol?
            mod:changeTearVariant(tear, mod.TEAR.MAGIC_BULLET)
            mod:AddToTearUpdateList("ff_magicBullet", tear, updateMagicBullet)
            sfx:Play(FiendFolio.Sounds.MurasaFire, 0.2)

            local d = mod:GetEntityData(tear)
            d.mult = mult

            Game():MakeShockwave(tear.Position, 0.02, 0.01, 8)
        end
        
        for index, value in ipairs(targets) do
            value:Remove()
        end
        targets = nil
    end

    if (targets == nil or not targets[1] or not targets[1]:Exists()) and p_data.ff_freischutzCount >= 2 and p_data.ff_freischutzCount ~= magicNumber then
        targets = {}
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.MAGIC_BULLET)
        local room = game:GetRoom()
        for i = 1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.MAGIC_BULLET), 1 do        
            local y = mod:Lerp(160, (room:GetGridHeight()*40)+80, rng:RandomFloat()) --this, glitchcity, and sun cross need manual checking for closets. BLEHHHHH

            --get player X, flip to other side of the room if they are more left-bound than not
            local mult, x = 1, -30
            local roomWidth = room:GetGridWidth()*40+80
            if player.Position.X < roomWidth/2 then
                mult=-1
                x = roomWidth-10
            end
            local vpos = Vector(x,y)
            local effect = Isaac.Spawn(mod.FF.MagicBulletCircle.ID, mod.FF.MagicBulletCircle.Var, mult+magicNumber, vpos, Vector.Zero, player)
            if mult == 1 then
                effect.FlipX = true
            end
            effect.PositionOffset = Vector(0,-20)

            targets[#targets+1] = effect
        end
    end
    
    p_data.ff_freishcutzTargets = targets
end

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.COLLECTIBLE.MAGIC_BULLET, FirePure)
mod:AddCollectibleCallback("POST_PRIMARY_GUN_FIRE", mod.ITEM.COLLECTIBLE.MAGIC_BULLET, function (_, _, player)
    FirePure(_, player, _, _, player) 
end)
--tear variant stuff
local function ganymedeRender(_, tear, var, data, offset)
    local sprite = tear:GetSprite()
    local scale = tear.Scale
    local flags = tear.TearFlags

    local anim
    if scale <= 0.675 then
        anim = "Star1"
    elseif scale <= 0.925 then
        anim = "Star2"
    elseif scale <= 1.175 then
        anim = "Star3"
    elseif scale <= 1.675 then
        anim = "Star4"
    elseif scale <= 2.175 then
        anim = "Star5"
    else
        anim = "Star6"
    end

    if not sprite:IsPlaying(anim) then
        local frame = sprite:GetFrame()
        sprite:Play(anim, true)
        sprite:SetFrame(frame)
    end

    local spritescale = mod:getTearScale6(tear)
    local layers = sprite:GetAllLayers()
    for _, layer in ipairs(layers) do
        layer:SetSize(spritescale)
    end

    local adjustedVelocity = tear.Velocity
    if tear.WaitFrames > 0 then
        adjustedVelocity = tear.ContinueVelocity
    end
        
    sprite.Rotation = adjustedVelocity:GetAngleDegrees()
    sprite.FlipX = false
    sprite.FlipY = false
end

mod:AddCallback("FF_CUSTOM_TEAR_RENDER", ganymedeRender, FiendFolio.TEAR.MAGIC_BULLET)

local function ganymedeSplat(_, tear, var, data, offset) --todo: make this not just reuse ganymedes stuff
    local explode = Isaac.Spawn(mod.FF.GanymedePoof.ID, mod.FF.GanymedePoof.Var, mod.FF.GanymedePoof.Sub, tear.Position + tear.PositionOffset, Vector.Zero, tear)
    explode.SpriteScale = Vector.One*tear.Scale*1.2
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", ganymedeSplat, FiendFolio.TEAR.GANYMEDE)