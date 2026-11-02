local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    GunOffset = Vector(14, -6),
    TrailColor1 = Color(1, 1, 1, 1, 0, 0, 0, 1, 0.2, 0.2, 1),
    TrailColor2 = Color(0.5, 0.5, 0.5, 1, 0, 0, 0, 0.6, 0.2, 0.2, 1),
    HaemoColor1 = Color(0.7, 0.5, 0.5, 1, 0.3, 0, 0, 0.6, 0.2, 0.2, 1),
    HaemoColor2 = Color(0.4, 0.2, 0.2, 1, 0.2, 0, 0, 0.6, 0.2, 0.2, 1),
    DustColor = Color(0.65, 0.5, 0.5, 0.1, 0, 0, 0),
    TurnDelay = 5,
    DisTimer = 25,
    RockShots = 3,

    DamMult = 2,
    DamFlat = 7.5,
    DamScale = 1.3,
    RailRadius = 50,
}

mod.RaildriverRails = {}
local SimpleLefts = {[RoomShape.ROOMSHAPE_1x1] = true, [RoomShape.ROOMSHAPE_IH] = true, [RoomShape.ROOMSHAPE_2x1] = true, [RoomShape.ROOMSHAPE_IIH] = true,
    [RoomShape.ROOMSHAPE_LBL] = true}
local SimpleUps = {[RoomShape.ROOMSHAPE_1x1] = true, [RoomShape.ROOMSHAPE_IV] = true, [RoomShape.ROOMSHAPE_1x2] = true, [RoomShape.ROOMSHAPE_IIV] = true,
    [RoomShape.ROOMSHAPE_LTR] = true}
local SimpleRights = {[RoomShape.ROOMSHAPE_1x1] = true, [RoomShape.ROOMSHAPE_IH] = true, [RoomShape.ROOMSHAPE_2x1] = true, [RoomShape.ROOMSHAPE_IIH] = true,
    [RoomShape.ROOMSHAPE_LBR] = true}
local SimpleDowns = {[RoomShape.ROOMSHAPE_1x1] = true, [RoomShape.ROOMSHAPE_IV] = true, [RoomShape.ROOMSHAPE_1x2] = true, [RoomShape.ROOMSHAPE_IIV] = true,
    [RoomShape.ROOMSHAPE_LBR] = true}

function mod:RaildriverGunMovement(e, player, forceNoLerp, target)
    target = target or player
    local d = mod:GetEntityData(e)
    local pd = mod:GetEntityData(player)
    local sprite = e:GetSprite()
    local fireDir = player:GetAimDirection()
    local room = game:GetRoom()
	if not pd.LastFiredMouse or mod.MouseGunAiming == 0 then
        fireDir = mod:SnapVector(fireDir, 90)
    end
    d.CurrentAngle = d.CurrentAngle or 90
    if fireDir:Length() > 0.5 then
        d.PreviousGunDir = Vector(fireDir.X, fireDir.Y)
        d.PreviousFireFrame = e.FrameCount
        if d.NOMORETURNING and not d.LockedInDir then
            d.LockedInDir = fireDir
        end
    else
        fireDir = d.PreviousGunDir
    end
    if d.LockedInDir then
        fireDir = d.LockedInDir
    end
    local targetPos = target.Position

    if d.PreviousFireFrame and e.FrameCount-d.PreviousFireFrame > 60 then
        d.PreviousFireFrame = nil
        d.PreviousGunDir = nil
    end

    local dir
    if not (pd.LastFiredMouse and mod.MouseGunAiming == 1) then
        if fireDir then
            local targetDir = fireDir
            local targetAng = d.AngleOffset + mod:GetAngleDegreesButGood(targetDir)
            if math.abs(d.CurrentAngle-(targetAng+360)) < math.abs(d.CurrentAngle-targetAng) then
                d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+targetAng, 0.75)
            elseif math.abs(d.CurrentAngle-(targetAng-360)) < math.abs(d.CurrentAngle-targetAng) then
                d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng-360, 0.75)
            else
                d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng, 0.75)
            end
        else
            local targetDir = (target.Velocity:Length() > 0.3 and target.Velocity) or (player:GetMovementVector():Length() > 0.3 and player:GetMovementVector()) or target.Velocity
            local snappedAng = d.AngleOffset + mod:GetAngleDegreesButGood(mod:SnapVector(targetDir, 90))
            if math.abs(d.CurrentAngle-(snappedAng+360)) < math.abs(d.CurrentAngle-snappedAng) then
                d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+snappedAng, 0.75)
            elseif math.abs(d.CurrentAngle-(snappedAng-360)) < math.abs(d.CurrentAngle-snappedAng) then
                d.CurrentAngle = mod:Lerp(d.CurrentAngle, snappedAng-360, 0.75)
            else
                d.CurrentAngle = mod:Lerp(d.CurrentAngle, snappedAng, 0.75)
            end
        end
    end

    if pd.LastFiredMouse and mod.MouseGunAiming == 1 then
        local pos = Input.GetMousePosition(true)
        if room:IsMirrorWorld() then
            local xPos = 2*room:GetCenterPos().X-pos.X
            pos = Vector(xPos, pos.Y)
        end
        local height = (mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].TearHeight) or mod.FriendBalancing.DefaultTearHeight
        local vec = pos-targetPos-Vector(0, height)
        if d.LockedInDir then
            vec = d.LockedInDir
        end
        local snappedAng = d.AngleOffset + mod:GetAngleDegreesButGood(mod:SnapVector(vec, 90))
        if math.abs(d.CurrentAngle-(snappedAng+360)) < math.abs(d.CurrentAngle-snappedAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+snappedAng, 0.75)
        elseif math.abs(d.CurrentAngle-(snappedAng-360)) < math.abs(d.CurrentAngle-snappedAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, snappedAng-360, 0.75)
        else
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, snappedAng, 0.75)
        end
    end

    if d.LockAngle then
        d.CurrentAngle = d.LockAngle
    end

    d.CurrentAngle = d.CurrentAngle % 360

    local offset = (mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].HeldOffset) or mod.FriendBalancing.DefaultHeldOffset
    local verticalOffset = (mod.FriendGunInfo[e.SubType] and mod.FriendGunInfo[e.SubType].VerticalOffset) or mod.FriendBalancing.DefaultVerticalOffset
    if d.CurrentAngle > 0 and d.CurrentAngle < 180 then
        local real = (90-math.abs(90-d.CurrentAngle))/90
        offset = offset-offset*0.25*real
    end
    if e.Variant == mod.FF.FriendsRevolver.Var and d.state == "Reload" then
        d.reloadOffset = d.reloadOffset or 1
        if d.substate == "End" then
            d.startReloadOffset = nil
            offset = offset*d.reloadOffset
            d.reloadOffset = math.min(1, d.reloadOffset+0.1)
        elseif d.startReloadOffset then
            offset = offset*d.reloadOffset
            d.reloadOffset = math.max(0.5, d.reloadOffset-0.1)
        end
        d.PreviousFireFrame = e.FrameCount-20
    end
    dir = Vector(offset, verticalOffset):Rotated(d.CurrentAngle)

    if d.MultishotOffset then
        dir = dir + d.MultishotOffset:Rotated(d.CurrentAngle)
    end

    e.SpriteRotation = d.CurrentAngle

    if d.CurrentAngle > 90 and d.CurrentAngle <= 270 then
        sprite.FlipX = true
        e.SpriteRotation = 180-e.SpriteRotation
    else
        sprite.FlipX = false
    end

    if sprite.FlipY then
        sprite.FlipY = false
    end

    if sprite.FlipY then
        e.SpriteRotation = -e.SpriteRotation
    end

    if e.FrameCount < 2 or forceNoLerp then
        e.Position = targetPos + dir
        e.Velocity = Vector.Zero
    else
        e.Velocity = (targetPos+target.Velocity*2.5+dir) - e.Position
    end
end

function mod:RaildriverNewRoomPlayer(player, d, room)
    if (room:IsFirstVisit() and player:HasCollectible(mod.ITEM.COLLECTIBLE.RAILDRIVER) and not room:IsClear()) then
        local gun = Isaac.Spawn(mod.FF.RaildriverGun.ID, mod.FF.RaildriverGun.Var, mod.FF.RaildriverGun.Sub, player.Position, Vector.Zero, player):ToEffect()
        local gd = mod:GetEntityData(gun)
        gd.AngleOffset = 0
        d.RaildriverGun = gun
    end
end
mod:AddCollectibleCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.RAILDRIVER, mod.RaildriverNewRoomPlayer)

mod:AddCollectibleCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, mod.ITEM.COLLECTIBLE.RAILDRIVER, function(_, player, d, waveNumber, isBossWave)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.RAILDRIVER) then
        --Basically ensures it won't give you a new raildriver and then the old one gets stuck
        if not (d.RaildriverGun)
        or (d.RaildriverGun and not d.RaildriverGun:Exists())
        or (d.RaildriverGun and d.RaildriverGun:Exists() and mod:GetEntityData(d.RaildriverGun).DisappearTimer)
        then
            local gun = Isaac.Spawn(mod.FF.RaildriverGun.ID, mod.FF.RaildriverGun.Var, mod.FF.RaildriverGun.Sub, player.Position, Vector.Zero, player):ToEffect()
            local gd = mod:GetEntityData(gun)
            gd.AngleOffset = 0
            d.RaildriverGun = gun
        end
    end
end)

function mod:RaildriverNewRoom(room)
    local level = game:GetLevel()
    local index = level:GetCurrentRoomDesc().ListIndex
    if mod.RaildriverRails[index] then
        for key,entry in pairs(mod.RaildriverRails[index]) do
            if not entry.Hole and entry.Player and entry.Player:Exists() then
                local player = entry.Player
                local doors = mod.availableDoors[room:GetRoomShape()]
                local foundDoors = {}
                for _,checkDoor in ipairs(doors) do
                    local checkedDoor = room:GetDoor(checkDoor)
                    if checkedDoor and level:GetRoomByIdx(checkedDoor.TargetRoomIndex).ListIndex == entry.PreviousIndex then
                        local goAhead
                        if entry.Vert then
                            if checkedDoor.Direction == Direction.UP or checkedDoor.Direction == Direction.DOWN then
                                goAhead = true
                            end
                        else
                            if checkedDoor.Direction == Direction.LEFT or checkedDoor.Direction == Direction.RIGHT then
                                goAhead = true
                            end
                        end
                        if goAhead then
                            table.insert(foundDoors, checkedDoor)
                        end
                    end
                end
                local start = player.Position
                local off = (entry.Vert and Vector(entry.DoorPos.X, 0)) or Vector(0, entry.DoorPos.Y)
                if #foundDoors > 1 then
                    local door
                    if (entry.Vert and entry.CenterPos.X > 0) or (not entry.Vert and entry.CenterPos.Y > 0) then
                        door = foundDoors[2]
                    else
                        door = foundDoors[1]
                    end
                    start = door.Position+off
                elseif #foundDoors == 1 then
                    start = foundDoors[1].Position+off
                end
                if room:IsPositionInRoom(start+entry.Dir:Resized(55), 0) then
                    mod.scheduleForUpdate(function()
                        sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.6, 0, false, mod:RandomInt(95,105,entry.RNG)/100)
                        sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.6, 0, false, mod:RandomInt(95,105,entry.RNG)/100)
                        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.8, 0, false, mod:RandomInt(95,105,entry.RNG)/100)
                        local aim = entry.Dir:Resized(15)
                        local tear = Isaac.Spawn(mod.FF.ChaosCardLeftover.ID, mod.FF.ChaosCardLeftover.Var, mod.FF.ChaosCardLeftover.Sub, start, aim, entry.Player):ToEffect()
                        tear.Visible = false
                        tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                        tear.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, start+Vector(0, bal.GunOffset.Y), Vector.Zero, entry.Player):ToEffect()
                        trail.Parent = tear
                        trail.Color = bal.TrailColor2
                        trail:Update()
                        local keepAtIt = true
                        local count = 0
                        local finalPos = tear.Position
                        while keepAtIt == true do
                            count = count+1
                            tear:Update()
                            local grid = room:GetGridEntityFromPos(tear.Position)
                            if grid and (grid:GetType() == GridEntityType.GRID_WALL or grid:GetType() == GridEntityType.GRID_DOOR) and count > 5 then
                                if entry.Vert then
                                    finalPos = Vector(tear.Position.X, grid.Position.Y)
                                else
                                    finalPos = Vector(grid.Position.X, tear.Position.Y)
                                end
                                keepAtIt = false
                                trail.Parent = trail
                                trail.Position = tear.Position+Vector(0, bal.GunOffset.Y)
                                trail.Velocity = aim:Resized(0.1)
                                trail:Update()
                                mod.scheduleForUpdate(function()
                                    trail:Remove()
                                end, 10)
                                tear:Remove()
                            elseif count > 700 then
                                finalPos = tear.Position+tear.Velocity:Resized(10)
                                keepAtIt = false
                                trail.Parent = trail
                                trail.Position = tear.Position
                                trail:Update()
                                mod.scheduleForUpdate(function()
                                    trail:Remove()
                                end, 10)
                                tear:Remove()
                            end
                        end

                        local realDoors = 0
                        if entry.DoorCheck then
                            local grid = room:GetGridEntityFromPos(start)
                            if grid and grid:GetType() == GridEntityType.GRID_DOOR then
                                if grid:ToDoor():IsOpen() then
                                    realDoors = 2
                                else
                                    realDoors = 1
                                end
                            end
                        end
                        if realDoors < 2 then
                            local targPos = (start+entry.Dir:Resized(60))
                            local crack = Isaac.Spawn(mod.FF.RaildriverCrack.ID, mod.FF.RaildriverCrack.Var, mod.FF.RaildriverCrack.Sub, targPos, Vector.Zero, entry.Player)
                            mod:GetEntityData(crack).MyPos = start
                            if realDoors == 1 then
                                mod:GetEntityData(crack).DoorCheck = true
                            end
                            crack.SpriteRotation = mod:GetAngleDegreesButGood(entry.Dir)-90
                            crack:Update()
                            crack:Update()
                        end

                        for _,enemy in ipairs(Isaac.FindInRadius(entry.Player.Position, 9999, EntityPartition.ENEMY)) do
                            if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
                                if entry.Vert then
                                    if math.abs(enemy.Position.X-finalPos.X) <= bal.RailRadius then
                                        enemy:TakeDamage(entry.Damage, 0, EntityRef(entry.Player), 0)
                                    end
                                else
                                    if math.abs(enemy.Position.Y-finalPos.Y) <= bal.RailRadius then
                                        enemy:TakeDamage(entry.Damage, 0, EntityRef(entry.Player), 0)
                                    end
                                end
                            end
                        end

                        for i=1,4 do
                            local vel = entry.Dir:Resized(mod:RandomInt(5,55,entry.RNG)/10):Rotated(mod:RandomInt(-35,35,entry.RNG))
                            local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, start, vel, entry.Player)
                            gib:Update()
                        end
                        for i=1,3 do
                            local vel = entry.Dir:Resized(mod:RandomInt(5,55,entry.RNG)/10):Rotated(180+mod:RandomInt(-35,35,entry.RNG))
                            local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, finalPos, vel, entry.Player)
                            gib:Update()
                        end
                        for i=-2,2 do
                            local spd = -mod:RandomInt(1,8,entry.RNG)/4
                            local vel = entry.Dir:Rotated(mod:RandomInt(-35,35,entry.RNG)):Resized(spd)
                            local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, finalPos + vel:Resized(6), vel, entry.Player):ToEffect()
                            local de_dust = mod:GetEntityData(dust)
                            dust.Color = bal.DustColor
                            dust.SpriteScale = Vector(0.3, 0.3)
                            dust:SetTimeout(mod:RandomInt(45,75,entry.RNG))
                            de_dust.cosmeticDust = {vel = vel, scale = mod:RandomInt(40,60,entry.RNG)/100, alpha = 0.5}
                            dust:Update()
                        end
                        for i=1,3 do
                            local spd = mod:RandomInt(2,10,entry.RNG)/4
                            local vel = entry.Dir:Rotated(mod:RandomInt(-20,20,entry.RNG)):Resized(spd)
                            local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, start + vel:Resized(15), vel, entry.Player):ToEffect()
                            local de_dust = mod:GetEntityData(dust)
                            dust.Color = bal.DustColor
                            dust.SpriteScale = Vector(0.5, 0.5)
                            dust:SetTimeout(mod:RandomInt(45,75,entry.RNG))
                            de_dust.cosmeticDust = {vel = vel, scale = mod:RandomInt(70,100,entry.RNG)/100, alpha = 0.5}
                            dust:Update()
                        end
                        for i=1,start:Distance(finalPos),30 do
                            if entry.RNG:RandomInt(2) > 0 then
                                local pos = start+entry.Dir:Resized(i+mod:RandomInt(-5,5,entry.RNG))+mod:shuntedPosition(5,entry.RNG)
                                local vel = Vector(mod:RandomInt(1,15,entry.RNG)/10, 0):Rotated(entry.RNG:RandomInt(360))
                                local haemo = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, pos, vel, entry.Player):ToEffect()
                                haemo.Color = bal.HaemoColor2
                                haemo.Parent = player
                                local scale = mod:getRoll(30,60,entry.RNG)/100
                                haemo.SpriteScale = Vector(scale, scale)
                                haemo.SpriteOffset = Vector(0, bal.GunOffset.Y)
                                haemo:SetTimeout(mod:RandomInt(7,25,entry.RNG))
                                local hd = mod:GetEntityData(haemo)
                                hd.Deccel = 0.9
                                hd.ShrinkDelay = 4
                                haemo:Update()
                            end
                        end
                        for i=1,bal.RockShots do
                            mod.scheduleForUpdate(function()
                                local vel = entry.Dir:Resized(mod:RandomInt(35,75,entry.RNG)/10):Rotated(mod:RandomInt(-25,25,entry.RNG))
                                local rock = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ROCK, 0, start, vel, entry.Player):ToTear()
                                rock.Scale = mod:RandomInt(60,100,entry.RNG)/100
                                rock.CollisionDamage = entry.RockDam
                                rock.FallingAcceleration = 1.1
                                rock.FallingSpeed = -mod:RandomInt(6,20,entry.RNG)
                                rock:Update()
                            end, i)
                        end
                        local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, finalPos-aim:Resized(15), Vector.Zero, entry.Player):ToEffect()
                        for i = 1,4 do
                            local vel = entry.Dir:Resized(-mod:RandomInt(5,20,entry.RNG)/10):Rotated(mod:RandomInt(-45,45,entry.RNG))
                            local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE, 0, finalPos-aim:Resized(15), vel, entry.Player):ToEffect()
                            gib.m_Height = -7
                            gib.State = 2
                        end
                        game:ShakeScreen(2)

                        entry.Hole = true
                        entry.TruePos = start
                        entry.StartHole = true
                    end, 2)
                else
                    mod.RaildriverRails[index][key] = nil
                end
            else
                local realDoors = 0
                if entry.DoorCheck then
                    local grid = room:GetGridEntityFromPos(entry.TruePos)
                    if grid and grid:GetType() == GridEntityType.GRID_DOOR then
                        if grid:ToDoor():IsOpen() then
                            realDoors = 2
                        else
                            --realDoors = 1
                            realDoors = 2
                            --Doors register as closed for the first frame so I'll just avoid them respawning here cause it's annoying
                        end
                    end
                end
                if realDoors < 2 then
                    local targPos
                    local turnSprite = 90
                    if entry.StartHole then
                        turnSprite = -90
                        targPos = (entry.TruePos+entry.Dir:Resized(60))
                    else
                        targPos = (entry.TruePos-entry.Dir:Resized(60))
                    end
                    local crack = Isaac.Spawn(mod.FF.RaildriverCrack.ID, mod.FF.RaildriverCrack.Var, mod.FF.RaildriverCrack.Sub, targPos, Vector.Zero, entry.Player)
                    mod:GetEntityData(crack).MyPos = entry.TruePos
                    if realDoors == 1 then
                        mod:GetEntityData(crack).DoorCheck = true
                    end
                    crack.SpriteRotation = mod:GetAngleDegreesButGood(entry.Dir)+turnSprite
                    crack:Update()
                    crack:Update()

                    --[[if realDoors > 0 then
                        mod.scheduleForUpdate(function()
                            local grid = room:GetGridEntityFromPos(entry.TruePos)
                            if grid:ToDoor():IsOpen() then
                                crack:Remove()
                                mod.RaildriverRails[index][key] = nil
                            end
                        end, 1)
                    end]]
                end
            end
        end
    end
end

function mod:RaildriverGunUpdate(e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)
    local rng = e:GetDropRNG()
    local room = game:GetRoom()

    if not d.init then
        d.State = "Appear"
        d.init = true
    end

    local player = mod:GetFriendGunPlayer(e)
    if player and player:Exists() and not player:IsDead() then
        --mod:StandardGunMovement(e, player)
        mod:RaildriverGunMovement(e, player) --Okay, I want it to only point 90 degrees

        if d.State == "Idle" then
            if d.DisappearTimer then
                if d.DisappearTimer > 0 then
                    d.DisappearTimer = d.DisappearTimer-1
                else
                    d.State = "Disappear"
                end
            elseif d.JustShot then
                d.State = "Shoot"
            end
            mod:SpritePlay(sprite, "Idle")
        elseif d.State == "Appear" then
            if sprite:IsFinished("Appear") then
                d.State = "Idle"
            else
                mod:SpritePlay(sprite, "Appear")
            end
        elseif d.State == "Shoot" then
            if sprite:IsFinished("Shoot") then
                d.State = "Idle"
                d.DisappearTimer = bal.DisTimer
            else
                mod:SpritePlay(sprite, "Shoot")
            end
        elseif d.State == "Disappear" then
            if sprite:IsFinished("Disappear") then
                e:Remove()
            else
                mod:SpritePlay(sprite, "Disappear")
            end
        end
    else
        e.Velocity = Vector.Zero
        if sprite:IsFinished("Disappear") then
            e:Remove()
        else
            mod:spritePlay(sprite, "Disappear")
        end
    end
end

function mod:RaildriverFire(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.RAILDRIVER) then
        local d = mod:GetEntityData(player)
        local aim = mod:GetSimpleAimDir(player)
        if aim:Length() > 0.5 and d.RaildriverGun and d.RaildriverGun:Exists() then
            local gun = d.RaildriverGun
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.RAILDRIVER)
            if not mod:GetEntityData(gun).NOMORETURNING then
                mod:GetEntityData(gun).NOMORETURNING = true
                sfx:Play(SoundEffect.SOUND_FETUS_LAND, 1, 0, false, 2.4)
                sfx:Play(SoundEffect.SOUND_TOOTH_AND_NAIL, 0.5, 0, false, 4)
                sfx:Play(mod.Sounds.PitchforkHit, 0.7, 0, false, 2)
                mod.scheduleForUpdate(function()
                    sfx:Play(mod.Sounds.SniperRifleFire, 0.24, 0, false, mod:RandomInt(100,110,rng)/100)
                    sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.8, 0, false, mod:RandomInt(105,115,rng)/100)
                    sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, mod:RandomInt(95,105,rng)/100)
                    sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.8, 0, false, mod:RandomInt(95,105,rng)/100)
                    local room = game:GetRoom()
                    local muzz
                    local mult = (gun.FlipX and -1) or 1
                    local rot = (gun.FlipX and 360-gun.SpriteRotation) or gun.SpriteRotation
                    muzz = gun.Position+Vector(mult*bal.GunOffset.X, 0):Rotated(rot)+gun.SpriteOffset+gun.PositionOffset
                    local tear = Isaac.Spawn(mod.FF.ChaosCardLeftover.ID, mod.FF.ChaosCardLeftover.Var, mod.FF.ChaosCardLeftover.Sub, muzz, aim:Resized(15), gun):ToEffect()
                    tear.Visible = false
                    --mod:TurnTearToFriendBullet(tear)
                    tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    tear.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, muzz+Vector(0, bal.GunOffset.Y), Vector.Zero, gun):ToEffect()
                    trail.Parent = tear
                    trail.Color = bal.TrailColor1
                    trail:Update()
                    local keepAtIt = true
                    local count = 0
                    local finalPos = tear.Position
                    local vert = math.abs(aim.Y) > math.abs(aim.X)
                    while keepAtIt == true do
                        count = count+1
                        tear:Update()
                        local grid = room:GetGridEntityFromPos(tear.Position)
                        if grid and (grid:GetType() == GridEntityType.GRID_WALL or grid:GetType() == GridEntityType.GRID_DOOR) then
                            if vert then
                                finalPos = Vector(tear.Position.X, grid.Position.Y)
                            else
                                finalPos = Vector(grid.Position.X, tear.Position.Y)
                            end
                            keepAtIt = false
                            trail.Parent = trail
                            trail.Position = tear.Position+Vector(0, bal.GunOffset.Y)
                            trail.Velocity = aim:Resized(0.1)
                            trail:Update()
                            mod.scheduleForUpdate(function()
                                trail:Remove()
                            end, 10)
                            tear:Remove()
                        elseif count > 700 then
                            finalPos = tear.Position+tear.Velocity:Resized(10)
                            keepAtIt = false
                            trail.Parent = trail
                            trail.Position = tear.Position
                            trail:Update()
                            mod.scheduleForUpdate(function()
                                trail:Remove()
                            end, 10)
                            tear:Remove()
                        end
                    end

                    local grid = room:GetGridEntityFromPos(finalPos)
                    if grid and grid:GetType() == GridEntityType.GRID_DOOR then
                        if not grid:ToDoor():IsOpen() then
                            local targPos = (finalPos-aim:Resized(60))
                            local crack = Isaac.Spawn(mod.FF.RaildriverCrack.ID, mod.FF.RaildriverCrack.Var, mod.FF.RaildriverCrack.Sub, targPos, Vector.Zero, player)
                            crack.SpriteRotation = mod:GetAngleDegreesButGood(aim)+90
                            mod:GetEntityData(crack).MyPos = finalPos
                            mod:GetEntityData(crack).DoorCheck = true
                            crack:Update()
                            crack:Update()
                        end
                    else
                        local targPos = (finalPos-aim:Resized(60))
                        local crack = Isaac.Spawn(mod.FF.RaildriverCrack.ID, mod.FF.RaildriverCrack.Var, mod.FF.RaildriverCrack.Sub, targPos, Vector.Zero, player)
                        crack.SpriteRotation = mod:GetAngleDegreesButGood(aim)+90
                        mod:GetEntityData(crack).MyPos = finalPos
                        crack:Update()
                        crack:Update()
                    end

                    for i=1,4 do
                        local vel = aim:Resized(mod:RandomInt(5,55,rng)/10):Rotated(180+mod:RandomInt(-35,35,rng))
                        local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, finalPos, vel, player)
                        gib:Update()
                    end
                    for i=-2,2 do
                        local spd = -mod:RandomInt(1,8,rng)/4
                        local vel = aim:Rotated(mod:RandomInt(-35,35,rng)):Resized(spd)
                        local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, finalPos + vel:Resized(6), vel, player):ToEffect()
                        local de_dust = mod:GetEntityData(dust)
                        dust.Color = bal.DustColor
                        dust.SpriteScale = Vector(0.3, 0.3)
                        dust:SetTimeout(mod:RandomInt(45,75,rng))
                        de_dust.cosmeticDust = {vel = vel, scale = mod:RandomInt(40,60,rng)/100, alpha = 0.5}
                        dust:Update()
                    end
                    for i=1,3 do
                        local spd = mod:RandomInt(2,10,rng)/4
                        local vel = aim:Rotated(mod:RandomInt(-20,20,rng)):Resized(spd)
                        local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, muzz + vel:Resized(15), vel, player):ToEffect()
                        local de_dust = mod:GetEntityData(dust)
                        dust.Color = bal.DustColor
                        dust.SpriteScale = Vector(0.5, 0.5)
                        dust:SetTimeout(mod:RandomInt(45,75,rng))
                        de_dust.cosmeticDust = {vel = vel, scale = mod:RandomInt(70,100,rng)/100, alpha = 0.5}
                        dust:Update()
                    end
                    for i=1,muzz:Distance(finalPos),30 do
                        if rng:RandomInt(2) > 0 then
                            local pos = muzz+aim:Resized(i+mod:RandomInt(-5,5,rng))+mod:shuntedPosition(5,rng)
                            local vel = Vector(mod:RandomInt(1,15,rng)/10, 0):Rotated(rng:RandomInt(360))
                            local haemo = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, pos, vel, player):ToEffect()
                            haemo.Color = bal.HaemoColor1
                            haemo.Parent = player
                            local scale = mod:getRoll(30,60,rng)/100
                            haemo.SpriteScale = Vector(scale, scale)
                            haemo.SpriteOffset = Vector(0, bal.GunOffset.Y)
                            haemo:SetTimeout(mod:RandomInt(7,25,rng))
                            local hd = mod:GetEntityData(haemo)
                            hd.Deccel = 0.9
                            hd.ShrinkDelay = 4
                            haemo:Update()
                        end
                    end
                    game:ShakeScreen(6)

                    local level = game:GetLevel()
                    local stage = level:GetAbsoluteStage()
                    local dam = player.Damage*bal.DamMult+bal.DamFlat+stage*bal.DamScale
                    for _,enemy in ipairs(Isaac.FindInRadius(player.Position, 9999, EntityPartition.ENEMY)) do
                        if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
                            if vert then
                                if math.abs(enemy.Position.X-finalPos.X) <= bal.RailRadius then
                                    if (aim.Y > 0 and enemy.Position.Y > muzz.Y) or (aim.Y < 0 and enemy.Position.Y < muzz.Y) then
                                        enemy:TakeDamage(dam, 0, EntityRef(player), 0)
                                    end
                                end
                            else
                                if math.abs(enemy.Position.Y-finalPos.Y) <= bal.RailRadius then
                                    if (aim.X > 0 and enemy.Position.X > muzz.X) or (aim.X < 0 and enemy.Position.X < muzz.X) then
                                        enemy:TakeDamage(dam, 0, EntityRef(player), 0)
                                    end
                                end
                            end
                        end
                    end

                    if room:GetType() ~= RoomType.ROOM_DUNGEON then
                        --The evil door checking if else
                        local tl = room:GetTopLeftPos()
                        local br = room:GetBottomRightPos()
                        local midPoint = (br+tl)/2
                        local roomShape = room:GetRoomShape()
                        local wall = "None"
                        local door
                        if finalPos.X <= tl.X then
                            wall = "Left"
                        elseif finalPos.X >= br.X then
                            wall = "Right"
                        elseif finalPos.Y <= tl.Y then
                            wall = "Up"
                        elseif finalPos.Y >= br.Y then
                            wall = "Down"
                        else
                            if vert then
                                if roomShape == RoomShape.ROOMSHAPE_LTL then
                                    door = DoorSlot.UP0
                                elseif roomShape == RoomShape.ROOMSHAPE_LTR then
                                    door = DoorSlot.UP1
                                elseif roomShape == RoomShape.ROOMSHAPE_LBL then
                                    door = DoorSlot.DOWN0
                                elseif roomShape == RoomShape.ROOMSHAPE_LBR then
                                    door = DoorSlot.DOWN1
                                end
                            else
                                if roomShape == RoomShape.ROOMSHAPE_LTL then
                                    door = DoorSlot.LEFT0
                                elseif roomShape == RoomShape.ROOMSHAPE_LTR then
                                    door = DoorSlot.RIGHT0
                                elseif roomShape == RoomShape.ROOMSHAPE_LBL then
                                    door = DoorSlot.LEFT1
                                elseif roomShape == RoomShape.ROOMSHAPE_LBR then
                                    door = DoorSlot.RIGHT1
                                end
                            end
                        end
                        if wall == "Left" then
                            if SimpleLefts[roomShape] then
                                door = DoorSlot.LEFT0
                            else
                                if finalPos.Y <= midPoint.Y then
                                    door = DoorSlot.LEFT0
                                else
                                    door = DoorSlot.LEFT1
                                end
                            end
                        elseif wall == "Right" then
                            if SimpleRights[roomShape] then
                                door = DoorSlot.RIGHT0
                            else
                                if finalPos.Y <= midPoint.Y then
                                    door = DoorSlot.RIGHT0
                                else
                                    door = DoorSlot.RIGHT1
                                end
                            end
                        elseif wall =="Up" then
                            if SimpleUps[roomShape] then
                                door = DoorSlot.UP0
                            else
                                if finalPos.X <= midPoint.X then
                                    door = DoorSlot.UP0
                                else
                                    door = DoorSlot.UP1
                                end
                            end
                        elseif wall == "Down" then
                            if SimpleDowns[roomShape] then
                                door = DoorSlot.DOWN0
                            else
                                if finalPos.X <= midPoint.X then
                                    door = DoorSlot.DOWN0
                                else
                                    door = DoorSlot.DOWN1
                                end
                            end
                        end
                        local index = level:GetCurrentRoomDesc().ListIndex
                        if not mod.RaildriverRails[index] then
                            mod.RaildriverRails[index] = {}
                        end
                        local doors
                        if grid and grid:GetType() == GridEntityType.GRID_DOOR then
                            doors = true
                            --[[if not grid:ToDoor():IsOpen() then
                                table.insert(mod.RaildriverRails[index], {Hole = true, TruePos = finalPos, Dir = aim, DoorCheck = true})
                            end]]
                        else
                            table.insert(mod.RaildriverRails[index], {Hole = true, TruePos = finalPos, Dir = aim})
                        end
                        if door and room:GetDoor(door) then
                            local found = room:GetDoor(door)
                            local foundIndex = level:GetRoomByIdx(found.TargetRoomIndex).ListIndex
                            if not mod.RaildriverRails[foundIndex] then
                                mod.RaildriverRails[foundIndex] = {}
                            end
                            local itemMult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.RAILDRIVER)
                            local pos = finalPos-found.Position
                            table.insert(mod.RaildriverRails[foundIndex], {Damage = dam*itemMult, Dir = aim, PreviousIndex = index, DoorPos = pos, DoorCheck = doors,
                                CenterPos = finalPos-midPoint, Player = player, Vert = vert, RNG = rng, RockDam = (player.Damage+stage*bal.DamScale)*itemMult})
                        end
                    end
                end, bal.TurnDelay)
                mod.scheduleForUpdate(function()
                    mod:GetEntityData(gun).JustShot = true
                end, bal.TurnDelay-2)
            end
        end
    end
end

function mod:RaildriverCrackUpdate(e)
    local d = mod:GetEntityData(e)
    if not d.MyPos then
		d.MyPos = e.Position
	end
    if not d.Init then
		e:GetSprite().Color = mod:GetDirtColor(e.Position)
        d.Init = true
    end
	if d.DoorCheck then
		local room = game:GetRoom()
		local grid = room:GetGridEntityFromPos(e.Position)
		if grid and grid:GetType() == GridEntityType.GRID_DOOR and grid:ToDoor():IsOpen() then
			d.FadeOut = true
		end

		if d.FadeOut then
			local sprite = e:GetSprite()
			if sprite:IsFinished("Vanish") then
				e:Remove()
			else
				mod:SpritePlay(sprite, "Vanish")
			end
		end
	end
	e.Velocity = (d.MyPos-e.Position)
end