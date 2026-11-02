local mod = FiendFolio
local game = Game()

local balsiketic = {
    slowThresh = 1,
    slowDown = 0.06,
    slowUp = 0.35,
    initialSpeed = 3.5,
    highSpeed = 6,

    hideTime = {45, 120, 26},
    hideTime2 = {15, 35, 12},
    maxRad = 240,
    minRad = 60,
    minimumChase = 45,
}

--MaxRadius is how far it can spawn
--MinRadius is how far away from the player it must spawn
function mod:FindPathablePositionNearPlayer(npc, player, maxRadius, minRadius, los)
    maxRadius = maxRadius or 300
    minRadius = minRadius or 80
    local validPositions = {}
    local room = game:GetRoom()
    local size = room:GetGridSize()
    local testNPC = Isaac.Spawn(mod.FF.ChummerPathfinder.ID, mod.FF.ChummerPathfinder.Var, 0, player.Position, Vector.Zero, nil):ToNPC()
    local testPath = testNPC.Pathfinder
    testNPC.Visible = false
    testNPC:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    testNPC.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    testNPC:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
    local truePos = player.Position+player.Velocity*3
    for i=0, size do
        local gridpos = room:GetGridPosition(i)
        if room:GetGridCollisionAtPos(gridpos) == GridCollisionClass.COLLISION_NONE and room:IsPositionInRoom(gridpos, 0) and (not los or room:CheckLine(testNPC.Position, gridpos, 0, 0, false, false)) then
            local realDist = gridpos:Distance(truePos)
            if realDist > minRadius and realDist < maxRadius and testPath:HasPathToPos(gridpos, false) then
                table.insert(validPositions, gridpos)
            end
        end
    end
    testNPC:Remove()
    if #validPositions > 0 then
        return validPositions[math.random(#validPositions)]
    else
        return npc.Position
    end
end

function mod:calsiketicAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:randomConfuse(npc, target.Position)
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()
    local blackingOut

    if not d.init then
        npc.SplatColor = Color(0.1, 0.2, 0.3, 1)
        d.myHead = rng:RandomInt(8)+1
        mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/calsiketic/monster_calsiketic" .. d.myHead, 1)
        if npc.SubType > 0 and not d.waited then
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
			npc.Visible = false
            mod:makeWaitFerr(npc, mod.FFID.Ferrium, npc.Variant, npc.SubType, 60, false)
        elseif d.waited then
            sprite:Play("Surface", true)
            d.state = "Surface"
            npc.Visible = true
        else
            d.state = "Idle"
            --npc.Visible = false
            sprite:PlayOverlay("Head")
        end
        --npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        d.originalColor = npc.Color
        d.speed = balsiketic.initialSpeed
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.state == "Idle" then
        local los
        if mod:isScare(npc) then
			local targetvel = (targetpos - npc.Position):Resized(-balsiketic.highSpeed)
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
            los = true
		elseif room:CheckLine(npc.Position, targetpos, 0, 1, false, false) then
			local targetvel = (targetpos - npc.Position):Resized(d.speed)
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
            d.speed = math.min(balsiketic.highSpeed, d.speed+balsiketic.slowUp)
            los = true
		else
            if npc.StateFrame > balsiketic.minimumChase then
                blackingOut = true
                d.speed = math.max(0, d.speed-balsiketic.slowDown)
            else
                d.speed = math.min(balsiketic.highSpeed, d.speed+balsiketic.slowUp)
            end
			if npc.Pathfinder:HasPathToPos(target.Position, false) then
				npc.Pathfinder:FindGridPath(targetpos, d.speed/6.5, 900, true)
			else
				npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.4)
			end
		end

        --[[if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
            if npc.Velocity.X > 0 then
                mod:spritePlay(sprite, "WalkRight")
            else
                mod:spritePlay(sprite, "WalkLeft")
            end
        else
            mod:spritePlay(sprite, "WalkVert")
        end]]
        if npc.Velocity:Length() > 0.1 then
			npc:AnimWalkFrame("WalkHori","WalkVert",0)
		else
			mod:spritePlay(sprite, "Idle")
		end
        if los then
            mod:spriteOverlayPlay(sprite, "HeadEnrage")
        else
            mod:spriteOverlayPlay(sprite, "Head")
        end

        if not mod:isScareOrConfuse(npc) and npc.StateFrame > balsiketic.minimumChase and d.speed < balsiketic.slowThresh then
            d.state = "Melt"
            npc:PlaySound(SoundEffect.SOUND_DOGMA_BLACKHOLE_OPEN, 0.2, 0, false, mod:RandomInt(260,290,rng)/100)
            mod.scheduleForUpdate(function()
                sprite:RemoveOverlay()
            end, 2)
        end
    elseif d.state == "Melt" then
        if sprite:IsFinished("Melt") then
            d.state = "Hidden"
            npc.StateFrame = 0
            npc.Visible = false
            d.blackingOut = nil
        elseif sprite:IsEventTriggered("Change") then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            mod:spritePlay(sprite, "Melt")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.4)
    elseif d.state == "Hidden" then
        local real
        for _,ent in ipairs(Isaac.FindInRadius(npc.Position, 500, EntityPartition.ENEMY)) do
            if not mod.dontpreventwaiting(ent) then
                if ent.Type == mod.FF.Calsiketic.ID and ent.Variant == mod.FF.Calsiketic.Var and mod:GetEntityData(ent).state == "Hidden" then
                else
                    real = true
                end
            end
        end
        local GO
        if not real then
            if npc.StateFrame > balsiketic.hideTime2[1] and rng:RandomInt(balsiketic.hideTime2[3]) == 0 then
                GO = true
            elseif npc.StateFrame > balsiketic.hideTime2[2] then
                GO = true
            end
        else
            if npc.StateFrame > balsiketic.hideTime[1] and rng:RandomInt(balsiketic.hideTime[3]) == 0 then
                GO = true
            elseif npc.StateFrame > balsiketic.hideTime[2] then
                GO = true
            end
        end
        if GO then
            npc.Visible = true
            npc.Color = d.originalColor
            d.state = "Surface"
            npc.Position = mod:FindPathablePositionNearPlayer(npc, target, balsiketic.maxRad, balsiketic.minRad, true)
        end
    elseif d.state == "Surface" then
        if sprite:IsFinished("Surface") then
            d.state = "Idle"
            d.speed = balsiketic.highSpeed
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("Change") then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        else
            mod:spritePlay(sprite, "Surface")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.4)
    end

    if blackingOut then
        local ratio = (d.speed-balsiketic.slowThresh/2)/(balsiketic.highSpeed-balsiketic.slowThresh/2)
        npc.Color = Color(ratio, ratio, ratio, npc.Color.A)
        d.blackingOut = true
    elseif d.blackingOut then
        local ratio = (d.speed-balsiketic.slowThresh/2)/(balsiketic.highSpeed-balsiketic.slowThresh/2)
        npc.Color = Color(ratio, ratio, ratio, npc.Color.A)
        if ratio > 0.9 then
            npc.Color = Color(1, 1, 1, npc.Color.A)
            d.blackingOut = nil
        end
    end
end