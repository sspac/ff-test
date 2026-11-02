local mod = FiendFolio
local indBal = {
    maxDist = 90,
    playerHop = 65,
    playerShoot = 240,
    moveCooldown = {5, 20, 7},
    shootCooldown = -10,

    laserDur = 10,
}

function mod:indulgerAI(npc)
    local target = npc:GetPlayerTarget()
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local rng = npc:GetDropRNG()

    if not d.init then
        d.myMoveTable = {
            {"Jump", 1},
            {"Shoot", 1},
        }
        d.refreshLoop = 0
        d.state = "Idle"
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if d.state == "Idle" then
        local GO
        if npc.StateFrame > indBal.moveCooldown[1] and rng:RandomInt(indBal.moveCooldown[3]) == 0 then
            GO = true
        elseif npc.StateFrame > indBal.moveCooldown[2] then
            GO = true
        end
        if mod:isConfuse(npc) then
            if npc.StateFrame > indBal.moveCooldown[1] then
                d.state = "Jump"
                d.targetPosition = mod:FindRandomFreePos(npc, indBal.maxDist, true)
            end
        elseif mod:isScare(npc) then
            d.state = "Jump"
            d.targetPosition = npc.Position+(npc.Position-target.Position):Resized(70)
        elseif GO then
            local tab = mod:makeCopiedTable(d.myMoveTable)
            local special = -1
            if target.Position:Distance(npc.Position) < indBal.playerHop then
                special = 1
                tab = {{"Jump", 3}, {"Shoot", 1}}
            elseif target.Position:Distance(npc.Position) < indBal.playerShoot then
                tab[1][2] = tab[1][2]*0.75
            else
                table.remove(tab, 2)
            end
            local result = mod:weightedRNG(tab, rng)
            d.state = result
            if result == "Jump" then
                if special == 1 then
                    d.targetPosition = target.Position
                else
                    d.targetPosition = mod:FindRandomFreePos(npc, indBal.maxDist, true)
                end
                d.myMoveTable[1][2] = d.myMoveTable[1][2]*0.75
            else
                npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_2, 1, 0, false, mod:RandomInt(90,110,rng)/100)
                d.targetDir = (target.Position-npc.Position)
                d.myMoveTable[2][2] = d.myMoveTable[2][2]*0.5
                mod:SetGatheredProjectiles()
                local params = ProjectileParams()
                params.Variant = 1
                npc:FireProjectiles(npc.Position, Vector.Zero, 0, params)
                for _,v in ipairs(mod:GetGatheredProjectiles()) do
                    d.specialColor = v.Color
                    v:Remove()
                end
                local tracer = Isaac.Spawn(1000, 198, 0, npc.Position + Vector(10, 0):Rotated(d.targetDir:GetAngleDegrees()), Vector(0.001,0), npc):ToEffect()
				tracer.Timeout = 20
				tracer.TargetPosition = Vector(1,0):Rotated(d.targetDir:GetAngleDegrees())
				tracer.LifeSpan = 15
				--tracer:FollowParent(npc)
                if npc:IsChampion() and npc:GetChampionColorIdx() == ChampionColor.FLICKER then
                    tracer.Color = Color(1, 1, 1, 0.3, 0, 0, 0)
                else
                    tracer.Color = Color(d.specialColor.R, d.specialColor.G, d.specialColor.B, 1, d.specialColor.RO, d.specialColor.GO, d.specialColor.BO)
                end
                tracer.SpriteOffset = Vector(0,-27)
                tracer:Update()
            end
            d.refreshLoop = d.refreshLoop+1
            if d.refreshLoop > 5 then
                d.myMoveTable = {
                    {"Jump", 1},
                    {"Shoot", 1},
                }
                d.refreshLoop = 0
            end
        end
        mod:spritePlay(sprite, "Down")
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        npc.FlipX = npc.Velocity.X < 0
    elseif d.state == "Shoot" then
        if not d.stared then
            npc.FlipX = (target.Position-npc.Position).X < 0
        else
            npc.FlipX = d.stared
        end

        if sprite:IsFinished("Attack") then
            d.state = "Idle"
            npc.StateFrame = indBal.shootCooldown
            d.stared = nil
        elseif sprite:IsEventTriggered("Shoot") then
            local playSound = SoundEffect.SOUND_BOSS_LITE_HISS
            if REPENTANCE_PLUS then
                playSound = FiendFolio.TempSoundEnums.PrideLaser
            end
            npc:PlaySound(playSound, 1, 0, false, 1)
            local laser = EntityLaser.ShootAngle(LaserVariant.PRIDE, npc.Position, d.targetDir:GetAngleDegrees(), indBal.laserDur, Vector(0, -18)*npc.SpriteScale.Y, npc)
            laser.Color = d.specialColor or Color(1, 1, 1, 1, 0, 0, 0)
            laser.CollisionDamage = 0
        else
            mod:spritePlay(sprite, "Attack")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    elseif d.state == "Jump" then
        if sprite:IsFinished("JumpDown") then
            d.state = "Idle"
            npc.StateFrame = 0
            d.targetPosition = nil
        elseif sprite:IsEventTriggered("Jump") then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            d.jumping = true
        elseif sprite:IsEventTriggered("Land") then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            d.jumping = nil
            npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, mod:RandomInt(95,115,rng)/100)
        else
            mod:spritePlay(sprite, "JumpDown")
        end
        if d.jumping then
            local vel = (d.targetPosition-npc.Position)*0.2
            npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.3)
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
        end
        
        npc.FlipX = npc.Velocity.X < 0
    end

    if npc:IsDead() and not mod:isFriend(npc) and mod:shouldDoDeathEffect(npc) then
        local puff = Isaac.Spawn(1000, EffectVariant.POOF01, 0, npc.Position, Vector.Zero, npc)
        local bomb = Isaac.Spawn(4, 3, 0, npc.Position, npc.Velocity*0.5, npc)
        --[[if npc:IsChampion() and npc:GetChampionColorIdx() == ChampionColor.GIANT then
            bomb.SpriteScale = bomb.SpriteScale*2
        elseif npc:IsChampion() and npc:GetChampionColorIdx() == ChampionColor.TINY then
            bomb.SpriteScale = bomb.SpriteScale*0.5
        end]]
        bomb.SpriteScale = npc.SpriteScale
    end
end