local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

function mod:warfarinUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.WARFARIN) then
        local data = mod:GetEntityData(player)
        if data.warfarinBleeding then
            if data.warfarinBleeding > 0 then
                if data.warfarinBleeding % 2 == 0 then
                    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.WARFARIN)
                    if data.skipNextCreepCheckWarfarin then
                        data.skipNextCreepCheckWarfarin = nil
                    else
                        local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()
                        creep.CollisionDamage = player.Damage*0.5
                        local scale = 1*data.warfarinBleeding/data.originalWarfarinBleeding
                        creep.Scale = scale
                        if rng:RandomInt(3) == 0 then
                            data.warfarinBleeding = data.warfarinBleeding+3
                            data.skipNextCreepCheckWarfarin = true
                        end
                        creep:Update()
                    end
                end
                data.warfarinBleeding = data.warfarinBleeding-1
            else
                data.warfarinBleeding = nil
                data.skipNextCreepCheckWarfarin = nil
                data.originalWarfarinBleeding = nil
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.WARFARIN, mod.warfarinUpdate)

function mod:warfarinHurt(player, damage, flag, source)
    if not mod:isDamageSelfInflicted(flag, source) and player:HasCollectible(mod.ITEM.COLLECTIBLE.WARFARIN) then
        if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.WARFARIN)
            local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.WARFARIN, false)

            mod:GetEntityData(player).warfarinBleeding = 20*mult
            mod:GetEntityData(player).originalWarfarinBleeding = 20*mult
            local bleedingOut = 1

            mod.scheduleForUpdate(function() --delayed so that it doesn't kill the player before damage (and also it's easier give me a break)
                if player:GetHearts() > 2 then
                    player:AddHearts(-bleedingOut)
                end
                if mult > 1 then
                    for i=1,mult-1 do
                        if rng:RandomInt(3) == 0 then
                            bleedingOut = bleedingOut+1
                        end
                    end
                end
                for i=1,math.max(1, bleedingOut) do
                    local vel = Vector(0,mod:getRoll(40,80,rng)/10):Rotated(rng:RandomInt(360))
                    local heart = Isaac.Spawn(5, 20, 1, player.Position, vel, player):ToPickup()
                    heart.Wait = 20
                    heart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    heart.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                    heart.Timeout = 100
                    heart:GetSprite():Play("Idle", true)
                    local ranZVel = -mod:getRoll(30, 65, rng)/10
                    mod:GetEntityData(heart).launchedEnemyInfo = {
                        vel = vel, zVel = ranZVel, height = -10, landFunc = function()
                            sfx:Play(SoundEffect.SOUND_PENNYDROP, 1, 0, false, 1)
                            heart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                            local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, heart.Position, Vector.Zero, player):ToEffect()
                            local dam = (player and player.Damage*0.5) or 2
                            creep.CollisionDamage = dam
                            creep.SpriteScale = Vector(0.8, 0.8)
                            creep:Update()
                            mod:GetEntityData(heart).warfarinCreep = {damage = dam, timer = 11}
                        end
                    }
                    mod:GetEntityData(heart).warfarinHeart = {player = player, damage = player.Damage*1.5}
                end

                local poof = Isaac.Spawn(1000, 16, 4, player.Position, Vector.Zero, player):ToEffect()

                    --[[for i=1,4 do
                        local randVel = RandomVector()*mod:getRoll(10,30,rng)/20
                        local cloud = Isaac.Spawn(1000, 59, 0, player.Position, Vector.Zero, nil):ToEffect()
                        cloud:SetTimeout(mod:getRoll(100,150,rng))
                        local color = Color(0.45,0,0,0,0,0,0)
                        cloud.Color = color
                        local randScale = mod:getRoll(80,150,rng)/100
                        cloud.SpriteScale = Vector(0.5, 0.5)
                        mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
                    end]]
            end, 1)
        else
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.WARFARIN)
            local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.WARFARIN, false)

            local bleedingOutChance = rng:RandomInt(100)
            local bleedingOut = 1
            if bleedingOutChance < -5 then --too punishing
                bleedingOut = 3
            elseif bleedingOutChance < 66 then
                bleedingOut = 2
            end

            mod:GetEntityData(player).warfarinBleeding = 20*mult
            mod:GetEntityData(player).originalWarfarinBleeding = 20*mult

            mod.scheduleForUpdate(function() --delayed so that it doesn't kill the player before damage (and also it's easier give me a break)
                if player:GetHearts() <= bleedingOut then
                    bleedingOut = player:GetHearts()-1
                end
                if player:GetHearts() > 1 then
                    player:AddHearts(-bleedingOut)
                end
                if mult > 1 then
                    for i=1,mult-1 do
                        if rng:RandomInt(3) == 0 then
                            bleedingOut = bleedingOut+1
                        end
                    end
                end
                for i=1,math.max(1, bleedingOut) do
                    local vel = Vector(0,mod:getRoll(40,80,rng)/10):Rotated(rng:RandomInt(360))
                    local heart = Isaac.Spawn(5, 10, 2, player.Position, vel, player):ToPickup()
                    heart.Wait = 20
                    heart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    heart.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                    heart.Timeout = 100
                    heart:GetSprite():Play("Idle", true)
                    local ranZVel = -mod:getRoll(30, 65, rng)/10
                    mod:GetEntityData(heart).launchedEnemyInfo = {
                        vel = vel, zVel = ranZVel, height = -10, landFunc = function()
                            sfx:Play(SoundEffect.SOUND_MEAT_FEET_SLOW0, 1, 0, false, 1)
                            heart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                            local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, heart.Position, Vector.Zero, player):ToEffect()
                            local dam = (player and player.Damage*0.5) or 2
                            creep.CollisionDamage = dam
                            creep.SpriteScale = Vector(0.8, 0.8)
                            creep:Update()
                            mod:GetEntityData(heart).warfarinCreep = {damage = dam, timer = 11}
                        end
                    }
                    mod:GetEntityData(heart).warfarinHeart = {player = player, damage = player.Damage*1.5}
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_CLOT) then
                        mod:GetEntityData(heart).warfarinHeart.bloodClot = true
                    end
                end

                local poof = Isaac.Spawn(1000, 16, 4, player.Position, Vector.Zero, player):ToEffect()

                    --[[for i=1,4 do
                        local randVel = RandomVector()*mod:getRoll(10,30,rng)/20
                        local cloud = Isaac.Spawn(1000, 59, 0, player.Position, Vector.Zero, nil):ToEffect()
                        cloud:SetTimeout(mod:getRoll(100,150,rng))
                        local color = Color(0.45,0,0,0,0,0,0)
                        cloud.Color = color
                        local randScale = mod:getRoll(80,150,rng)/100
                        cloud.SpriteScale = Vector(0.5, 0.5)
                        mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
                    end]]
            end, 1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local d = mod:GetEntityData(pickup)
    if d.warfarinHeart then
        local entry = d.warfarinHeart
        local rng = pickup:GetDropRNG()
        local sprite = pickup:GetSprite()
        if sprite:IsPlaying("Idle") then
            if pickup.FrameCount % 3 == 0 then
                local trail = Isaac.Spawn(1000, EffectVariant.HAEMO_TRAIL, 0, pickup.Position+pickup.Velocity, RandomVector()*2, pickup):ToEffect()
                local scale = mod:getRoll(70,100,rng)/100
                trail.SpriteScale = Vector(scale, scale)
                trail.SpriteOffset = Vector(0, pickup.SpriteOffset.Y-5)
                trail.DepthOffset = -100
                trail:Update()
            end

            if d.warfarinCreep then
                local entry2 = d.warfarinCreep
                if entry2.timer > 0 then
                    entry2.timer = entry2.timer-1

                    if entry2.timer % 2 == 0 then
                        if d.skipNextCreepCheck then
                            d.skipNextCreepCheck = nil
                        else
                            local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
                            creep.CollisionDamage = entry2.damage
                            local scale = 0.8*entry2.timer/14
                            creep.Scale = scale
                            if rng:RandomInt(3) == 0 then
                                entry2.timer = entry2.timer+3
                                d.skipNextCreepCheck = true
                            end
                            creep:Update()
                        end
                    end
                else
                    d.warfarinCreep = nil
                end
            end

            if pickup.Timeout < 30 then
                if not d.warfarinTarget or not mod:superExists(d.getTarget) then
                    d.warfarinTarget = mod.FindRandomEnemy(pickup.Position, 300, true)
                end
                if d.warfarinTarget and mod:superExists(d.warfarinTarget) then
                    pickup.Velocity = mod:Lerp(pickup.Velocity, (d.warfarinTarget.Position-pickup.Position):Resized(4), 0.2)
                end
            end

            if pickup.Timeout <= 1 then
                local explosion = Isaac.Spawn(1000, EffectVariant.ENEMY_GHOST, 1, pickup.Position, Vector.Zero, pickup):ToEffect()
                explosion.SpriteScale = Vector(1.6, 1.6)
                explosion.CollisionDamage = entry.damage+12*Game():GetLevel():GetAbsoluteStage()/2+15
    
                sfx:Play(SoundEffect.SOUND_MOTHER_WRIST_EXPLODE, 1, 0, false, mod:getRoll(110,120,rng)/100)
                sfx:Play(SoundEffect.SOUND_MOTHER_ISAAC_HIT, 2, 0, false, 1)
    
                for i=1,4 do
                    local randVel = RandomVector()*mod:getRoll(10,30,rng)/20
                    local cloud = Isaac.Spawn(1000, 59, 0, pickup.Position, Vector.Zero, nil):ToEffect()
                    cloud:SetTimeout(mod:getRoll(100,150,rng))
                    local color = Color(0.45,0,0,0,0,0,0)
                    cloud.Color = color
                    local randScale = mod:getRoll(80,150,rng)/100
                    cloud.SpriteScale = Vector(0.5, 0.5)
                    mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
                end
    
                local bigSplat = Isaac.Spawn(1000, 7, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
                bigSplat.SpriteScale = Vector(2, 2)
                bigSplat:Update()
    
                for i=-1,1,2 do
                    local angle = i*45+mod:getRoll(-10,10,rng)
                    for j=-6,6,2 do
                        local gib = Isaac.Spawn(1000, 5, 0, pickup.Position, Vector(j+mod:getRoll(-1,1,rng),0):Rotated(angle), pickup):ToEffect()
                    end
                    local angle2 = i*45+mod:getRoll(-10,10,rng)
                    for j=-4,4,2 do
                        if j ~= 0 then
                            local tear = Isaac.Spawn(2, 1, 0, pickup.Position, Vector(j*2+mod:getRoll(-1,1,rng), 0):Rotated(angle2), pickup):ToTear()
                            tear.CollisionDamage = entry.damage
                            tear.Scale = mod:getRoll(45,100,rng)/100
                            tear.FallingAcceleration = mod:getRoll(100,180,rng)/100
                            tear.FallingSpeed = -mod:getRoll(8,13,rng)
                            tear:Update()
                        end
                    end
                    for j=-4,4,2 do
                        local splat = Isaac.Spawn(1000, 7, 0, pickup.Position+Vector(j*15, 0):Rotated(angle), Vector.Zero, pickup):ToEffect()
                        splat.Scale = mod:getRoll(80, 100, rng)/100
                    end
                end
    
                local bigCreep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, pickup.Position, Vector.Zero, nil):ToEffect()
                bigCreep.SpriteScale = Vector(2.1, 2.1)
                bigCreep.CollisionDamage = entry.damage*0.5
                bigCreep:SetTimeout(200)
                bigCreep:Update()
    
                --aaaaaa this just doesn't look good
                --[[for i=-1,1,2 do
                    local pos1 = pickup.Position+Vector(0,-30)+Vector(80*i, -80)
                    local pos2 = pickup.Position+Vector(0,-30)+Vector(-1*65*i, 65)
                    local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, pos1, (pos2-pos1):Resized(6), player):ToEffect()
                    trail.MinRadius = 0.1
                    trail.MaxRadius = 0.7
                    trail.SpriteScale = Vector(2, 1)
                    trail.Parent = trail
                    trail.Color = Color(1, 0, 0, 1, 0, 0, 0)
                    --trail:SetColor(Color(0, 0, 0, 1, 0, 0, 0), 999, 1, true, false)
                    for j=1,5 do
                        trail:Update()
                    end
                    mod:GetEntityData(trail).warfarinSlash = {pos1 = pos1, pos2 = pos2, originalPos = pickup.Position, num = i}
                end]]

                if entry.bloodClot then
                    local clot = Isaac.Spawn(3, FamiliarVariant.BLOOD_BABY, 0, pickup.Position, Vector.Zero, pickup):ToFamiliar()
                    if entry.player and entry.player:Exists() then
                        clot.Player = entry.player
                    end
                end
    
                pickup:Remove()
            elseif pickup.Timeout < 6 and pickup.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE then
                pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                for i=-1,1,2 do
                    local slash = Isaac.Spawn(1000, EffectVariant.CLEAVER_SLASH, 0, pickup.Position+Vector(-1*i*50,50), Vector.Zero, pickup):ToEffect()
                    slash.SpriteRotation = i*45
                    slash.SpriteScale = Vector(0.5, 2)
                    slash.Color = Color(1, 1, 1, 1, 0, 0, 0)
                    slash:FollowParent(pickup)
                    slash:Update()
                    slash:Update()
                end
            end
        end
    end
end, 10)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local d = mod:GetEntityData(pickup)
    if d.warfarinHeart then
        local entry = d.warfarinHeart
        local rng = pickup:GetDropRNG()
        local sprite = pickup:GetSprite()
        if sprite:IsPlaying("Idle") then
            if pickup.FrameCount % 3 == 0 then
                local trail = Isaac.Spawn(1000, EffectVariant.HAEMO_TRAIL, 0, pickup.Position+pickup.Velocity, RandomVector()*2, pickup):ToEffect()
                local scale = mod:getRoll(70,100,rng)/100
                trail.SpriteScale = Vector(scale, scale)
                trail.SpriteOffset = Vector(0, pickup.SpriteOffset.Y-5)
                trail.DepthOffset = -100
                trail:Update()
            end

            if d.warfarinCreep then
                local entry2 = d.warfarinCreep
                if entry2.timer > 0 then
                    entry2.timer = entry2.timer-1

                    if entry2.timer % 2 == 0 then
                        if d.skipNextCreepCheck then
                            d.skipNextCreepCheck = nil
                        else
                            local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
                            creep.CollisionDamage = entry2.damage
                            local scale = 0.8*entry2.timer/14
                            creep.Scale = scale
                            if rng:RandomInt(3) == 0 then
                                entry2.timer = entry2.timer+3
                                d.skipNextCreepCheck = true
                            end
                            creep:Update()
                        end
                    end
                else
                    d.warfarinCreep = nil
                end
            end

            if pickup.Timeout < 30 then
                if not d.warfarinTarget or not mod:superExists(d.getTarget) then
                    d.warfarinTarget = mod.FindRandomEnemy(pickup.Position, 300, true)
                end
                if d.warfarinTarget and mod:superExists(d.warfarinTarget) then
                    pickup.Velocity = mod:Lerp(pickup.Velocity, (d.warfarinTarget.Position-pickup.Position):Resized(4), 0.2)
                end
            end

            if pickup.Timeout <= 1 then
                local explosion = Isaac.Spawn(1000, EffectVariant.ENEMY_GHOST, 1, pickup.Position, Vector.Zero, pickup):ToEffect()
                explosion.SpriteScale = Vector(1.6, 1.6)
                explosion.CollisionDamage = entry.damage+12*Game():GetLevel():GetAbsoluteStage()/2+15
    
                sfx:Play(SoundEffect.SOUND_MOTHER_WRIST_EXPLODE, 1, 0, false, mod:getRoll(110,120,rng)/100)
                sfx:Play(SoundEffect.SOUND_MOTHER_ISAAC_HIT, 2, 0, false, 1)
    
                for i=1,4 do
                    local randVel = RandomVector()*mod:getRoll(10,30,rng)/20
                    local cloud = Isaac.Spawn(1000, 59, 0, pickup.Position, Vector.Zero, nil):ToEffect()
                    cloud:SetTimeout(mod:getRoll(100,150,rng))
                    local color = Color(0.45,0,0,0,0,0,0)
                    cloud.Color = color
                    local randScale = mod:getRoll(80,150,rng)/100
                    cloud.SpriteScale = Vector(0.5, 0.5)
                    mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
                end
    
                local bigSplat = Isaac.Spawn(1000, 7, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
                bigSplat.SpriteScale = Vector(2, 2)
                bigSplat:Update()
    
                for i=-1,1,2 do
                    local angle = i*45+mod:getRoll(-10,10,rng)
                    for j=-6,6,2 do
                        local gib = Isaac.Spawn(1000, 5, 0, pickup.Position, Vector(j+mod:getRoll(-1,1,rng),0):Rotated(angle), pickup):ToEffect()
                    end
                    local angle2 = i*45+mod:getRoll(-10,10,rng)
                    for j=-4,4,2 do
                        if j ~= 0 then
                            local tear = Isaac.Spawn(2, 1, 0, pickup.Position, Vector(j*2+mod:getRoll(-1,1,rng), 0):Rotated(angle2), pickup):ToTear()
                            tear.CollisionDamage = entry.damage
                            tear.Scale = mod:getRoll(45,100,rng)/100
                            tear.FallingAcceleration = mod:getRoll(100,180,rng)/100
                            tear.FallingSpeed = -mod:getRoll(8,13,rng)
                            tear:Update()
                        end
                    end
                    for j=-4,4,2 do
                        local splat = Isaac.Spawn(1000, 7, 0, pickup.Position+Vector(j*15, 0):Rotated(angle), Vector.Zero, pickup):ToEffect()
                        splat.Scale = mod:getRoll(80, 100, rng)/100
                    end
                end
    
                local bigCreep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, pickup.Position, Vector.Zero, nil):ToEffect()
                bigCreep.SpriteScale = Vector(2.1, 2.1)
                bigCreep.CollisionDamage = entry.damage*0.5
                bigCreep:SetTimeout(200)
                bigCreep:Update()
    
                --aaaaaa this just doesn't look good
                --[[for i=-1,1,2 do
                    local pos1 = pickup.Position+Vector(0,-30)+Vector(80*i, -80)
                    local pos2 = pickup.Position+Vector(0,-30)+Vector(-1*65*i, 65)
                    local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, pos1, (pos2-pos1):Resized(6), player):ToEffect()
                    trail.MinRadius = 0.1
                    trail.MaxRadius = 0.7
                    trail.SpriteScale = Vector(2, 1)
                    trail.Parent = trail
                    trail.Color = Color(1, 0, 0, 1, 0, 0, 0)
                    --trail:SetColor(Color(0, 0, 0, 1, 0, 0, 0), 999, 1, true, false)
                    for j=1,5 do
                        trail:Update()
                    end
                    mod:GetEntityData(trail).warfarinSlash = {pos1 = pos1, pos2 = pos2, originalPos = pickup.Position, num = i}
                end]]

                if entry.bloodClot then
                    local clot = Isaac.Spawn(3, FamiliarVariant.BLOOD_BABY, 0, pickup.Position, Vector.Zero, pickup):ToFamiliar()
                    if entry.player and entry.player:Exists() then
                        clot.Player = entry.player
                    end
                end
    
                pickup:Remove()
            elseif pickup.Timeout < 6 and pickup.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE then
                pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                for i=-1,1,2 do
                    local slash = Isaac.Spawn(1000, EffectVariant.CLEAVER_SLASH, 0, pickup.Position+Vector(-1*i*50,50), Vector.Zero, pickup):ToEffect()
                    slash.SpriteRotation = i*45
                    slash.SpriteScale = Vector(0.5, 2)
                    slash.Color = Color(1, 1, 1, 1, 0, 0, 0)
                    slash:FollowParent(pickup)
                    slash:Update()
                    slash:Update()
                end
            end
        end
    end
end, 20)

--[[mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local d = mod:GetEntityData(e)
    if d.warfarinSlash then
        local entry = d.warfarinSlash
        if e.FrameCount > 1 and entry.pos2 then
            e.Position = entry.pos2
            entry.pos2 = nil
            entry.disappear = true
        end
        if entry.disappear then
            if e.SpriteScale.X > 0 then
                e.SpriteScale = Vector(e.SpriteScale.X-0.2, e.SpriteScale.Y)
                e.Velocity = e.Velocity*0.95
                e.Color = Color(1, 0, 0, e.Color.A-10/255, 0, 0, 0)
            else
                e:Remove()
            end
        end
    end
end, EffectVariant.SPRITE_TRAIL)]]

function mod:WarfarinDeath(npc)
    local totalNum = 0
    local gogogo
    local totalLuck = 0
    local healthRatio = 0
    for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
        if p:HasCollectible(mod.ITEM.COLLECTIBLE.WARFARIN) then
            gogogo = true
            totalNum = totalNum+p:GetCollectibleNum(mod.ITEM.COLLECTIBLE.WARFARIN, false)
            totalLuck = totalLuck+p.Luck
            local tempHealthRatio = math.max(0.33, (p:GetEffectiveMaxHearts()-p:GetHearts())/p:GetEffectiveMaxHearts())
            if healthRatio < tempHealthRatio then
                healthRatio = math.min(1, tempHealthRatio + healthRatio*0.5)
            else
                healthRatio = math.min(1, healthRatio + tempHealthRatio*0.5)
            end
        end
    end

	if gogogo then
		if npc.Type >= 10 and not (npc.Type == mod.FFID.Tech and npc.Variant > 999) and not npc:HasEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER) then
			local room = game:GetRoom()
            --local mult = mod.getCollectibleMultiplierAcrossAllPlayers(FiendFolio.ITEM.COLLECTIBLE.WARFARIN, false)
			--local chance = math.min(50, 20*mult)
            local chance = math.min(50, 20*totalNum+mod.XalumLuckBonus(totalLuck, 20, 0.5)*100)*healthRatio
            local chance2 = math.min(75, 25*totalNum+mod.XalumLuckBonus(totalLuck, 25, 0.2)*100)*healthRatio
			if npc:GetDropRNG():RandomInt(100) < chance and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
                if totalNum > 1 and npc:GetDropRNG():RandomInt(100) < chance2 then
                    local heart = Isaac.Spawn(5, 10, 1, npc.Position, Vector.Zero, nil):ToPickup()
                    --heart.Timeout = 999
                else
                    local heart = Isaac.Spawn(5, 10, 2, npc.Position, Vector.Zero, nil):ToPickup()
                    --heart.Timeout = 999
                end
			end
		end
	end
end
mod:AddCollectibleCallback("FF_POST_NPC_DEATH_FERRIUM", mod.ITEM.COLLECTIBLE.WARFARIN, mod.WarfarinDeath)