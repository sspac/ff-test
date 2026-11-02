local mod = FiendFolio
local game = Game()

function mod:cochleaAI(npc)
    local target = npc:GetPlayerTarget()
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()
    
    if not d.init then
        d.state = "Idle"
        d.moveFrame = -mod:getRoll(20,10,rng)
        d.moveSpeed = 0
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
        d.moveFrame = d.moveFrame+1
    end

    if mod:isConfuse(npc) then
        d.state = "Squirm"
    elseif mod:isScare(npc) then
        d.state = "Scared"
    end

    if npc.Velocity.X > 0 then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end

    if sprite:IsEventTriggered("Move") then
        npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 0.3, 0, false, mod:getRoll(130,160,rng)/100)
    end

    if d.state == "Idle" then
        if d.moveFrame >= 0 then
            d.moveFrame = 0

            local rand = rng:RandomInt(5)
            if rand < 2 then
                d.targetPos = mod:FindRandomValidPathPosition(npc, 3, nil, 150)
                npc.StateFrame = 0
                d.state = "Move"
            elseif rand == 2 then
                d.state = "Squirm"
                npc.StateFrame = 0
            else --Harassing
                d.targetPos = mod:FindClosestValidPosition(npc, target, 60, 200, 0)
                npc.StateFrame = 0
                d.state = "Move"
            end
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)

        mod:spritePlay(sprite, "Idle")
    elseif d.state == "Move" then
        if d.moveFrame < 0 then
            mod:spritePlay(sprite, "Idle")
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.2)
        else
            if sprite:IsEventTriggered("Move") then
                d.moveSpeed = 6
            elseif sprite:IsEventTriggered("End") then
                d.moveFrame = -mod:getRoll(0, 5, rng)
            else
                mod:spritePlay(sprite, "Move")
            end

            if npc.Position:Distance(d.targetPos) < 20 or npc.StateFrame > 120 then
                d.state = "Idle"
                npc.StateFrame = 0
                d.moveFrame = -mod:getRoll(15, 25, rng)
            elseif room:CheckLine(npc.Position, d.targetPos, 0, 1, false, false) then
                npc.Velocity = mod:Lerp(npc.Velocity, (d.targetPos-npc.Position):Resized(d.moveSpeed), 0.3)
            else
                npc.Pathfinder:FindGridPath(d.targetPos, d.moveSpeed/5.3, 999, true)
            end

            if d.moveSpeed > 0 then
                d.moveSpeed = math.max(0, d.moveSpeed*0.86)
            end
        end
    elseif d.state == "Squirm" then
        if npc.StateFrame > 140 then
            d.state = "Idle"
            npc.StateFrame = 0
            d.moveFrame = -mod:getRoll(20, 30)
        end

        if sprite:IsEventTriggered("Move") or not d.squirmPos or npc.Position:Distance(d.squirmPos) < 5 then
            d.moveSpeed = 6
            d.squirmPos = mod:FindRandomValidPathPosition(npc, 3, nil, 90)
        else
            mod:spritePlay(sprite, "Move")
        end

        if d.moveSpeed > 0 then
            d.moveSpeed = math.max(0, d.moveSpeed*0.86)
        end

        npc.Velocity = mod:Lerp(npc.Velocity, (d.squirmPos-npc.Position):Resized(d.moveSpeed), 0.3)
    elseif d.state == "Scared" then
        if sprite:IsEventTriggered("Move") then
            d.moveSpeed = 6
        else
            mod:spritePlay(sprite, "Move")
        end

        npc.Velocity = mod:Lerp(npc.Velocity, (npc.Position-target.Position):Resized(d.moveSpeed+1), 0.3)

        if d.moveSpeed > 0 then
            d.moveSpeed = math.max(0, d.moveSpeed*0.86)
        end

        if not mod:isScare(npc) then
            d.state = "Idle"
            npc.StateFrame = 0
            d.moveFrame = -mod:getRoll(10, 20, rng)
        end
    end

    if npc:IsDead() then
        npc:PlaySound(SoundEffect.SOUND_LARYNX_SCREAM_MED, 0.7, 0, false, mod:RandomInt(290,330,rng)/100)

		if mod:shouldDoDeathEffect(npc) then
			local params = ProjectileParams()
			for i=0,4 do
				local vec = (target.Position-npc.Position):Resized(10, 0):Rotated(i*72)
				npc:FireProjectiles(npc.Position, vec, 0, params)
			end
		end

        for i=1,8 do
            mod.scheduleForUpdate(function()
                local line = Isaac.Spawn(1000, 151, 11, npc.Position, Vector.Zero, npc):ToEffect()
                line:SetTimeout(10)
                line.Color = Color(1, 0.2, 0.2, 1, 0, 0, 0)
                mod:GetEntityData(line).cochleaEffect = {scale = 1, frames = 0, speed = 0.025}
                line.SpriteScale = Vector(1,1)
                line.MaxRadius = mod:BasicRandomFloat(10, 20, line:GetDropRNG())
                line:GetSprite().Rotation = line:GetDropRNG():RandomInt(360)
                line:Update()
            end, 3+i)
        end

        for i=0,2 do
            mod.scheduleForUpdate(function()
                local burst = Isaac.Spawn(1000, EffectVariant.BIG_ATTRACT, 10, npc.Position, Vector.Zero, npc):ToEffect()
                burst:SetTimeout(30)
                burst.Color = Color(1, 0.2, 0.2, 1, 0, 0, 0)
                mod:GetEntityData(burst).cochleaEffect = {scale = 0.01, frames = 0, speed = 0.03}
                burst.SpriteScale = Vector.Zero
                burst:GetSprite().Rotation = burst:GetDropRNG():RandomInt(360)
                burst:Update()
            end, 3*i)
        end

        local func = function(_, enemy)
            return enemy.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE and enemy:IsActiveEnemy()
        end
        for _,enemy in pairs(mod:GetAllEnemies(func)) do
            mod:GetEntityData(enemy).cochleaDeathEffect = {npc = npc, friend = mod:isFriend(npc), target = target, timeout = 15, backupPos = target.Position}
            if enemy.Type == mod.FF.SplitEar.ID and enemy.Variant == mod.FF.SplitEar.Var then
                if mod:GetEntityData(enemy).State ~= "CochleaRetaliation" then
                    mod:GetEntityData(enemy).cochleaDeathEffect = {npc = npc, friend = mod:isFriend(npc), target = target, timeout = 15, backupPos = target.Position}
                end
            elseif enemy.Type == mod.FF.EarSplitter.ID and enemy.Variant == mod.FF.EarSplitter.Var then
                mod:GetEntityData(enemy).cochleaDeathEffect = nil
                if mod:GetEntityData(enemy).State ~= "Shoot" and mod:GetEntityData(enemy).State ~= "ChargeWait" then
                    mod:GetEntityData(enemy).State = "Shoot"
                    mod:GetEntityData(enemy).HurtingEnemies = true
                    mod:GetEntityData(enemy).HurtList = {}
                    mod:GetEntityData(enemy).SizeMulti = Vector(1.5, 1)
                    mod:FlipSprite(enemy:GetSprite(), enemy.Position, mod:confusePos(enemy, enemy:GetPlayerTarget().Position))
                end
            else
                mod:GetEntityData(enemy).cochleaDeathEffect = {npc = npc, friend = mod:isFriend(npc), target = target, timeout = 15, backupPos = target.Position}
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local d = mod:GetEntityData(e)
    if d.cochleaEffect then
        local entry = d.cochleaEffect
        if e.SubType == 11 then
            e.SpriteScale = Vector(2, 0.5)
        else
            e.SpriteScale = Vector(entry.scale, entry.scale)
        end
        --entry.scale = math.max(0, entry.scale+entry.speed)
        entry.scale = math.max(0, math.min(entry.maxScale or 10, entry.scale+entry.speed))
        entry.speed = entry.speed*(entry.slowdown or 0.92)

        if entry.fadeIn then
            e.Color = Color(e.Color.R, e.Color.G, e.Color.B, math.min(1, e.Color.A+entry.fadeIn), e.Color.RO, e.Color.BO, e.Color.GO)
            if e.Color.A >= 1 then
                entry.fadeIn = nil
            end
        end

        if entry.npc then
            if not mod:superExists(entry.npc) or entry.npc.EntityCollisionClass == EntityCollisionClass.ENTCOLL_NONE then
                e:Remove()
            end
        end
    end
end, EffectVariant.BIG_ATTRACT)

function mod:cochleaDeathEffectUpdate(npc, d)
    if d.cochleaDeathEffect then
        local entry = d.cochleaDeathEffect
        if npc.Type == mod.FF.SplitEar.ID and npc.Variant == mod.FF.SplitEar.Var then
            --[[if not entry.init then
                table.insert(mod.TearBarrage, {["Duration"] = 20, ["Pos"] = npc.Position, ["Tar"] = npc:GetPlayerTarget().Position, ["Spawner"] = npc})
                for key,entry2 in pairs(mod.TearBarrage) do
                    if entry2.Spawner and entry2.Spawner.InitSeed == npc.InitSeed then
                        d.cochleaEarTableInfo = {key = key, vec = (entry2.Tar-entry2.Pos)}
                    end
                end
                entry.init = true

                local color = Color(1,0.3,0.3,0.7)
                for i = 1, 6 do
                    local line = mod:MakeLarynxLine(npc.Position, mod:RandomInt(15,25,npc:GetDropRNG()), 10, npc, color)
                    line:FollowParent(npc)
                end
                local wave = mod:MakeLarynxWave(npc.Position, 30, 30, npc, color)
                wave:FollowParent(npc)
            end

            if d.cochleaEarTableInfo then
                local entry2 = mod.TearBarrage[d.cochleaEarTableInfo.key]
                entry2.Pos = npc.Position
                entry2.Tar = npc.Position+d.cochleaEarTableInfo.vec

                if entry2.Duration <= 0 then
                    d.cochleaDeathEffect = nil
                    d.cochleaEarTableInfo = nil
                end
            end]]

            if d.State ~= "CochleaRetaliation" then
                d.State = "CochleaRetaliation"
                d.cochleaMoveVector = npc.Velocity
                d.cochleaStopMoving = true
            end
            d.cochleaDeathEffect = nil
        else
            if not entry.init then
                for i=0,2 do
                    mod.scheduleForUpdate(function()
                        local burst = Isaac.Spawn(1000, EffectVariant.BIG_ATTRACT, 10, npc.Position, Vector.Zero, npc):ToEffect()
                        burst:SetTimeout(30)
                        burst.Color = Color(1, 0.2, 0.2, 0, 0, 0, 0)
                        mod:GetEntityData(burst).cochleaEffect = {scale = 0.15, frames = 0, fadeIn = 0.1, speed = -0.015}
                        burst.SpriteScale = Vector.Zero
                        burst:GetSprite().Rotation = burst:GetDropRNG():RandomInt(360)
                        burst:FollowParent(npc)
                        burst:Update()
                    end, 3*i)
                end
                entry.init = true
            end

            if mod:superExists(npc) and entry.npc.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE then
                local guy = entry.target and mod:superExists(entry.target)
                if guy then
                    entry.backupPos = entry.target.Position
                end
    
                if entry.timeout > 0 then
                    entry.timeout = entry.timeout-1
                else
                    if guy then
                        local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, (entry.target.Position-npc.Position):Resized(14), entry.npc):ToProjectile()
                        if entry.friend then
                            projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
                        else
                            mod:makeCharmProj(npc, projectile)
                        end
                    else
                        local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, (entry.backupPos-npc.Position):Resized(14), entry.npc):ToProjectile()
                        if entry.friend then
                            projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
                        else
                            mod:makeCharmProj(npc, projectile)
                        end
                    end
                    local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 0, npc.Position, Vector.Zero, npc):ToEffect()
                    poof.DepthOffset = 80
                    poof.SpriteScale = Vector(0.4, 0.5)
                    poof.SpriteOffset = Vector(0,-5)
                    poof:FollowParent(npc)
                    poof:Update()
                    d.cochleaDeathEffect = nil
                end
            else
                d.cochleaDeathEffect = nil
            end
        end
    end
end