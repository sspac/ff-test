local mod = FiendFolio
local game = Game()

local Settings = {
    MOVE_SPEED = 6,
    MOVE_SPEED_MIN = 5,
    MOVE_SPEED_MAX = 7.5,
    AURA_SIZE = 69,
    FRIENDLY_AURA_SIZE = 40
}

function mod.FindClosestEnemyGeigerspirit(pos)
	local radius = 99999
	local target = nil
	for _, entity in ipairs(Isaac.GetRoomEntities()) do
		if entity:IsActiveEnemy() and not mod:isFriend(entity) and entity:IsVulnerableEnemy() then
			local etype = entity.Type
			local evar = entity.Variant
			local esub = entity.SubType
			local badent = false
			for _, v in ipairs(mod.GeigerspiritBlacklist) do
				if v[3] then if etype == v[1] and evar == v[2] and esub == v[3] then badent = true end
				elseif v[2] then if etype == v[1] and evar == v[2] then badent = true end
				elseif etype == v[1] then badent = true end
			end
			for _, v in ipairs(mod.HidingUnderwaterEnts) do
				if v[3] then if etype == v[1] and evar == v[2] and esub == v[3] then badent = true end
				elseif v[2] then if etype == v[1] and evar == v[2] then badent = true end
				elseif etype == v[1] then badent = true end
			end
			if mod:GetEntityData(entity).FFIsCircleSummon then
				badent = true
			end
			if not badent then
				local distance = pos:Distance(entity.Position)
				if distance < radius then
					radius = distance
					target = entity
				end
			end
		end
	end
	--Isaac.ConsoleOutput("{" .. target.Type .. ", " .. target.Variant .. "}\n")
	return target
end

---@param npc EntityNPC
function mod:GeigerspiritUpdate(npc)
    if npc.State == NpcState.STATE_INIT then
        npc.State = NpcState.STATE_MOVE
        npc:GetSprite():Play("Fly")
    end

    local resetAnyway = false
    if mod:isFriend(npc) then
        local room = game:GetRoom()
        if room:GetFrameCount() == 0 then
            resetAnyway = true
        end
    end

    local data = mod:GetEntityData(npc)
    if resetAnyway or not npc.Parent then
        local newHost = mod.FindClosestEnemyGeigerspirit(npc.Position)
        if newHost then
            npc.Parent = newHost
        else
            npc.Parent = npc:GetPlayerTarget()
        end
    end

    if npc.Parent then
        data.GSCircleAngle = data.GSCircleAngle or (npc.Position - npc.Parent.Position):GetAngleDegrees()
        data.GSCircleAngle = data.GSCircleAngle + 3

        local circleDistance = 40 + npc.Parent.Size
        if npc.Parent.Type == EntityType.ENTITY_PLAYER then
            circleDistance = 80
        end
        local targPos = npc.Parent.Position + Vector.FromAngle(data.GSCircleAngle):Resized(circleDistance)
        local length = (targPos - npc.Position)
        local moveSpeed = Settings.MOVE_SPEED
        if npc.Parent.Type == EntityType.ENTITY_PLAYER then
            moveSpeed = mod:ClampNumber(moveSpeed * (npc.Parent:ToPlayer().MoveSpeed), Settings.MOVE_SPEED_MIN, Settings.MOVE_SPEED_MAX)
        end
        local targetVel = length:Resized(math.min(moveSpeed, length:Length()))
        npc.Velocity = mod:Lerp(npc.Velocity, targetVel, 0.5)

        if length:Length() > 10 then
            data.GSCircleAngle = nil
        end
    end

    local auraSize = mod:isFriend(npc) and Settings.FRIENDLY_AURA_SIZE or Settings.AURA_SIZE
    mod:SetRadioactiveAura(npc, auraSize, 15)
end

---@param npc EntityNPC
function mod:GeigerspiritInit(npc)
    mod:GetEntityData(npc).ffRadioactiveEnemy = true
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    npc.SplatColor = mod.ColorBobsGreen
end

-- So that it doesn't collide with other entities, but isn't hurt by their attacks either.
---@param npc Entity
---@param source EntityRef
function mod:GeigerspiritTakeDamage(npc, damage, flag, source)
    if mod:isFriend(npc) then
        return
    end

    if not source 
    or not source.Entity then
        return
    end

    local attacker = source.Entity
    if not attacker:IsEnemy() then
        if not (source.Entity.SpawnerEntity and source.Entity.SpawnerEntity:IsEnemy()) then
            return
        end

        attacker = source.Entity.SpawnerEntity
    end

    if attacker
    and not source.IsCharmed
    and not source.IsFriendly then
        return false
    end
end