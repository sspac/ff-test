local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    GSpeed = 4.5,
    IdleChance = 2,
    Idle = {20,40},

    TDist = {180, 300},
    TChance = 3, --1/3 chance to not jump at the player if in the max range.
    TCycle = 30,
    TDiv = 10, --Divide by this it's a weird thing idk
    TAcc = 0.965,

    SWarn = 25,
    SSpeed = 13,
    SDist = 40,

    Swap = {120, 160, 40},

    SurveyCooldown = 120,
}

local function SurveySoulmates()
    local pool = {}
    local room = game:GetRoom()
    for _,npc in ipairs(Isaac.FindByType(mod.FF.Soulmate.ID, mod.FF.Soulmate.Var, -1, false, false)) do
        if mod:superExists(npc) and not mod:GetEntityData(npc).IsSoulmateGhost then
            pool[npc.SubType] = pool[npc.SubType] or {}
            table.insert(pool[npc.SubType], npc:ToNPC())
            mod:GetEntityData(npc).SoulmatePool = pool[npc.SubType]
            mod:GetEntityData(npc).SoulmateSurveyed = room:GetFrameCount()
        end
    end

    for _,npc in ipairs(Isaac.FindByType(mod.FF.Soulmite.ID, mod.FF.Soulmite.Var, -1, false, false)) do
        if mod:superExists(npc) and not mod:GetEntityData(npc).IsSoulmateGhost then
            pool[npc.SubType] = pool[npc.SubType] or {}
            table.insert(pool[npc.SubType], npc:ToNPC())
            mod:GetEntityData(npc).SoulmatePool = pool[npc.SubType]
            mod:GetEntityData(npc).SoulmateSurveyed = room:GetFrameCount()
        end
    end

    return pool
end

local function AreTheyDifferent(npc, npc1)
    return (npc.Variant ~= npc1.Variant and mod:GetEntityData(npc).CurrentSoul == mod:GetEntityData(npc1).CurrentSoul) or (npc.Variant == npc1.Variant and mod:GetEntityData(npc).CurrentSoul ~= mod:GetEntityData(npc1).CurrentSoul)
end

function mod:soulmateAI(npc)
    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local d = mod:GetEntityData(npc)
    local room = game:GetRoom()
    local targetpos = mod:randomConfuse(npc, target.Position)
    local rng = npc:GetDropRNG()

    if not d.init then
        if d.IsSoulmateGhost then
            d.State = "Ghosting"
            d.SubState = "Appear"
            npc.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_REWARD)
            sprite:Play("GhostSpawn", true)
        else
            d.State = "IdleNormal"
        end
        d.SoulmiteFrames = 0
        d.CurrentSoul = "Normal"
        d.init = true
    else
        d.SoulmiteFrames = d.SoulmiteFrames+1
        npc.StateFrame = npc.StateFrame+1
    end

    if npc.FrameCount > 5 and not d.IsSoulmateGhost then
        if not d.SoulmateSurveyed or room:GetFrameCount()-d.SoulmateSurveyed > bal.SurveyCooldown then
            SurveySoulmates()
        end
    end

    local searching

    if d.State == "IdleNormal" then
        if mod:isScare(npc) then
			local targetvel = (targetpos - npc.Position):Resized(-bal.GSpeed*1.2)
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
		elseif room:CheckLine(npc.Position, targetpos, 0, 1, false, false) then
			local targetvel = (targetpos - npc.Position):Resized(bal.GSpeed)
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
		else
			if npc.Pathfinder:HasPathToPos(target.Position, false) then
				npc.Pathfinder:FindGridPath(targetpos, bal.GSpeed/6.5, 900, true)
			else
                if not d.TargetPos or npc.Position:Distance(d.TargetPos) < 5 or d.SoulmiteFrames > 60 or  npc:CollidesWithGrid() then
                    if d.TargetPos and rng:RandomInt(bal.IdleChance) == 0 and npc.Position:Distance(d.TargetPos) < 5 then
                        d.IdlePos = mod:RandomInt(bal.Idle[1], bal.Idle[2], rng)
                    end
                    d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)+mod:shuntedPosition(10, rng)
                    d.SoulmiteFrames = 0
                end
        
                if d.IdlePos then
                    if d.IdlePos > 0 then
                        d.IdlePos = d.IdlePos-1
                        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
                    else
                        d.IdlePos = nil
                        d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)+mod:shuntedPosition(10, rng)
                    end
                elseif d.TargetPos then
                    if room:CheckLine(npc.Position, d.TargetPos, 0, 1, false, false) then
                        local targetvel = (d.TargetPos - npc.Position):Resized(bal.GSpeed)
                        npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
                    else
                        npc.Pathfinder:FindGridPath(d.TargetPos, bal.GSpeed/6.5, 900, true)
                    end
                else
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
                end
			end
		end

        if npc.Velocity:Length() > 1 then
            if sprite:IsPlaying("BodyIdle") then
                sprite:Play("WalkVert", true)
                sprite:PlayOverlay("HeadWalk", true)
            end
            if not sprite:IsOverlayPlaying("HeadWalk") then
                sprite:Play("WalkVert", true)
                sprite:PlayOverlay("HeadWalk", true)
            end

            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                if npc.Velocity.X > 0 then
                    mod:spriteSetAnimation(sprite, "WalkRight", false)
                else
                    mod:spriteSetAnimation(sprite, "WalkLeft", false)
                end
            else
                mod:spriteSetAnimation(sprite, "WalkVert", false)
            end
        else
            mod:spriteOverlayPlay(sprite, "HeadIdle")
            mod:spritePlay(sprite, "BodyIdle")
        end

        if npc.StateFrame > bal.Swap[1] and rng:RandomInt(bal.Swap[3]) == 0 then
            searching = true
        elseif npc.StateFrame > bal.Swap[2] then
            searching = true
        end
    elseif d.State == "IdlePossessed" then
        if d.SoulmiteFrames > bal.TCycle then
            if mod:isConfuse(npc) then
                local dest = room:GetRandomPosition(0)
                if npc.Position:Distance(dest) > bal.TDist[1] then
                    dest = npc.Position+(dest-npc.Position):Resized(bal.TDist[1])
                end
                d.JumpTarget = room:FindFreePickupSpawnPosition(dest, 0, true, false)
            elseif mod:isScare(npc) then
                d.JumpTarget = room:FindFreePickupSpawnPosition((npc.Position-target.Position):Resized(bal.TDist[2]), 0, true, false)
            elseif npc.Position:Distance(target.Position) < bal.TDist[1] then
                d.JumpTarget = room:FindFreePickupSpawnPosition(target.Position, 0, true, false)
            elseif npc.Position:Distance(target.Position) < bal.TDist[2] then
                if rng:RandomInt(bal.TChance) == 0 then
                    local dest = room:GetRandomPosition(0)
                    if npc.Position:Distance(dest) > bal.TDist[1] then
                        dest = npc.Position+(dest-npc.Position):Resized(bal.TDist[1])
                    end
                    d.JumpTarget = room:FindFreePickupSpawnPosition(dest, 0, true, false)
                else
                    d.JumpTarget = room:FindFreePickupSpawnPosition(target.Position, 0, true, false)
                end
            else
                local dest = room:GetRandomPosition(0)
                if npc.Position:Distance(dest) > bal.TDist[1] then
                    dest = npc.Position+(dest-npc.Position):Resized(bal.TDist[1])
                end
                d.JumpTarget = room:FindFreePickupSpawnPosition(dest, 0, true, false)
            end
            d.State = "JumpPossessed"
            d.SoulmiteMovement = nil
        end

        mod:spritePlay(sprite, "IdlePossesed")

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)

        if npc.StateFrame > bal.Swap[1] and rng:RandomInt(bal.Swap[3]) == 0 then
            searching = true
        elseif npc.StateFrame > bal.Swap[2] then
            searching = true
        end
    elseif d.State == "JumpPossessed" then
        if sprite:IsFinished("Hop") then
            d.State = "IdlePossessed"
            d.SoulmiteFrames = 0
        elseif sprite:IsEventTriggered("Jump") then
            d.SoulMiteVec = (d.JumpTarget-npc.Position)/bal.TDiv
            d.SoulmiteMovement = true
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        elseif sprite:IsEventTriggered("Land") then
            npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1)
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            d.SoulmiteMovement = nil
        else
            mod:spritePlay(sprite, "Hop")
        end

        if d.SoulmiteMovement then
            npc.Velocity = mod:Lerp(npc.Velocity, d.SoulMiteVec, 0.3)
            d.SoulMiteVec = d.SoulMiteVec*bal.TAcc
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
        end
    elseif d.State == "Stasis" then
        mod:spritePlay(sprite, "Sleeping")
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.4)

        if d.MySoul and not mod:superExists(d.MySoul) and npc.StateFrame > 100 then
            npc:Kill()
        end
    elseif d.State == "Ghosting" then
        if d.SubState == "Appear" then
            if sprite:IsFinished("GhostSpawn") then
                sprite:Play("Ghost", true)
            end

            if npc.StateFrame > bal.SWarn then
                d.SubState = "Move"
            end
            npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, -1), 0.1)
        elseif d.SubState == "Move" then
            if npc.Position:Distance(d.TargetSoul.Position) < bal.SDist then
                d.SubState = "Enter"
            end
            mod:spritePlay(sprite, "Ghost")

            npc.Velocity = mod:Lerp(npc.Velocity, (d.TargetSoul.Position-npc.Position):Resized(bal.SSpeed), 0.2)
        elseif d.SubState == "Enter" then
            if sprite:IsFinished("GhostDisappear") then
                mod:GetEntityData(d.TargetSoul).State = "LeaveStasis"
                mod:GetEntityData(d.TargetSoul).CurrentSoul = (npc.Variant == d.TargetSoul.Variant and "Normal") or "Possessed"
                npc:Remove()
            else
                mod:spritePlay(sprite, "GhostDisappear")
            end
            npc.Velocity = mod:Lerp(npc.Velocity, (d.TargetSoul.Position-npc.Position)*0.2, 0.3)
        elseif d.SubState == "Fade" then
            if sprite:IsFinished("GhostDisappear") then
                npc:Remove()
            else
                mod:spritePlay(sprite, "GhostDisappear")
            end
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
        end

        if not mod:superExists(d.TargetSoul) then
            if mod:superExists(d.IsSoulmateGhost) and d.SubState ~= "Enter" then
                d.TargetSoul = d.IsSoulmateGhost
            end
        end

        if not mod:superExists(d.IsSoulmateGhost) then
            d.SubState = "Fade"
        end
    elseif d.State == "StartStasis" then
        if sprite:GetOverlayAnimation() then
            sprite:RemoveOverlay()
        end

        if sprite:IsFinished("FallAsleep" .. d.CurrentSoul) then
            d.State = "Stasis"
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("SpawnGhost") then
            local ghost
            if d.CurrentSoul == "Normal" then
                ghost = Isaac.Spawn(npc.Type, npc.Variant, 0, npc.Position, Vector.Zero, npc):ToNPC()
            else
                ghost = Isaac.Spawn(npc.Type, mod.FF.Soulmite.Var, 0, npc.Position, Vector.Zero, npc):ToNPC()
            end
            ghost:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            ghost.Parent = npc
            mod:GetEntityData(ghost).IsSoulmateGhost = npc
            ghost.DepthOffset = 50
            mod:GetEntityData(ghost).TargetSoul = d.TargetSoul
            ghost:Update()
            d.MySoul = ghost
        else
            mod:spritePlay(sprite, "FallAsleep" .. d.CurrentSoul)
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    elseif d.State == "LeaveStasis" then
        if sprite:IsFinished("WakeUp" .. d.CurrentSoul) then
            d.State = "Idle" .. d.CurrentSoul
            npc.StateFrame = 0
            d.SoulmiteFrames = 0
            d.SubState = "Idle"
        else
            mod:spritePlay(sprite, "WakeUp" .. d.CurrentSoul)
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    end

    if searching and d.SoulmatePool and #d.SoulmatePool > 0 then
        local potentials = {}
        for _,guy in pairs(d.SoulmatePool) do
            if mod:superExists(guy) and guy.StateFrame > bal.Swap[1] and AreTheyDifferent(npc, guy) and mod:GetEntityData(guy).State == "Idle" .. mod:GetEntityData(guy).CurrentSoul then
                table.insert(potentials, guy)
            end
        end

        if #potentials > 0 then
            local chosen = potentials[rng:RandomInt(#potentials)+1]
            mod:GetEntityData(chosen).State = "StartStasis"
            mod:GetEntityData(chosen).TargetSoul = npc
            d.TargetSoul = chosen
            d.State = "StartStasis"
        end
    end
end

function mod:soulmiteAI(npc)
    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local d = mod:GetEntityData(npc)
    local room = game:GetRoom()
    local targetpos = mod:randomConfuse(npc, target.Position)
    local rng = npc:GetDropRNG()

    if not d.init then
        if d.IsSoulmateGhost then
            d.State = "Ghosting"
            d.SubState = "Appear"
            npc.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_REWARD)
            sprite:Play("GhostSpawn", true)
        else
            d.State = "IdleNormal"
        end
        d.SoulmiteFrames = 0
        d.CurrentSoul = "Normal"
        d.init = true
    else
        d.SoulmiteFrames = d.SoulmiteFrames+1
        npc.StateFrame = npc.StateFrame+1
    end

    if npc.FrameCount > 5 and not d.IsSoulmateGhost then
        if not d.SoulmateSurveyed or room:GetFrameCount()-d.SoulmateSurveyed > bal.SurveyCooldown then
            SurveySoulmates()
        end
    end

    local searching

    if d.State == "IdlePossessed" then
        if mod:isScare(npc) then
			local targetvel = (targetpos - npc.Position):Resized(-bal.GSpeed*1.2)
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
		elseif room:CheckLine(npc.Position, targetpos, 0, 1, false, false) then
			local targetvel = (targetpos - npc.Position):Resized(bal.GSpeed)
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
		else
			if npc.Pathfinder:HasPathToPos(target.Position, false) then
				npc.Pathfinder:FindGridPath(targetpos, bal.GSpeed/6.5, 900, true)
			else
				if npc.Pathfinder:HasPathToPos(target.Position, false) then
                    npc.Pathfinder:FindGridPath(targetpos, bal.GSpeed/6.5, 900, true)
                else
                    if not d.TargetPos or npc.Position:Distance(d.TargetPos) < 5 or d.SoulmiteFrames > 60 or  npc:CollidesWithGrid() then
                        if d.TargetPos and rng:RandomInt(bal.IdleChance) == 0 and npc.Position:Distance(d.TargetPos) < 5 then
                            d.IdlePos = mod:RandomInt(bal.Idle[1], bal.Idle[2], rng)
                        end
                        d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)+mod:shuntedPosition(10, rng)
                        d.SoulmiteFrames = 0
                    end

                    if d.IdlePos then
                        if d.IdlePos > 0 then
                            d.IdlePos = d.IdlePos-1
                            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
                        else
                            d.IdlePos = nil
                            d.TargetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)+mod:shuntedPosition(10, rng)
                        end
                    elseif d.TargetPos then
                        if room:CheckLine(npc.Position, d.TargetPos, 0, 1, false, false) then
                            local targetvel = (d.TargetPos - npc.Position):Resized(bal.GSpeed)
                            npc.Velocity = mod:Lerp(npc.Velocity, targetvel, 0.3)
                        else
                            npc.Pathfinder:FindGridPath(d.TargetPos, bal.GSpeed/6.5, 900, true)
                        end
                    else
                        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
                    end
                end
			end
		end

        if npc.Velocity:Length() > 1 then
            mod:spritePlay(sprite, "Walk")
        else
            mod:spritePlay(sprite, "IdlePossessed")
        end

        if npc.StateFrame > bal.Swap[1] and rng:RandomInt(bal.Swap[3]) == 0 then
            searching = true
        elseif npc.StateFrame > bal.Swap[2] then
            searching = true
        end
    elseif d.State == "IdleNormal" then
        if d.SoulmiteFrames > bal.TCycle then
            if mod:isConfuse(npc) then
                local dest = room:GetRandomPosition(0)
                if npc.Position:Distance(dest) > bal.TDist[1] then
                    dest = npc.Position+(dest-npc.Position):Resized(bal.TDist[1])
                end
                d.JumpTarget = room:FindFreePickupSpawnPosition(dest, 0, true, false)
            elseif mod:isScare(npc) then
                d.JumpTarget = room:FindFreePickupSpawnPosition((npc.Position-target.Position):Resized(bal.TDist[2]), 0, true, false)
            elseif npc.Position:Distance(target.Position) < bal.TDist[1] then
                d.JumpTarget = room:FindFreePickupSpawnPosition(target.Position, 0, true, false)
            elseif npc.Position:Distance(target.Position) < bal.TDist[2] then
                if rng:RandomInt(bal.TChance) == 0 then
                    local dest = room:GetRandomPosition(0)
                    if npc.Position:Distance(dest) > bal.TDist[1] then
                        dest = npc.Position+(dest-npc.Position):Resized(bal.TDist[1])
                    end
                    d.JumpTarget = room:FindFreePickupSpawnPosition(dest, 0, true, false)
                else
                    d.JumpTarget = room:FindFreePickupSpawnPosition(target.Position, 0, true, false)
                end
            else
                local dest = room:GetRandomPosition(0)
                if npc.Position:Distance(dest) > bal.TDist[1] then
                    dest = npc.Position+(dest-npc.Position):Resized(bal.TDist[1])
                end
                d.JumpTarget = room:FindFreePickupSpawnPosition(dest, 0, true, false)
            end
            d.State = "JumpNormal"
            d.SoulmiteMovement = nil
        end

        mod:spritePlay(sprite, "Idle")

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)

        if npc.StateFrame > bal.Swap[1] and rng:RandomInt(bal.Swap[3]) == 0 then
            searching = true
        elseif npc.StateFrame > bal.Swap[2] then
            searching = true
        end
    elseif d.State == "JumpNormal" then
        if sprite:IsFinished("Hop") then
            d.State = "IdleNormal"
            d.SoulmiteFrames = 0
        elseif sprite:IsEventTriggered("Jump") then
            d.SoulMiteVec = (d.JumpTarget-npc.Position)/bal.TDiv
            d.SoulmiteMovement = true
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        elseif sprite:IsEventTriggered("Land") then
            npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1)
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            d.SoulmiteMovement = nil
        else
            mod:spritePlay(sprite, "Hop")
        end

        if d.SoulmiteMovement then
            npc.Velocity = mod:Lerp(npc.Velocity, d.SoulMiteVec, 0.3)
            d.SoulMiteVec = d.SoulMiteVec*bal.TAcc
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
        end
    elseif d.State == "Stasis" then
        mod:spritePlay(sprite, "Sleeping")
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.4)

        if d.MySoul and not mod:superExists(d.MySoul) and npc.StateFrame > 120 then
            npc:Kill()
        end
    elseif d.State == "Ghosting" then
        if d.SubState == "Appear" then
            if sprite:IsFinished("GhostSpawn") then
                sprite:Play("Ghost", true)
            end

            if npc.StateFrame > bal.SWarn then
                d.SubState = "Move"
            end
            npc.Velocity = mod:Lerp(npc.Velocity, Vector(0, -1), 0.1)
        elseif d.SubState == "Move" then
            if npc.Position:Distance(d.TargetSoul.Position) < bal.SDist then
                d.SubState = "Enter"
            end
            mod:spritePlay(sprite, "Ghost")

            npc.FlipX = npc.Velocity.X > 0

            npc.Velocity = mod:Lerp(npc.Velocity, (d.TargetSoul.Position-npc.Position):Resized(bal.SSpeed), 0.2)
        elseif d.SubState == "Enter" then
            if sprite:IsFinished("GhostDisappear") then
                mod:GetEntityData(d.TargetSoul).State = "LeaveStasis"
                mod:GetEntityData(d.TargetSoul).CurrentSoul = (npc.Variant == d.TargetSoul.Variant and "Normal") or "Possessed"
                npc:Remove()
            else
                mod:spritePlay(sprite, "GhostDisappear")
            end
            npc.Velocity = mod:Lerp(npc.Velocity, (d.TargetSoul.Position-npc.Position)*0.2, 0.3)
        elseif d.SubState == "Fade" then
            if sprite:IsFinished("GhostDisappear") then
                npc:Remove()
            else
                mod:spritePlay(sprite, "GhostDisappear")
            end
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
        end

        if not mod:superExists(d.TargetSoul) then
            if mod:superExists(d.IsSoulmateGhost) and d.SubState ~= "Enter" then
                d.TargetSoul = d.IsSoulmateGhost
            end
        end

        if not mod:superExists(d.IsSoulmateGhost) then
            d.SubState = "Fade"
        end
    elseif d.State == "StartStasis" then
        if sprite:IsFinished("FallAsleep" .. d.CurrentSoul) then
            d.State = "Stasis"
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("SpawnGhost") then
            local ghost
            if d.CurrentSoul == "Normal" then
                ghost = Isaac.Spawn(npc.Type, npc.Variant, 0, npc.Position, Vector.Zero, npc):ToNPC()
            else
                ghost = Isaac.Spawn(npc.Type, mod.FF.Soulmate.Var, 0, npc.Position, Vector.Zero, npc):ToNPC()
            end
            ghost:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            ghost.Parent = npc
            mod:GetEntityData(ghost).IsSoulmateGhost = npc
            ghost.DepthOffset = 50
            mod:GetEntityData(ghost).TargetSoul = d.TargetSoul
            ghost:Update()
            d.MySoul = ghost
        else
            mod:spritePlay(sprite, "FallAsleep" .. d.CurrentSoul)
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    elseif d.State == "LeaveStasis" then
        if sprite:IsFinished("WakeUp" .. d.CurrentSoul) then
            d.State = "Idle" .. d.CurrentSoul
            npc.StateFrame = 0
            d.SoulmiteFrames = 0
            d.SubState = "Idle"
        else
            mod:spritePlay(sprite, "WakeUp" .. d.CurrentSoul)
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    end

    if searching and d.SoulmatePool and #d.SoulmatePool > 0 then
        local potentials = {}
        for _,guy in pairs(d.SoulmatePool) do
            if mod:superExists(guy) and guy.StateFrame > bal.Swap[1] and AreTheyDifferent(npc, guy) and mod:GetEntityData(guy).State == "Idle" .. mod:GetEntityData(guy).CurrentSoul then
                table.insert(potentials, guy)
            end
        end

        if #potentials > 0 then
            local chosen = potentials[rng:RandomInt(#potentials)+1]
            mod:GetEntityData(chosen).State = "StartStasis"
            mod:GetEntityData(chosen).TargetSoul = npc
            d.TargetSoul = chosen
            d.State = "StartStasis"
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player)
    for _,npc in ipairs(Isaac.FindByType(mod.FF.Soulmate.ID, mod.FF.Soulmate.Var, -1, false, false)) do
        if mod:GetEntityData(npc).IsSoulmateGhost then
            sfx:Play(SoundEffect.SOUND_DEMON_HIT, 0.75, 0, false, 1)
            local explosion = Isaac.Spawn(1000, 144, 1, npc.Position, Vector.Zero, player):ToEffect()
            explosion:Update()
            --explosion:SetColor(spoopColour1, 999, 999, false, false)
            npc:Remove()
        end
    end

    for _,npc in ipairs(Isaac.FindByType(mod.FF.Soulmite.ID, mod.FF.Soulmite.Var, -1, false, false)) do
        if mod:GetEntityData(npc).IsSoulmateGhost then
            sfx:Play(SoundEffect.SOUND_DEMON_HIT, 0.75, 0, false, 1)
            local explosion = Isaac.Spawn(1000, 144, 1, npc.Position, Vector.Zero, player):ToEffect()
            explosion:Update()
            --explosion:SetColor(spoopColour1, 999, 999, false, false)
            npc:Remove()
        end
    end
end, CollectibleType.COLLECTIBLE_VADE_RETRO)

function mod:SoulmateMiteOnHurt(npc, damage, flags, source)
    if flags ~= flags | DamageFlag.DAMAGE_CLONES then
        if mod:GetEntityData(npc).State == "Stasis" or mod:GetEntityData(npc).State == "Start" then
            npc:TakeDamage(damage/2, flags | DamageFlag.DAMAGE_CLONES, source, 0)
            return false
        end
    end
end