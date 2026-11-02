local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local cardLines = {
    [mod.ITEM.CARD.ENERGY_GRASS] = {Sound = mod.Sounds.VACardEnergyGrass, Delay = 60},
    [mod.ITEM.CARD.ENERGY_FIRE] = {Sound = mod.Sounds.VACardEnergyFire},
    [mod.ITEM.CARD.ENERGY_WATER] = {Sound = mod.Sounds.VACardEnergyWater},
    [mod.ITEM.CARD.ENERGY_LIGHTNING] = {Sound = mod.Sounds.VACardEnergyLightning},
    [mod.ITEM.CARD.ENERGY_FIGHTING] = {Sound = mod.Sounds.VACardEnergyFighting, Delay = 60},
    [mod.ITEM.CARD.ENERGY_PSYCHIC] = {Sound = mod.Sounds.VACardEnergyPsychic},
    [mod.ITEM.CARD.ENERGY_COLORLESS] = {Sound = mod.Sounds.VACardEnergyColorless},
    [mod.ITEM.CARD.ENERGY_DARKNESS] = {Sound = mod.Sounds.VACardEnergyDarkness, Delay = 150},
    [mod.ITEM.CARD.ENERGY_METAL] = {Sound = mod.Sounds.VACardEnergyMetal},
    [mod.ITEM.CARD.ENERGY_DRAGON] = {Sound = mod.Sounds.VACardEnergyDragon},
    [mod.ITEM.CARD.ENERGY_FAIRY] = {Sound = mod.Sounds.VACardEnergyFairy},
}

function mod:friendlymonCard(cardID, player, useFlags)
    local rng = player:GetCardRNG(cardID)
    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
    --Dragon Energy, Uses a random other card effect
    local doneEffects = {}
    if cardID == mod.ITEM.CARD.ENERGY_DRAGON then
        local effect = FiendFolio.DragonEnergyCards[rng:RandomInt(#FiendFolio.DragonEnergyCards) + 1]
        doneEffects[effect] = true
        while doneEffects[effect] do
            effect = FiendFolio.DragonEnergyCards[rng:RandomInt(#FiendFolio.DragonEnergyCards) + 1]
        end
        doneEffects[effect] = true
    else
        doneEffects[cardID] = true
    end

    --print(dragonRNG)
    for i, v in ipairs(Isaac.GetRoomEntities()) do
        if v:IsVulnerableEnemy() and not v:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and (not mod:isFriend(v)) then
            --Grass Energy, Poisons enemies
            if doneEffects[mod.ITEM.CARD.ENERGY_GRASS] then
                v:AddPoison(EntityRef(player), 120, player.Damage)
            end
            --Fire Energy, Burns enemies
            if doneEffects[mod.ITEM.CARD.ENERGY_FIRE] then
                v:AddBurn(EntityRef(player), 120, player.Damage)
            end
            --Water Energy, Bloats enemies (FF Effect)
            if doneEffects[mod.ITEM.CARD.ENERGY_WATER] then
               --mod.AddBloated(v, player, 120, player.Damage, player.MaxFireDelay, player.ShotSpeed, player.TearHeight, player.TearFallingSpeed, player.TearFallingAcceleration, player.TearFlags, player.TearColor)
               local damg = player.Damage
               for k = 0, 120 * secondHandMultiplier, 20 do
                    mod.scheduleForUpdate(function()
                        if v and v:Exists() then
                            for i = 45, 360, 45 do
                                local vec = Vector(9, 0):Rotated(i):Rotated(2.25 * k/2)
                                local tear = Isaac.Spawn(2, 0, 0, v.Position + v.Velocity + vec:Resized(v.Size + 5), vec, nil):ToTear()
                                tear.Scale = 0.75
                                tear.CollisionDamage = damg
                                tear.FallingAcceleration = -0.05
                                v:TakeDamage(damg/10, 0, EntityRef(Isaac.GetPlayer()), 0)
                            end
                        end
                    end, k)
                end
            end
            --Lightning Energy, Overloads enemies (FF Effect)
            if doneEffects[mod.ITEM.CARD.ENERGY_LIGHTNING] then
				 mod.AddOverloaded(v, player, 0, 3 * secondHandMultiplier, player.Damage * 0.4, 45, 15, true)
            end
            --Fighting Energy, Bruises enemies (FF Effect)
            if doneEffects[mod.ITEM.CARD.ENERGY_FIGHTING] then
                --mod.AddBerserk(v, player, 120 * secondHandMultiplier)
                for i = 0, 2 do
                    mod.scheduleForUpdate(function()
                        if v and v:Exists() then
                            mod.AddBruise(v, player, (120 * secondHandMultiplier) - (30 * i), 1, 1)
                            if not sfx:IsPlaying(mod.Sounds.PvZBucket) then
                                sfx:Play(mod.Sounds.EpicPunch, 1, 0, false, 1 - (i * 0.2))
                            end
                        end
                    end, 1 + (30 * i))
                end
            end
            --Psychic Energy, Confuses enemies
            if doneEffects[mod.ITEM.CARD.ENERGY_PSYCHIC] then
                --v:AddConfusion(EntityRef(player), 120, false)
                --mod.AddDrowsy(v, player, 60, 360 * secondHandMultiplier)
                for k = 0, 2 * secondHandMultiplier do
                    mod.scheduleForUpdate(function()
                        if v and v:Exists() then
                            v:AddConfusion(EntityRef(player), 120, false)
                        end
                    end, k * 120)
                end
            end
            --Colorless Energy, Multi-euclideises enemies (FF Effect)
            if doneEffects[mod.ITEM.CARD.ENERGY_COLORLESS] then
                --mod.AddBleed(v, player, 60 * secondHandMultiplier, player.Damage)
                mod.AddMultiEuclidean(v, player, 120 * secondHandMultiplier)
            end
            --Darkness Energy, Fears enemies
            if doneEffects[mod.ITEM.CARD.ENERGY_DARKNESS] then
                v:AddFear(EntityRef(player), 120)
            end
            --Metal Energy, Haemmorhages enemies (FF Effect)
            if doneEffects[mod.ITEM.CARD.ENERGY_METAL] then
                mod.AddBleed(v, player, 60 * secondHandMultiplier, player.Damage)
                local slash = Isaac.Spawn(mod.FF.MetalSlash.ID,mod.FF.MetalSlash.Var,mod.FF.MetalSlash.Sub, v.Position, nilvector, player):ToEffect()
                slash:FollowParent(v)
                slash.DepthOffset = 500
                slash.SpriteOffset = Vector(0, -20)
                slash.SpriteScale = slash.SpriteScale * (math.random(5,15)/100)
                slash.SpriteRotation = math.random(360)
                slash:GetSprite().PlaybackSpeed = math.random(100,200)/100
                slash:Update()
            end
            --Fairy Energy, Charms enemies
            if doneEffects[mod.ITEM.CARD.ENERGY_FAIRY] then
                v:AddCharmed(EntityRef(player), 120)
            end
        end
    end

    --Effects
    if doneEffects[mod.ITEM.CARD.ENERGY_GRASS] then
        sfx:Play(SoundEffect.SOUND_DEVILROOM_DEAL, 1, 0, false, 0.8)
        for i = 1, 100 do
			local vecX = math.random(50,100)
			if math.random(2) == 1 then
				vecX = vecX * -1
			end

			local side = -400 + math.random(room:GetGridWidth()*40 + 650)

			local eff = Isaac.Spawn(1000, 138, 961, Vector(side, 30 + math.random(room:GetGridHeight() * 40 + 120)), Vector(vecX, 0), nil):ToEffect()
			eff.Color = Color(0.5,1,0.5,1,0,1,0)
            mod:GetEntityData(eff).opacity = 0.1
			eff:GetSprite():Stop()
			eff:GetSprite():SetFrame(math.random(4)-1)
			eff.Timeout = 50
			eff:Update()
		end
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_FIRE] then
        sfx:Play(SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, 1)
        --[[for i = 1, 100 do
			local vecX = math.random(50,100)
			if math.random(2) == 1 then
				vecX = vecX * -1
			end

			local side = -400 + math.random(room:GetGridWidth()*40 + 650)

			local eff = Isaac.Spawn(1000, 138, 961, Vector(side, 30 + math.random(room:GetGridHeight() * 40 + 120)), Vector(vecX, 0), nil):ToEffect()
			eff.Color = Color(-1,-1,-1,1,0,0,0)
            mod:GetEntityData(eff).opacity = 1
			eff:GetSprite():Stop()
			eff:GetSprite():SetFrame(math.random(4)-1)
			eff.Timeout = 50
			eff:Update()
		end]]
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_WATER] then
        local splash = Isaac.Spawn(1000, 132, 0, player.Position, nilvector, player):ToEffect()
        sfx:Play(mod.Sounds.SplashLargePlonkless, 0.5, 0, false, 1)
        splash:FollowParent(player)
        for i = 45, 360, 45 do
            local vec = Vector(9, 0):Rotated(i)
            local tear = Isaac.Spawn(2, 0, 0, player.Position + player.Velocity + vec:Resized(player.Size + 5), vec, player):ToTear()
            tear.Scale = 0.75
            tear.CollisionDamage = player.Damage
            tear.FallingAcceleration = -0.05
        end
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_LIGHTNING] then
        for i = 1, 3 do
            local laser = EntityLaser.ShootAngle(10, player.Position, math.random(360), 2, Vector(0, -10), player)
            laser.Parent = player
            laser.CollisionDamage = player.Damage
            laser.MaxDistance = player.Size + math.random(50,100)
            laser.OneHit = true
			laser.Color = Color(0,0,0,1,200 / 255,200 / 255,50 / 255) -- hi zapbladder
            laser:Update()
        end
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_FIGHTING] then
        sfx:Play(mod.Sounds.FlashDevilCard, 0.4, 0, false, 0.75)
        for i = 1, 100 do
			local vecX = math.random(50,100)
			if math.random(2) == 1 then
				vecX = vecX * -1
			end

			local side = -400 + math.random(room:GetGridWidth()*40 + 650)

			local eff = Isaac.Spawn(1000, 138, 961, Vector(side, 30 + math.random(room:GetGridHeight() * 40 + 120)), Vector(vecX, 0), nil):ToEffect()
			eff.Color = Color(1,0.5,0.5,1,0.5,0,0)
            mod:GetEntityData(eff).opacity = 0.3
			eff:GetSprite():Stop()
			eff:GetSprite():SetFrame(math.random(4)-1)
			eff.Timeout = 50
			eff:Update()
		end
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_PSYCHIC] then
        sfx:Play(mod.Sounds.EnergyPsychic, 1, 0, false, 1)
        local ring = Isaac.Spawn(mod.FF.PsychicRing.ID,mod.FF.PsychicRing.Var,mod.FF.PsychicRing.Sub, player.Position, nilvector, player):ToEffect()
        ring:FollowParent(player)
        ring.SpriteScale = Vector(0.3,0.3)
        ring.SpriteOffset = Vector(0, -player.SpriteScale.X/2 * 40)
        ring.Color = Color(1,1,1,0.3)
        ring:Update()
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_COLORLESS] then
        sfx:Play(mod.Sounds.WardenHit, 1, 0, false, 0.75)
        local pulse = Isaac.Spawn(1000, 1960, 20, player.Position, nilvector, player)
        pulse.Color = Color(1,1,1,0.1,0,0,0)
        pulse:Update()
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_DARKNESS] then
        sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0, false, 0.5)
        game:Darken(1, 120 * secondHandMultiplier)
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_METAL] then
        --mod:explodePlayer(player, true)
        --[[local slash = Isaac.Spawn(mod.FF.MetalSlash.ID,mod.FF.MetalSlash.Var,mod.FF.MetalSlash.Sub, player.Position, nilvector, player):ToEffect()
        slash.DepthOffset = 500
        slash.SpriteOffset = Vector(0, -20)
        slash.SpriteScale = slash.SpriteScale * 0.25
        slash.SpriteRotation = math.random(360)
        slash:Update()]]
        sfx:Play(mod.Sounds.EnergyMetal, 2, 0, false, 0.75)
    end
    if doneEffects[mod.ITEM.CARD.ENERGY_FAIRY] then
        sfx:Play(mod.Sounds.EnergyFairy, 1, 0, false, 1)
        local ring = Isaac.Spawn(mod.FF.LoveHeart.ID,mod.FF.LoveHeart.Var,mod.FF.LoveHeart.Sub, player.Position, nilvector, player):ToEffect()
        ring:FollowParent(player)
        --ring.SpriteScale = Vector(0.3,0.3)
        ring.SpriteOffset = Vector(0, -player.SpriteScale.X/2 * 40)
        ring.Color = Color(1,1,1,0.7)
        ring:Update()
    end
    if player:HasTrinket(mod.ITEM.TRINKET.ENERGY_SEARCHER) then
        if rng:RandomInt(3) == 0 then
            local pos = room:FindFreePickupSpawnPosition(player.Position, 40, true)
            Isaac.Spawn(5, 302, 2, pos, nilvector, nil)
        end
    end
    FiendFolio:trySayAnnouncerLine(cardLines[cardID].Sound, useFlags, cardLines[cardID].Delay or 30)
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_GRASS)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_FIRE)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_WATER)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_LIGHTNING)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_FIGHTING)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_PSYCHIC)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_COLORLESS)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_DARKNESS)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_METAL)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_DRAGON)
mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.friendlymonCard, mod.ITEM.CARD.ENERGY_FAIRY)

function mod:psychicRingAI(e)
    if e:GetSprite():IsFinished("Idle") then
        e:Remove()
    end
end

function mod:loveHeartAI(e)
    if e:GetSprite():IsFinished("Idle") then
        e:Remove()
    end
end

--Trainer cards are here honorarily
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local d = mod:GetEntityData(player)
    d.holdingFFItem = cardID
    d.holdingFFItemSlot = "card"
    player:AnimateCard(cardID, "LiftItem")
end, FiendFolio.ITEM.CARD.TRAINER_CARD)

function mod:useHeldTrainerCard(player, data, aim)
    local tear = Isaac.Spawn(2, mod.TEAR.TRAINER_CARD, 0, player.Position, aim:Resized(15) + player:GetTearMovementInheritance(aim), player)
    tear.CollisionDamage = 0
    tear:Update()
    sfx:Play(SoundEffect.SOUND_SHELLGAME)
    data.HoldingFFItemBlankVisual = true
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local sprite = tear:GetSprite()
    if tear.Velocity.X < 0 then
        sprite.FlipX = true
    end
    mod:spritePlay(sprite, "Rotate")
end, mod.TEAR.TRAINER_CARD)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, coll)
    if tear.SpawnerEntity and tear.SpawnerEntity:Exists() then
        local npc = coll:ToNPC()
        if npc and not mod:isFriend(npc) then
            local isBoss = npc:IsBoss()
            if isBoss then
                if not mod:isCharm(npc) then
                    npc:AddCharmed(EntityRef(tear.SpawnerEntity), 180)
                    npc:SetColor(Color(1,1,1,1,1,0.75,0.75),20,10, true, true)
                    sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION,1,0,false,math.random(400,600)/100)
                    local heart = Isaac.Spawn(mod.FF.LoveHeart.ID, mod.FF.LoveHeart.Var, mod.FF.LoveHeart.Sub, npc.Position, Vector.Zero, nil)
                    heart.SpriteScale = heart.SpriteScale * 0.25
                    heart:GetSprite().PlaybackSpeed = 2
                    heart:Update()
                end
            else
                npc:AddCharmed(EntityRef(tear.SpawnerEntity), -1)
                npc:SetColor(Color(1,1,1,1,1,0.75,0.75),20,10, true, true)
                npc.HitPoints = npc.MaxHitPoints * 5
                sfx:Play(SoundEffect.SOUND_DIVINE_INTERVENTION,1,0,false,math.random(400,600)/100)
                local heart = Isaac.Spawn(mod.FF.LoveHeart.ID, mod.FF.LoveHeart.Var, mod.FF.LoveHeart.Sub, npc.Position, Vector.Zero, nil)
                heart.SpriteScale = heart.SpriteScale * 0.25
                heart:GetSprite().PlaybackSpeed = 2
                heart:Update()
            end
        end
    end
end, mod.TEAR.TRAINER_CARD)

function mod:trainerCardTearDeath(tear, data)
    if tear.Variant == mod.TEAR.TRAINER_CARD then
        if tear.SpawnerEntity then
            local newTear = Isaac.Spawn(2, mod.TEAR.TRAINER_CARD, 0, tear.Position, Vector.Zero, nil)
            newTear:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR | EntityFlag.FLAG_RENDER_WALL)
            newTear:Update()
            local sprite = newTear:GetSprite()
            newTear.SpriteRotation = tear.Velocity:GetAngleDegrees() + 90
            sprite.FlipX = tear:GetSprite().FlipX
            if sprite.FlipX then
                newTear.SpriteRotation = newTear.SpriteRotation * -1
            end
            sprite:SetFrame("Stuck", 0)
        end
    end
end