local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

function mod:RoastyAI(npc, sprite, data)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position)
    local room = game:GetRoom()
    if not data.Init then
        data.Index = room:GetGridIndex(npc.Position)
        if npc.SubType == 1 then
            mod:makeWaitFerr(npc, npc.Type, npc.Variant, 0, 30)
        else
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR)
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            if data.waited then
                npc.Visible = true
                mod.OccupiedGrids[data.Index] = "Closed"
            end
            npc.SplatColor = mod.ColorFireyFade
            sprite:Play("Emerge")
        end
        if room:GetFrameCount() <= 1 then
            room:SpawnGridEntity(data.Index, GridEntityType.GRID_PIT, 0, 0, 0)
            mod:UpdatePits()
        end
        data.Init = true
    end
    if room:HasWater() then
        npc:Kill()
    end
    mod.NegateKnockoutDrops(npc)
    if data.WeJumpin then
        if data.StateFrame >= 21 then
            data.WeJumpin = false
            npc.SpriteOffset = Vector(0,0)
            data.StateFrame = 0
            if sprite:IsPlaying("InAirHori01") then
                sprite:Play("BounceHori")
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET + EntityFlag.FLAG_HIDE_HP_BAR)
                mod:DoRoastySplat(npc)
                npc.Velocity = Vector.Zero
                npc.TargetPosition = data.EndPoint
            elseif sprite:IsPlaying("InAirHori02") then
                sprite:Play("Submerge01")
                local effect = Isaac.Spawn(1000,16,67,npc.Position,Vector.Zero,npc):ToEffect()
                effect:GetSprite().Scale = effect:GetSprite().Scale * 0.75
                sfx:Play(SoundEffect.SOUND_WAR_LAVA_SPLASH)
            elseif sprite:IsPlaying("InAirVert01") then
                sprite:Play("BounceVert")
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET + EntityFlag.FLAG_HIDE_HP_BAR)
                mod:DoRoastySplat(npc)
                npc.Velocity = Vector.Zero
                npc.TargetPosition = data.EndPoint
            elseif sprite:IsPlaying("InAirVert02") then
                sprite:Play("Submerge02")
                local effect = Isaac.Spawn(1000,16,67,npc.Position,Vector.Zero,npc):ToEffect()
                effect:GetSprite().Scale = effect:GetSprite().Scale * 0.75
                sfx:Play(SoundEffect.SOUND_WAR_LAVA_SPLASH)
            end
        end
    elseif data.WeHidin then
        npc.Velocity = Vector.Zero
        if npc.StateFrame <= 0 then
            npc.Position = room:GetGridPosition(data.Index)
            sprite:Play("Emerge")
            data.WeHidin = false
            npc.Visible = true
            mod:FlipSprite(sprite, targetpos, npc.Position)
            data.IGottaShoot = true
        else
            npc.StateFrame = npc.StateFrame - 1
        end
    elseif sprite:IsPlaying("Idle") then
        npc.Velocity = Vector.Zero
        if npc.StateFrame <= 0 then
            if data.IGottaShoot then
                sprite:Play("Shoot")
                data.IGottaShoot = false
            else
                mod:GetRoastyTarget(npc, sprite, data)
            end
        else
            npc.StateFrame = npc.StateFrame - 1
        end
    else
        npc.Velocity = Vector.Zero
    end
    if sprite:IsFinished("Emerge") or sprite:IsFinished("Shoot") then
        npc.StateFrame = mod:RandomInt(40,80)
        sprite:Play("Idle")
    elseif sprite:IsFinished("JumpHoriStart") then
        sprite:Play("InAirHori01")
    elseif sprite:IsFinished("BounceHori") then
        sprite:Play("InAirHori02")
    elseif sprite:IsFinished("JumpVertStart") then
        sprite:Play("InAirVert01")
    elseif sprite:IsFinished("BounceVert") then
        sprite:Play("InAirVert02")
    elseif sprite:IsFinished("Submerge01") or sprite:IsFinished("Submerge02") then
        if not data.WeHidin then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET + EntityFlag.FLAG_HIDE_HP_BAR)
            npc.Visible = false
            npc.StateFrame = mod:RandomInt(30,45)
            data.WeHidin = true
        end
    end
    if sprite:IsEventTriggered("Emerge") then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET + EntityFlag.FLAG_HIDE_HP_BAR)
        sfx:Play(SoundEffect.SOUND_WAR_LAVA_SPLASH)
    elseif sprite:IsEventTriggered("Jump") then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        mod:PlaySound(SoundEffect.SOUND_CUTE_GRUNT, npc, 1)
        if sprite:IsPlaying("JumpHoriStart") or sprite:IsPlaying("JumpVertStart") then
            Isaac.Spawn(1000,16,66,npc.Position,Vector.Zero,npc)
        end
        data.StateFrame = 0
        data.WeJumpin = true
    elseif sprite:IsEventTriggered("Shoot") then
        local vel = (targetpos - npc.Position):Resized(12)
        local projectile = mod:LazySpawnProjectile(9, 0, npc.Position, vel, npc):ToProjectile()
        projectile:GetSprite():Load("gfx/projectiles/projectile_coal_ball.anm2", true)
        projectile:GetSprite():Play("Move")
        mod:FlipSprite(projectile:GetSprite(), npc.Position, targetpos)
        projectile.FallingAccel = -0.08
        projectile.Size = 14
        mod:GetEntityData(projectile).projType = "coalBall"
        mod:ProjectileFriendCheck(npc, projectile)
        mod:PlaySound(SoundEffect.SOUND_BOSS_GURGLE_ROAR, npc, 1)
        local effect = Isaac.Spawn(1000,2,4,npc.Position,Vector.Zero,npc):ToEffect()
        effect.Color = mod.ColorFireJuicy
        mod:FlipSprite(sprite, targetpos, npc.Position)
        if sprite.FlipX then
            effect.SpriteOffset = Vector(10,-25)
        else
            effect.SpriteOffset = Vector(-5,-25)
        end
        effect.DepthOffset = npc.Position.Y * 1.25
        effect:GetSprite().Scale = effect:GetSprite().Scale * 0.75
    end
end

function mod:RoastyRender(npc, sprite, data, isPaused, isReflected)
    if not (isPaused or isReflected) then
        if data.WeJumpin then
            local curve = math.sin(math.rad(9 * data.StateFrame))
            local height = 0 - curve * 40
            npc.SpriteOffset = Vector(0, height)
            data.StateFrame = data.StateFrame + 0.5
            npc.Velocity = data.Trajectory
        end
    end
end

function mod:IgnoreFireDamage(npc, amount, damageFlags, source)
    if mod:HasDamageFlag(DamageFlag.DAMAGE_FIRE, damageFlags) and not mod:IsPlayerDamage(source) then
        return false
    end
end

function mod:GetRoastyTarget(npc, sprite, data)
    local room = game:GetRoom()
    local startpos = room:GetGridPosition(data.Index)
    local pits = mod:GetAllGridIndexOfType(GridEntityType.GRID_PIT, GridCollisionClass.COLLISION_PIT)
    local validtargets1 = {}
    local validtargets2 = {}
    for _, index in pairs(pits) do
        if mod.OccupiedGrids[index] ~= "Closed" then
            local endpos = room:GetGridPosition(index)
            local trajectory = endpos - startpos
            local length = trajectory:Length()
            if length < 400 then
                local midpoint = startpos + trajectory:Resized(trajectory:Length()/2)
                if room:GetGridCollisionAtPos(midpoint) == GridCollisionClass.COLLISION_NONE then
                    if length < 100 or length > 300 then
                        table.insert(validtargets2, {["Endpoint"] = endpos, ["Midpoint"] = midpoint, ["Index"] = index, ["Trajectory"] = trajectory})
                    else
                        table.insert(validtargets1, {["Endpoint"] = endpos, ["Midpoint"] = midpoint, ["Index"] = index, ["Trajectory"] = trajectory})
                    end
                end
            end
        end
    end
    local chosenpath = mod:GetRandomElem(validtargets1)
    if not chosenpath then
        chosenpath = mod:GetRandomElem(validtargets2)
    end
    if chosenpath then
        mod.OccupiedGrids[data.Index] = "Open"
        data.MidPoint = chosenpath.Midpoint
        data.EndPoint = chosenpath.Endpoint
        data.Trajectory = chosenpath.Trajectory/40
        data.Index = chosenpath.Index
        mod.OccupiedGrids[data.Index] = "Closed"
        if math.abs(data.Trajectory.X) > math.abs(data.Trajectory.Y) then
            sprite:Play("JumpHoriStart")
        else
            sprite:Play("JumpVertStart")
        end
        npc.TargetPosition = data.MidPoint
        mod:FlipSprite(sprite, npc.TargetPosition, npc.Position)
    else
        sprite:Play("Shoot")
    end
end

function mod:DoRoastySplat(npc)
    table.insert(mod.FireShockwaves, {["Spawner"] = npc, ["Position"] = mod:GetEntityData(npc).MidPoint})
    mod:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, npc, 0.8, 1.5)
    local effect = Isaac.Spawn(1000,16,3,npc.Position,Vector.Zero,npc):ToEffect()
    effect.Color = mod.ColorFireJuicy
    effect:GetSprite().Scale = effect:GetSprite().Scale * 0.75
    local creep = Isaac.Spawn(1000,22,0,npc.Position,Vector.Zero,npc):ToEffect()
    creep.Color = mod.ColorGreyscaleLight
    creep:SetColor(mod.ColorFireJuicy, 90, 0, true, false)
    creep.SpriteScale = creep.SpriteScale * 1.5
    creep:SetTimeout(60)
end

function mod:FireShockwaveUpdate(wave)
    wave.Duration = wave.Duration or 10
    wave.Count = wave.Count or 1
    if wave.Duration >= 0 then
        if wave.Duration % 10 == 0 then
            local npc = wave.Spawner:ToNPC()
            local fourfold = 360/(wave.Count*4)
            for i = 0, 360 - fourfold, fourfold do
                Isaac.Spawn(1000, 147, 0, wave.Position + Vector(0,(40 * wave.Count)):Rotated(i), Vector.Zero, npc)
            end
            wave.Count = wave.Count + 1
        end
        wave.Duration = wave.Duration - 1
    else
        wave = nil
    end
end

function mod:CoalBallBreak(projectile, data)
    local room = game:GetRoom()
    sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)
    local effect = Isaac.Spawn(1000,2,4,projectile.Position,Vector.Zero,projectile):ToEffect()
    effect.Color = mod.ColorFireJuicy
    effect:GetSprite().Scale = effect:GetSprite().Scale * 0.75
    effect.SpriteOffset = projectile.SpriteOffset
    effect.DepthOffset = projectile.Position.Y * 0.75
    effect = Isaac.Spawn(1000,145,0,projectile.Position,Vector.Zero,projectile):ToEffect()
    effect.Color = mod.ColorCharred
    effect:GetSprite().Scale = effect:GetSprite().Scale * 1.25
    effect.SpriteOffset = projectile.SpriteOffset
    local projRNG = projectile:GetDropRNG()
    if projectile.ProjectileFlags ~= projectile.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER then
        for i = 1, 3 do
            local targetpos = projectile.Position + Vector.One:Resized(50,100):Rotated(mod:GetAngleDegreesButGood(projectile.Velocity) + mod:RandomInt(-70,70))
            if room:GetGridCollisionAtPos(targetpos) ~= GridCollisionClass.COLLISION_NONE or not room:IsPositionInRoom(targetpos, 15) then
                local newPos = game:GetRoom():FindFreePickupSpawnPosition(targetpos, 0, false, false)
                if newPos:Distance(targetpos) < 70 and game:GetRoom():IsPositionInRoom(newPos, 10) then
                    targetpos = newPos
                end
            end

            local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_GRID, mod.FF.ShadowlessGridProjectile.Sub, projectile.Position,
                (projectile.Position - targetpos)/20, projectile):ToProjectile()
            proj.Height = projectile.Height
            proj.FallingSpeed = -mod:RandomInt(12,24,projRNG)
            proj.FallingAccel = 1
            mod:ThrowCoal(proj)
        end
    end
    for i = 0, 5 do
        local shard = Isaac.Spawn(1000, 35, 1, projectile.Position, Vector.One:Resized(rng:RandomFloat()*4):Rotated(mod:RandomAngle()), projectile)
        shard.Color = mod.ColorCharred
    end
end

--Projectile variant should be grid projectile and subtype should be ShadowlessGridProjectile
function mod:ThrowCoal(proj)
    local pRNG = proj:GetDropRNG()
	mod:GetEntityData(proj).projType = "customProjectileBehavior"
	mod:GetEntityData(proj).dontBlink = true
    proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
	proj:Update()
	local coalType = mod:RandomInt(0, 2, pRNG)+1
	local sprite = proj:GetSprite()
	sprite:Load("gfx/818.002_coal " .. coalType .. ".anm2", true)
    mod:GetEntityData(proj).customProjectileBehavior = {death = function(p)
        local coal = Isaac.Spawn(EntityType.ENTITY_FIREPLACE, 11, coalType, p.Position, p.Velocity, p):ToNPC()
		coal:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		coal.PositionOffset = Vector(0, math.min(0, p.Height))

		if p:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) and p:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
			coal:AddCharmed(EntityRef(p), -1)
		elseif p:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) then
			coal:AddCharmed(EntityRef(p), 9999)
		end

        local room = game:GetRoom()
		local gridColl = room:GetGridCollisionAtPos(p.Position)
        local findPos = room:FindFreePickupSpawnPosition(p.Position, 0, false, false)
		if gridColl == GridCollisionClass.COLLISION_PIT or findPos:Distance(p.Position) > 60 then
			coal.HitPoints = 0
			coal:TakeDamage(1, 0, EntityRef(p), 0)
			mod:GetEntityData(coal).StayHereDamnIt = p.Position
			coal.PositionOffset = Vector(0, p.Height)
			coal:Update()
			coal:Update()
			coal:Update()
        end
    end, update = function(p)
        if p.FrameCount > 2 and not mod:GetEntityData(p).CanHitNow then
            p:ClearProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
            mod:GetEntityData(p).CanHitNow = true
        end
		mod:spritePlay(sprite, "IdleRock")
	end}
end