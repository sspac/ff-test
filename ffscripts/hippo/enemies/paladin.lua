local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    maxInvisTime = 100,

    teleportRange = 150,
    maxIdleTime = 200,
    idleSlashSpeed = 12,
    idleSlashRange = 130,

    chaseAccel = 0.1,
    maxChaseSpeed = 14,
    maxChaseTime = 300,
    chaseSlashSpeed = 16,
    chaseSlashRange = 130,
}

local function getFacing(npc,directionto,d)
    if math.abs(directionto.X) > math.abs(directionto.Y) then
        return Vector(mod.sign(directionto.X), 0)
    else
        return Vector(0, mod.sign(directionto.Y))
    end
end

local function prepareSwing(swingSpeed, range, npc, target, d)
    if d.chaseSpeed and d.chaseSpeed < 4 then
        return false
    end
    if npc.Position:Distance(target.Position) < range 
    and (mod.sign(target.Position.X-npc.Position.X) == d.facing.X or mod.sign(target.Position.Y-npc.Position.Y) == d.facing.Y) then
        local hasdistance = true
        if mod.sign(target.Position.X-npc.Position.X) == d.facing.X and math.abs(target.Position.Y-npc.Position.Y) > 40 then
            hasdistance = false
        elseif mod.sign(target.Position.Y-npc.Position.Y) == d.facing.Y and math.abs(target.Position.X-npc.Position.X) > 40 then
            hasdistance = false
        end
        if hasdistance then
            local vec = (target.Position-npc.Position):Resized(swingSpeed)
            npc.Velocity = vec
            d.facing = getFacing(npc,target.Position-npc.Position,d)
            d.slashvec = d.facing
            d.stateTimer = nil
            d.state = 4
            return true
        end
    end
end

function mod:PaladinAI(npc, sprite, d)
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()

    local confused = npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)
    local feared = npc:HasEntityFlags(EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK)

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        npc.SplatColor = mod.ColorGhostly
        d.facing = Vector(0,1)
        d.facingString = "Down"
        d.hasescaped = false
        d.init = true

        if d.waited then
            mod:SpritePlay(sprite, "Appear")
            d.state = 0
		elseif npc.SubType == 1 then
			mod:makeWaitFerr(npc, npc.Type, npc.Variant, npc.SubType, 60)
        else
            d.state = 0
        end
    end

    if not d.hasescaped and npc.FrameCount > 400 then
        d.hasescaped = true
    end

    if d.facing.X == 1 and d.facing.Y == 0 then
        d.facingString = "Right"
    elseif d.facing.X == -1 and d.facing.Y == 0 then
        d.facingString = "Left"
    elseif d.facing.X == 0 and d.facing.Y == -1 then
        d.facingString = "Up"
    else
        d.facingString = "Down"
    end

    if d.state == 0 then
        npc.CollisionDamage = 0
        if not sprite:IsPlaying("Appear") then
            mod:SpritePlay(sprite, "Vanish" .. d.facingString)
        end
        if sprite:IsFinished("Vanish" .. d.facingString) then
            d.stateTimer = nil
            d.state = 1
        end

        npc.Velocity = Vector.Zero

    -- INVISIBLE
    elseif d.state == 1 then
        npc.CollisionDamage = 0
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        if npc.FrameCount % 6 == 0 and mod:RandomInt(4) == 1 then
            d.pos = target.Position + RandomVector()*bal.teleportRange
            local times = 10
            local fireplace = mod:GetNearestThing(d.pos, 33, -1)
            while times > 0 and not (room:IsPositionInRoom(d.pos, 0) and room:GetGridCollisionAtPos(d.pos) <= 1 and not (fireplace and fireplace.Position:Distance(d.pos) < 40)) do
                d.pos = target.Position + RandomVector()*bal.teleportRange
                fireplace = mod:GetNearestThing(d.pos, 33, -1)
                times = times - 1
            end
            npc.Position = d.pos

            d.facing = getFacing(npc,target.Position-npc.Position,d)
            d.stateTimer = nil
            d.state = 2
        end

        d.stateTimer = d.stateTimer or bal.maxInvisTime
        if d.stateTimer <= 0 then
            d.stateTimer = nil
            d.state = 2
        end

        npc.Velocity = Vector.Zero

    -- APPEAR
    elseif d.state == 2 then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        mod:SpritePlay(sprite, "Appear" .. d.facingString)
        if sprite:IsFinished("Appear" .. d.facingString) then
            d.stateTimer = nil
            d.state = 3
        end
        npc.Visible = true
        npc.Velocity = Vector.Zero

    -- IDLE
    elseif d.state == 3 then
        mod:SpritePlay(sprite, "Idle" .. d.facingString)
        if sprite:IsFinished("Idle" .. d.facingString) then
            d.state = 3
        end
        npc.Velocity = npc.Velocity

        d.stateTimer = d.stateTimer or bal.maxIdleTime
        if d.stateTimer <= 0 then
            if not d.hasescaped and npc.HitPoints < npc.MaxHitPoints/2 then
                d.hasescaped = true
            end
            d.stateTimer = nil
            d.state = 0 
        elseif d.stateTimer < 185 then
            npc.CollisionDamage = 1

            if not (confused or feared) then
                prepareSwing(bal.idleSlashSpeed, bal.idleSlashRange, npc,target,d)

                if npc.FrameCount % 20 == 0 and mod:RandomInt(6) == 1 then
                    local readytorun = true
                    local paladins = Isaac.FindByType(mod.FF.Paladin.ID, mod.FF.Paladin.Var)
                    for i, entity in ipairs(paladins) do
                        if entity:GetData().state == 5 then
                            readytorun = false
                        end
                    end

                    if not mod:RoomClearExceptMe(npc) and mod:RandomInt(5) <= 3 then readytorun = false end
                    if readytorun and npc.Velocity:Length() < 0.3 then
                        d.stateTimer = nil
                        d.state = 5
                    end
                end
            end
        end

        if not d.hasescaped and npc.HitPoints < npc.MaxHitPoints/2 then
            d.hasescaped = true
            d.stateTimer = nil
            d.state = 0
        end

    -- SLASH
    elseif d.state == 4 then
        mod:SpritePlay(sprite, "Slash" .. d.facingString)
        if sprite:IsFinished("Slash" .. d.facingString) then
            d.stateTimer = nil
            d.state = 0
        end
        if sprite:IsEventTriggered("Slash") then
            npc:PlaySound(SoundEffect.SOUND_SHELLGAME, 0.7, 0, false, 0.8)
            npc:PlaySound(mod.Sounds.ShadowverseSlash1, 1.0, 0, false, 0.85 + math.random(15)*0.01)
            local slash = Isaac.Spawn(1000, mod.FF.PaladinSlash.Var, mod.FF.PaladinSlash.Sub, npc.Position+d.facing*30, Vector.Zero, npc):ToEffect()
            slash.Parent = npc
            slash:FollowParent(npc)
            slash:GetData().targetvec = d.slashvec
            d.slashvec = nil
        end
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.25)
    
    -- CHASE
    elseif d.state == 5 then
        mod:SpritePlay(sprite, "Idle" .. d.facingString)

        d.chaseSpeed = d.chaseSpeed or 1
        d.chaseSpeed = math.min(d.chaseSpeed + bal.chaseAccel, bal.maxChaseSpeed)
        
        npc.Velocity = mod:Lerp(npc.Velocity,(target.Position-npc.Position):Resized(d.chaseSpeed),0.05)
        d.facing = getFacing(npc,npc.Velocity,d)
        
        d.stateTimer = d.stateTimer or bal.maxChaseTime
        if d.stateTimer <= 0 then
            d.stateTimer = nil
            d.chaseSpeed = nil
            d.state = 0 
        end
        if prepareSwing(bal.chaseSlashSpeed, bal.chaseSlashRange, npc,target,d) then
            d.stateTimer = nil
            d.chaseSpeed = nil
        end
    end

    if npc:IsDead() then
        --[[if mod:RandomInt(1, 2, rng) == 1 then
            local pon = Isaac.Spawn(840, 0, 0, npc.Position, Vector.Zero, npc)
            pon:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            pon:GetSprite():Play("Hop", true)
            pon:GetSprite():SetFrame(12)
        else
            npc.SplatColor = Color(1,1,1,1)
            npc:BloodExplode()
        end]]

        npc.SplatColor = Color(1,1,1,1)
        npc:BloodExplode()
    end

    if d.stateTimer and d.stateTimer > 0 then d.stateTimer = d.stateTimer - 1 end
end

function mod:paladinHurt(npc, sprite, data, amount, flags, source, cooldown)
    if data.facing and mod:KnightDamageBlocking(npc, source, -data.facing, 110) then
        return false
    end
end

function mod:PaladinSlashEffect(effect)
    local d = effect:GetData()
    local sprite = effect:GetSprite()

    if effect.FrameCount == 1 then
        if d.targetvec then
            sprite.Rotation = d.targetvec:GetAngleDegrees()
        end
    end
    if sprite:IsEventTriggered("Slash") then
        for i, ent in ipairs(Isaac.FindInRadius(effect.Position, 50, EntityPartition.PLAYER | EntityPartition.ENEMY)) do
            if ent:ToPlayer() then
                ent:TakeDamage(1, 0, EntityRef(effect.Parent or effect), 1)
                ent.Velocity = d.targetvec*6
            end
            if ent:ToNPC() and not (ent.Type == mod.FF.Paladin.ID and ent.Variant == mod.FF.Paladin.Var) and not ent:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)  then
                ent:TakeDamage(12, 0, EntityRef(effect.Parent or effect), 1)
                ent.Velocity = d.targetvec*6
            end
        end
    end
    
    mod:SpritePlay(sprite, "SwordSlash")
    if sprite:IsFinished("SwordSlash") then
        effect:Remove()    
    end
end