local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local color = Color(1,1,1,1,0,0,0)
color:SetColorize(6,1,1,1)

local bal = {
    HurtCooldown = 48, --Time it takes for her to retaliate again
    HurtProjNum = 4, --Number of gravity projectiles she fires, not counting the big one!
    HurtScale = {2,9},
    HurtScale2 = 2,
    HurtSpeed = {75,150},
    HurtAngle = 40,
    HurtAccel = 0.3, --How fast the projectile accels down
    HurtSpeedCap = 12, --How fast it can be moving before it stops acceling
    SplitSpeed = 10,

    DyingTime = 42, --Time spent spraying in Death anim
    DeathFreq = 2,
    DeathSpeed = {170,200},
    DeathAngle = 70,
    DeathAngle2 = 40,
    DeathOffset = 180,
    DeathNum = {2, 3, 3}, --Min, Max, chance

    SocialDistance = 60, --How far away other Laids have to be from the potential emerge point.
    DamageReduction = 0.5, --Takes less damage when it can't retaliate (Appear/Disappear)

    IdleTime = {40, 90, 30}, --Min, max, chance
    HidleTime = {30, 55, 25},
    HideDelay = -30, --Extra delay when hidden on room start

    BackupLength = 80, --Backup hitbox size in case repentogon isn't installed
    BackupClench = 60,
}

local dirToAngle = {
    ["Up"] = 0,
    ["Right"] = 90,
    ["Down"] = 180,
    ["Left"] = 270,
}

function mod:laideronnetteAI(npc)
    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    local d = mod:GetEntityData(npc)
    local rng = npc:GetDropRNG()
    local targetpos = mod:confusePos(npc, target.Position)

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        --npc.Visible = false
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        if d.Deaded then
            d.State = "Death1"

            if REPENTOGON then
                if not d.Hitbox then
                    d.Hitbox = Isaac.Spawn(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var, 0, npc.Position, npc.Velocity, npc)
                    local hData = mod:GetEntityData(d.Hitbox)
                    if npc.SpriteRotation % 180 == 0 then
                        d.HitboxOrient = "Height"
                    else
                        d.HitboxOrient = "Width"
                    end
                    hData.Relay = true
                    hData.FixToSpawner = true
                    d.Hitbox.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    d.Hitbox.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                    d.Hitbox.CollisionDamage = 0
                end
                d.Lengthen = nil
            else
                if not d.Hitbox then
                    d.Hitbox = Isaac.Spawn(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var, 0, npc.Position, npc.Velocity, npc)
                    local hData = mod:GetEntityData(d.Hitbox)
                    if npc.SpriteRotation == 0 or npc.SpriteRotation == 180 then
                        hData.Height = bal.BackupLength
                    else
                        hData.Width = bal.BackupLength
                    end
                    hData.Relay = true
                    hData.FixToSpawner = true
                    d.Hitbox.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    d.Hitbox.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                    d.Hitbox.CollisionDamage = 0
                end

                mod:GetEntityData(d.Hitbox).PositionOffset = Vector(0,bal.BackupLength):Rotated(npc.SpriteRotation+180)
            end
        else
            local wallPos = mod:GetClosestWallPos(npc.Position)
            local ang = dirToAngle[mod:GetMoveString(npc.Position - wallPos)]
            npc.SpriteRotation = ang
            npc.Position = wallPos
            d.StayHere = wallPos

            if npc.SubType > 0 then
                d.State = "Hidden"
                npc.Visible = false
                npc.StateFrame = bal.HideDelay
            else
                d.State = "Appear"
                sprite:Play("Clench")
            end
            
            local check = Isaac.Spawn(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var, 0, npc.Position, npc.Velocity, npc)
            check.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            check:Update()
            if not check or not check:Exists() then
                npc:Remove()
            else
                check:Remove()
            end
        end

        d.LaidCooldown = 0

        d.init  = true
    else
        if d.LaidCooldown > 0 then
            d.LaidCooldown=d.LaidCooldown-1
        end
        npc.StateFrame = npc.StateFrame+1
    end

    if d.State == "Idle" then
        if npc.StateFrame > bal.IdleTime[1] and rng:RandomInt(bal.IdleTime[3]) == 0 then
            d.State = "Unclench"
        elseif npc.StateFrame > bal.IdleTime[2] then
            d.State = "Unclench"
        end

        if not d.Hitbox:Exists() then
            npc:Remove()
        end

        mod:spritePlay(sprite, "Idle")
        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Hidden" then
        local check
        if npc.StateFrame > bal.HidleTime[1] and rng:RandomInt(bal.HidleTime[3]) == 0 then
            check = true
        elseif npc.StateFrame > bal.HidleTime[2] then
            check = true
        end

        if check then
            local pos = targetpos
            local wallPos = mod:GetClosestWallPos(pos)
            local crowded
            for _,laid in ipairs(Isaac.FindByType(mod.FF.Laideronnette.ID, mod.FF.Laideronnette.Var, -1, false, false)) do
                if mod:GetEntityData(laid).State ~= "Hidden" and laid.Position:Distance(wallPos) < bal.SocialDistance then
                    crowded = true
                    npc.StateFrame = npc.StateFrame-mod:RandomInt(5,10,rng)
                    break
                end
            end

            if not crowded then
                local ang = dirToAngle[mod:GetMoveString(pos - wallPos)]
                npc.SpriteRotation = ang
                npc.Position = wallPos
                d.StayHere = wallPos
                d.State = "Surface"
                sprite:Play("Surface", true)
                npc.Visible = true
            end
        end
    elseif d.State == "Hurt" then
        if sprite:IsFinished(d.LaidAnim) then
            d.State = "Idle"
        else
            mod:spritePlay(sprite, d.LaidAnim)
        end

        if not d.Hitbox:Exists() then
            npc:Remove()
        end

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Clench" then
        local updateHit
        if sprite:IsFinished("Clench") then
            d.State = "Idle"
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("Transition") and not REPENTOGON then
            updateHit = bal.BackupClench
        elseif sprite:IsEventTriggered("Transition2") and not REPENTOGON then
            updateHit = bal.BackupLength
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, mod:RandomInt(90, 110, rng)/100)
        else
            mod:spritePlay(sprite, "Clench")
        end

        if updateHit and d.Hitbox and mod:superExists(d.Hitbox) then
            local hd = mod:GetEntityData(d.Hitbox)
            if d.HitboxOrient == "Height" then
                hd.Height = updateHit
            else
                hd.Width = updateHit
            end
            hd.PositionOffset = Vector(0,updateHit/2):Rotated(npc.SpriteRotation+180)
        end

        if not d.Hitbox:Exists() then
            npc:Remove()
        end

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Unclench" then
        if sprite:IsFinished("Unclench") then
            d.State = "Hide"
            npc.StateFrame = 0
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, mod:RandomInt(90, 110, rng)/100)
        else
            mod:spritePlay(sprite, "Unclench")
        end

        if not d.Hitbox:Exists() then
            npc:Remove()
        end

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Hide" then
        if sprite:IsFinished("Sink") then
            d.State = "Hidden"
            npc.Visible = false
        elseif sprite:IsEventTriggered("Transition") then
            --d.hiding = 2
            if d.Hitbox then
                d.Hitbox:Remove()
            end
            d.Hitbox = nil
            d.PreviousHitboxSize = nil
        else
            mod:spritePlay(sprite, "Sink")
        end

        --[[if d.hiding and not REPENTOGON then
            mod:GetEntityData(d.Hitbox).PositionOffset = Vector(0,bal.BackupLength/2):Rotated(npc.SpriteRotation+180)*d.hiding

            if d.hiding > 0 then
                d.hiding = d.hiding-1
            else
                d.hiding = nil
                d.Hitbox:Remove()
                d.Hitbox = nil
                d.PreviousHitboxSize = nil
            end
        end]]

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Rise" then
        if sprite:IsFinished("Rise") then
            d.State = "Clench"
        elseif sprite:IsEventTriggered("Transition") then
            d.Lengthen = 0
        elseif sprite:IsEventTriggered("Sound") then
            --npc:PlaySound(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 1, 0, false, 1)
            npc:PlaySound(SoundEffect.SOUND_SHELLGAME, 0.6, 0, false, mod:RandomInt(82,90,rng)/100)
        else
            mod:spritePlay(sprite, "Rise")
        end

        if d.Lengthen then
            if REPENTOGON then
                if not d.Hitbox then
                    d.Hitbox = Isaac.Spawn(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var, 0, npc.Position, npc.Velocity, npc)
                    local hData = mod:GetEntityData(d.Hitbox)
                    if npc.SpriteRotation % 180 == 0 then
                        d.HitboxOrient = "Height"
                    else
                        d.HitboxOrient = "Width"
                    end
                    hData.Relay = true
                    hData.FixToSpawner = true
                    d.Hitbox.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    d.Hitbox.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                    d.Hitbox.CollisionDamage = 1
                end
                d.Lengthen = nil
            else
                if not d.Hitbox then
                    d.Hitbox = Isaac.Spawn(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var, 0, npc.Position, npc.Velocity, npc)
                    local hData = mod:GetEntityData(d.Hitbox)
                    --hData.Rotation = npc.SpriteRotation
                    if npc.SpriteRotation == 0 or npc.SpriteRotation == 180 then
                        hData.Height = bal.BackupLength
                    else
                        hData.Width = bal.BackupLength
                    end
                    hData.Relay = true
                    hData.FixToSpawner = true
                    d.Hitbox.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                    d.Hitbox.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                    d.Hitbox.CollisionDamage = 1
                end

                mod:GetEntityData(d.Hitbox).PositionOffset = Vector(0,bal.BackupLength/2):Rotated(npc.SpriteRotation+180)*d.Lengthen

                if d.Lengthen < 2 then
                    d.Lengthen = d.Lengthen+1
                else
                    d.Lengthen = nil
                end
            end
            if not d.Hitbox:Exists() then
                npc:Remove()
            end
        end

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Appear" then
        if sprite:IsFinished("Appear") then
            d.State = "Rise"
        else
            mod:spritePlay(sprite, "Appear")
        end

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Surface" then
        if sprite:IsFinished("Surface") then
            d.State = "Appear"
        else
            mod:spritePlay(sprite, "Surface")
        end

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Death1" then
        if sprite:IsFinished("Death1") then
            d.State = "Death2"
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(mod.Sounds.LaideronnetteDeath, 1, 0, false, 1)
            --npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 0, false, mod:RandomInt(90,110,rng)/100)
            d.LaidSpray = true
            npc.StateFrame = 0

            local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 5, npc.Position+Vector(0,bal.DeathOffset):Rotated(npc.SpriteRotation+180), Vector.Zero, npc):ToEffect()
            poof.SpriteScale = Vector(0.5, 0.5)
            poof.DepthOffset = 900
            poof:Update()
        else
            mod:spritePlay(sprite, "Death1")
        end

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Death2" then
        if npc.StateFrame > bal.DyingTime then
            d.State = "Death3"
            d.LaidSpray = nil
        else
            mod:spritePlay(sprite, "Death2")
        end

        npc.Velocity = (d.StayHere-npc.Position)
    elseif d.State == "Death3" then
        if sprite:IsFinished("Death3") then
            if d.Hitbox then
                d.Hitbox:Remove()
            end
            d.Hitbox = nil
            npc:Remove()
        elseif sprite:IsEventTriggered("Transition") and not REPENTOGON then
            if d.Hitbox then
                d.Hitbox:Remove()
            end
            d.Hitbox = nil
        elseif sprite:IsEventTriggered("Transition2") and REPENTOGON then
            if d.Hitbox then
                d.Hitbox:Remove()
            end
            d.Hitbox = nil
        elseif sprite:IsEventTriggered("Sound") then
            npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 0, false, mod:RandomInt(90,110,rng)/100)
        else
            mod:spritePlay(sprite, "Death3")
        end

        npc.Velocity = (d.StayHere-npc.Position)
    end

    if d.LaidSpray then
        local offset = npc.Position+Vector(0,bal.DeathOffset):Rotated(npc.SpriteRotation+180)
        local v2 = Vector(mod:RandomInt(10,45,rng)/10, 0):Rotated(rng:RandomInt(360))
        local poof = Isaac.Spawn(1000, EffectVariant.BLOOD_EXPLOSION, mod:RandomInt(2,3,rng), offset+mod:shuntedPosition(20, rng), v2, npc):ToEffect()
        poof.DepthOffset = 900

        if npc.StateFrame % bal.DeathFreq == 0 then
            local ang = (npc.SpriteRotation % 160 == 0 and bal.DeathAngle) or bal.DeathAngle2

            npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.2,0,false,mod:RandomInt(70,85,rng)/100)
            local params = ProjectileParams()
            params.FallingAccelModifier = -0.05
            params.FallingSpeedModifier = 0
            params.HeightModifier = -3
            params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE
            mod:SetGatheredProjectiles()
            local num = bal.DeathNum[1]
            if rng:RandomInt(bal.DeathNum[3]) == 0 then
                num = bal.DeathNum[2]
            end
            for i=1,num do
                params.Scale = mod:RandomInt(bal.HurtScale[1],bal.HurtScale[2],rng)/10
                local speed = mod:RandomInt(bal.DeathSpeed[1], bal.DeathSpeed[2])/10+npc.StateFrame/3
                local vel = Vector(0,speed):Rotated(npc.SpriteRotation+180+mod:RandomInt(-ang,ang,rng)/10)
                npc:FireProjectiles(offset, vel, 0, params)
            end
            for _,proj in pairs(mod:GetGatheredProjectiles()) do
                local pData = mod:GetEntityData(proj)
                pData.projType = "laideronnette"
                proj.Height = -3
                pData.FallDir = Vector(0,bal.HurtAccel):Rotated(npc.SpriteRotation)
                pData.DeathAnimShots = true
            end
        end
    end

    if REPENTOGON and d.Hitbox and mod:superExists(d.Hitbox) then
        local over = sprite:GetNullFrame("LaidSize")
        if over and over:GetPos() then
            if not d.PreviousHitboxSize or d.PreviousHitboxSize ~= -1*over:GetPos().Y then
                local hd = mod:GetEntityData(d.Hitbox)
                hd.PositionOffset = -1*over:GetPos():Rotated(sprite.Rotation+180)/2
                local size = -1*over:GetPos().Y
                d.PreviousHitboxSize = size
                if d.HitboxOrient == "Height" then
                    hd.Height = size
                else
                    hd.Width = size
                end
            end
        else
            d.PreviousHitboxSize = nil
            d.Hitbox:Remove()
            d.Hitbox = nil
        end
    end
end

function mod:laideronnetteHurt(entity, damage, flags, source, countdown)
    local npc = entity:ToNPC()
    local d = mod:GetEntityData(npc)
    d.LaidCooldown = d.LaidCooldown or 0
    if damage > 0 and d.LaidCooldown <= 0 then
        local rng = npc:GetDropRNG()
        if d.State == "Idle" then
            d.State = "Hurt"
            d.LaidAnim = "Hurt" .. rng:RandomInt(2)+1
        end

        if damage < npc.HitPoints then
            npc:PlaySound(mod.Sounds.LaideronnetteHurt, 1, 0, false, mod:RandomInt(90,110,rng)/100)

            local offset = npc.Position+Vector(0,50):Rotated(npc.SpriteRotation+180)

            local params = ProjectileParams()
            params.FallingAccelModifier = -0.05
            params.FallingSpeedModifier = 0
            params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE
            mod:SetGatheredProjectiles()
            for i=1,bal.HurtProjNum do
                params.Scale = mod:RandomInt(bal.HurtScale[1],bal.HurtScale[2],rng)/10
                local speed = mod:RandomInt(bal.HurtSpeed[1], bal.HurtSpeed[2])/10
                local vel = Vector(0,speed):Rotated(npc.SpriteRotation+180+mod:RandomInt(-bal.HurtAngle,bal.HurtAngle,rng))
                npc:FireProjectiles(offset, vel, 0, params)
            end
            params.Scale = 2
            params.Color = color
            local speed = mod:RandomInt(bal.HurtSpeed[1], bal.HurtSpeed[2])/10
            local vel = Vector(0,speed):Rotated(npc.SpriteRotation+180+mod:RandomInt(-bal.HurtAngle,bal.HurtAngle,rng))
            npc:FireProjectiles(offset, vel, 0, params)
            for _,proj in pairs(mod:GetGatheredProjectiles()) do
                local pData = mod:GetEntityData(proj)
                pData.projType = "laideronnette"
                pData.FallDir = Vector(0,bal.HurtAccel):Rotated(npc.SpriteRotation)
                if proj.Scale == 2 then
                    pData.LaidBurst = true
                end
            end
    
            d.LaidCooldown = bal.HurtCooldown
        end
    end

    if d.State == "Death1" or d.State == "Death2" or d.State == "Death3" then
        return false
    elseif damage > 0 and not (d.State == "Idle" or d.State == "Hurt") and flags ~= flags | DamageFlag.DAMAGE_CLONES then
        npc:TakeDamage(damage*bal.DamageReduction, flags | DamageFlag.DAMAGE_CLONES, source, 0)
        return false
    end
end

function mod.laideronnetteProj(v, d)
    if d.projType == "laideronnette" then
        local room = game:GetRoom()

        v.FallingSpeed = -0.12
        v.FallingAccel = -0.05

        if not d.LaidStop then
            v.Velocity = v.Velocity+d.FallDir
        end

        if not room:IsPositionInRoom(v.Position, -100) and d.LaidFalling == true and not d.DeathAnimShots then
            v:Remove()
        elseif d.DeathAnimShots and v.FrameCount > 650 then
            v:Remove()
        end

        if math.abs(d.FallDir.X) > math.abs(d.FallDir.Y) then
            if not d.LaidOrient then
                d.LaidOrient = "Hori"
            end

            if d.FallDir.X > 0 then
                if not d.LaidStop and v.Velocity.X > bal.HurtSpeedCap then
                    d.LaidStop = true
                end

                if not d.LaidCanCollide and v.Velocity.X > 0 then
                    d.LaidFalling = true
                    if room:IsPositionInRoom(v.Position, 0) then
                        d.LaidCanCollide = true
                    end
                end
            else
                if not d.LaidStop and v.Velocity.X < -bal.HurtSpeedCap then
                    d.LaidStop = true
                end

                if not d.LaidCanCollide and v.Velocity.X < 0 then
                    d.LaidFalling = true
                    if room:IsPositionInRoom(v.Position, 0) then
                        d.LaidCanCollide = true
                    end
                end
            end
        else
            if not d.LaidOrient then
                d.LaidOrient = "Vert"
            end

            if d.FallDir.Y > 0 then
                if not d.LaidStop and v.Velocity.Y > bal.HurtSpeedCap then
                    d.LaidStop = true
                end

                if not d.LaidCanCollide and v.Velocity.Y > 0 then
                    d.LaidFalling = true
                    if room:IsPositionInRoom(v.Position, 0) then
                        d.LaidCanCollide = true
                    end
                end
            else
                if not d.LaidStop and v.Velocity.Y < -bal.HurtSpeedCap then
                    d.LaidStop = true
                end

                if not d.LaidCanCollide and v.Velocity.Y < 0 then
                    d.LaidFalling = true
                    if room:IsPositionInRoom(v.Position, 0) then
                        d.LaidCanCollide = true
                    end
                end
            end
        end

        local wallDetect = room:GetGridCollisionAtPos(v.Position)
        local gridEnt = room:GetGridEntityFromPos(v.Position)
        if wallDetect == GridCollisionClass.COLLISION_WALL and gridEnt and gridEnt:GetType() == GridEntityType.GRID_PILLAR then
            v:Die()
        end

        if d.LaidCanCollide then
            if wallDetect == GridCollisionClass.COLLISION_WALL and v.FrameCount > 8 then
                v:Die()
            end
        end

        if d.LaidOrient == "Hori" then
            if v.Velocity.Y > 0 then
                if v.Position.Y > room:GetBottomRightPos().Y then
                    v:Die()
                end
            elseif v.Position.Y < room:GetTopLeftPos().Y then
                v:Die()
            end

            if d.LaidFalling then
                if v.Velocity.X > 0 then
                    if v.Position.X > room:GetBottomRightPos().X then
                        v:Die()
                    end
                elseif v.Position.X < room:GetTopLeftPos().X then
                    v:Die()
                end
            end
        else
            if v.Velocity.X > 0 then
                if v.Position.X > room:GetBottomRightPos().X then
                    v:Die()
                end
            elseif v.Position.X < room:GetTopLeftPos().X then
                v:Die()
            end

            if d.LaidFalling then
                if v.Velocity.Y > 0 then
                    if v.Position.Y > room:GetBottomRightPos().Y then
                        v:Die()
                    end
                elseif v.Position.Y < room:GetTopLeftPos().Y then
                    v:Die()
                end
            end
        end
    end
end

function mod.laideronnetteProjRemove(v, d)
    if d.projType == "laideronnette" and d.LaidBurst then
        sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, 1)
        for i=1,8 do
            local proj = mod:LazySpawnProjectile(0, 0, v.Position, Vector(0,bal.SplitSpeed):Rotated(i*45), v):ToProjectile()
            proj.ProjectileFlags = v.ProjectileFlags
            local pData = mod:GetEntityData(proj)
            pData.projType = "laideronnette"
            pData.FallDir = d.FallDir
            pData.canCollide = true
        end
    end
end

function mod.LaideronnetteDeathAnim(npc)
    local onCustomDeath = function(n, deathAnim)
		mod:GetEntityData(deathAnim).Deaded = true
        deathAnim.SpriteRotation = n.SpriteRotation
        deathAnim.Position = mod:GetEntityData(n).StayHere or n.Position
        mod:GetEntityData(deathAnim).StayHere = mod:GetEntityData(n).StayHere or n.Position
        mod:GetEntityData(deathAnim).HitboxOrient = mod:GetEntityData(n).HitboxOrient or "Height"
	end
	mod.genericCustomDeathAnim(npc, "Death1", false, onCustomDeath, false, false)
end

--[[function mod:laideronneteHelperAI(npc)
    local d = mod:GetEntityData(npc)
    local laid = d.laideronnette

    if not d.init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc.Visible = false
        npc:GetSprite().Color = Color(1,1,1,0,0,0,0)
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        d.state = "Snap"

        d.init = true
    end

    npc.Visible = false

    if not mod:superExists(laid) then
        npc:Remove()
    else
        if d.state == "Snap" then
            local wallPos = mod:GetClosestWallPos(npc.Position)
            local ang = dirToAngle[mod:GetMoveString(npc.Position - wallPos)]
            laid.SpriteRotation = ang
            npc.Position = wallPos
            laid.Position = npc.Position
            d.state = "Idle"
        end
    end
end]]