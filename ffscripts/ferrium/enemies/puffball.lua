local mod = FiendFolio
local game = Game()

local sporeLog = {
    puffCooldown = 10, --how long before it can puff following an attack
    playerDistance = 70, --how close the player has to be for it to try to puff

    puffRadius = 60, --how big is its radius for puffing
    puffForcePlayer = 15, --how hard will it hit players
    puffForceEnemy = 50, --how hard it hits enemies
    puffForceTear = 10, --how hard will it push tears
    puffForceProj = 15, --how hard will it push projectiles

    bidingAddition = 4, --how much time getting hit adds to biding period
    bidingInitial = 50, --how long it bides originally
    damageReduction = 0.6, --how much damage it takes from shots while biding
    bidingMax = 90, --how long it can be forced to bide for
    bidingSmall = 12, -- how long it waits when doing a quick fart
}

function mod:puffballAI(npc)
    local data = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()

    local projSearch

    if not data.init then
        data.state = "Idle"
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        data.initPos = npc.Position
        data.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if not data.isSpecturned then
		if not data.initPos then
			data.initPos = npc.Position
		end
		npc.Velocity = data.initPos-npc.Position
	else
		data.initPos = nil
	end

    if data.state == "Idle" then
        if npc.StateFrame > sporeLog.puffCooldown then
            projSearch = true
            if target.Position:Distance(npc.Position) < sporeLog.playerDistance and not mod:isScareOrConfuse(npc) then
                data.state = "Biding"
                npc:PlaySound(SoundEffect.SOUND_BABY_HURT, 0.8, 0, false, mod:getRoll(110,120,rng)/100)
                data.bidingSmall = true
                npc.StateFrame = 0
            end
        end

        mod:spritePlay(sprite, "Idle")
    elseif data.state == "Biding" then
        projSearch = true
        if data.bidingSmall then
            if npc.StateFrame > sporeLog.bidingSmall then
                data.state = "Puffing"
                data.bidingSmall = nil
            end
            mod:spritePlay(sprite, "Rumble")
        else
            if npc.StateFrame > (data.currentPuffCap or sporeLog.bidingInitial) then
                data.state = "Puffing"
            end

            mod:spritePlay(sprite, "Biding")
        end
    elseif data.state == "Puffing" then
        if sprite:IsFinished("Puff") then
            data.state = "Idle"
            npc.StateFrame = 0
            data.puffballPUFFEDGOGOGO = nil
        elseif sprite:IsEventTriggered("Puff") then
            data.puffballPUFFEDGOGOGO = true
            if mod:isCharm(npc) then
                game:Fart(npc.Position, sporeLog.puffRadius, npc, 1.25, 0)
            else
                game:Fart(npc.Position, 0, npc, 1.25, 0)
            end
            game:ButterBeanFart(npc.Position, sporeLog.puffRadius, npc, false, false)
            mod:FakeFart(npc, npc.Position, sporeLog.puffRadius)
            for _,ent in ipairs(Isaac.FindInRadius(npc.Position, sporeLog.puffRadius, EntityPartition.BULLET)) do
                ent.Velocity = mod:Lerp(ent.Velocity, (ent.Position-npc.Position):Resized(sporeLog.puffForceProj), 0.7)
            end
            for _,ent in ipairs(Isaac.FindInRadius(npc.Position, sporeLog.puffRadius, EntityPartition.TEAR)) do
                ent.Velocity = mod:Lerp(ent.Velocity, (ent.Position-npc.Position):Resized(sporeLog.puffForceTear), 0.7)
            end
        else
            mod:spritePlay(sprite, "Puff")
        end
    elseif data.state == "Death" then
        if sprite:IsFinished("Death") then
            game:Fart(npc.Position, 0, npc, 1, 0)
            npc:Kill()
        else
            mod:spritePlay(sprite, "Death")
        end
    end

    if not mod.IsActiveRoom() then
        data.state = "Death"
    end

    if projSearch then
        for _,proj in ipairs(Isaac.FindInRadius(npc.Position, 80, EntityPartition.BULLET)) do
            local pd = mod:GetEntityData(proj)
            proj = proj:ToProjectile()
            if not (pd.puffballIgnoreProjColl or pd.continuepuffballIgnoreProjColl == npc.InitSeed) and not proj:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) then
                if proj.Position:DistanceSquared(npc.Position) <= (npc.Size + proj.Size) ^ 2 then
                    if data.state == "Biding" then
                        if not data.bidingSmall then
                            data.currentPuffCap = math.min(data.currentPuffCap+sporeLog.bidingAddition, sporeLog.bidingMax)
                        end
                    else
                        data.state = "Biding"
                        npc.StateFrame = 0
                        data.currentPuffCap = sporeLog.bidingInitial
                        npc:PlaySound(SoundEffect.SOUND_BABY_HURT, 0.8, 0, false, mod:getRoll(110,120,rng)/100)
                    end
                    pd.puffballIgnoreProjColl = {npc = npc, pos = proj.Position}
                    proj.FallingSpeed = 0
                    proj.FallingAccel = -0.11
                    proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                end
            end
        end
    end
end

--[[function mod:puffballColl(npc, coll, low)
    local data = mod:GetEntityData(npc)
    if mod:GetEntityData(coll).puffballIgnoreProjColl then
        return true
    elseif data.state == "Biding" or (data.state == "Idle" and npc.StateFrame > sporeLog.puffCooldown) then
        if coll.Type == 2 and coll:ToTear() then
            local tear = coll:ToTear()
            npc:TakeDamage(tear.CollisionDamage*sporeLog.damageReduction, 0, EntityRef(tear), 0)
            mod:GetEntityData(tear).puffballIgnoreProjColl = {npc = npc, pos = tear.Position}
            tear.FallingSpeed = 0
            tear.FallingAcceleration = -0.13
            tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            return true
        elseif coll.Type == 9 and coll:ToProjectile() then
            local proj = coll:ToProjectile()
            if proj:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) then
                npc:TakeDamage(proj.CollisionDamage*sporeLog.damageReduction, 0, EntityRef(proj), 0)
            end
            mod:GetEntityData(proj).puffballIgnoreProjColl = {npc = npc, pos = proj.Position}
            proj.FallingSpeed = 0
            proj.FallingAccel = -0.13
            proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            return true
        end
    end
end]]

function mod:puffballProjColl(proj, coll, low) --oh ok this doesn't work in majority of cases hmm.
    if coll and coll:ToNPC() then
        local npc = coll:ToNPC()
        if npc.Type == mod.FF.Puffball.ID and npc.Variant == mod.FF.Puffball.Var then
            local data = mod:GetEntityData(npc)
            local pd = mod:GetEntityData(proj)
            if pd.puffballIgnoreProjColl or pd.continuepuffballIgnoreProjColl == npc.InitSeed then
                return true
            elseif data.state == "Biding" or (data.state == "Idle" and npc.StateFrame > sporeLog.puffCooldown) then
                if proj:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) then
                    npc:TakeDamage(proj.CollisionDamage*sporeLog.damageReduction, 0, EntityRef(proj), 0)
                end
                if data.state == "Biding" then
                    if not data.bidingSmall then
                        data.currentPuffCap = math.min(data.currentPuffCap+sporeLog.bidingAddition, sporeLog.bidingMax)
                    end
                else
                    data.state = "Biding"
                    npc.StateFrame = 0
                    data.currentPuffCap = sporeLog.bidingInitial
                    local rng = npc:GetDropRNG()
                    npc:PlaySound(SoundEffect.SOUND_BABY_HURT, 0.8, 0, false, mod:getRoll(110,120,rng)/100)
                end
                pd.puffballIgnoreProjColl = {npc = npc, pos = proj.Position}
                proj.FallingSpeed = 0
                proj.FallingAccel = -0.11
                proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                return true
            end
        end
    end
end

function mod:puffballTearColl(tear, coll, low)
    if coll and coll:ToNPC() then
        local npc = coll:ToNPC()
        if npc.Type == mod.FF.Puffball.ID and npc.Variant == mod.FF.Puffball.Var then
            local data = mod:GetEntityData(npc)
            local td = mod:GetEntityData(tear)
            if td.puffballIgnoreProjColl or td.continuepuffballIgnoreProjColl == npc.InitSeed then
                return true
            elseif data.state == "Biding" or (data.state == "Idle" and npc.StateFrame > sporeLog.puffCooldown) then
                npc:TakeDamage(tear.CollisionDamage*sporeLog.damageReduction, 0, EntityRef(tear), 0)
                if data.state == "Biding" then
                    if not data.bidingSmall then
                        data.currentPuffCap = math.min(data.currentPuffCap+sporeLog.bidingAddition, sporeLog.bidingMax)
                    end
                else
                    data.state = "Biding"
                    npc.StateFrame = 0
                    data.currentPuffCap = sporeLog.bidingInitial
                    local rng = npc:GetDropRNG()
                    npc:PlaySound(SoundEffect.SOUND_BABY_HURT, 0.8, 0, false, mod:getRoll(110,120,rng)/100)
                end
                td.puffballIgnoreProjColl = {npc = npc, pos = tear.Position}
                tear.FallingSpeed = 0
                tear.FallingAcceleration = -0.11
                tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                return true
            end
        end
    end
end

function mod:puffballTearUpdate(v, d)
    if d.puffballIgnoreProjColl then
        local entry = d.puffballIgnoreProjColl
        v.FallingSpeed = 0
        v.FallingAcceleration = -0.11

        v.Velocity = (entry.pos-v.Position)
        
        if not entry.npc or not mod:superExists(entry.npc) then
            d.puffballIgnoreProjColl = nil
            v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            v.FallingAcceleration = 1.5
        elseif entry.npc and entry.npc:ToNPC() then
            local npc = entry.npc:ToNPC()
            local data = mod:GetEntityData(npc)
            if data.puffballPUFFEDGOGOGO then
                v.Velocity = (v.Position-npc.Position):Resized(sporeLog.puffForceProj)
                v.FallingAcceleration = -0.07
                d.puffballIgnoreProjColl = nil
                d.continuepuffballIgnoreProjColl = entry.npc.InitSeed or 0
                v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
        end
    end
end

function mod:puffballProj(v, d)
    if d.puffballIgnoreProjColl then
        local entry = d.puffballIgnoreProjColl
        v.FallingSpeed = 0
        v.FallingAccel = -0.11

        v.Velocity = (entry.pos-v.Position)
        
        if not entry.npc or not mod:superExists(entry.npc) then
            d.puffballIgnoreProjColl = nil
            v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            v.FallingAccel = 1.5
        elseif entry.npc and entry.npc:ToNPC() then
            local npc = entry.npc:ToNPC()
            local data = mod:GetEntityData(npc)
            if data.puffballPUFFEDGOGOGO then
                v.Velocity = (v.Position-npc.Position):Resized(sporeLog.puffForceProj)
                v.FallingAccel = -0.07
                d.puffballIgnoreProjColl = nil
                d.continuepuffballIgnoreProjColl = entry.npc.InitSeed or 0
                v.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
        end
    end
end