local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- https://love2d.org/wiki/HSV_color
local function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

------------------------------------------------------------
--- ITEM SPECIFIC LOCUSTS ----------------------------------
------------------------------------------------------------

function mod:HydrokinesisLocustCharge(locust)
    local EXTRA_TEAR_COOLDOWN = 20

    local data = mod:GetEntityData(locust)
    if locust.FireCooldown == -1 then
        data.HydroTearCooldown = data.HydroTearCooldown or 0

        if data.HydroTearCooldown <= 0 then
            local player = locust.Player
			mod.IgnoreSecondaryFireEffects = true
            local tear = player:FireTear(locust.Position, Vector.Zero, false, true, true, locust)
			mod.IgnoreSecondaryFireEffects = false
            tear.CollisionDamage = 4
            mod:HydrokinesisControlTear(tear)
            
            data.HydroTearCooldown = EXTRA_TEAR_COOLDOWN
        end

        data.HydroTearCooldown = data.HydroTearCooldown - 1
    end
end

-- Run the update hydro tear function, but only if it isn't already being ran by a player who owns the item
function mod:UpdateHydroTearLocust(tear)
    local spawner = tear.SpawnerEntity
    if spawner
    and spawner.Type == EntityType.ENTITY_FAMILIAR
    and spawner.Variant == FamiliarVariant.ABYSS_LOCUST
    and spawner.SubType == mod.ITEM.COLLECTIBLE.HYDROKINESIS then
        if not PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.HYDROKINESIS) then
            mod:UpdateHydroTear(tear)
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_TEAR_UPDATE, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, mod.ITEM.COLLECTIBLE.HYDROKINESIS, mod.UpdateHydroTear)

function mod:ShadowClusterLocustHit(player, locust, entity)
    local SPIKE_CHANCE = 0.25
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < SPIKE_CHANCE then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.ShadowClusterSpike.Var, mod.FF.ShadowClusterSpike.Sub, locust.Position, Vector.Zero, player)
        sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 1, 1, false, 2)
    end
end

function mod:SanguineHookLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local CHANCE = 0.1
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.AddBruise(entity, player, 120 * secondHandMultiplier, 1, 1)
    end

    if rng:RandomFloat() < CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.AddHemorrhage(entity, player, 120 * secondHandMultiplier, damage)
    end
end

function mod:AlphaCoinLocustHit(player, locust, entity, flags, damage)
    local willDie = entity.HitPoints - damage <= 0 and entity:IsActiveEnemy(true)
    local data = mod:GetEntityData(locust)

    data.AlphaCoinLocust = data.AlphaCoinLocust or {
        Kills = 0,
        DukeOfFlies = 0
    }

    if willDie then
        data.AlphaCoinLocust.Kills = data.AlphaCoinLocust.Kills + 1
    end

    if math.random() < 0.05 then
        game:ButterBeanFart(locust.Position, 20, player, true, false)
    end

    if math.random() < 0.05 then
        game:Fart(locust.Position, 40, player)
    end

    local roomType = game:GetRoom():GetType()
    if roomType == RoomType.ROOM_DEFAULT then
        if math.random() < 0.1 then
            local creepRandom = math.random(1, 3)
            local creepType = 44
            if creepRandom == 1 then
                creepType = 45
            elseif creepRandom == 2 then
                creepType = 46
            end

            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, creepType, 0, locust.Position, Vector.Zero, player)
            creep.SpriteScale = Vector(0.7, 0.7)
            creep:ToEffect().Timeout = 40
            creep:Update()
        end
    elseif roomType == RoomType.ROOM_DEVIL then
        if math.random() < 0.15 then
            local pentagram = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PENTAGRAM_BLACKPOWDER, 0, locust.Position, Vector.Zero, player)
            pentagram.SpriteScale = Vector(0.15, 0.15)
            pentagram:ToEffect().State = 1
            pentagram:Update()
        end
    elseif roomType == RoomType.ROOM_ANGEL then
        if math.random() < 0.15 then
            local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, locust.Position, Vector.Zero, player)
            beam.CollisionDamage = 5
        end
    elseif roomType == RoomType.ROOM_CHALLENGE then
        if math.random() < 0.15 then
            game:ButterBeanFart(locust.Position, 20, player, true, false)
        end
    elseif roomType == RoomType.ROOM_BOSS then
        if math.random() < 0.15 then
            local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, locust.Position, Vector.Zero, locust)
            explosion.SpriteScale = Vector(0.5, 0.5)

            local scorchMark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0, locust.Position, Vector.Zero, locust)
            scorchMark.SpriteScale = explosion.SpriteScale

            sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK)

            for _, ent in ipairs(Isaac.FindInRadius(locust.Position, 30, EntityPartition.ENEMY)) do
                local enemy = ent:ToNPC()
                if enemy and ent:IsActiveEnemy() and ent:IsVulnerableEnemy() then
                    enemy:TakeDamage(10, DamageFlag.DAMAGE_EXPLOSION, EntityRef(locust.Player), 5)
                end
            end
        end
    elseif roomType == RoomType.ROOM_ERROR then
        if math.random() < 0.15 then
            game:DevolveEnemy(entity)
            sfx:Play(SoundEffect.SOUND_EDEN_GLITCH)
        end
    end

    if willDie and entity.Type == EntityType.ENTITY_ATTACKFLY then
        local duke = Isaac.FindByType(EntityType.ENTITY_DUKE)
        if #duke > 0 then
            local addedChance = (data.AlphaCoinLocust.DukeOfFlies / 10) * 0.05
            if math.random() < 0.05 + addedChance then
                local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, duke[1].Position, Vector.Zero, nil)
                fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            end
            data.AlphaCoinLocust.DukeOfFlies = data.AlphaCoinLocust.DukeOfFlies + 1
            if data.AlphaCoinLocust.DukeOfFlies > 10 then
                data.AlphaCoinLocust.DukeOfFlies = 10
            end
        end
    end
end

function mod:AlphaCoinLocustUpdate(locust)
    local data = mod:GetEntityData(locust)
    local isCharging = locust.FireCooldown == -1

    data.AlphaCoinLocust = data.AlphaCoinLocust or {
        Kills = 0,
        DukeOfFlies = 0
    }

    local room = game:GetRoom()
    if room:GetFrameCount() == 0 then
        data.AlphaCoinLocust = {
            Kills = 0,
            DukeOfFlies = 0
        }
    end

    if isCharging then
        if data.AlphaCoinLocust.Kills < 4 then
            locust.Velocity = locust.Velocity * 1.03
        elseif data.AlphaCoinLocust.Kills == 7 then
            locust.Velocity = locust.Velocity * 1.2
        elseif data.AlphaCoinLocust.Kills > 15 then
            locust.Velocity = locust.Velocity * 1.1
        elseif data.AlphaCoinLocust.Kills > 10 then
            locust.Velocity = locust.Velocity * 0.9
        end
    end

    local frame = game:GetFrameCount()
    local h = frame % 256
    local r,g,b = HSV(h/255, 1, 0.7)
	locust.Color = Color(r, g, b, 1)
end

function mod:KingWormLocustUpdate(locust)
    local data = mod:GetEntityData(locust)
    if locust.FireCooldown == -1 then
        if not data.KingWormLocust then
            data.KingWormLocust = locust.Velocity:Resized(8)
        end
        local wiggle = math.sin(locust.FrameCount/1.5) * 30
        locust.Velocity = data.KingWormLocust:Rotated(wiggle)
    else
        data.KingWormLocust = nil
    end
end

function mod:SoapsudsLocustUpdate(locust)
    local isCharging = locust.FireCooldown == -1
    
    if locust.FrameCount % (isCharging and 8 or 25) == 0 then
        local bubble = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.SoapsudBubble.Var, mod.FF.SoapsudBubble.Sub, locust.Position, RandomVector() * 2, locust)
        bubble.PositionOffset = Vector(0, -15)
        sfx:Play(SoundEffect.SOUND_PLOP, 0.15, 2, false, math.random(8,12) / 10)
    end
end

function mod:HorncobLocustHit(player, locust, entity, flags, damage)
    if player 
    and not entity:HasEntityFlags(EntityFlag.FLAG_NO_REWARD)
    and player:Exists() 
    and entity.HitPoints - damage <= 0
    and entity:IsActiveEnemy(true) then
        if math.random() < 0.1 then
            local entData = mod:GetEntityData(entity)
            if not (entData.checkedHornCob or (entity.Type == mod.FFID.Tech and entity.Variant > 999)) then
                local pillsToQueue = math.ceil(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.HORNCOB)))
                FiendFolio.QueuePills(player, pillsToQueue)
                sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN, 0.5, 0, false, math.random(130,170)/100)
                sfx:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.7, 0, false, math.random(70,80)/100)
                entData.checkedHornCob = true
            end
        end
    end
end

------------------------------------------------------------
--- GENERIC LOCUSTS ----------------------------------------
------------------------------------------------------------

function mod:DropPennyLocustHit(player, locust, entity, flags, damage)
    local COIN_CHANCE = 0.1
    local rng = player:GetCollectibleRNG(locust.SubType)
    if not entity:HasEntityFlags(EntityFlag.FLAG_NO_REWARD)
    and entity.HitPoints - damage <= 0
    and entity:IsActiveEnemy(true)
    and rng:RandomFloat() < COIN_CHANCE then
        local room = game:GetRoom()
        local pos = room:FindFreePickupSpawnPosition(entity.Position)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos, Vector.Zero, locust)
    end
end

function mod:CritLocustHit(entity, damage, flags, source)
    if flags & DamageFlag.DAMAGE_CLONES > 0 then
        return
    end
	local locust = source.Entity
	if not (locust and locust.Type == EntityType.ENTITY_FAMILIAR and locust.Variant == FamiliarVariant.ABYSS_LOCUST and 
	        (locust.SubType == FiendFolio.ITEM.COLLECTIBLE.IMP_SODA or locust.SubType == FiendFolio.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY))
	then
		return
	end
	local player = locust:ToFamiliar().Player
    
    local CRIT_CHANCE = 0.04
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < CRIT_CHANCE then
        mod:doCriticalHitFx(locust.Position, entity, locust, locust.SubType == mod.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY)
        return {Damage = damage * mod.CritDamageMult}
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -200, mod.CritLocustHit)

function mod:SewnLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local SEWN_CHANCE = 0.25
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < SEWN_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
        FiendFolio.AddSewn(entity, player, 180 * secondHandMultiplier, nil, nil, 0.5)
    end
end

function mod:DrowsyLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local DROWSY_CHANCE = 0.2
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < DROWSY_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
        FiendFolio.AddDrowsy(entity, player, 40, 120 * secondHandMultiplier)
    end
end

function mod:BerserkLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local BERSERK_CHANCE = 0.2
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < BERSERK_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
        FiendFolio.AddBerserk(entity, player, 180 * secondHandMultiplier)
    end
end

function mod:DoomedLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local DOOMED_CHANCE = 0.2
    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
	mod:TryApplyDoom(entity, player, 180 * secondHandMultiplier, 3, player.Damage * 4, DOOMED_CHANCE)
end

function mod:MartyrLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local MARTYR_CHANCE = 0.2
    local rng = player:GetCollectibleRNG(locust.SubType)
    if entity.HitPoints - damage <= 0
    and entity:IsActiveEnemy(true)
    and rng:RandomFloat() < MARTYR_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
        FiendFolio.MarkForMartyrDeath(entity, player, 150 * secondHandMultiplier, false) -- just using prank cookie for this
    end
end

function mod:OverloadedLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local OVERLOADED_CHANCE = 0.2
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < OVERLOADED_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
        FiendFolio.AddOverloaded(entity, player, 0, 3 * secondHandMultiplier, player.Damage * 0.4, 45, 15, true) -- just using prank cookie for this
    end
end

function mod:DownloadFailureLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local DOWNLOAD_FAILURE_CHANCE = 0.1
    local rng = player:GetCollectibleRNG(locust.SubType)
    if mod:canNpcGetDownloadFaliure(entity) and rng:RandomFloat() < DOWNLOAD_FAILURE_CHANCE then
        mod:GetEntityData(entity).DownloadFailuredManually = true
    end
end

function mod:ExcommunicatedLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local EXCOMMUNICATED_CHANCE = 0.2
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < EXCOMMUNICATED_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
        FiendFolio.AddExcommunicated(entity, player, 90 * secondHandMultiplier, player.Damage) -- just using prank cookie for this
    end
end

function mod:MuggedLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local MUGGED_CHANCE = 0.2
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < MUGGED_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.AddMugged(entity, player, 90 * secondHandMultiplier)
    end
end

function mod:NursingLocustHit(player, locust, entity, flags, damage)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local NURSING_CHANCE = 0.05
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < NURSING_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.AddNursing(entity, player, 300 * secondHandMultiplier)
    end
end

function mod:PacifiedLocustHit(player, locust, entity)
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
        return
    end

    local PACIFIED_CHANCE = 0.1
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < PACIFIED_CHANCE then
        local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.AddPacified(entity, player, 90 * secondHandMultiplier)
    end
end

function mod:SoapsudsLocustHit(player, locust, entity)
    local SOAPSUDS_CHANCE = 0.4
    local rng = player:GetCollectibleRNG(locust.SubType)
    if rng:RandomFloat() < SOAPSUDS_CHANCE then
        mod:CleanChampionWithSoap(entity, player)
    end
end

------------------------------------------------------------
--- THE BIG DICTIONARY -------------------------------------
------------------------------------------------------------

-- Putting all of the [[LOCUSTS]] I make in here instead of the respective item's file.
-- This keeps things organized and allows me to reuse systems easier.

mod.CatLocustDict = {
    [mod.ITEM.COLLECTIBLE.HYDROKINESIS] = {
        Update = mod.HydrokinesisLocustCharge
    },
    [mod.ITEM.COLLECTIBLE.SHADOW_CLUSTER] = {
        Damage = mod.ShadowClusterLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.GOLDEN_SPIKES] = {
        Damage = mod.DropPennyLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.STORE_WHISTLE] = {
        Damage = mod.DropPennyLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.COOL_SUNGLASSES] = {
        Damage = mod.DropPennyLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.STRING_THEORY] = {
        Damage = mod.SewnLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.BEDTIME_STORY] = {
        Damage = mod.DrowsyLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE] = {
        Damage = mod.DrowsyLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.LIL_MINX] = {
        Damage = mod.BerserkLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.DOG_WHISTLE] = {
        Damage = mod.BerserkLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.DOOMSDAY_CLOCK] = {
        Damage = mod.DoomedLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.DEVIL_DOG] = {
        Damage = mod.DoomedLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.DIVINE_DOG] = {
        Damage = mod.MartyrLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.OUTLET_BABY] = {
        Damage = mod.OverloadedLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.PAPAL_PAL] = {
        Damage = mod.ExcommunicatedLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.BURGLAR_BABY] = {
        Damage = mod.MuggedLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.SANGUINE_HOOK] = {
        Damage = mod.SanguineHookLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.ALPHA_COIN] = {
        Damage = mod.AlphaCoinLocustHit,
        Update = mod.AlphaCoinLocustUpdate
    },
    [mod.ITEM.COLLECTIBLE.ROBOBABY3] = {
        Update = mod.wrongWarpLocustAI,
    },
    [mod.ITEM.COLLECTIBLE.KING_WORM] = {
        Update = mod.KingWormLocustUpdate,
    },
    [mod.ITEM.COLLECTIBLE.HORNCOB] = {
        Damage = mod.HorncobLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.ZIP_43] = {
        Damage = mod.DownloadFailureLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.ECHOLILAC] = {
        Damage = mod.PacifiedLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.SOAPSUDS] = {
        Update = mod.SoapsudsLocustUpdate,
        Damage = mod.SoapsudsLocustHit,
    },
    [mod.ITEM.COLLECTIBLE.CRY_BABY] = {
        Damage = mod.PacifiedLocustHit,
    },
}

-- Insert this into erf's locust dict so i can avoid doing extra work LOLE
for i, v in pairs(mod.CatLocustDict) do
    mod.ErflyLocustDict[i] = v
end