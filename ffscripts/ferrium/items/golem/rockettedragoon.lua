local mod = FiendFolio
local sfx = SFXManager()

local bal = {
    FireDelays = 5,
    FireDelayInit = 12,

    DamageMult = 1.5,
    BulletSpeed = 20,
    BulletFlat = 5,
    DefaultShots = 1,
}

function mod:RocketteDragoonUpdate(player)
    if player:HasTrinket(mod.ITEM.ROCK.ROCKETTE_DRAGOON) then
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.ROCKETTE_DRAGOON)

        if player.FrameCount % 40 == 0 and mod:IsActiveRoom() and rng:RandomInt(180) == 0 then
            sfx:Play(SoundEffect.SOUND_GASCAN_POUR, 0.8, 0, false, 2)
			local piss = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_LEMON_MISHAP, 0, player.Position, Vector.Zero, player):ToEffect()
			piss.CollisionDamage = player.Damage+5
			piss:Update()
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.ROCKETTE_DRAGOON, mod.RocketteDragoonUpdate)

mod:AddCallback("FF_TRINKET_CHARGE_CIRCLE_FIRED", function(_, player, entry, d)
    local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.ROCKETTE_DRAGOON)
    local rng = player:GetTrinketRNG(mod.ITEM.ROCK.ROCKETTE_DRAGOON)

    local gun = Isaac.Spawn(mod.FF.RocketteDragoonGun.ID, mod.FF.RocketteDragoonGun.Var, mod.FF.RocketteDragoonGun.Sub, player.Position, Vector.Zero, player):ToEffect()
    local gd = mod:GetEntityData(gun)
    gun.Parent = player
    gun.DepthOffset = 5
    gun.SpriteOffset = Vector(0,-8)
    gd.state = "Init"
    gd.StateFrame = 0
    gd.AngleOffset = 0
    gd.TotalShots = bal.DefaultShots+math.ceil(mult)
    gd.TrinketMult = mult
    mod:GunDataInit(player, gun, d)
    local target = mod.FindClosestEnemy(player.Position, 1000, true, false, nil, nil, nil, true, nil, nil, 3)
    local angle
    if target then
    angle = mod:GetAngleDegreesButGood(target.Position-player.Position)
    elseif entry.dir then
        angle = mod:GetAngleDegreesButGood(entry.dir)
    else
        angle = rng:RandomInt(360)
    end
    gd.CurrentAngle = angle
end, mod.ITEM.ROCK.ROCKETTE_DRAGOON)

function mod:RocketteDragoonGunUpdate(e)
    local d = mod:GetEntityData(e)
    local sprite = e:GetSprite()

    if not d.init then
        d.state = "Appear"
        d.StateFrame = 0
        d.ShotsFired = 0
        d.init = true
    else
        d.StateFrame = d.StateFrame+1
    end

    if e.Parent and e.Parent:ToPlayer() and e.Parent:Exists() and not e.Parent:IsDead() then
        local rng = e:GetDropRNG()
        local player = e.Parent:ToPlayer()
        local pd = mod:GetEntityData(player)

        d.CurrentAngle = d.CurrentAngle or 90
        d.CurrentAngle = d.CurrentAngle % 360

        local offset = 20
        if d.CurrentAngle > 0 and d.CurrentAngle < 180 then
            local real = (90-math.abs(90-d.CurrentAngle))/90
            offset = offset-offset*0.25*real
        end
        local dir = Vector(offset, 0):Rotated(d.CurrentAngle)

        if d.CurrentAngle > 90 and d.CurrentAngle <= 270 then
            sprite.FlipX = true
            e.SpriteRotation = 180-d.CurrentAngle
        else
            sprite.FlipX = false
            e.SpriteRotation = d.CurrentAngle
        end

        if e.FrameCount < 2 then
            e.Position = player.Position + dir
            e.Velocity = Vector.Zero
        else
            e.Velocity = (player.Position+player.Velocity*2.5+dir) - e.Position
        end

        if not player:IsExtraAnimationFinished() or player:GetSprite():IsPlaying("TeleportUp") then
            --mod:spritePlay(sprite, "Disappear")
            e.Visible = false
            d.TempHidden = true
            d.SetVisiblePlease = true
        elseif d.SetVisiblePlease then
            d.SetVisiblePlease = nil
            e.Visible = true
        end

        if d.state ~= "Appear" and d.state ~= "Disappear" then
            if d.ShotsFired < d.TotalShots then
                local fired
                if not d.StartedFiring then
                    if d.StateFrame > bal.FireDelayInit then
                        fired = true
                        d.StartedFiring = true
                    end
                elseif d.StateFrame > bal.FireDelays then
                    fired = true
                end
                if fired then
					mod.PreventBulletMuzzleAndSpeedUpFromRandom = true
                    local tear = player:FireTear(e.Position, Vector(bal.BulletSpeed, 0):Rotated(d.CurrentAngle), false, true, false, player, bal.DamageMult)
					mod.PreventBulletMuzzleAndSpeedUpFromRandom = nil
                    tear.FallingSpeed = -0.1
                    tear.FallingAcceleration = -0.05
                    tear.CollisionDamage = tear.CollisionDamage+bal.BulletFlat*(d.TrinketMult or 1)
                    local td = mod:GetEntityData(tear)
                    local tsprite = td.FFCustomTearSprite
                    if not td.FFCustomTearSprite then
                        tsprite = Sprite()
                        tsprite:Load("gfx/projectiles/guns/bullet_default.anm2", true)
                        tsprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_coquette_bullet.png", true)
                        td.FFCustomTearSprite = tsprite
                    end
                    mod:TurnTearToFriendBullet(tear, nil, player)
					TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
                    tear.Color = Color(1, 1, 1, 1)
                    sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
                    sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT, 1, 0, false, mod:RandomInt(90,100,rng)/100)
                    d.state = "Shoot"
                    sprite:Play("Shoot", true)
                    d.StateFrame = 0
                    d.ShotsFired = d.ShotsFired+1

                    local vel = (player.Velocity * 1.2):Rotated(mod:RandomInt(-50,50,rng))
                    if vel:Length() < 1 then
                        vel = Vector(1, 0):Rotated(rng:RandomInt(360))
                    elseif vel:Length() > 6 then
                        vel = vel:Resized(6)
                    end
                    local case = Isaac.Spawn(1000, mod.FF.GolemsARBulletCase.Var, mod.FF.GolemsARBulletCase.Sub, player.Position, vel, player)
                    case:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_coquette_bulletcase.png")
                    case:GetSprite():LoadGraphics()
                    local anim
                    local scale = tear.Scale
                    if scale <= 0.3 then
                        anim = "RegularTear1"
                    elseif scale <= 0.55 then
                        anim = "RegularTear2"
                    elseif scale <= 0.675 then
                        anim = "RegularTear3"
                    elseif scale <= 0.8 then
                        anim = "RegularTear4"
                    elseif scale <= 0.925 then
                        anim = "RegularTear5"
                    elseif scale <= 1.05 then
                        anim = "RegularTear6"
                    elseif scale <= 1.175 then
                        anim = "RegularTear7"
                    elseif scale <= 1.425 then
                        anim = "RegularTear8"
                    elseif scale <= 1.675 then
                        anim = "RegularTear9"
                    elseif scale <= 1.925 then
                        anim = "RegularTear10"
                    elseif scale <= 2.175 then
                        anim = "RegularTear11"
                    elseif scale <= 2.55 then
                        anim = "RegularTear12"
                    else
                        anim = "RegularTear13"
                    end
                    case:GetSprite():Play(anim)
                    if tear.Velocity.X < 0 then
                        case:GetSprite().FlipX = true
                    end
                    case:Update()
                end
            elseif d.StateFrame > 15 then
                d.state = "Disappear"
            end
        end

        if d.state == "Idle" then
            if d.TempHidden and e.Visible then
                if sprite:IsFinished("Appear") then
                    d.TempHidden = nil
                else
                    mod:spritePlay(sprite, "Appear")
                end
            else
                mod:spritePlay(sprite, "Idle")
            end
        elseif d.state == "Shoot" then
            if sprite:IsFinished("Shoot") then
                d.state = "Idle"
            else
                mod:spritePlay(sprite, "Shoot")
            end
        elseif d.state == "Appear" then
            if sprite:IsFinished("Appear") then
                d.state = "Idle"
            else
                mod:spritePlay(sprite, "Appear")
            end
        elseif d.state == "Disappear" then
            if sprite:IsFinished("Disappear") then
                e:Remove()
            else
                mod:spritePlay(sprite, "Disappear")
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