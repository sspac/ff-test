local mod = FiendFolio
local game = Game()

local RARE_FACE_CHANCE = 0.1
local SURROUND_DISTANCE_RING_INNER = 125
local SPEED = 2.5

---@param enemy EntityNPC
function mod:CongregationInit(enemy)
    local headRng = RNG(enemy.InitSeed)

    -- Spawn some friends
    if enemy.SubType > 0 then
        for _ = 1, enemy.SubType do
            Isaac.Spawn(mod.FFID.Cat, mod.FF.Congregation.Var, 0, enemy.Position + RandomVector() * 40, Vector.Zero, enemy)
        end

        enemy.SubType = 0
    end

    if headRng:RandomFloat() < RARE_FACE_CHANCE then
        enemy.I1 = headRng:RandomInt(1, 4) + 2
    else
        enemy.I1 = headRng:RandomInt(0, 2)
    end

    enemy:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_NO_TARGET)
    enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    -- Position
    mod:CongregationUpdate()
end

function mod:CongregationUpdate()
    local room = game:GetRoom()

    -- Surround starting from in front of Isaac
    for _, congregator in ipairs(Isaac.FindByType(mod.FFID.Cat, mod.FF.Congregation.Var)) do
        congregator = congregator:ToNPC()

        if congregator.State == NpcState.STATE_MOVE then
            local target = congregator:GetPlayerTarget()
            local angle = (target.Position - congregator.Position):GetAngleDegrees()

            -- If the player isn't surrounded, surround. Otherwise, just find the closet valid position.

            local projected = Vector.FromAngle(angle) * SURROUND_DISTANCE_RING_INNER + target.Position
            local _, pos = room:CheckLine(target.Position, projected, LineCheckMode.RAYCAST, 950, false, false)

            congregator.TargetPosition = room:FindFreePickupSpawnPosition(pos, 30, true, false)
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_UPDATE, mod.FFID.Cat, mod.FF.Congregation.Var, 0, mod.CongregationUpdate)

---@param npc EntityNPC
function mod:CongregationNpcUpdate(npc)
    local room = game:GetRoom()
    local sprite = npc:GetSprite()
    local targetPosition = npc.TargetPosition

    if npc.State == NpcState.STATE_INIT then
        npc.State = NpcState.STATE_MOVE
    end

    if targetPosition:Distance(npc.Position) > 5 then
        local playerTarget = npc:GetPlayerTarget()
        local noHit = room:CheckLine(npc.Position, targetPosition, LineCheckMode.RAYCAST, 950)
        if noHit then
            local vec
            if npc.Position:Distance(playerTarget.Position) < SURROUND_DISTANCE_RING_INNER and npc.State == NpcState.STATE_MOVE then
                vec = (npc.Position - targetPosition):Resized(SPEED)
            elseif npc.Position:Distance(playerTarget.Position) > SURROUND_DISTANCE_RING_INNER + 20 then
                vec = (targetPosition - npc.Position):Resized(SPEED)
            end

            if vec then
                -- Don't move forward if congregator is in projected path
                local proceed = true

                for _, thing in ipairs(Isaac.FindInRadius(npc.Position + vec, 0.01, EntityPartition.ENEMY)) do
                    if thing.Type == mod.FFID.Cat
                    and thing.Variant == mod.FF.Congregation.Var
                    and thing.InitSeed ~= npc.InitSeed then
                        proceed = false
                        break
                    end
                end

                -- Don't move forward if rock
                if room:GetGridPathFromPos(npc.Position + vec) >= 1000 then
                    proceed = false
                end

                if proceed then
                    npc:AddVelocity(vec)
                end
            elseif npc.State == NpcState.STATE_MOVE then
                if math.random() < 0.005 then
                    npc.State = NpcState.STATE_IDLE
                    npc.TargetPosition = playerTarget.Position + RandomVector() * (SURROUND_DISTANCE_RING_INNER + 10)

                    if npc.TargetPosition:Distance(playerTarget.Position) < SURROUND_DISTANCE_RING_INNER then
                        npc.State = NpcState.STATE_MOVE
                    end
                end
            else
                npc:AddVelocity((targetPosition - npc.Position):Resized(SPEED))
            end
        else
            npc.Pathfinder:FindGridPath(targetPosition, SPEED / 1.5, 900, true)
        end
    else
        npc.State = NpcState.STATE_MOVE
    end

    if npc.FrameCount % 45 == 0 then
        npc.State = NpcState.STATE_MOVE
    end

    if room:IsClear() then
        npc:Kill()
        return
    end

    local length = npc.Velocity:Length()
    if npc.I2 == 0 then
        if length > 2 then
            sprite:PlayOverlay("BookClose")
            npc.I2 = 10
        elseif length < 1 then
            sprite:PlayOverlay("BookOpen")
            npc.I2 = 10
        end
    end

    npc.I2 = math.max(npc.I2 - 1, 0)

    npc.Velocity = npc.Velocity * 0.75
    npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
end

-- It might seem unholy to not be using an overlay for the head and a separate sprite object for the book...
-- ...but I promise you this is MUCH less laggy.
--- Having a separate sprite object for every NPC and rendering it every frame is very, very laggy.
function mod:CongregationRender(npc)
    npc:GetSprite():SetLayerFrame(1, npc.I1)
end

function mod:CongregationCollision(npc, collider)
    if npc.Type == mod.FFID.Cat and npc.Variant == mod.FF.Congregation.Var then
        if collider.Type == mod.FFID.Cat and collider.Variant == mod.FF.Congregation.Var then
            return nil
        elseif collider:IsEnemy() then
            return true
        end
    end
end

function mod:CongregationTearCollision(tear, collider)
    if collider.Type == mod.FFID.Cat and collider.Variant == mod.FF.Congregation.Var then
        if tear:HasTearFlags(TearFlags.TEAR_SPECTRAL) then
            return true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.CongregationTearCollision)