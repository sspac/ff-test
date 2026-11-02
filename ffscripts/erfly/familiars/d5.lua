local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local d = mod:GetEntityData(fam)
	local sprite = fam:GetSprite()
    local player = fam.Player
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.D5)
    local isSuperpositioned = mod:isSuperpositionedPlayer(player)
	local isSirenCharmed = mod:isSirenCharmed(fam)
    local room = game:GetRoom()

    if room:GetFrameCount() == 0 then
        d.BeingThrown = nil
        d.bounceCount = nil
        d.fallAccel = nil
        d.fallSpeed = nil
        d.rotAmount = nil
        d.handLanded = nil
        d.spawnedEffect = nil
        d.endFrame = nil
        d.lastCollider = nil
        fam.SpriteOffset = Vector.Zero
    end

    fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

    if d.PowerUp then
        d.PowerTimer = d.PowerTimer or 0
        d.PowerTimer = d.PowerTimer + math.min((d.PowerUp/2), 4)
        if d.PowerTimer > 20 then
            local glowPow = 0.5 - ((d.PowerTimer - 20)/20)
            fam.Color = Color(1,1,1,1,glowPow,glowPow,glowPow)
            if d.PowerTimer > 30 then
                d.PowerTimer = 0
            end
        elseif d.PowerTimer > 10 then
            local glowPow = (d.PowerTimer - 10)/20
            fam.Color = Color(1,1,1,1,glowPow,glowPow,glowPow)
        else
            fam.Color = Color(1,1,1,1)
        end
    else
        d.PowerTimer = nil
        fam.Color = Color(1,1,1,1)
    end

    local power = fam:GetMultiplier()
    if d.PowerUp then
        power = power * d.PowerUp
    end
    if isSuperpositioned then
        power = power * 0.25
    end

    if d.CurrentHolder and d.CurrentHolder:Exists() then
        fam.CollisionDamage = 0
        sprite:SetFrame("Idle", 0)
        local holdingPlayer = d.CurrentHolder:ToPlayer()
        --Holding visuals
        local moveVec = holdingPlayer:GetMovementVector()
        local targPos = holdingPlayer.Position
        local dist = 20
        if moveVec:Length() > 0 then
            targPos = targPos + (moveVec*20)
            if math.abs(moveVec.X) > 0 then
                if moveVec.X < 0 then
                    sprite.FlipX = true
                else
                    sprite.FlipX = false
                end
            end
        else
            targPos = targPos + Vector(0,20)
        end
        fam.Velocity = mod:Lerp(fam.Velocity, (targPos - fam.Position), 0.5)

        if holdingPlayer:IsFlying() or room:GetType() == RoomType.ROOM_DUNGEON then
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        else
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end

        local aim = FiendFolio.GetCorrectedFiringInput(holdingPlayer)
        --Throw it here
        if aim:Length() > 0.5 then
            sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 0.75, 0, false, mod:RandomInt(125,175)/100)
            fam.Position = holdingPlayer.Position
            fam.Velocity = aim:Resized(15) + holdingPlayer:GetTearMovementInheritance(aim)
            d.CurrentHolder = nil
            d.BeingThrown = true
            if fam.Velocity.X > 0 then
                d.rotDir = 3
            else
                d.rotDir = -3
            end
            if sprite.FlipX then
                d.rotDir = d.rotDir * -1
            end
        end
    elseif d.BeingThrown then
        local gridcoll = room:GetGridCollisionAtPos(fam.Position)
        if gridcoll == GridCollisionClass.COLLISION_NONE then
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        fam.CollisionDamage = 1
        fam.Velocity = fam.Velocity * 0.95
        d.rotAmount = d.rotAmount or 0
        d.rotAmount = (d.rotAmount + d.rotDir) % 36
        sprite:SetFrame("Rotation", math.floor(d.rotAmount))
        d.fallSpeed = d.fallSpeed or -9 + (rng:RandomFloat() * -2)
        d.fallAccel = d.fallAccel or 1.25 + (rng:RandomFloat() * 0.5)
        d.fallSpeed = d.fallSpeed + d.fallAccel
        fam.SpriteOffset = Vector(0, fam.SpriteOffset.Y + d.fallSpeed)
        --sprite.Rotation = sprite.Rotation + (10 * d.rotDir)
        if fam:CollidesWithGrid() then
            sfx:Play(mod.Sounds.D5WoodImpact, 0.5, 0, false, mod:RandomInt(100,150)/100)
        end
        if fam.SpriteOffset.Y >= 0 then
            sfx:Play(mod.Sounds.D5WoodImpact, 0.5, 0, false, mod:RandomInt(100,150)/100)
            d.bounceCount = d.bounceCount or 0
            d.bounceCount = d.bounceCount + 1
            fam.SpriteOffset = Vector.Zero
            if d.bounceCount >= 3 then
                d.BeingThrown = nil
                d.bounceCount = nil
                d.fallAccel = nil
                d.fallSpeed = nil
                d.rotAmount = nil
                d.handLanded = nil
                d.spawnedEffect = nil
                d.endFrame = rng:RandomInt(5) + 1
                --d.endFrame = 2
                d.lastCollider = nil
            else
                d.fallSpeed = -10 + (d.bounceCount * 3)
                d.fallAccel = d.fallAccel
                d.rotDir = d.rotDir * -0.75
            end
        end
        if fam.FrameCount % 5 == 1 then
            local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, fam.Position, fam.Velocity * 0.1, fam)
            mod:GetEntityData(cloud).longonly = true
            cloud.SpriteOffset = fam.SpriteOffset
            cloud.SpriteScale = Vector(0.75,0.75)
            cloud.Color = Color(1,1,1,0.25)
            cloud:Update()
        end
    else
        fam.CollisionDamage = 0
        sprite.Rotation = 0
        sprite.FlipX = false
        if room:GetGridCollisionAtPos(fam.Position) == GridCollisionClass.COLLISION_NONE then
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if d.endFrame and not d.handLanded then
            if sprite:IsFinished("Land".. d.endFrame) then
                d.handLanded = true
            else
                mod:spritePlay(sprite, "Land".. d.endFrame)
            end
        else
            sprite:SetFrame("Idle", d.endFrame or 0)
        end
        if d.endFrame and not d.spawnedEffect then
            local dpf = mod:calculateDPS(player)
            if d.endFrame == 1 then
                --Spawn creep
                sfx:Play(mod.Sounds.D5CreepPuddle, 0.75, 0, false, mod:RandomInt(125,175)/100)
                local creep = Isaac.Spawn(1000,32,0,fam.Position,Vector.Zero, player):ToEffect()
                local newCol = Color(1,1,1,1)
                newCol:SetColorize(127/255,164/255,237/255,1)
                creep.Color = newCol
                creep.CollisionDamage = (dpf) * power -- ~3.2 at base
                creep.Scale = creep.Scale * (0.9 + (power * 0.1))
                --creep.Timeout = 180
                if isSuperpositioned then
                    local tearcolor = Color.Lerp(creep.Color, Color(1,1,1,1,0,0,0), 0)
                    tearcolor.A = tearcolor.A / 4
                    creep.Color = tearcolor
                end
                creep:Update()
                d.PowerUp = nil
            elseif d.endFrame == 2 then
                --Double next effect
                d.PowerUp = d.PowerUp or 1
                d.PowerUp = d.PowerUp * 2
                local pitch = 0.8 + d.PowerUp/10
                sfx:Play(mod.Sounds.D5DoublePower, 0.75, 0, false, math.min(pitch, 3))
            elseif d.endFrame == 3 then
                --Fire out 3 crit tears
                sfx:Play(mod.Sounds.WarpZoneSpit, 0.75, 0, false, mod:RandomInt(130,150,rng)/100)
                local vec = RandomVector()
                local target = mod.FindClosestEnemy(fam.Position, 800, true, nil, nil, nil, nil, nil, nil, nil, 3)
                if target then
                    vec = target.Position - fam.Position
                end
                vec = vec:Resized(13)
                for i = 120, 360, 120 do
                    local tear = Isaac.Spawn(2, 0, 0, fam.Position, vec:Rotated(i), fam):ToTear()
                    local critOdds = (10 - math.floor(player.Luck * 2))
                    tear.CollisionDamage = (dpf * 1.5) -- ~15 at base
                    if math.random(math.max(3, critOdds)) == 1 then
                        TearFlagsLib.AddTearFlags(tear, mod.CritFlag)
						local data = mod:GetEntityData(tear)
						if not data.critLightning or not data.critLightning:Exists() then
							sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
							local critLightning = Isaac.Spawn(1000, 1737, 1, tear.Position, Vector.Zero, tear):ToEffect()
							critLightning.Parent = tear
							critLightning.Color = Color(1,1,1,0,0,0,1)
							critLightning:Update()
							data.critLightning = critLightning
						end
						tear.Color = Color(1.3,1.3,1.3,1,100/255,-150/255,100/255)
                    end
                    tear.CollisionDamage = tear.CollisionDamage * power
                    tear.Scale = tear.Scale * (1 + (power * 0.1))
                    if isSuperpositioned then
                        local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                        tearcolor.A = tearcolor.A / 4
                        tear.Color = tearcolor
                    end
                end
                d.PowerUp = nil
            elseif d.endFrame == 4 then
                --Fire out 4 flames
                for i = 90, 360, 90 do
                    local fire = Isaac.Spawn(1000, 52, 0, fam.Position, Vector(10,0):Rotated(i), player):ToEffect()
                    fire:Update()
                    fire.CollisionDamage = (dpf/1.9) * power -- ~5 at base
                    fire.Timeout = 250
                    if isSuperpositioned then
                        local tearcolor = Color.Lerp(fire.Color, Color(1,1,1,1,0,0,0), 0)
                        tearcolor.A = tearcolor.A / 4
                        fire.Color = tearcolor
                    end
                    fire.Scale = fire.Scale * (0.9 + (power * 0.1))
                    fire:Update()
                    sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
                end
                d.PowerUp = nil
            elseif d.endFrame == 5 then
                --Five out 5 bruising tears
                sfx:Play(mod.Sounds.ShotgunBlast,0.2,0,false,mod:RandomInt(120,150,rng)/100)
                local vec = RandomVector()
                local target = mod.FindClosestEnemy(fam.Position, 800, true, nil, nil, nil, nil, nil, nil, nil, 3)
                if target then
                    vec = target.Position - fam.Position
                end
                vec = vec:Resized((1 + mod.FriendBalancing.Shotspeed) * 10)
                for i = -45, 45, 22.5 do
                    local tear = Isaac.Spawn(2, 0, 0, fam.Position, vec:Rotated(i), fam):ToTear()
                    tear:ChangeVariant(mod.TEAR.M90_BULLET)
                    local data = mod:GetEntityData(tear)
                    tear.CollisionDamage = (dpf * 0.75) * power -- ~7.2 at base
                    FiendFolio.FlagBruise(tear, 120 * (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1), 1, 1)
                    tear.Color = Color(0.5, 0.3, 0.5, 1.0, 40/255, 0/255, 40/255)
                    tear.Scale = tear.Scale * (0.9 + (power * 0.1))
                    if isSuperpositioned then
                        local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                        tearcolor.A = tearcolor.A / 4
                        tear.Color = tearcolor
                    end
                end
                d.PowerUp = nil
            end
            d.spawnedEffect = true
        end
        fam.Velocity = fam.Velocity * 0.2
    end
    for _, ent in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.D5, -1)) do
        if GetPtrHash(ent) ~= GetPtrHash(fam) then
            local entDat = mod:GetEntityData(ent)
            if (not d.CurrentHolder) and (not entDat.CurrentHolder) then
                local actualDist = ent.Position:Distance(fam.Position) - fam.Size - ent.Size
                if actualDist <= 0 then
                    if d.BeingThrown and not (entDat.BeingThrown) and ((not entDat.endFrame) or (entDat.endFrame and entDat.spawnedEffect)) then
                        sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 0.75, 0, false, mod:RandomInt(125,175)/100)
                        ent.Velocity = (ent.Position - fam.Position):Resized(5):Rotated(mod:RandomInt(-90,90,rng))
                        entDat.CurrentHolder = nil
                        entDat.BeingThrown = true
                        if ent.Velocity.X > 0 then
                            entDat.rotDir = 3
                        else
                            entDat.rotDir = -3
                        end
                        if ent:GetSprite().FlipX then
                            entDat.rotDir = entDat.rotDir * -1
                        end
                        entDat.bounceCount = mod:RandomInt(0,1,rng)
                        entDat.fallSpeed = -10 + (entDat.bounceCount * 3)
                    else
                        if (not d.BeingThrown) and not entDat.BeingThrown then
                            local vec = (ent.Position - fam.Position):Rotated(mod:RandomInt(-90,90,rng))
                            if vec:Length() <= 0.1 then
                                vec = RandomVector()
                            end
                            ent.Velocity = ent.Velocity + vec:Resized(actualDist * -0.25)
                        end
                    end
                end
            end
        end
    end
end, mod.ITEM.FAMILIAR.D5)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, fam, coll)
    local d = mod:GetEntityData(fam)
    if coll.Type == 1 and not d.BeingThrown then
        if not d.CurrentHolder or (d.CurrentHolder and not d.CurrentHolder:Exists()) then
            if (not d.endFrame) or (d.endFrame and d.spawnedEffect) then
                local cannotHold
                for _, ent in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.D5, -1)) do
                    local entDat = mod:GetEntityData(ent)
                    if entDat.CurrentHolder and GetPtrHash(entDat.CurrentHolder) == GetPtrHash(coll) then
                        cannotHold = true
                        break
                    end
                end
                if not cannotHold then
                    d.CurrentHolder = coll
                    sfx:Play(SoundEffect.SOUND_SCAMPER, 0.35, 0, false, mod:RandomInt(150,175)/100)
                end
            end
        end
    elseif coll.Type > 9 then
        if d.BeingThrown then
            if (not d.lastCollider) or (GetPtrHash(d.lastCollider) ~= GetPtrHash(coll)) then
                d.lastCollider = coll
                sfx:Play(mod.Sounds.D5WoodImpact, 0.5, 0, false, mod:RandomInt(100,150)/100)
                fam.Velocity = (fam.Velocity + (fam.Position - coll.Position) * 5):Resized(fam.Velocity:Length() * 0.5)
            end
        end
    end
end, mod.ITEM.FAMILIAR.D5)