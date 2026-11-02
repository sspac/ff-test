local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local WANTED_CHANCE = 0.25
local HEALTH_MULT = 1.75
local EXTRA_PROJECTILE_DELAY = 20
local EXTRA_PROJECTILE_SPEED = 8
local EXTRA_PROJECTILE_VARIANCE = 25

local extraProjectileParams = ProjectileParams()
extraProjectileParams.FallingSpeedModifier = -14
extraProjectileParams.FallingAccelModifier = 1.2
extraProjectileParams.HeightModifier = -5

---@param entity Entity
function mod:GetTopOfEntity(entity)
    local sprite = entity:GetSprite()
    local layer = sprite:GetLayer("head") or sprite:GetNullFrame("OverlayEffect") or sprite:GetLayer("body") or sprite:GetLayer(0)
    if layer then
        return layer:GetPos()
    else
        return entity.PositionOffset
    end
end

function mod:ChooseWantedPosterTarget()
    local room = game:GetRoom()
    if not (room:IsFirstVisit() and not room:IsClear()) then
        return
    end

    local player = PlayerManager.FirstTrinketOwner(mod.ITEM.TRINKET.WANTED_POSTER)
    if not player then
        return
    end
    
    local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.WANTED_POSTER)
    local save = mod.getFieldInit(FiendFolio.savedata, 'run', 'level', 'wantedPoster', {targetChosen = false})
    if not save.targetChosen then
        for _, ent in ipairs(Isaac.GetRoomEntities()) do
            if ent:IsActiveEnemy() 
            and ent:IsVulnerableEnemy() 
            and not ent:IsBoss()
            and not ent:HasEntityFlags(EntityFlag.FLAG_NO_REWARD)
            and not mod:isFriend(ent)
            and not mod:isCharm(ent)
            and rng:RandomFloat() < WANTED_CHANCE then
                local npc = ent:ToNPC()

                npc.MaxHitPoints = npc.MaxHitPoints * HEALTH_MULT
                npc.HitPoints = npc.MaxHitPoints
                
                npc.Scale = 1.5

			    local icon = Isaac.Spawn(EntityType.ENTITY_EFFECT, 1748, 0, npc.Position, mod.nilvector, nil):ToEffect()
                icon:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                icon:FollowParent(npc)
                icon.DepthOffset = 1
                icon:GetSprite():Play("Wanted", true)
                icon:Update()

                local data = mod:GetEntityData(npc)
                data.WantedPosterTarget = true
                data.WantedPosterIcon = EntityPtr(icon)
                data.WantedPosterMult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.WANTED_POSTER)

                save.targetChosen = true
                return
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.TRINKET.WANTED_POSTER, mod.ChooseWantedPosterTarget)

---@param npc EntityNPC
function mod:HandleWantedPosterTarget(npc, data)
    if data.WantedPosterTarget then
        if npc.FrameCount % EXTRA_PROJECTILE_DELAY == 0 and npc.FrameCount > EXTRA_PROJECTILE_DELAY then
            local pos = npc.Position + mod:GetTopOfEntity(npc)
            local target = npc:GetPlayerTarget()
            local variance = mod:RandomInt(-EXTRA_PROJECTILE_VARIANCE, EXTRA_PROJECTILE_VARIANCE)
            local direction = (target.Position - npc.Position):Resized(EXTRA_PROJECTILE_SPEED):Rotated(variance)
            npc:FireProjectiles(pos, direction, ProjectileMode.SINGLE, extraProjectileParams)
            local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, pos, Vector.Zero, npc)
            splat.DepthOffset = 100
        end

        if npc:HasMortalDamage() then
            local mult = data.WantedPosterMult or 1
            
            for _ = 1, mult do
                local spawnPos = game:GetRoom():FindFreePickupSpawnPosition(npc.Position)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, spawnPos, Vector.Zero, npc)
            end

            data.WantedPosterTarget = nil -- Just in case

            if data.WantedPosterIcon and data.WantedPosterIcon.Ref then
                data.WantedPosterIcon.Ref:Remove()
                data.WantedPosterIcon = nil
            end
        end
    end
end