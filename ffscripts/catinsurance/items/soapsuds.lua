local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local soapsudBubble = mod.FF.SoapsudBubble

local manager = TearFlagsLib
manager.RegisterTearFlag("SOAPSUDS")

local Constants = {
    -- Luck stuff (KILLED)
    MAX_LUCK = 7,
    MIN_CHANCE = 0.15,
    MAX_CHANCE = 1,

    -- How often should this entity spawn cosmetic bubbles?
    INTERVAL_VARIANCE = 9,
    MIN_INTERVAL = 4,
    BUBBLE_INTERVAL = {
        [EntityType.ENTITY_LASER] = 4,
        [EntityType.ENTITY_TEAR] = 12,
        [EntityType.ENTITY_BOMB] = 12,
        [EntityType.ENTITY_EFFECT] = 12, -- Shadow Cluster, Aquarius creep, etc.
        [EntityType.ENTITY_KNIFE] = 14,
    },
    LASER_CONTINUOUS_BUBBLES = { -- Which lasers shoot bubbles constantly?
        [LaserVariant.THICK_RED] = true,
        [LaserVariant.SHOOP] = true,
        [LaserVariant.BRIM_TECH] = true,
        [LaserVariant.LIGHT_BEAM] = true,
        [LaserVariant.THICKER_RED] = true,
        [LaserVariant.THICKER_BRIM_TECH] = true,
        [LaserVariant.GIANT_BRIM_TECH] = true,
    },
    LASER_BUBBLE_COUNT = 3, -- How many bubbles to spawn for lasers that aren't continuous?
}

mod.SoapsudsChampionLoot = {
    [ChampionColor.RED] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.YELLOW] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.GREEN] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.ORANGE] = function (npc, player, rng, pickupPos)
        for _ = 0, rng:RandomInt(2) do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, pickupPos, Vector.Zero, npc)
        end
    end,
    [ChampionColor.BLUE] = function (npc, player, rng, pickupPos)
        player:AddBlueFlies(3, npc.Position, player)
    end,
    [ChampionColor.BLACK] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.WHITE] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.GREY] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.TRANSPARENT] = function (npc, player, rng, pickupPos)
        local megaChestChance = 0.01
        if megaChestChance > rng:RandomFloat() then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_MEGACHEST, ChestSubType.CHEST_CLOSED, pickupPos, Vector.Zero, npc)
        else
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, ChestSubType.CHEST_CLOSED, pickupPos, Vector.Zero, npc)
        end
    end,
    [ChampionColor.FLICKER] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, ChestSubType.CHEST_CLOSED, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.PURPLE] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.DARK_RED] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.LIGHT_BLUE] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.CAMO] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.TINY] = function (npc, player, rng, pickupPos)
        local pool = Game():GetItemPool()
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pool:ForceAddPillEffect(PillEffect.PILLEFFECT_SMALLER), pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.GIANT] = function (npc, player, rng, pickupPos)
        local pool = Game():GetItemPool()
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pool:ForceAddPillEffect(PillEffect.PILLEFFECT_LARGER), pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.PULSE_RED] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.SIZE_PULSE] = function (npc, player, rng, pickupPos)
        player:AddBlueFlies(4 + rng:RandomInt(3), npc.Position, player)
    end,
    [ChampionColor.KING] = function (npc, player, rng, pickupPos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, pickupPos, Vector.Zero, npc)
    end,
    [ChampionColor.DEATH] = function (npc, player, rng, pickupPos)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM)
    end,
    [ChampionColor.RAINBOW] = function (npc, player, rng, pickupPos)
        local room = game:GetRoom()
        local pos = pickupPos
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, pos, Vector.Zero, npc)

        pos = room:FindFreePickupSpawnPosition(pos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, pos, Vector.Zero, npc)
        
        pos = room:FindFreePickupSpawnPosition(pos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, pos, Vector.Zero, npc)
        
        pos = room:FindFreePickupSpawnPosition(pos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, pos, Vector.Zero, npc)
        
        pos = room:FindFreePickupSpawnPosition(pos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, pos, Vector.Zero, npc)
        
        pos = room:FindFreePickupSpawnPosition(pos)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, pos, Vector.Zero, npc)
    end
}

-- thank you pixie plz ^_^
local function getLaserEndPoint(laser)
    local pos = laser:GetEndPoint()
	local samples = laser:GetSamples()

	if #samples > 0 then -- Straight lasers don't have samples :-)
		pos = samples:Get(#samples - 1)
	end

	return pos
end

function mod:SoapsudsBubbleGenerator(entity)
    if manager.HasTearFlags(entity, manager.Flag.SOAPSUDS) then
        -- Only run code for Aquarius creep once
        local chanceBasedSound = false
        if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL then
            if entity.FrameCount > 0 then
                return
            end

            chanceBasedSound = true
        end

        local baseInterval = Constants.BUBBLE_INTERVAL[entity.Type]
        if baseInterval then
            local data = mod:GetEntityData(entity)
            if not data.SoapsudsBubbleInterval then
                data.SoapsudsBubbleInterval = 0
            end

            if data.SoapsudsBubbleInterval == 0 or entity.FrameCount % data.SoapsudsBubbleInterval == 0 then
                local spawnPos
                -- Lasers should spawn along the points, or between the start and end
                if entity.Type == EntityType.ENTITY_LASER then
                    ---@type EntityLaser
                    local laser = entity:ToLaser()
                    local isSample = laser:IsSampleLaser()
                    local didEffect = false
                    if isSample then
                        -- Spawn at a random spot between 2 samples
                        local samples = laser:GetSamples()
                        if #samples > 0 then
                            local selectedSample = math.random(0, #samples-1)
                            if selectedSample == #samples-1 then
                                selectedSample = selectedSample - 1
                            end

                            local originSample = samples:Get(selectedSample)
                            local nextSample = samples:Get(selectedSample + 1)
                            
                            spawnPos = mod:Lerp(originSample, nextSample, math.random())

                            didEffect = true
                        end
                    end
                    
                    -- Some lasers have 0 samples (anti-grav), so just do it like this in that scenario
                    if not didEffect then
                        local iterations = Constants.LASER_CONTINUOUS_BUBBLES[laser.Variant]
                        for _ = 1, (iterations and 1 or Constants.LASER_BUBBLE_COUNT) do
                            -- Spawn it at a random point along the line
                            local endPoint = getLaserEndPoint(laser)
                            spawnPos = mod:Lerp(laser.Position, endPoint, math.random())
                        end
                    end
                    
                    -- All non lasers and effects are free to just spawn around the weapon's position
                else
                    local offset = RandomVector() * entity.Size * entity.SizeMulti
                    spawnPos = entity.Position + offset
                end
                
                local bubble = Isaac.Spawn(EntityType.ENTITY_EFFECT, soapsudBubble.Var, soapsudBubble.Sub, spawnPos, RandomVector() * 2, entity)
                bubble.PositionOffset = entity.PositionOffset

                -- Only a 20% chance to play the noise with Aquarius
                if not chanceBasedSound or math.random() < 0.2 then
                    sfx:Play(SoundEffect.SOUND_PLOP, 0.15, 2, false, math.random(8,12) / 10)
                end

                local variance = math.random(0, Constants.INTERVAL_VARIANCE) - (Constants.INTERVAL_VARIANCE / 2)
                local finalVariance = math.ceil(baseInterval + variance)
                finalVariance = math.max(finalVariance, Constants.MIN_INTERVAL)
                data.SoapsudsBubbleInterval = finalVariance
            end
        end
    end
end

local function shouldAddFlag(player, source)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.SOAPSUDS) then
        return true
    end

    return false
end

function mod:soapsudsFlagGeneric(entity, player, weaponFlag)
    if shouldAddFlag(player, entity) then
        TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.SOAPSUDS)
        local data = mod:GetEntityData(entity)
        if not data.HasAppliedSoapsudsBubbleFunc then
            mod:AddToTearUpdateList("ff_soapsuds", entity, mod.SoapsudsBubbleGenerator)
            data.HasAppliedSoapsudsBubbleFunc = true
        end

        if entity.Type == EntityType.ENTITY_TEAR then
            local tear = entity:ToTear()
            local overlay = tear:GetTearEffectSprite()
            overlay:Load("gfx/projectiles/soapsuds_sparkles.anm2", true)
            overlay:Play("Idle")
            tear:ResetSpriteScale(true)
        end
    end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.SOAPSUDS, mod.soapsudsFlagGeneric)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.ITEM.COLLECTIBLE.SOAPSUDS, mod.soapsudsFlagGeneric)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.SOAPSUDS] = {
	BodyColor = Color(1,1,1,1,-14.664/255,34.982/255,44.009/255,0.885,0.690,0.655,1),
	EyeAColor = Color(1,1,1,1,52.672/255,-9.391/255,58.656/255,0.672,0.609,0.656,1),
	EyeBColor = Color(1,1,1,1,52.672/255,-9.391/255,58.656/255,0.672,0.609,0.656,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.SOAPSUDS)
    local data = mod:GetEntityData(tear)
    if not data.HasAppliedSoapsudsBubbleFunc then
        mod:AddToTearUpdateList("ff_soapsuds", tear, mod.SoapsudsBubbleGenerator)
        data.HasAppliedSoapsudsBubbleFunc = true
    end

    local overlay = tear:GetTearEffectSprite()
    overlay:Load("gfx/projectiles/soapsuds_sparkles.anm2", true)
    overlay:Play("Idle")

    tear.Color = tear.Color * Color(1.5, 1.5, 1.5, 1)
end, FiendFolio.ITEM.COLLECTIBLE.SOAPSUDS)

function mod:CleanChampionWithSoap(entity, player)
    local npc = entity:ToNPC()
    if npc then
        local color = npc:GetChampionColorIdx()
        if color == -1 then
            return
        end

        for _, enemy in ipairs(Isaac.GetRoomEntities()) do
            local enemyNpc = enemy:ToNPC()
            if enemyNpc and enemyNpc:GetChampionColorIdx() == ChampionColor.KING and color == ChampionColor.YELLOW then
                return
            end
        end

        -- Respawn as non champion (FUCK YOU!!!!!!!)
        if (
            entity:IsInvincible() 
            or not entity:IsVulnerableEnemy()
            or (
                not entity:HasMortalDamage()
                and not entity:IsDead()
            )
        ) then

            -- Drop loot
            local lootFunc = Isaac.RunCallback(mod.CALLBACK.FF_SOAPSUDS_CHECK_CHAMPION, npc)
            if type(lootFunc) == "function" then
                lootFunc(npc, player, npc:GetDropRNG(), game:GetRoom():FindFreePickupSpawnPosition(npc.Position))
            elseif mod.SoapsudsChampionLoot[color] then
                mod.SoapsudsChampionLoot[color](npc, player, npc:GetDropRNG(), game:GetRoom():FindFreePickupSpawnPosition(npc.Position))
            end


            -- Spawn the New Guy
            local newGuy = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position, Vector.Zero, entity.SpawnerEntity)
            newGuy.HitPoints = entity.HitPoints
            newGuy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            entity:Remove()

            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, npc)
            poof.Color = poof.Color * Color(1, 1.2, 1.2, 1)

            sfx:Play(mod.Sounds.SoapsudsClean)
        end
    end
end
mod:AddCallback(manager.Callback.APPLY_TEARFLAG_EFFECT, mod.CleanChampionWithSoap, manager.Flag.SOAPSUDS)

function mod:SoapsudsBubbleUpdate(bubble)
    local sprite = bubble:GetSprite()

    if bubble.State == 1 and sprite:IsFinished("Pop") then
        bubble:Remove()
    end

    if bubble.FrameCount >= 15 and bubble.State == 0 then
        sprite:Play("Pop")
        bubble.State = 1
        bubble.Velocity = Vector.Zero
    end
end