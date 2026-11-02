local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero

--All these different functions were created by the Clyde discord AI back before we understood the negative implications of AI.
--Nothing from this is used for actual real enemies, it was just fuckin' around and seeing if it could even do anything.

--Turns out everything it made SUCKED, it's CRAP and BAD, but the functions are still here below to oogle at.
--We won't be using this kinda thing again, please do understand this was a little more acceptable at the time.

--You can summon enemies using this code as subtypes 1-4 of 160.999

function mod:flyerAI(entity)
    local sprite = entity:GetSprite()
    local data = mod:GetEntityData(entity)
    local player = Isaac.GetPlayer(0)

    if not data.init then
        data.init = true
        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end

    -- Movement behavior
    local velocity = entity.Velocity
    local speed = 2.0
    if math.random(100) < 10 then
        velocity = Vector((math.random() * 2.0) - 1.0, (math.random() * 2.0) - 1.0):Normalized() * speed
    end
    entity.Velocity = mod:Lerp(entity.Velocity, velocity, 0.2)

    -- Shooting behavior
    if entity.FrameCount % 120 == 0 then
        local shootDir = (player.Position - entity.Position):Normalized()
        entity:FireProjectiles(entity.Position, shootDir, 0, ProjectileParams())
        entity:PlaySound(SoundEffect.SOUND_MEATHEAD_SHOOT)
    end

    -- Death behavior
    if entity:IsDead() then
        Isaac.Spawn(math.random(50), math.random(8), 0, entity.Position, Vector(0,0), nil)
    end
end

function mod:laserShooterAI(entity)
    local data = mod:GetEntityData(entity)

    if not data.init then
        data.init = true
        data.laserTimer = 0
    end

    local player = Isaac.GetPlayer(0)
    local angle = (player.Position - entity.Position):GetAngleDegrees() - 90
    entity.Velocity = Vector.FromAngle(angle):Resized(1)

    data.laserTimer = data.laserTimer + 1
    if data.laserTimer > 30 then
        data.laserTimer = 0
        local laser = EntityLaser.ShootAngle(1, entity.Position, angle, 20, Vector(0,-40), entity)
        laser:SetTimeout(30)
        laser:SetMaxDistance(500)
        laser.Color = Color(1, 0, 0, 1, 0, 0, 0)
    end
end

function mod:tearShooterAI(entity)
    local data = mod:GetEntityData(entity)

    if not data.init then
        data.init = true
        data.chaseTarget = Isaac.GetPlayer(0)
        data.shootTimer = 0
    end

    local player = Isaac.GetPlayer(0)
    local playerPos = player.Position

    if entity.Position:Distance(playerPos) > 100 then
        entity.Velocity = (playerPos - entity.Position):Normalized() * 3
    else
        entity.Velocity = Vector(0,0)
    end

    data.shootTimer = (data.shootTimer + 1) % 90
    if data.shootTimer == 0 then
        local tearParams = ProjectileParams()
        tearParams.Variant = ProjectileVariant.PROJECTILE_TEAR
        tearParams.FallingSpeedModifier = -0.25
        tearParams.FallingAccelModifier = 0.05
        tearParams.Scale = 1.0
        tearParams.Color = Color(1, 1, 1, 1, 0, 0, 0)

        local tearSpeed = 15
        local numTears = 12
        local tearSpread = 30

        local startPos = entity.Position
        local targetPos = player.Position

        local angles = {}
        for i = 0, numTears - 1 do
            local angle = (targetPos - startPos):GetAngleDegrees()
            angles[i] = angle + i * tearSpread
        end

        for i = 0, numTears - 1 do
            local tearVector = Vector.FromAngle(angles[i])
            entity:FireProjectiles(startPos, tearVector * tearSpeed, 0, tearParams)
        end
    end
end

function mod:bossEnemyAI(enemy)
    local sprite = enemy:GetSprite()
    local d = mod:GetEntityData(enemy)
    local target = enemy:GetPlayerTarget()
    local path = enemy.Pathfinder
    local room = game:GetRoom()
    if not d.init then
        enemy.SplatColor = mod.ColorPureWhite
        d.init = true
    end
    if enemy.Velocity:Length() > 0.1 then
        enemy:AnimWalkFrame("WalkHori","WalkVert",0)
    else
        sprite:SetFrame("WalkVert", 0)
    end

    local targetpos = mod:confusePos(enemy, target.Position)
    if game:GetRoom():CheckLine(enemy.Position,targetpos,0,1,false,false) or mod:isScare(enemy) then
        local targetvel = mod:reverseIfFear(enemy, (targetpos - enemy.Position):Resized(3))
        enemy.Velocity = mod:Lerp(enemy.Velocity, targetvel,0.25)
    else
        path:FindGridPath(targetpos, 0.4, 900, true)
    end

    -- Additional boss behavior goes here
    -- You can add attacks, patterns, or any other boss mechanics

    if game:GetFrameCount() % 60 == 0 then
        -- Shoot a projectile at the player
        local projectile = mod:LazySpawnProjectile(0, 0, enemy.Position, (target.Position - enemy.Position):Normalized() * 10, enemy)
        mod:GetEntityData(projectile).IsBossProjectile = true
    end

    if game:GetFrameCount() % 120 == 0 then
        -- Spawn additional enemies
        Isaac.Spawn(31, 0, 0, enemy.Position, nilvector, enemy)
    end

    if enemy:IsDead() then
        local checkGrid = room:GetGridEntityFromPos(enemy.Position)
        if not checkGrid or checkGrid:GetType() ~= 20 then
            Isaac.GridSpawn(10, 0, enemy.Position, true)
        end
        for i = 90, 360, 90 do
            checkGrid = room:GetGridEntityFromPos(enemy.Position + Vector(40, 0):Rotated(i))
            if not checkGrid or checkGrid:GetType() ~= 20 then
                Isaac.GridSpawn(10, 0, enemy.Position + Vector(40, 0):Rotated(i), true)
            end
        end
        Isaac.Spawn(85, 962, 0, enemy.Position, nilvector, enemy)
    end
end


function mod:clydeAI(entity)
    if entity.SubType == 1 then
        mod:flyerAI(entity)
    elseif entity.SubType == 2 then
        mod:laserShooterAI(entity)
    elseif entity.SubType == 3 then
        mod:tearShooterAI(entity)
    elseif entity.SubType == 4 then
        mod:bossEnemyAI(entity)
    end
end

--[[function mod:OnEnemySpawn()
    local room = Game():GetRoom()
    if room:IsClear() then return end -- Skip if the room is clear

    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
        local entity = entities[i]
        local npc = entity:ToNPC()
        if npc then
            local rng = math.random(5) -- Change the number to adjust the chance
            if rng == 1 then
                Game():RerollEnemy(entity)
                mod:GetEntityData(entity).IsRubberBloon = true
            end
        end
    end
end

function mod:OnEntityTakeDamage(entity, amount, flags, source, countdown)
    if mod:GetEntityData(entity).IsRubberBloon then
        local room = Game():GetRoom()
        Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position, Vector.Zero, entity)
        entity:Remove()
        room:SpawnGridEntity(room:GetGridIndex(entity.Position), 0, 0, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnEnemySpawn)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnEntityTakeDamage)]]