local mod = FiendFolio
local game = Game()

--cannibalizing dirt digger and stub code yippeee

--Todo
--step sounds, charge, fire stuff

local bal = {
    Speed = 6.5,

    HealthThresh = 0.5,
    ESpeed = 6.6,

    MaxPosition = 13, --for parent following
    ChargeSpeed = 12,
    ChargeMinimum = 110,
    TurnPause = 13,
}

local function getNewTarget(npc, rng)
	local position = npc.Position
	local room = game:GetRoom()

	local i = 0
	repeat
		position = Isaac.GetFreeNearPosition(room:GetGridPosition(room:GetRandomTileIndex(rng:Next())), 40)
		i = i + 1
	until i >= 32 or (npc.Pathfinder:HasPathToPos(position, false) and position:Distance(npc.Position) >= 80)

	local failed = i >= 32
	if failed then
		position = npc.Position
	end

	return position, failed
end

function mod:writheAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()

    if not d.init then
        if npc.SubType & 1 == 1 then
            d.skipAhead = true
        end
        d.state = "Idle"

        d.movementMode = "Random"
        d.writheState = "Walk"

        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        sprite:Play("HeadLeft")
        if not d.dontMakePoofFake then
            npc.Visible = false
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            Isaac.Spawn(1000, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, npc)
        end
        if room:GetFrameCount() > 5 then
            d.setToGroundColl = true
        else
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end

        d.writheSpeed = bal.Speed

        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    mod.NegateKnockoutDrops(npc)

    if npc.FrameCount < 12 and d.state == "Idle" and not d.skipTheChecks then
        if npc.FrameCount > 2 then
            npc.Visible = true
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end

        npc.Velocity = Vector.Zero

        if npc.I1 == 0 and (npc.FrameCount > 1 or (d.skipAhead and npc.FrameCount > 0)) then
            if not npc.Child and not d.writheHead then
                d.writheHead = true

                local did
                local closest
                local totalCount = 1
                local curr = npc
                
                while curr do
                    local dist = room:GetFrameCount() > 5 and 100 or 50
                    for _, ent in pairs (Isaac.FindByType(npc.Type, npc.Variant, 0)) do --0 subtype so it doesn't grab the headeds
                        if ent.Position:Distance(curr.Position) < dist and ent:ToNPC().I1 == 0 and not mod:GetEntityData(ent).writheHead then
                            closest = ent
                            dist = closest.Position:Distance(npc.Position)
                        end
                    end
    
                    if closest then
                        did = true
    
                        curr.Child = closest
                        closest.Parent = curr
                        mod:GetEntityData(closest).ultraParent = npc
                        closest:ToNPC().I1 = curr:ToNPC().I1+1
                        curr = closest
                        totalCount = totalCount+1

                        if not d.playedHeadAnim then
                            local vec = npc.Position - closest.Position
                            if math.abs(vec.X) > math.abs(vec.Y) then
                                if vec.X > 0 then
                                    mod:spriteSetAnimation(sprite, d.writheState .. "HeadRight", false)
                                else
                                    mod:spriteSetAnimation(sprite, d.writheState .. "HeadLeft", false)
                                end
                            else
                                if vec.Y > 0 then
                                    mod:spriteSetAnimation(sprite, d.writheState .. "HeadDown", false)
                                else
                                    mod:spriteSetAnimation(sprite, d.writheState .. "HeadUp", false)
                                end
                            end
                            d.playedHeadAnim = true
                        end

                        closest = nil
                    else
                        did = nil
                    end
    
                    if not did then
                        local health = npc.MaxHitPoints*totalCount
                        npc.MaxHitPoints = health
                        npc.HitPoints = health
    
                        local man = npc
                        while man.Child and not mod:IsReallyDead(man.Child) do
                            man.Child.MaxHitPoints = health
                            man.Child.HitPoints = health
                            man = man.Child
                        end
    
                        curr = nil
                    end
                end
            end
        else
            mod:spritePlay(sprite, d.writheState .. "Body")
            --sprite.FlipX = npc.Velocity.X < 0

            if not d.randomFlipCosmetic then
                d.randomFlipCosmetic = true
                if rng:RandomInt(2) == 0 then
                    sprite.FlipX = true
                end
            end
        end
    elseif npc.I1 == 0 and not d.skipTheChecks then
        sprite.FlipX = false
        if d.setToGroundColl and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            d.setToGroundColl = false
        end

        if d.writheState == "Walk" and npc.HitPoints < npc.MaxHitPoints*bal.HealthThresh then
            d.state = "Enrage"
            d.writheState = "Rage"
            mod:adjustChildrenData(npc, "state", "Enrage")
            mod:adjustChildrenData(npc, "writheState", "Rage")
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                if npc.Velocity.X > 0 then
                    d.writheDir = "Right"
                else
                    d.writheDir = "Left"
                end
            else
                if npc.Velocity.Y > 0 then
                    d.writheDir = "Down"
                else
                    d.writheDir = "Up"
                end
            end
        end

        if sprite:IsEventTriggered("Step") then
            npc:PlaySound(SoundEffect.SOUND_POOPITEM_HOLD, 0.2, 0, false, mod:RandomInt(90,100,rng)/100)
        end

        if d.state == "Idle" then
            if room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
                if d.movementMode == "Random" then
                    d.targetpos = d.targetpos or getNewTarget(npc, rng)
                    if npc.Position:Distance(d.targetpos) < 10 or not npc.Pathfinder:HasPathToPos(d.targetpos, false) then
                        d.targetpos = getNewTarget(npc, rng)
                    end

                    mod.XalumGridPathfind(npc, d.targetpos, d.writheSpeed)
                end
            else
                local gridPosition = mod.XalumAlignPositionToGrid(npc.Position)
                local targetVelocity = (npc.Position - gridPosition):Resized(d.writheSpeed)

                npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity, 0.3)
            end

            local dir
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                if npc.Velocity.X > 0 then
                    mod:spriteSetAnimation(sprite, d.writheState .. "HeadRight", false)
                    dir = "Right"
                else
                    mod:spriteSetAnimation(sprite, d.writheState .. "HeadLeft", false)
                    dir = "Left"
                end
            else
                if npc.Velocity.Y > 0 then
                    mod:spriteSetAnimation(sprite, d.writheState .. "HeadDown", false)
                    dir = "Down"
                else
                    mod:spriteSetAnimation(sprite, d.writheState .. "HeadUp", false)
                    dir = "Up"
                end
            end

            if d.writheState == "Rage" then
                if npc.StateFrame > bal.ChargeMinimum and ((((dir == "Right" and target.Position.X > npc.Position.X) or (dir == "Left" and target.Position.X < npc.Position.X)) and (math.abs(npc.Position.Y-target.Position.Y) < 40)) or
                (((dir == "Up" and target.Position.Y < npc.Position.Y) or (dir == "Down" and target.Position.Y > npc.Position.Y)) and (math.abs(npc.Position.X-target.Position.X) < 40)))
                and room:CheckLine(npc.Position, target.Position, 0, 0, false, false) and not mod:isScareOrConfuse(npc) then
                    d.state = "Charge"
                    local angle = math.floor((mod:GetAngleDegreesButGood(target.Position-npc.Position)+45)/90)
                    d.chargeDir = Vector(bal.ChargeSpeed,0):Rotated(90*angle)
                    npc.StateFrame = 0

                    npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_3, 1, 0, false, mod:RandomInt(120,130,rng)/100)
                end
            end
        elseif d.state == "Charge" then
            if npc:CollidesWithGrid() then
                d.state = "Idle"
                npc.StateFrame = 0
                d.chargeTurn = nil
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.6, 0, false, mod:RandomInt(120,130,rng)/100)

                if d.chargeTurning and not d.chargeTurned then
                    mod:adjustChildrenData(npc, "state", "Idle")
                end
                d.chargeTurning = nil
                d.chargeTurned = nil
            else
                if not d.chargeTurn then
                    local passedBy
                    if npc.StateFrame > 10 then
                        if math.abs(d.chargeDir.X) > math.abs(d.chargeDir.Y) then
                            if math.abs(target.Position.X-npc.Position.X) < 40 and math.abs(target.Position.Y-npc.Position.Y) > 40 then
                                passedBy = true
                            end
                        else
                            if math.abs(target.Position.Y-npc.Position.Y) < 40 and math.abs(target.Position.X-npc.Position.X) > 40 then
                                passedBy = true
                            end
                        end
                    end
                    if passedBy then
                        npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, 0.6, 0, false, mod:RandomInt(120,130,rng)/100)
                        d.chargeTurn = true
                        mod:adjustChildrenData(npc, "state", "Pause")
                        d.chargeTurning = bal.TurnPause
                        local angle = math.floor((mod:GetAngleDegreesButGood(target.Position-npc.Position)+45)/90)
                        d.chargeDir = Vector(bal.ChargeSpeed,0):Rotated(90*angle)
                    end
                    npc.Velocity = mod:Lerp(npc.Velocity, d.chargeDir:Resized(bal.ChargeSpeed), 0.3)
                elseif d.chargeTurning then
                    if d.chargeTurning > 0 then
                        d.chargeTurning = d.chargeTurning-1
                        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.5)
                    else
                        mod:adjustChildrenData(npc, "state", "Idle")
                        d.chargeTurned = true
                        d.chargeTurning = nil
                    end
                else
                    npc.Velocity = mod:Lerp(npc.Velocity, d.chargeDir:Resized(bal.ChargeSpeed), 0.3)
                end

                
            end

            local word = (d.chargeTurning and "Idle") or "Head"
            local suffix
            if not d.chargeTurning then
                if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                    if npc.Velocity.X > 0 then
                        suffix = "Right"
                    else
                        suffix = "Left"
                    end
                else
                    if npc.Velocity.Y > 0 then
                        suffix = "Down"
                    else
                        suffix = "Up"
                    end
                end
            else
                if math.abs(d.chargeDir.X) > math.abs(d.chargeDir.Y) then
                    if d.chargeDir.X > 0 then
                        suffix = "Right"
                    else
                        suffix = "Left"
                    end
                else
                    if d.chargeDir.Y > 0 then
                        suffix = "Down"
                    else
                        suffix = "Up"
                    end
                end
            end
            mod:spritePlay(sprite, "Rage" .. word .. suffix)
        elseif d.state == "Enrage" then
            if sprite:IsFinished("RageStart" .. d.writheDir) then
                d.state = "Idle"
                mod:adjustChildrenData(npc, "state", "Idle")
                npc.StateFrame = 0
                d.writheSpeed = bal.ESpeed
                sprite:Play("RageHead" .. d.writheDir, true)
            elseif sprite:IsEventTriggered("Sound") then
                local man = npc
                local continue = true
                while continue do
                    man.SplatColor = mod.ColorFireyFade
                    if man.Child and not mod:IsReallyDead(man.Child) then
                        man = man.Child
                    else
                        continue = false
                    end
                end
                npc:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_3, 1, 0, false, 1.2)
                npc:PlaySound(SoundEffect.SOUND_FLAMETHROWER_START, 1, 0, false, 1)
            else
                mod:spritePlay(sprite, "RageStart" .. d.writheDir)
            end

            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        end

        if npc.Child and not npc.Child:Exists() then
            npc:Kill()
        end
    elseif npc.FrameCount > 0 then
        if not d.randomFlipCosmetic then
            d.randomFlipCosmetic = true
            if rng:RandomInt(2) == 0 then
                sprite.FlipX = true
            end
        end
        if npc.Parent and not mod:IsReallyDead(npc.Parent) then
            if d.setToGroundColl and npc.Position:Distance(npc.Parent.Position) <= 25 then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                d.setToGroundColl = false
            end

            if not d.followParentInfoWrithe then
                d.followParentInfoWrithe = {parent = npc.Parent}
            end

            local par = npc.Parent:ToNPC()
            local pd = mod:GetEntityData(par)
            npc.DepthOffset = par.DepthOffset-2
            if d.state == "Idle" then
                mod:spritePlay(sprite, d.writheState .. "Body")
            elseif d.state == "Enrage" then
                mod:spritePlay(sprite, "RageStartBody")
            end


            if mod:IsReallyDead(npc.Parent) then
                npc:Kill()
            end

            if not npc.Child then
                
            end
        else
            npc:Kill()
        end

        if mod:IsReallyDead(npc) then
            local man = mod:GetEntityData(npc).ultraParent
            if not mod:GetEntityData(npc).ultraParent then
                man = npc
                while man.Parent do
                    man = man.Parent
                end
                man:Kill()
            else
                man:Kill()
            end
        end
    end
end

function mod:writheColl(npc, coll, bool)
    if coll.Type == mod.FF.Writhe.ID and coll.Variant == mod.FF.Writhe.Var then
        return true
    elseif coll.Type == 33 or (coll.Type == 818 and coll.Variant == 2) then
        local d = mod:GetEntityData(npc)
        if npc.Parent then
            if d.ultraParent and mod:superExists(d.ultraParent) and mod:GetEntityData(d.ultraParent).writheState == "Walk" then
                npc = d.ultraParent
                d = mod:GetEntityData(d.ultraParent)
                d.state = "Enrage"
                d.writheState = "Rage"
                mod:adjustChildrenData(npc, "state", "Enrage")
                mod:adjustChildrenData(npc, "writheState", "Rage")
                if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                    if npc.Velocity.X > 0 then
                        d.writheDir = "Right"
                    else
                        d.writheDir = "Left"
                    end
                else
                    if npc.Velocity.Y > 0 then
                        d.writheDir = "Down"
                    else
                        d.writheDir = "Up"
                    end
                end
            end
        elseif d.writheState == "Walk" then
            d.state = "Enrage"
            d.writheState = "Rage"
            mod:adjustChildrenData(npc, "state", "Enrage")
            mod:adjustChildrenData(npc, "writheState", "Rage")
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                if npc.Velocity.X > 0 then
                    d.writheDir = "Right"
                else
                    d.writheDir = "Left"
                end
            else
                if npc.Velocity.Y > 0 then
                    d.writheDir = "Down"
                else
                    d.writheDir = "Up"
                end
            end
        end
    elseif mod:IsInMinecart(coll) then
        return true
    end
end

function mod:writheHurt(npc, damage, flag, source)
    if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type ~= 1 then
        local d = mod:GetEntityData(npc)
		if npc.Parent then
            if d.ultraParent and mod:superExists(d.ultraParent) and mod:GetEntityData(d.ultraParent).writheState == "Walk" then
                npc = d.ultraParent
                d = mod:GetEntityData(d.ultraParent)
                d.state = "Enrage"
                d.writheState = "Rage"
                mod:adjustChildrenData(npc, "state", "Enrage")
                mod:adjustChildrenData(npc, "writheState", "Rage")
                if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                    if npc.Velocity.X > 0 then
                        d.writheDir = "Right"
                    else
                        d.writheDir = "Left"
                    end
                else
                    if npc.Velocity.Y > 0 then
                        d.writheDir = "Down"
                    else
                        d.writheDir = "Up"
                    end
                end
            end
        elseif d.writheState == "Walk" then
            d.state = "Enrage"
            d.writheState = "Rage"
            mod:adjustChildrenData(npc, "state", "Enrage")
            mod:adjustChildrenData(npc, "writheState", "Rage")
            if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
                if npc.Velocity.X > 0 then
                    d.writheDir = "Right"
                else
                    d.writheDir = "Left"
                end
            else
                if npc.Velocity.Y > 0 then
                    d.writheDir = "Down"
                else
                    d.writheDir = "Up"
                end
            end
        end
    end
    if flag ~= flag | DamageFlag.DAMAGE_CLONES then
        if mod:GetEntityData(npc).writheHead then
            local man = npc
            while man.Child and not mod:IsReallyDead(man.Child) do
                man.Child:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
                man = man.Child
            end
        else
            local man = mod:GetEntityData(npc).ultraParent
            if not mod:GetEntityData(npc).ultraParent then
                man = npc
                while man.Parent do
                    man = man.Parent
                end
                man:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
                while man.Child and not mod:IsReallyDead(man.Child) do
                    if man.Child.InitSeed ~= npc.InitSeed then
                        man.Child:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
                    end
                    man = man.Child
                end
            else
                man:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
                while man.Child and not mod:IsReallyDead(man.Child) do
                    if man.Child.InitSeed ~= npc.InitSeed then
                        man.Child:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, EntityRef(npc), 0)
                    end
                    man = man.Child
                end
            end
        end
    end
end

function mod:writheRender(npc)
    local d = mod:GetEntityData(npc)

    if d.followParentInfoWrithe then
		local tab = d.followParentInfoWrithe
		if mod:IsNormalRender(false) then
			if not tab.init then
				tab.init = true
				tab.recordParent = {}
			end
			tab.parent = tab.parent or npc.Parent
			
			if tab.parent and tab.parent:Exists() then
                if d.state == "Idle" then
                    local head = d.ultraParent
                    local hd = mod:GetEntityData(head)
                    if head and not mod:IsReallyDead(head) then
                        if hd.state == "Charge" then
                            table.insert(tab.recordParent, {position = npc.Parent.Position, velocity = npc.Parent.Velocity, state = hd.state})
                            table.remove(tab.recordParent, 1)
                            
                            if not npc.Child and npc.StateFrame % 3 == 0 and not d.LeftFire then
                                local rng = npc:GetDropRNG()
                                d.LeftFire = true
                                local fire = Isaac.Spawn(33, 10, 0, npc.Position+mod:shuntedPosition(15, rng), Vector.Zero, npc):ToNPC()
                                fire.HitPoints = fire.HitPoints*(mod:RandomInt(25,48,rng)/100)
                                mod:GetEntityData(fire).MovableFireTimeout = 66
                                fire:Update()
                            elseif npc.StateFrame % 3 ~= 0 then
                                d.LeftFire = nil
                            end
                        end

                        table.insert(tab.recordParent, {position = tab.parent.Position, velocity = tab.parent.Velocity, state = hd.state})
                        if #tab.recordParent > bal.MaxPosition then
                            table.remove(tab.recordParent, 1)
                        end

                        local entry = tab.recordParent[1]
                        if npc.FrameCount < 25 then
                            npc.Velocity = mod:Lerp(npc.Velocity, (entry.position-npc.Position):Resized(bal.Speed), 0.4)
                        elseif entry.state == "Charge" and hd.state ~= "Charge" then
                            npc.Velocity = mod:Lerp(npc.Velocity, (entry.position-npc.Position):Resized(bal.Speed), 0.3)
                        else
                            npc.Velocity = (entry.position-npc.Position)
                        end
                    end
                else
                    local entry = tab.recordParent[1]
                    local pos = entry.position or npc.Position
                    npc.Velocity = (pos-npc.Position)
                end
			else
				d.followParentInfoWrithe = nil
				d.followParentStopped = true
			end
		end
	end
end