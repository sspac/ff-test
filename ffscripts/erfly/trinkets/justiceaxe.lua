local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local JusticeAxeBal = {
    COOLDOWN = 270, --Cooldown before player can fire another
    FALL_ACCEL = 0.75,
    INITIAL_FALL_SPEED = -10,
    VELOCITY = 9, --Thrown speed before player tear inheritance applied
    TEAR_INHERITANCE_LERPNESS = 0.3,

    THROWN_AXE_RADIUS = 30, --Radius that enemies take damage in
    THROWN_AXE_FRAME = 2, --Every X frames, axe tries to do damage
    THROWN_AXE_DAMAGE = 2,

    LANDED_AXE_IMMEDIATE_RADIUS = 30, --Closer enemies
    LANDED_AXE_IMMEDIATE_DAMAGE = 35,
    LANDED_AXE_RADIUS = 60, --AOE when landing
    LANDED_AXE_DAMAGE = 15,


    AXE_SPRITE_OFFSET = -10,
    INITIAL_AXE_ROTATION = 45,
    INITIAL_AXE_ROTATION_SPEED = 180,
    AXE_ROTATION_SLOW_SPEED = 15,
    AXE_ROTATION_SPEED = 30,
    GIB_ROTATION_SPEED = 30,
}

function mod:justiceAxePlayerUpdate(player)
    if player:HasTrinket(mod.ITEM.TRINKET.JUSTICE_AXE) then
        local data = mod:GetEntityData(player)
        if data.JusticeAxeCooldown then
            data.JusticeAxeCooldown = data.JusticeAxeCooldown - player:GetTrinketMultiplier(mod.ITEM.TRINKET.JUSTICE_AXE)
            if data.JusticeAxeCooldown <= 0 then
                data.JusticeAxeCooldown = nil
                player:SetColor(player.Color * Color(0.75,0.75,0.75,1,0,0.25,0), 5, 5, true, false)
                --sfx:Play(mod.Sounds.TennisHit,0.7,0,false, math.random(130,150)/100)
            end
        else
            local aim = mod.GetCorrectedFiringInput(player)
            if aim:Length() > 0.5 then
                sfx:Play(mod.Sounds.AxeThrow, 0.4, 0, false, math.random(80,120)/100)
                data.JusticeAxeCooldown = JusticeAxeBal.COOLDOWN
                local vec = aim:Resized(JusticeAxeBal.VELOCITY)
                local vec = mod:Lerp(vec, player:GetTearMovementInheritance(vec), JusticeAxeBal.TEAR_INHERITANCE_LERPNESS)
                local axe = Isaac.Spawn(mod.FF.JusticeAxeProjectile.ID, mod.FF.JusticeAxeProjectile.Var, mod.FF.JusticeAxeProjectile.Sub, player.Position, vec, player):ToEffect()
                axe:Update()
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.TRINKET.JUSTICE_AXE, mod.justiceAxePlayerUpdate)

function mod:justiceAxeProjectileAI(e)
    local d = mod:GetEntityData(e)
    local sprite = e:GetSprite()
    if not d.init then
        e.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        d.state = "thrown"
        e.SpriteRotation = JusticeAxeBal.INITIAL_AXE_ROTATION
        d.init = true
    end
    if d.state == "thrown" then
        mod:spritePlay(sprite, "spin")
        if e.Velocity.X < 0 then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
        d.rotationSpeed = d.rotationSpeed or JusticeAxeBal.INITIAL_AXE_ROTATION_SPEED
        d.rotationSpeed = math.max(JusticeAxeBal.AXE_ROTATION_SPEED, d.rotationSpeed - JusticeAxeBal.AXE_ROTATION_SLOW_SPEED)
        e.SpriteRotation = e.SpriteRotation + d.rotationSpeed
        d.fallAccel = d.fallAccel or JusticeAxeBal.FALL_ACCEL
        d.fallSpeed = d.fallSpeed or JusticeAxeBal.INITIAL_FALL_SPEED
        d.fallSpeed = d.fallSpeed + d.fallAccel
        d.height = d.height or 0
        d.height = d.height + d.fallSpeed
        e.SpriteOffset = Vector(0, d.height + JusticeAxeBal.AXE_SPRITE_OFFSET)
        if d.height >= 0 then
            d.state = "land"
            e.SpriteRotation = 0
            e.SpriteOffset = Vector(0,0)
            e.Velocity = Vector.Zero
            sfx:Play(mod.Sounds.CleaverHit,0.4,0,false, math.random(70,80)/100)
            local bigPoof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, e.Position,Vector.Zero,e):ToEffect()
            bigPoof.Color = Color(1,1,1,0.25)
            bigPoof.SpriteScale = Vector(0.75,0.75)
            local immediateHits = {}
            local hitConnected
            for _, enemy in ipairs(Isaac.FindInRadius(e.Position, JusticeAxeBal.LANDED_AXE_IMMEDIATE_RADIUS, EntityPartition.ENEMY)) do
                if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
                    enemy:TakeDamage(JusticeAxeBal.LANDED_AXE_IMMEDIATE_DAMAGE, 0, EntityRef(e), 0)
                    immediateHits[GetPtrHash(enemy)] = true
                    hitConnected = true
                    mod:makeEnemyGib(enemy:ToNPC())
                end
            end
            for _, enemy in ipairs(Isaac.FindInRadius(e.Position, JusticeAxeBal.LANDED_AXE_RADIUS, EntityPartition.ENEMY)) do
                if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
                    if not immediateHits[GetPtrHash(enemy)] then
                        enemy:TakeDamage(JusticeAxeBal.LANDED_AXE_DAMAGE, 0, EntityRef(e), 0)
                    end
                end
            end
            if hitConnected then
                sfx:Play(SoundEffect.SOUND_MEATY_DEATHS,0.75,0,false,0.9)
            end
        else
            if e.FrameCount % 2 == 0 then
                for _, enemy in ipairs(Isaac.FindInRadius(e.Position + e.SpriteOffset, JusticeAxeBal.THROWN_AXE_RADIUS, EntityPartition.ENEMY)) do
                    if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
                        enemy:TakeDamage(JusticeAxeBal.THROWN_AXE_DAMAGE, 0, EntityRef(e), 0)
                    end
                end
            end
        end
    elseif d.state == "land" then
        if sprite:IsFinished("land") then
            local flip = 1
            if sprite.FlipX then
                flip = -1
            end
            for i = 1, 3 do
                local startPos = Vector.Zero
                if i == 1 then
                    startPos = Vector(-20,0) * flip
                elseif i == 2 then
                    startPos = Vector(0,-10)
                end
                local gib = Isaac.Spawn(1000,163,0,e.Position + startPos, RandomVector()*math.random(3),e):ToEffect()
                local gibS = gib:GetSprite()
                gibS.FlipX = sprite.FlipX
                gibS:Load("gfx/projectiles/justice_axe_projectile.anm2", true)
                gibS:Play("gib" .. i)
                gib:Update()
                for k = 1, 8 do
                    mod.scheduleForUpdate(function()
                        local mult = 1
                        if gib.Velocity.X > 0 then
                            gib.SpriteRotation = gib.SpriteRotation + JusticeAxeBal.GIB_ROTATION_SPEED
                        else
                            gib.SpriteRotation = gib.SpriteRotation - JusticeAxeBal.GIB_ROTATION_SPEED
                        end
                    end, k)
                end
            end
            e:Remove()
        else
            mod:spritePlay(sprite, "land")
        end
    end
end

function mod:justiceAxeRender(e, offset)
    local renderMode = game:GetRoom():GetRenderMode()
    if renderMode == RenderMode.RENDER_WATER_REFRACT or renderMode == RenderMode.RENDER_WATER_REFLECT then
        return false
    end
end