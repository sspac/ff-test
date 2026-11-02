local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local enemy = {}

local warpCultist = mod.FF.WarpCultist

local COLOR_COOLDOWN = 15

local reviveList = {}

-- [string entity type] = {[string variant or -1 for all variants] = {list of subtypes, add "-1" to apply to all subtypes}}
mod.WarpCultistBlacklist = {
    [tostring(EntityType.ENTITY_BISHOP)] = {['-1'] = {}},
    [tostring(EntityType.ENTITY_CULTIST)] = {['0'] = {'-1'}},
    [tostring(mod.FF.Flickerspirit.ID)] = {[tostring(mod.FF.Flickerspirit.Var)] = {'-1'}},
    [tostring(EntityType.ENTITY_MAGGOT)] = {[tostring(mod.FF.Alfil.Var)] = {'-1'}},
    [tostring(mod.FF.SternumRib.ID)] = {[tostring(mod.FF.SternumRib.Var)] = {'-1'}},
    [tostring(mod.FF.MrBones.ID)] = {[tostring(mod.FF.MrBones.Var)] = {'-1'}},
    [tostring(mod.FF.EternalFlickerspirit.ID)] = {[tostring(mod.FF.EternalFlickerspirit.Var)] = {'-1'}}
}

local function canColor(var, cooldown, frameCount)
    if not var or frameCount - var > cooldown then
        return true
    end

    return false
end

---@param npc Entity
local function checkBlacklist(npc)
    if mod.WarpCultistBlacklist[tostring(npc.Type)] then
        local npcType = mod.WarpCultistBlacklist[tostring(npc.Type)]
        if npcType["-1"] then
            return true
        else
            local subtypes = npcType[tostring(npc.Variant)]
            if subtypes then
                for _, subtype in ipairs(subtypes) do
                    if subtype == "-1" or subtype == tostring(npc.SubType) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local Settings = {
    MoveSpeed = 4.7,
    ReviveCooldown = 70,
    ReviveRadius = 80,
    ReviveDistance = 50,
    TurnFromWallDistance = 60,
    TurnFromPillarDistance = 55,
}

local function getClosestOnRevive(pos)
    local item, distance
    for i, v in ipairs(reviveList) do
        local d = v.Position:DistanceSquared(pos)
        if not distance or d < distance then
            distance = d
            item = i
        end
    end

    return item
end

local function updateRevivedEnemies()
    for _, ent in ipairs(Isaac.GetRoomEntities()) do
        local n = ent:ToNPC()
        if n then
            local entData = mod:GetEntityData(n)
            if (n.Parent and mod:GetEntityData(n.Parent).WarpedCultistRevived)
            or (n.Child and mod:GetEntityData(n.Child).WarpedCultistRevived)
            or (n.SpawnerEntity and mod:GetEntityData(n.SpawnerEntity).WarpedCultistRevived) then
                n:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_REWARD)
                n.CanShutDoors = false
                n.Color = Color(1, 1, 1, 0.5, 1, 0.6, 1)
                entData.WarpedCultistRevived = true
            end
        end
    end
end

---@param cultist EntityNPC
function mod:WarpCultistInit(cultist)
    local data = mod:GetEntityData(cultist)
    data.WCReviveCooldown = Settings.ReviveCooldown
    cultist:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_NO_TARGET)
    cultist:GetSprite():Play("Idle", true)
    cultist.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
end

---@param cultist EntityNPC
function mod:WarpCultistUpdate(cultist)
    if cultist.State == NpcState.STATE_INIT then
        cultist.State = NpcState.STATE_MOVE
    end

    local sprite = cultist:GetSprite()
    local data = mod:GetEntityData(cultist)
    local rng = cultist:GetDropRNG()

    if game:GetRoom():IsClear() then
        cultist.State = NpcState.STATE_DEATH
        cultist.Velocity = Vector.Zero
        cultist.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sfx:Play(SoundEffect.SOUND_BLACK_POOF)

        -- Kill revived guys
        for _, entity in ipairs(Isaac.GetRoomEntities()) do
            if mod:GetEntityData(entity).WarpedCultistRevived then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, entity)
                entity:Remove()
            end
        end

        return
    end

    data.WCReviveCooldown = math.max(data.WCReviveCooldown - 1, 0)

    if cultist.State ~= NpcState.STATE_DEATH and canColor(data.WCFadeoutTimer, COLOR_COOLDOWN, cultist.FrameCount) then
        for _ in ipairs(Isaac.FindInRadius(cultist.Position, cultist.Size, EntityPartition.TEAR)) do
            cultist:SetColor(Color(1, 1, 1, 0.33, 0.9, 0.5, 0.9), 10, 100, true, true)
            data.WCFadeoutTimer = cultist.FrameCount + 15
            break
        end
    end

    if cultist.State == NpcState.STATE_MOVE then
        local nearestWall = mod:GetClosestWall(cultist.Position)
        local nearestPillar = mod:GetClosestPillar(cultist.Position)
        if #reviveList > 0 and data.WCReviveCooldown == 0 then
            local closestIndex = getClosestOnRevive(cultist.Position)
            if not closestIndex then -- something went wrong somehow
                reviveList = {}
                return
            end

            local closestData = reviveList[closestIndex]
            local result = mod:CatheryPathFinding(cultist, closestData.Position, {
                Speed = Settings.MoveSpeed,
                Accel = 0.1,
                UseDirectPath = true,
                GiveUp = false,
                IgnorePits = true,
            })

            -- Failsafe, just go straight towards enemy
            if result == false then
                cultist.Velocity = mod:Lerp(cultist.Velocity, (closestData.Position - cultist.Position):Resized(Settings.MoveSpeed), 0.1)
            end

            if cultist.Position:Distance(closestData.Position) <= Settings.ReviveDistance then
                cultist.State = NpcState.STATE_SUMMON
                sprite:Play("Respawn", true)
            end
        elseif nearestWall:Distance(cultist.Position) <= Settings.TurnFromWallDistance then
            local angle = mod:LerpAngleDegrees(cultist.Velocity, (cultist.Position - nearestWall), 0.5)
            cultist.Velocity = mod:Lerp(cultist.Velocity, Vector.FromAngle(angle):Resized(Settings.MoveSpeed), 0.2)
        elseif nearestPillar and nearestPillar:Distance(cultist.Position) <= Settings.TurnFromPillarDistance then
            local angle = mod:LerpAngleDegrees(cultist.Velocity, (cultist.Position - nearestPillar), 0.5)
            cultist.Velocity = mod:Lerp(cultist.Velocity, Vector.FromAngle(angle):Resized(Settings.MoveSpeed), 0.2)
        else
            if cultist.Velocity:Length() < 1e-3 then
                cultist.Velocity = rng:RandomVector():Resized(Settings.MoveSpeed)
            else
                cultist.Velocity = cultist.Velocity:Resized(Settings.MoveSpeed)
            end
        end
    
    elseif cultist.State == NpcState.STATE_SUMMON then
        cultist.Velocity = mod:Lerp(cultist.Velocity, Vector.Zero, 0.2)
        if not data.SelectedRevive and not sprite:WasEventTriggered("Shoot") then
            data.SelectedRevive = {}
            local indexesToRemove = {}
            for i, v in ipairs(reviveList) do
                if v.Position:Distance(cultist.Position) <= Settings.ReviveRadius then
                    table.insert(data.SelectedRevive, v)
                    indexesToRemove[#indexesToRemove+1] = i
                end
            end

            for i = #indexesToRemove, 1, -1 do
                table.remove(reviveList, indexesToRemove[i])
            end
        end

        if sprite:IsEventTriggered("Shoot") and #data.SelectedRevive > 0 then
            for _, v in ipairs(data.SelectedRevive) do
                local npc = Isaac.Spawn(v.Type, v.Variant, v.SubType, v.Position, Vector.Zero, cultist):ToNPC()
                npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_REWARD)
                npc.CanShutDoors = false
                npc.Color = Color(1, 1, 1, 0.5, 1, 0.6, 1)
                mod:GetEntityData(npc).WarpedCultistRevived = true
            end

            updateRevivedEnemies()

            sfx:Play(SoundEffect.SOUND_BOSS_LITE_HISS)
            sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
        end
        
        if sprite:IsFinished("Respawn") then
            cultist.State = NpcState.STATE_MOVE
            data.SelectedRevive = nil
            sprite:Play("Idle", true)
        end
    end

    -- Updates colors and such for spawned fires
    if cultist.FrameCount % 6 == 0 then
        updateRevivedEnemies()
    end
end

---@param npc EntityNPC
function enemy:TrackEnemyDeath(npc)
    if not mod:GetEntityData(npc).WarpedCultistRevived
    and npc:IsActiveEnemy(true)
    and not checkBlacklist(npc)
    and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
    and not npc:HasEntityFlags(EntityFlag.FLAG_CHARM)
    and not npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)
    and Isaac.CountEntities(nil, warpCultist.ID, warpCultist.Var) > 0 then
        table.insert(reviveList, {
            Position = npc.Position,
            Type = npc.Type,
            Variant = npc.Variant,
            SubType = npc.SubType,
        })
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, enemy.TrackEnemyDeath)

---@param ent Entity
function enemy:PreventRevivedDamage(ent)
    local npc = ent:ToNPC()
    if npc and mod:GetEntityData(ent).WarpedCultistRevived then
        return false
    end

    if npc and npc.Type == warpCultist.ID and npc.Variant == warpCultist.Var then
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, enemy.PreventRevivedDamage)

---@param collider Entity
function enemy:PassthroughPlayerObjects(ent, collider)
    local data = mod:GetEntityData(collider)
    if data.WarpedCultistRevived then
        return true
    end
end

mod:AddEntityCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, warpCultist.ID, warpCultist.Var, 0, enemy.PassthroughPlayerObjects)
mod:AddEntityCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, warpCultist.ID, warpCultist.Var, 0, enemy.PassthroughPlayerObjects)


function mod:WarpCultistWipeReviveList()
    reviveList = {}
end