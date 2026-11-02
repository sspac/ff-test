local mod = FiendFolio
local game = Game()

local Settings = {
    MOVE_SPEED = 1.5,
}

local function isActive(isBlue)
    if not mod.TotemsExist then
        return true
    end
    
    local totemState = mod.TotemState
    if (totemState and isBlue)
    or (not totemState and not isBlue) then
        return true
    else
        return false
    end
end

---@param npc EntityNPC
function mod:BinaryInit(npc)
    npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)

    -- Set spritesheet
    mod:LoadBinarySkin(npc)
end

function mod:LoadBinarySkin(npc)
    local cPair = mod:GetExpectedTotemColors()
    if cPair then
        if npc.SubType == 0 then
            npc:ReplaceSpritesheet(0, "gfx/enemies/binary/binary_" .. cPair[1] .. ".png", true)
        else
            npc:ReplaceSpritesheet(0, "gfx/enemies/binary/binary_" .. cPair[2] .. ".png", true)
        end
    elseif npc.SubType == 1 then
        npc:ReplaceSpritesheet(0, "gfx/enemies/binary/binary_B_blue.png", true)
    end
end

---@param npc EntityNPC
function mod:BinaryUpdate(npc)
    local sprite = npc:GetSprite()
    local pathfinder = npc.Pathfinder
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()

    if npc.StateFrame == 1 or npc.State == NpcState.STATE_INIT then
        sprite:SetFrame("WalkVert", 0)
        if isActive(npc.SubType == 1) then
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
            sprite:PlayOverlay("HeadOn", false)
        else
            npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
            sprite:PlayOverlay("HeadOff", false)
        end
    end

    npc.StateFrame = math.max(npc.StateFrame - 1, 0)
    if isActive(npc.SubType == 1) or mod:isFriend(npc) then
        if mod:isConfuse(npc) then
			pathfinder:MoveRandomly()
        else
            if mod:isScare(npc) then
                npc:AddVelocity((npc.Position - target.Position):Resized(Settings.MOVE_SPEED))
            else
                if mod:isCharm(npc) and target.Type == EntityType.ENTITY_PLAYER and target.Position:Distance(npc.Position) < 60 then
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
                else
                    local noHit = room:CheckLine(npc.Position, target.Position, LineCheckMode.RAYCAST, 1)
                    if noHit then
                        npc:AddVelocity((target.Position - npc.Position):Resized(Settings.MOVE_SPEED))
                    else
                        pathfinder:FindGridPath(target.Position, Settings.MOVE_SPEED, 900, true)
                    end
                end
            end
        end 

        if npc.State ~= NpcState.STATE_MOVE then
            npc.StateFrame = npc:GetDropRNG():RandomInt(1, 4)
            npc.State = NpcState.STATE_MOVE
        end
    else
        if npc.State ~= NpcState.STATE_IDLE then
            npc.StateFrame = npc:GetDropRNG():RandomInt(1, 4)
            npc.State = NpcState.STATE_IDLE
        end
    end

    if npc.FrameCount > 0 then
        npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
    end

    if not mod:isConfuse(npc) then
        npc.Velocity = npc.Velocity * 0.8
    else 
        npc.Velocity = npc.Velocity * 0.9
    end
end

function mod:BinaryHurt(npc, amount, flags, source, frames)
    if not isActive(npc.SubType == 1) then
        return false
    end
end

-- Knockback from knives (get pushed away from SpawnerEntity in order to avoid getting pushed into the player)
function mod:BinaryCollide(npc, collider)
    if collider.Type == EntityType.ENTITY_KNIFE and collider.SpawnerEntity then
        npc:AddVelocity((npc.Position - collider.SpawnerEntity.Position):Normalized())
    end
end