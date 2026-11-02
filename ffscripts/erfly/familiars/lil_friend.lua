local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, f)
	f.IsFollower = true
    f.Coins = 6 --Ammo
end, mod.ITEM.FAMILIAR.LIL_FRIEND)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local player = fam.Player
    local d = mod:GetEntityData(fam)
	local sprite = fam:GetSprite()
    local isSuperpositioned = mod:isSuperpositionedPlayer(player)
	local isSirenCharmed = mod:isSirenCharmed(fam)
    local rng = fam:GetDropRNG()

    if not d.Gun or (d.Gun and not d.Gun:Exists()) then
        d.Gun = Isaac.Spawn(mod.FF.LilFriendsRevolver.ID, mod.FF.LilFriendsRevolver.Var, mod.FF.LilFriendsRevolver.Sub, fam.Position, Vector.Zero, fam)
        d.Gun.Parent = fam
    end
    local gun = d.Gun
    local gunS, gunD = gun:GetSprite(), mod:GetEntityData(gun)
    gunD.isSuperpositioned = isSuperpositioned

    if game:GetRoom():GetFrameCount() == 0 then
        d.CurrentAngle = nil
        d.rState = nil
        d.rCount = nil
        fam.Coins = 6
        d.shootCooldown = 7
    end

    fam:FollowParent()

    d.CurrentAngle = d.CurrentAngle or 90
    local aim = player:GetAimDirection()
    local target
    if isSirenCharmed then
        target = mod:getClosestPlayer(fam.Position, 800)
        if target then
            target = target.Position
        end
    elseif aim:Length() > 0.5 then
        target = mod.FindClosestEnemy(fam.Position, 800, true, nil, nil, nil, nil, nil, nil, nil, 3)
        if target then
            target = target.Position
        else
            target = fam.Position + aim
        end
    end
    local tryShoot
    local targetAng
    if target then
        local targetDir = target - fam.Position
        targetAng = mod:GetAngleDegreesButGood(targetDir)
        if math.abs(d.CurrentAngle-(targetAng+360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+targetAng, 0.75)
        elseif math.abs(d.CurrentAngle-(targetAng-360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng-360, 0.75)
        else
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng, 0.75)
        end
        tryShoot = true
    else
        local targetDir = (fam.Velocity:Length() > 0.3 and fam.Velocity) or Vector(1,0)
        targetAng = mod:GetAngleDegreesButGood(targetDir)
        if math.abs(d.CurrentAngle-(targetAng+360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, 360+targetAng, 0.2)
        elseif math.abs(d.CurrentAngle-(targetAng-360)) < math.abs(d.CurrentAngle-targetAng) then
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng-360, 0.6)
        else
            d.CurrentAngle = mod:Lerp(d.CurrentAngle, targetAng, 0.2)
        end
    end
    d.CurrentAngle = d.CurrentAngle % 360
    local usedAng = d.CurrentAngle
    if d.firingDir then
        usedAng = d.firingDir
        d.firingDirCooldown = d.firingDirCooldown - 1
        if d.firingDirCooldown <= 0 then
            d.firingDir = nil
        end
    end

    local offset = 10
    if usedAng > 0 and usedAng < 180 then
        local real = (90-math.abs(90-usedAng))/90
        offset = offset-offset*0.25*real
    end

    local dir = Vector(offset, 0):Rotated(usedAng)

    if usedAng > 90 and usedAng <= 270 then
        gunS.FlipX = true
        gun.SpriteRotation = 180-usedAng
    else
        gunS.FlipX = false
        gun.SpriteRotation = usedAng
    end

    gun.Velocity = (fam.Position+dir*1.5) - gun.Position

    if d.shootCooldown then
        d.shootCooldown = d.shootCooldown - 1
        if d.shootCooldown <= 0 then
            d.shootCooldown = nil
        end
    end

    if (tryShoot and fam.Coins > 0) then
        d.rState = nil
        d.rCount = nil
        if not d.shootCooldown then
            gunS:Play("Shoot", true)
            d.firingDir = targetAng
            d.firingDirCooldown = 15
            d.shootCooldown = 7
            fam.Coins = fam.Coins - 1
            sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT, 0.5, 0, false, mod:RandomInt(130,150,rng)/100)
            local tear = Isaac.Spawn(2, 0, 0, gun.Position, Vector(20,0):Rotated(targetAng), fam):ToTear()
            tear:ChangeVariant(mod.TEAR.M90_BULLET)
			TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
            local mult = fam:GetMultiplier()
            tear.Scale = 0.25 + 0.25 * math.max(1, mult)
            tear.CollisionDamage = 4.90 * mult
            if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
				TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.YIN_YANG)
				TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.YIN_YANG, {Strength = 0.05})
                tear.Color = FiendFolio.ColorPsy
            end
            if isSuperpositioned then
                tear.CollisionDamage = tear.CollisionDamage / 4
                local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
				tearcolor.A = tearcolor.A / 4
				tear.Color = tearcolor
            end
        end
    elseif not gunS:IsPlaying("Shoot") then
        if fam.Coins >= 6 then
            if d.rState then
                if gunS:IsFinished("ReloadFinish") then
                    d.rState = nil
                elseif gunS:IsEventTriggered("Sound") then
                    sfx:Play(mod.Sounds.GunDraw,0.25,0,false,mod:RandomInt(150,170,rng)/100)
                elseif not gunS:IsPlaying("ReloadFinish") then
                    mod:spritePlay(gunS, "ReloadFinish")
                end
            else
                mod:spritePlay(gunS, "Idle")
            end
        else
            if not d.rState then
                d.rState = "start"
                d.rCount = nil
            elseif d.rState == "start" then
                if gunS:IsFinished("BeginReload") then
                    d.rState = "loading"
                else
                    mod:spritePlay(gunS, "BeginReload")
                end
            elseif d.rState == "loading" then
                d.rCount = d.rCount or 0
                d.rCount = d.rCount + 1 + player:GetTrinketMultiplier(TrinketType.TRINKET_FORGOTTEN_LULLABY)
                if d.rCount > 4 then
                    if gunS:IsFinished("ReloadBullet") then
                        d.rCount = 0
                        fam.Coins = fam.Coins + 1
                    elseif not gunS:IsPlaying("ReloadBullet") then
                        mod:spritePlay(gunS, "ReloadBullet")
                        sfx:Play(SoundEffect.SOUND_SCAMPER, 0.15, 0, false, mod:RandomInt(190,210,rng)/100)
                        --Ejected Case
                        local vel = (fam.Velocity * 1.2):Rotated(mod:RandomInt(-50,50,rng))
                        if vel:Length() < 1 then
                            vel = Vector(1, 0):Rotated(rng:RandomInt(360))
                        elseif vel:Length() > 6 then
                            vel = vel:Resized(6)
                        end
                        local case = Isaac.Spawn(1000, mod.FF.FriendCasing.Var, mod.FF.FriendCasing.Sub, gun.Position + gun.SpriteOffset, vel, fam):ToEffect()
                        case.SpriteScale = Vector(0.7, 0.5) * 0.75
                        case.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                        if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                            case.Color = FiendFolio.ColorDarkPurple
                        end
                        if isSuperpositioned then
                            local caseCol = Color.Lerp(case.Color, Color(1,1,1,1,0,0,0), 0)
                            caseCol.A = caseCol.A / 4
                            case.Color = caseCol
                        end
                        local cd = mod:GetEntityData(case)
                        if game:GetRoom():GetType() ~= RoomType.ROOM_DUNGEON then
                            cd.launchedEnemyInfo = {zVel = -5, height = -2, landFunc = function()
                                sfx:Play(mod.Sounds.D2Toss,0.08,0,false, mod:RandomInt(95,115,rng)/100)
                                case.SpriteOffset = Vector(0, -2)
                                cd.launchedEnemyInfo = {zVel = -2.5, height = -2, landFunc = function()
                                    sfx:Play(mod.Sounds.D2Toss,0.03,0,false, mod:RandomInt(130,145,rng)/100)
                                    case.SpriteOffset = Vector(0, -2)
                                    cd.launchedEnemyInfo = {zVel = -1, height = -2, landFunc = function()
                                        sfx:Play(mod.Sounds.D2Toss,0.02,0,false, mod:RandomInt(160,170,rng)/100)
                                        cd.FinishedBouncing = true
                                    end}
                                end}
                            end}
                        end
                    end
                else
                    mod:spritePlay(gunS, "ReloadIdle")
                end
            end
        end
    end

end, mod.ITEM.FAMILIAR.LIL_FRIEND)

function mod:lilFriendsRevolverAI(e)
    e.SpriteOffset = Vector(0, -10)
    if e.Parent then
        local p = e.Parent
        local d = mod:GetEntityData(p)
        e.SpriteScale = p.SpriteScale * 0.75
    else
        e:Remove()
    end
end

function mod:preLilFriendsRevolverRender(gun)
    local isSuperpositioned = mod:GetEntityData(gun).isSuperpositioned
    local renderMode = game:GetRoom():GetRenderMode()
    if renderMode == RenderMode.RENDER_WATER_REFRACT or renderMode == RenderMode.RENDER_WATER_REFLECT then
        gun.Color = mod.ColorInvisible
    elseif isSuperpositioned then
        gun.Color = Color(1,1,1,0.25)
    else
        gun.Color = mod.ColorNormal
    end
end