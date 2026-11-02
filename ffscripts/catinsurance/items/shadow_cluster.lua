local mod = FiendFolio
local sfx = SFXManager()
local game = Game()
local ShadowCluster = {}

local ITEM_ID = mod.ITEM.COLLECTIBLE.SHADOW_CLUSTER

local Constants = {
    EFFECT_SPIKE = mod.FF.ShadowClusterSpike,
    EFFECT_CREEP = mod.FF.ShadowClusterCreep,

    -- Active balancing
    CREEP_SPIN_AMOUNT = 9,
    CREEP_DISTANCE = 18,

    -- Spike balancing
    SPIKE_HIT_INTERVAL = 10,
    SPIKE_DAMAGE_FLAT = 1.7,
    SPIKE_DAMAGE_MULT = 0.2,
    SPIKE_DAMAGE_MULT_TEAREFFECTS = 0.5,
    SPIKE_DAMAGE_RADIUS = 40,
    SPIKE_DAMAGE_RADIUS_WISP = 20,
    BELIAL_DAMAGE_MULT = 0.5,
    BELIAL_DAMAGE_FLAT = 3,
    BELIAL_DAMAGE_RADIUS = 80,

    -- Creep balancing
    CREEP_LIFETIME = 50,
    CREEP_FADE_IN_TIME = 8,
    CREEP_FADE_OUT_TIME = 15,
    CREEP_SPEED_DIVIDER = 4.5,
    CREEP_SPAWN_INTERVAL_TRUE_MIN = 2, -- Not used for the lerp function but is the true minimum
    CREEP_SPAWN_INTERVAL_MIN = 3, -- Use for the lerp function
    CREEP_SPAWN_INTERVAL_MAX = 8,
    CREEP_VELOCITY_FOR_MIN_INTERVAL = 9,
}

TearFlagsLib.RegisterWeapon("FF_SHADOW_CLUSTER")
TearFlagsLib.RegisterWeaponIdentityFunction(TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER, function(entity)
    return (
        entity.Type == FiendFolio.FF.ShadowClusterSpike.ID and
        entity.Variant == FiendFolio.FF.ShadowClusterSpike.Var and
        entity.SubType == FiendFolio.FF.ShadowClusterSpike.Sub
    )
end)

mod.CAN_OF_BEANS.FART_ONCE = mod.CAN_OF_BEANS.FART_ONCE | TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER
mod.CHEMICAL_COOKIE.ROLL_ON_HIT = mod.CHEMICAL_COOKIE.ROLL_ON_HIT | TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER
mod.CHEMICAL_COOKIE.DO_CREEP_EFFECTS_ON_APPLY = mod.CHEMICAL_COOKIE.DO_CREEP_EFFECTS_ON_APPLY | TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER
mod.CHEMICAL_COOKIE.PER_WEAPONFLAG_COOLDOWN = mod.CHEMICAL_COOKIE.PER_WEAPONFLAG_COOLDOWN | TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER
mod.MODERN_OUROBOROS.PREVENT_APPLY_CREEP = mod.MODERN_OUROBOROS.PREVENT_APPLY_CREEP | TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER

---@param player EntityPlayer
function mod:ShadowClusterPassiveCreep(player)
    -- Get creep spawn interval
    local interval = mod:Lerp(Constants.CREEP_SPAWN_INTERVAL_MAX, Constants.CREEP_SPAWN_INTERVAL_MIN, player.Velocity:Length() / Constants.CREEP_VELOCITY_FOR_MIN_INTERVAL)
    interval = math.floor(interval)
    if interval <= Constants.CREEP_SPAWN_INTERVAL_TRUE_MIN then
        interval = Constants.CREEP_SPAWN_INTERVAL_TRUE_MIN
    end
    if player.FrameCount % interval == 0 then
		local room = game:GetRoom()
        -- Don't spawn over grids
        if room:GetGridCollisionAtPos(player.Position) ~= GridCollisionClass.COLLISION_NONE then
            return
        end

        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, Constants.EFFECT_CREEP.Var, Constants.EFFECT_CREEP.Sub, player.Position, Vector.Zero, player):ToEffect()
        creep.SpriteScale = Vector.One * 0.5
        creep:GetSprite():PlayRandom(creep.InitSeed)
        creep.SortingLayer = SortingLayer.SORTING_BACKGROUND
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ITEM_ID, mod.ShadowClusterPassiveCreep)

function ShadowCluster:ActivateCreep(_, _, player, flags)
    local isCarBattery = flags & UseFlag.USE_CARBATTERY > 0
    for i = 360 / Constants.CREEP_SPIN_AMOUNT, 360, 360 / Constants.CREEP_SPIN_AMOUNT do
        local velocity = isCarBattery and Constants.CREEP_DISTANCE * 1.5 or Constants.CREEP_DISTANCE
        local angle = Vector.FromAngle(i) * velocity
        local thrownCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, Constants.EFFECT_CREEP.Var, Constants.EFFECT_CREEP.Sub, player.Position, angle, player):ToEffect()
        thrownCreep:GetSprite():PlayRandom(thrownCreep.InitSeed)
        thrownCreep.SortingLayer = SortingLayer.SORTING_BACKGROUND

        mod:GetEntityData(thrownCreep).ShadowCreepCarBattery = isCarBattery
    end
    
    Isaac.CreateTimer(function ()
        local creep = Isaac.FindByType(EntityType.ENTITY_EFFECT, Constants.EFFECT_CREEP.Var, Constants.EFFECT_CREEP.Sub)
        table.sort(creep, function (a, b)
            return a.FrameCount < b.FrameCount -- sort newest first
        end)

        for i, c in ipairs(creep) do
            if c.SpawnerEntity and GetPtrHash(c.SpawnerEntity) == GetPtrHash(player) then
                local creepData = mod:GetEntityData(c)
                if not creepData.ClusterActivated and not creepData.ClusterFadingOut then
                    creepData.ClusterActivated = true
                    
                    Isaac.CreateTimer(function ()
                        if c:Exists() and not creepData.ClusterFadingOut then
                            local spike = Isaac.Spawn(EntityType.ENTITY_EFFECT, Constants.EFFECT_SPIKE.Var, Constants.EFFECT_SPIKE.Sub, c.Position, Vector.Zero, player)
                            local spikeData = mod:GetEntityData(spike)
                            spikeData.SpikeCarBattery = flags & UseFlag.USE_CARBATTERY > 0
                            spikeData.ShadowCreepFromWisp = creepData.ShadowCreepFromWisp

                            sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 1, 1, false, mod:RandomFloat(0.9, 1.0))

                            if spikeData.ShadowCreepFromWisp then
                                spike.SpriteScale = Vector(0.5, 0.5)
                            end

                            if mod:playerIsBelialMode(player) and not creepData.ShadowCreepFromWisp then
                                -- Burst damage at spot
                                local burst = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.ShadowClusterBlood.Var, mod.FF.ShadowClusterBlood.Sub, c.Position, Vector.Zero, player)
                                burst:GetSprite():ReplaceSpritesheet(0, "gfx/effects/shadow_cluster_blood.png", true)
                                burst.SpriteScale = Vector(0.75, 0.75)
                                burst.SortingLayer = SortingLayer.SORTING_BACKGROUND
                                sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 1, false, mod:RandomFloat(0.9, 1.0))

                                for _, enemy in ipairs(Isaac.FindInRadius(spike.Position, Constants.BELIAL_DAMAGE_RADIUS, EntityPartition.ENEMY)) do
                                    if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() then
                                        local npc = enemy:ToNPC()
                                        if not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
                                        and not npc:HasEntityFlags(EntityFlag.FLAG_CHARM) then
                                            npc:TakeDamage(player.Damage * Constants.BELIAL_DAMAGE_MULT + Constants.BELIAL_DAMAGE_FLAT, 0, EntityRef(player), 2)
                                        end
                                    end
                                end
                            end
                        end
                    end, (i - 1) * 2, 1, false)
                end
            end
        end
    end, 12, 1, false)
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ShadowCluster.ActivateCreep, ITEM_ID)

---@param creep EntityEffect
function mod:UpdateShadowClusterCreep(creep)
    local data = mod:GetEntityData(creep)

    local maxScale
    if data.ShadowCreepFromWisp then
        maxScale = Vector(0.5, 0.5)
    else
        maxScale = Vector(1, 1)
    end

    if creep.FrameCount <= Constants.CREEP_FADE_IN_TIME then
        creep.SpriteScale = maxScale * math.max((creep.FrameCount / Constants.CREEP_FADE_IN_TIME / 2 + 0.5), maxScale.X / 2) 
    end

    local endFrame = Constants.CREEP_LIFETIME
    if creep.FrameCount >= endFrame + Constants.CREEP_FADE_OUT_TIME then
        data.ClusterFadingOut = true
        local t = 1 - ((creep.FrameCount - (endFrame + Constants.CREEP_FADE_OUT_TIME)) / Constants.CREEP_FADE_OUT_TIME)
        creep.Color = Color(1, 1, 1, t)
        creep.SpriteScale = maxScale * t
    end

    creep.Velocity = creep.Velocity * 0.7
    creep.Position = game:GetRoom():GetClampedPosition(creep.Position, 5)

    if creep.FrameCount >= endFrame + Constants.CREEP_FADE_OUT_TIME * 2 then
        creep:Remove()
        return
    end
end

---@param spike EntityEffect
function mod:UpdateShadowClusterSpikes(spike)
    local data = mod:GetEntityData(spike)
    local sprite = spike:GetSprite()
    local player = spike.SpawnerEntity and spike.SpawnerEntity:ToPlayer()

    if not player then
        return
    end

    local endFrame = Constants.CREEP_LIFETIME
    if spike.FrameCount < endFrame then
        if spike.FrameCount == 0 or spike.FrameCount % Constants.SPIKE_HIT_INTERVAL == 0 then
            for _, enemy in ipairs(Isaac.FindInRadius(spike.Position, data.ShadowCreepFromWisp and Constants.SPIKE_DAMAGE_RADIUS_WISP or Constants.SPIKE_DAMAGE_RADIUS, EntityPartition.ENEMY)) do
                if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() then
                    local npc = enemy:ToNPC()
                    if not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                        -- First, wipe the old ones because we want to poll for new ones every damage tick
                        TearFlagsLib.WipeTearFlags(spike)
                        TearFlagsLib.WipeCustomVanillaTearFlags(spike)

                        -- Get damage for the spike
                        local vanillaFlags, vanillaDamage = TearFlagsLib.PollVanillaTearFlags(player, spike)
                        spike.CollisionDamage = vanillaDamage * Constants.SPIKE_DAMAGE_MULT + Constants.SPIKE_DAMAGE_FLAT
                        if data.ShadowCreepFromWisp then
                            spike.CollisionDamage = spike.CollisionDamage / 2
                        end

                        -- Then poll for the flags
						local color = spike.Color
                        TearFlagsLib.PollTearFlags(spike, player, TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER)
						spike.Color = color

                        -- Poll vanilla tear effects, with some extra parameters
                        TearFlagsLib.SetCustomVanillaTearFlagParams(spike, {
                            DamageOverride = spike.CollisionDamage * Constants.SPIKE_DAMAGE_MULT_TEAREFFECTS, -- Makes explosions/holy light deal less damage
                            ColorOverride = mod.ColorGritWavePurple,
                        })
                        TearFlagsLib.AddCustomVanillaTearFlags(spike, vanillaFlags)

                        -- Apply tear flags and damage
                        TearFlagsLib.ApplyWeaponTearFlags(npc, player, spike, TearFlagsLib.WeaponFlag.FF_SHADOW_CLUSTER, true)
                        TearFlagsLib.DamageEntity(npc, spike.CollisionDamage, 0, spike)
						
						-- Lil bit of cleanup after
						spike.CollisionDamage = 0
                    end
                end
            end
        end
    end

    if spike.FrameCount >= endFrame then
        if sprite:IsFinished("Death") then
            spike:Remove()
        end

        if not sprite:IsPlaying("Death") then
            sprite:Play("Death")
        end
    end
end

function mod:UpdateShadowClusterBlood(effect)
    if effect.FrameCount > 60 then
        local progress = effect.FrameCount - 60
        effect:GetSprite().Color = Color(1, 1, 1, 1 - (progress / 30))
        if effect.FrameCount >= 90 then
            effect:Remove()
        end
    end
end