local mod = FiendFolio
local sfx = SFXManager()

function mod:mtnDewUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.MTN_DEW) then
        local d = mod:GetEntityData(player)

        if player.FrameCount % 30 == 0 and mod.GetEntityCount(1000, EffectVariant.TINY_FLY) < 10 then
            local fly = Isaac.Spawn(1000, EffectVariant.TINY_FLY, 0, player.Position, Vector.Zero, player)
        end

        if d.mtnDewFired then
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.MTN_DEW)
            d.mtnDewFrameCount = d.mtnDewFrameCount+1
            local frames = d.mtnDewFrameCount
            --local dir = (player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) and mod.GetCorrectedFiringInput(player)) or Vector(-1,0):Rotated(player:GetHeadDirection()*90)
            local dir = mod.GetCorrectedFiringInput(player)
            if dir:Length() > 0 then
                d.LastMtnDewDir = Vector(dir.X, dir.Y)
            elseif d.LastMtnDewDir then
                dir = d.LastMtnDewDir
            else
                dir = Vector(-1,0):Rotated(player:GetHeadDirection()*90)
            end
            --[[local lockAngle
            if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) and 1 == 0 then
                    lockAngle = 45
                else
                    lockAngle = 90
                end
            end
            if lockAngle then
                dir = mod:SnapVector(dir, lockAngle)
            end]]


            local vel = math.max(2, math.min(18, (frames*0.3)^1.5)+2+mod:getRoll(-40,40,rng)/100)
            local scale = math.min(0.35, (frames*0.02)^1.2)+mod:getRoll(20,40,rng)/100+mod:getRoll(-20,20,rng)/100
            local mtnDewColor = Color(1, 1, mod:getRoll(20,35,rng)/100, 1, mod:getRoll(0, 5, rng)/100, mod:getRoll(0, 30, rng)/100, 0)
            mtnDewColor:SetColorize(mod:getRoll(0,10,rng)/100, 0.4+mod:getRoll(0, 20, rng)/100, 0, 0.6)
            local tearBehaviorSmall = {
                death = function(tear)
                    local rng2 = tear:GetDropRNG()
                    if rng2:RandomInt(2) == 0 then
                        local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, tear.Position, Vector.Zero, tear):ToEffect()
                        local color2 = Color(0.3, 1, mod:getRoll(20,35,rng)/100, 1, mod:getRoll(0, 5, rng)/100, mod:getRoll(10, 30, rng)/100, 0)
                        color2:SetColorize(mod:getRoll(0,10,rng)/100, 0.4+mod:getRoll(0, 20, rng)/100, 0, 0.6)
                        splat.Color = color2
                        local sca = mod:getRoll(40,80,rng2)/100
                        splat.SpriteScale = Vector(sca, sca)
                    end
                end
            }

            if d.mtnDewFrameCount % 5 and d.mtnDewFrameCount < 15 then
                local velDir = dir:Resized(mod:getRoll(20,60,rng)/10):Rotated(mod:getRoll(-20,20,rng))
                velDir = velDir+player:GetTearMovementInheritance(velDir)
                local cloud = Isaac.Spawn(1000, 59, 0, player.Position, velDir, player):ToEffect()
                cloud:SetTimeout(mod:getRoll(60,120,rng))
                local color = Color(0.2,0.8,0,0,0,0.2,0)
                cloud.Color = color
                local randScale = mod:getRoll(60,90,rng)/100
                cloud.SpriteScale = Vector(0.5, 0.5)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = velDir, alpha = 0.35, slowdown = 0.95}
                cloud.SpriteOffset = Vector(0, -20) * player.SpriteScale.Y
            end

            if d.mtnDewFrameCount < 5 then
                if d.mtnDewFrameCount % 2 == 0 then
                    local ang = mod:getRoll(-20,20,rng)
                    local velDir = dir:Resized(vel):Rotated(ang)
                    velDir = velDir+player:GetTearMovementInheritance(velDir)
                    local tear = Isaac.Spawn(2, 0, 0, player.Position, velDir, player):ToTear()
                    tear.FallingAcceleration = mod:getRoll(100,130,rng)/100
                    tear.FallingSpeed = math.min(-1, (-5-math.min(15, (frames*0.5)^2)+mod:getRoll(-40,0,rng)/10)+30*math.abs(ang)/20)
                    tear.Scale = scale
                    tear.Color = mtnDewColor
                    tear.CollisionDamage = player.Damage*(scale+0.2)*0.66
                    mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tearBehaviorSmall)
                end
            elseif d.mtnDewFrameCount < 15 then
                local ang = mod:getRoll(-20,20,rng)
                local velDir = dir:Resized(vel):Rotated(ang)
                velDir = velDir+player:GetTearMovementInheritance(velDir)
                local tear = Isaac.Spawn(2, 0, 0, player.Position, velDir, player):ToTear()
                tear.FallingAcceleration = mod:getRoll(100,130,rng)/100
                tear.FallingSpeed = math.min(-1, (-7-math.min(15, (frames*0.5)^2)+mod:getRoll(-40,0,rng)/10)+35*math.abs(ang)/20)
                tear.Scale = scale
                tear.Color = mtnDewColor
                tear.CollisionDamage = player.Damage*(scale+0.2)*0.66
                mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tearBehaviorSmall)
            else
                for i=1,2 do
                    local ang = mod:getRoll(-20,20,rng)
                    local velDir = dir:Resized(vel):Rotated(ang)
                    velDir = velDir+player:GetTearMovementInheritance(velDir)
                    local tear = Isaac.Spawn(2, 0, 0, player.Position, velDir, player):ToTear()
                    tear.FallingAcceleration = mod:getRoll(100,130,rng)/100
                    tear.FallingSpeed = math.min(-1, (-12-math.min(15, (frames*0.5)^2)+mod:getRoll(-40,0,rng)/10)+45*math.abs(ang)/20)
                    tear.Scale = scale
                    tear.Color = mtnDewColor
                    tear.CollisionDamage = player.Damage*(scale+0.2)*0.66
                    mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tearBehaviorSmall)
                end
            end
            

            if d.mtnDewFrameCount > 30 then
                local tearBehavior = {
                    update = function(tear)
                        if tear.FrameCount % 2 == 0 then
                            local ember = Isaac.Spawn(1000, EffectVariant.EMBER_PARTICLE, 0, tear.Position, Vector(0,mod:getRoll(0,15,rng)/10):Rotated(rng:RandomInt(360)), tear):ToEffect()
                            local color = Color(1, 1, 1, 1, 0, 0, 0)
		                    color:SetColorize(0, 2, 0, 1)
                            ember.Color = color
                            ember.PositionOffset = Vector(0, tear.Height)
                            ember:SetTimeout(5)
                        end
                    end, death = function(tear)
                        local color2 = Color(0.3, 1, mod:getRoll(20,35,rng)/100, 1, mod:getRoll(0, 5, rng)/100, mod:getRoll(10, 30, rng)/100, 0)
                        color2:SetColorize(mod:getRoll(0,10,rng)/100, 0.4+mod:getRoll(0, 20, rng)/100, 0, 0.6)
                        local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 3, tear.Position, Vector.Zero, tear):ToEffect()
                        poof.Color = color2
                        poof.SpriteScale = Vector(0.9,0.9)
                        local poof2 = Isaac.Spawn(1000, EffectVariant.POOF02, 4, tear.Position, Vector.Zero, tear):ToEffect()
                        poof2.Color = color2
                        poof2.SpriteScale = Vector(0.9,0.9)
                        sfx:Play(SoundEffect.SOUND_POISON_HURT, 0.3, 0, false, mod:getRoll(120, 150, rng)/100)

                        for _, enemy in ipairs(Isaac.FindInRadius(tear.Position, 65, EntityPartition.ENEMY)) do
                            if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
                                local damage = player.Damage*1.5
                                enemy:TakeDamage(damage, 0, EntityRef(player or tear), 0)
                                if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
                                    enemy:AddPoison(EntityRef(player or tear), 90, player.Damage)
                                end
                            end
                        end

                        for i=1,4 do
                            local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, tear.Position+mod:shuntedPosition(40, tear:GetDropRNG()), Vector.Zero, tear):ToEffect()
                            splat.Color = color2
                        end
                        local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, tear.Position+mod:shuntedPosition(40, tear:GetDropRNG()), Vector.Zero, tear):ToEffect()
                        splat.Color = color2
                        splat.SpriteScale = Vector(2, 2)

                        local scale2 = 90*(tear.Scale/1.5)
                        local aura = mod:SpawnRadioactiveAura(player, tear.Position, scale2, 999)
                        mod:GetEntityData(aura).ignorePulsing = true
                        table.insert(mod.mtnDewAuras, {aura = aura, radius = scale2, frames = 0})
                    end
                }

                for i=1,2 do
                    local realDir = dir:Resized(mod:getRoll(60,135,rng)/10):Rotated(mod:getRoll(-20,20,rng))
                    local tear = Isaac.Spawn(2, 0, 0, player.Position, realDir, player):ToTear()
                    tear.FallingAcceleration = mod:getRoll(130,160,rng)/100
                    tear.FallingSpeed = -25+mod:getRoll(-10,10,rng)
                    tear.Scale = mod:getRoll(100,150,rng)/100
                    mod:GetEntityData(tear).dontHitAbove = true
                    local color = Color(1, 1, mod:getRoll(20,35,rng)/100, 1, mod:getRoll(0, 5, rng)/100, mod:getRoll(0, 30, rng)/100, 0)
                    color:SetColorize(mod:getRoll(0,10,rng)/100, 0.4+mod:getRoll(0, 20, rng)/100, 0, 0.6)
                    tear.Color = color
                    mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tearBehavior)
                end

                local color = Color(1, 1, mod:getRoll(20,35,rng)/100, 1, mod:getRoll(0, 5, rng)/100, mod:getRoll(0, 30, rng)/100, 0)
                color:SetColorize(mod:getRoll(0,10,rng)/100, 0.4+mod:getRoll(0, 20, rng)/100, 0, 0.6)
                local ang = mod:getRoll(-20,20,rng)
                local tear = Isaac.Spawn(2, 0, 0, player.Position, dir:Resized(vel):Rotated(mod:getRoll(-20,20,rng)), player):ToTear()
                tear.FallingAcceleration = mod:getRoll(100,130,rng)/100
                tear.FallingSpeed = math.min(-1, (-12-math.min(15, (frames*0.5)^2)+mod:getRoll(-40,0,rng)/10)+45*math.abs(ang)/20)
                tear.Scale = mod:getRoll(100,150,rng)/100
                tear.Color = color
                mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tearBehavior)
                
                d.mtnDewFired = nil
                d.LastMtnDewDir = nil
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.MTN_DEW, mod.mtnDewUpdate)

mod:AddCallback("FF_CHARGE_CIRCLE_FIRED", function(_, player, entry, d)
    d.mtnDewFrameCount = 0
    d.mtnDewFired = true
    d.LastMtnDewDir = d.customChargeBarDirection[mod.ITEM.COLLECTIBLE.MTN_DEW]
    sfx:Play(mod.Sounds.MtnDewHiss, 1.5, 0, false, 1)
end, mod.ITEM.COLLECTIBLE.MTN_DEW)

function mod:mtnDewAuraUpdate(entry, key)
    if entry.radius > 2 then
        entry.frames = entry.frames+1
        if entry.frames > 200 then
            entry.radius = entry.radius-0.25-(entry.frames-200)/30*0.2
        elseif entry.frames > 50 then
            entry.radius = entry.radius-0.15
        end
        mod:GetEntityData(entry.aura).radiationRadius = entry.radius

        if not mod.IsActiveRoom() then
            entry.radius = 1
        end
    else
        entry.aura:SetTimeout(1)
        mod.mtnDewAuras[key] = nil
    end
end

mod:AddCallback("FF_CURSE_MIST_ADDED", function(_, player, d)
    d.mtnDewFired = nil
    d.LastMtnDewDir = nil
end)