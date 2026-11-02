local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback("FF_CHARGE_CIRCLE_FIRED", function(_, player, entry, d)
    local headDir = player:GetHeadDirection()
    local vec = d.customChargeBarDirection[mod.ITEM.COLLECTIBLE.GKUNHOMDIMA]
    vec = vec * player.ShotSpeed * 1.2
    local cloud = Isaac.Spawn(mod.FF.PlayerRainCloud.ID, mod.FF.PlayerRainCloud.Var, mod.FF.PlayerRainCloud.Sub,player.Position,vec,player)
    cloud.Parent = player
    cloud.Color = player.TearColor
    mod:GetEntityData(cloud).DefaultVec = vec
    cloud:Update()
    sfx:Play(mod.Sounds.WingFlap,1.5,0,false,math.random(50,80)/100)
end, mod.ITEM.COLLECTIBLE.GKUNHOMDIMA)

function mod:gkunhomdimaCircleCharged(player, entry)
    player:SetColor(Color(1,1,1,1,0.15,0.15,0.5), 10, 15, true, false)
    sfx:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 0.5, 0, false, 1.5)
end
mod:AddCallback("FF_CHARGE_CIRCLE_CHARGED", mod.gkunhomdimaCircleCharged, mod.ITEM.COLLECTIBLE.GKUNHOMDIMA)

local CLOUD_OFFSET = 75
local TEARSPAWN_HEIGHT = 115

function mod:playerRainCloudAI(e)
    local sprite, d = e:GetSprite(), mod:GetEntityData(e)
    local player = nil
    e.DepthOffset = 50
    e.SpriteScale = Vector(0.66,0.66)
    if e.Parent and e.Parent:Exists() then
        player = e.Parent:ToPlayer()
    end

    d.DefaultVec = d.DefaultVec or e.Velocity
    local targVel = d.DefaultVec
    local target = mod.FindClosestEnemy(e.Position + e.Velocity:Resized(50), 120)
    if target then
        local rotAmount = 30
        if target.Position:Distance(e.Position + targVel:Rotated(-1)) < target.Position:Distance(e.Position + targVel:Rotated(1)) then
            targVel = targVel:Rotated(-rotAmount)
        else
            targVel = targVel:Rotated(rotAmount)
        end
    end
    e.Velocity = mod:Lerp(e.Velocity, targVel, 0.2)

    local room = game:GetRoom()
    if (d.disappearing)
    or (not player)
    or e.FrameCount > 300
    or (not room:IsPositionInRoom(e.Position, 0))
    then
        d.disappearing = true
        mod:spritePlay(sprite, "Disappear")
        if sprite:IsEventTriggered("CloudDisappear") then
            e:Remove()
        end
    else
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GKUNHOMDIMA)

        if not d.init then
            d.TargetCol = e.Color
            d.init = true
        end

        if d.TargetCol then
            e.Color = Color.Lerp(e.Color, d.TargetCol, 0.1)
        end

        if e.FrameCount <= 18 then
            sprite.Offset = Vector(0, -(((CLOUD_OFFSET/324)*(e.FrameCount)^2)*0.73)-20)
            sprite:SetFrame("Appear", e.FrameCount)
        else
            sprite.Offset = Vector(0, (-CLOUD_OFFSET + math.sin((e.FrameCount+ 1)*0.2)))
            mod:spritePlay(sprite, "Walk")
            d.CoolDown = d.CoolDown or 1
            d.CoolDown = d.CoolDown - 1
            if d.CoolDown <= 0 then
                local weapon = player:GetWeapon(1)
                local weaponType = WeaponType.WEAPON_TEARS
                local isLung
                if weapon then
                    weaponType = weapon:GetWeaponType()
                end
                if weaponType == WeaponType.WEAPON_MONSTROS_LUNGS then
                    isLung = true
                end
                local spawnOffsetVec = Vector(-10 + rng:RandomInt(21), -10 + rng:RandomInt(21))
                mod.FiringGkunhomdimaTear = true
                --UNUSED CURRENTLY
                if weaponType == WeaponType.WEAPON_BOMBS
                or weaponType == WeaponType.WEAPON_ROCKETS
                then
                    weaponType = WeaponType.WEAPON_BOMBS
					mod.IgnoreSecondaryFireEffects = true
                    local bomb = player:FireBomb(e.Position + spawnOffsetVec, Vector.Zero, player)
					mod.IgnoreSecondaryFireEffects = false
                    bomb.PositionOffset = Vector(0,-TEARSPAWN_HEIGHT + 10)
                    Isaac.RunCallback(FiendFolio.CALLBACK.POST_GKUN_RAIN_BOMB, bomb, player)
                else
                    weaponType = WeaponType.WEAPON_TEARS
                    --local tear = player:FireTear(e.Position + spawnOffsetVec, Vector.Zero, true, true, false, player, 1)
                    local tear = mod:SpawnPlayerTear(player, e.Position + spawnOffsetVec, Vector.Zero,
                    function(tear, player)
                        mod:GetEntityData(tear).FiredByGkunhomdimaCloud = true
                        tear:ClearTearFlags(TearFlags.TEAR_ABSORB | TearFlags.TEAR_ORBIT | TearFlags.TEAR_LASERSHOT)
                        tear.FallingSpeed = player.ShotSpeed * 10
                        tear.FallingAcceleration = 0.1
                        tear.Height = -TEARSPAWN_HEIGHT
                        d.TargetCol = tear.Color
                        mod:GetEntityData(tear).dontHitAbove = true
                    end)
                    Isaac.RunCallback(FiendFolio.CALLBACK.POST_GKUN_RAIN_TEAR, tear, player)

                    if not tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) then
                        if tear:HasTearFlags(TearFlags.TEAR_BOOMERANG) then
                            -- undo the falling speed/acceleration changes that happen on first update
							-- doing this to match stardust for the synergy
                            tear.FallingSpeed = tear.FallingSpeed * 2
                            tear.FallingAcceleration = (tear.FallingAcceleration + 0.08) * 4 - 0.08
                        end
                    end
                    tear:Update()
                end
                mod.FiringGkunhomdimaTear = false
                local multiShotParams = player:GetMultiShotParams(weaponType)
                local numTears = multiShotParams:GetNumTears()
                local mult = 1
                if isLung then
                    mult = 4.3
                end
                d.CoolDown = math.floor(player.MaxFireDelay/numTears/mult)
            end
        end
    end
end