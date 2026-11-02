local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local bal = {
    ArcFall = {-45,-30},
    ArcAccel = 1.1,
    ArcScale = 2,
    ArcVar = {18,35}, --Rotation
    ArcVar2 = {-45, 10}, --Speed
    ArcFireHealth = 1,

    JumpSpeed = 7,
    JumpFireHealth = 0.45,
    JumpFireTime = 60,
}

local segmentColors = {
    [2] = 2, [3] = 3, [4] = 3, [5] = 2,
}

mod.DreadPinFiring = nil

function mod:DreadPinChampion(npc)
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local sprite = npc:GetSprite()
    local rng = npc:GetDropRNG()

    if not d.init then
        if not npc.Parent then
            d.DreadpinHead = true
            d.ultraParent = nil
            local curr = 1
            local man = npc
            local toMorph = {}
            while man.Child and not mod:IsReallyDead(man.Child) and man.Child.Type == npc.Type and npc.Child.SubType ~= npc.SubType do
                local c = man.Child:ToNPC()
                local nd = mod:GetEntityData(c)
                nd.DreadPinSegment = curr
                nd.ultraParent = npc
                table.insert(toMorph, c)
                man = man.Child
                curr = curr+1
            end

            for _,c in ipairs(toMorph) do
                --If they're damaged too early, they turn red forever
                c:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 999, 1, false, false)
                c:Morph(mod.FF.DreadPin.ID, mod.FF.DreadPin.Var, mod.FF.DreadPin.Sub, -1)
            end
        end
        d.init = true
    end

    if d.DreadpinHead then
        local anim = sprite:GetAnimation()
        if anim == "Body1Wiggle" then
            sprite:Play("HeadWiggleBack", true)
        end
        
        if npc.State == NpcState.STATE_IDLE then --Emerging
            d.DreadDontRepeatBullet = nil
            d.lastcreepleft = npc.Position
            mod.scheduleForUpdate(function()
                npc.Velocity = npc.Velocity * 0.8
            end, 2)
        elseif npc.State == NpcState.STATE_MOVE and npc.PositionOffset.Y > 5 then
            d.lastcreepleft = d.lastcreepleft or npc.Position + Vector(0,20)
			if d.lastcreepleft:Distance(npc.Position) > 15 and npc.FrameCount > 10 then
				npc:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE,0.3,0,false,mod:RandomInt(90,110,rng)/100)
				local crack = Isaac.Spawn(1000, 62, 0, npc.Position, Vector.Zero, npc):ToEffect()
				crack.Color = Color(0.5,0.5,0.5,1,0,0,0)
                crack.DepthOffset = -10
				crack:Update()
				mod:DestroyNearbyGrid(npc, 30)
				d.lastcreepleft = npc.Position
			end
        end

        --[[for _, proj in ipairs(Isaac.FindByType(9, 0, 0, false, false)) do
            if proj.FrameCount < 2 and proj.SpawnerEntity and proj.SpawnerEntity:Exists() and GetPtrHash(proj.SpawnerEntity) == GetPtrHash(npc) and not mod:GetEntityData(proj).DreadPinProj then --Oh right, the segments fire the x
                if d.DreadDontRepeatBullet then
                    d.DreadDontRepeatBullet = d.DreadDontRepeatBullet-1
                    if d.DreadDontRepeatBullet <= 0 then
                        d.DreadDontRepeatBullet = nil
                    end
                else
                    local params = ProjectileParams()
                    params.Scale = bal.ArcScale
                    params.Color = Color(1, 0.6, 0.6, 1, 0.5, 0.1, 0)
                    params.FallingAccelModifier = bal.ArcAccel
                    local dir = (target.Position-npc.Position)*0.03
                    for i=1,3 do
                        if i ~= 1 then
                            local side = -1+rng:RandomInt(2)*2
                            local rot = mod:RandomInt(bal.ArcVar[1], bal.ArcVar[2], rng)*side
                            dir = dir:Rotated(rot)*(100+mod:RandomInt(bal.ArcVar2[1], bal.ArcVar2[2], rng))/100
                        end
                        params.FallingSpeedModifier = mod:RandomInt(bal.ArcFall[1], bal.ArcFall[2], rng)
                        local v = npc:FireProjectilesEx(npc.Position, dir, 0, params)[1]
                        mod:GetEntityData(v).projType = "customProjectileBehavior"
                        mod:GetEntityData(v).customProjectileBehavior = {death = function(a)
                            if a:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
                            else
                                sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.6, 0, false, mod:RandomInt(120,140,rng))
                                local boom = Isaac.Spawn(1000, 1, 0, v.Position, Vector.Zero, v):ToEffect()
                                boom.SpriteScale = Vector(0.4, 0.4)
                                boom:Update()
                                local crater = Isaac.Spawn(1000, 18, 0, v.Position, Vector.Zero, v):ToEffect()
                                crater.SpriteScale = Vector(0.4, 0.4)
                                crater:Update()
                                if game:GetRoom():IsPositionInRoom(v.Position, 0) then
                                    local fire = Isaac.Spawn(33, 10, 0, a.Position, Vector.Zero, a):ToNPC()
                                    fire.HitPoints = fire.HitPoints*bal.ArcFireHealth
                                    fire:Update()
                                end
                                for _,grid in ipairs(mod.GetGridEntities()) do
                                    if grid.Position:Distance(v.Position) < 25 then
                                        grid:Destroy()
                                    end
                                end
                            end
                        end}
                        mod:GetEntityData(v).DreadPinProj = true
                    end
                    d.DreadDontRepeatBullet = 1
                end
                proj:Remove()
            elseif proj.FrameCount < 2 and proj.SpawnerEntity and proj.SpawnerEntity:Exists() and proj.SpawnerEntity.Type == 62 and proj.SpawnerEntity.Variant == 0
            and proj.SpawnerEntity.SubType == mod.FF.DreadPin.Sub and not mod:GetEntityData(proj).DreadPinProj then
                local fromme
                local man = npc
                while man.Child and not mod:IsReallyDead(man.Child) and man.Child.Type == npc.Type and not fromme do
                    if GetPtrHash(proj.SpawnerEntity) == GetPtrHash(man.Child) then
                        fromme = true
                    end
                    man = man.Child
                end
                if fromme then
                    if d.DreadDontRepeatBullet then
                        d.DreadDontRepeatBullet = d.DreadDontRepeatBullet-1
                        if d.DreadDontRepeatBullet <= 0 then
                            d.DreadDontRepeatBullet = nil
                        end
                    else
                        local rangle = rng:RandomInt(360)
                        local params = ProjectileParams()
                        params.Color = Color(1, 0.6, 0.6, 1, 0.5, 0.1, 0)
                        npc:PlaySound(SoundEffect.SOUND_TEARS_FIRE, 0.5, 0, false, 0.8)
                        for i=1,6 do
                            local v = npc:FireProjectilesEx(npc.Position, Vector(0, bal.JumpSpeed):Rotated(rangle+60*i), 0, params)[1]
                            mod:GetEntityData(v).projType = "customProjectileBehavior"
                            mod:GetEntityData(v).customProjectileBehavior = {death = function(a)
                                if a:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
                                else
                                    local fire = Isaac.Spawn(33, 10, 0, a.Position, Vector.Zero, a):ToNPC()
                                    fire.HitPoints = fire.HitPoints*bal.JumpFireHealth
                                    mod:GetEntityData(fire).MovableFireTimeout = bal.JumpFireTime
                                    fire:Update()
                                end
                            end}
                            mod:GetEntityData(v).DreadPinProj = true
                        end
                        d.DreadDontRepeatBullet = 3
                    end
                    proj:Remove()
                end
            end
        end]]
        if d.TriggerDreadPinLob then
            mod.DreadPinFiring = true
            local params = ProjectileParams()
            params.Scale = bal.ArcScale
            params.Color = Color(1, 0.6, 0.6, 1, 0.5, 0.1, 0)
            params.FallingAccelModifier = bal.ArcAccel
            local dir = (target.Position-npc.Position)*0.03
            for i=1,3 do
                if i ~= 1 then
                    local side = -1+rng:RandomInt(2)*2
                    local rot = mod:RandomInt(bal.ArcVar[1], bal.ArcVar[2], rng)*side
                    dir = dir:Rotated(rot)*(100+mod:RandomInt(bal.ArcVar2[1], bal.ArcVar2[2], rng))/100
                end
                params.FallingSpeedModifier = mod:RandomInt(bal.ArcFall[1], bal.ArcFall[2], rng)
                local v = npc:FireProjectilesEx(npc.Position, dir, 0, params)[1]
                mod:GetEntityData(v).projType = "customProjectileBehavior"
                mod:GetEntityData(v).customProjectileBehavior = {death = function(a)
                    if a:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
                    else
                        sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.6, 0, false, mod:RandomInt(120,140,rng))
                        local boom = Isaac.Spawn(1000, 1, 0, v.Position, Vector.Zero, v):ToEffect()
                        boom.SpriteScale = Vector(0.4, 0.4)
                        boom:Update()
                        local crater = Isaac.Spawn(1000, 18, 0, v.Position, Vector.Zero, v):ToEffect()
                        crater.SpriteScale = Vector(0.4, 0.4)
                        crater:Update()
                        if game:GetRoom():IsPositionInRoom(v.Position, 0) then
                            local fire = Isaac.Spawn(33, 10, 0, a.Position, Vector.Zero, a):ToNPC()
                            fire.HitPoints = fire.HitPoints*bal.ArcFireHealth
                            fire:Update()
                        end
                        for _,grid in ipairs(mod.GetGridEntities()) do
                            if grid.Position:Distance(v.Position) < 25 then
                                grid:Destroy()
                            end
                        end
                    end
                end}
            end
            mod.DreadPinFiring = nil
            d.TriggerDreadPinLob = nil
        end
    else
        if segmentColors[d.DreadPinSegment or 0] then
            local anim = sprite:GetAnimation()
            if anim == "Body1Wiggle" or anim == "Body2Wiggle" or anim == "Body3Wiggle" then
                sprite:Play(anim .. segmentColors[d.DreadPinSegment])
            end
        end

        if d.TriggerDreadPinFire then
            mod.DreadPinFiring = true
            local rangle = rng:RandomInt(360)
            local params = ProjectileParams()
            params.Color = Color(1, 0.6, 0.6, 1, 0.5, 0.1, 0)
            npc:PlaySound(SoundEffect.SOUND_TEARS_FIRE, 0.5, 0, false, 0.8)
            for i=1,6 do
                local v = npc:FireProjectilesEx(npc.Position, Vector(0, bal.JumpSpeed):Rotated(rangle+60*i), 0, params)[1]
                mod:GetEntityData(v).projType = "customProjectileBehavior"
                mod:GetEntityData(v).customProjectileBehavior = {death = function(a)
                    if a:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
                    else
                        local fire = Isaac.Spawn(33, 10, 0, a.Position, Vector.Zero, a):ToNPC()
                        fire.HitPoints = fire.HitPoints*bal.JumpFireHealth
                        mod:GetEntityData(fire).MovableFireTimeout = bal.JumpFireTime
                        fire:Update()
                    end
                end}
                mod:GetEntityData(v).DreadPinProj = true
            end
            d.TriggerDreadPinFire = nil
            mod.DreadPinFiring = nil
        end

        if d.ultraParent then
            npc.Color = d.ultraParent.Color
            npc:SetColor(d.ultraParent:GetColor(), 999, 10, false, false)
            if mod:superExists(d.ultraParent) then
                local myFriend = mod:isFriend(npc)
                local pFriend = mod:isFriend(d.ultraParent)
                if myFriend ~= pFriend then
                    if pFriend then
                        npc:Kill()
                    else
                        d.ultraParent:Kill()
                        d.ultraParent = nil
                    end
                end
            else
                npc:Kill()
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local d = mod:GetEntityData(npc)
    if d.MovableFireTimeout then
        if d.MovableFireTimeout > 0 then
            d.MovableFireTimeout = d.MovableFireTimeout-1
        else
            npc.State = 16
            npc:GetSprite():Play("Disappear", true)
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            d.MovableFireTimeout = nil
        end
    end
end, 33)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, function(_, proj)
    if proj.SpawnerEntity and proj.SpawnerEntity.Type == 62 and proj.SpawnerEntity.Variant == 0
    and proj.SpawnerEntity.SubType == mod.FF.DreadPin.Sub and not mod.DreadPinFiring then
        local npc = proj.SpawnerEntity:ToNPC()
        local d = mod:GetEntityData(npc)
        if npc.State == NpcState.STATE_ATTACK then
            d.TriggerDreadPinLob = true
        else
            d.TriggerDreadPinFire = true
        end
        proj:Remove()
    end
end, 0)

mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, function()
    local dPins = Isaac.FindByType(mod.FF.DreadPin.ID, mod.FF.DreadPin.Var, mod.FF.DreadPin.Sub, false, false)
    for _, dPin in ipairs(dPins) do
		if dPin:GetSprite():GetAnimation() == "Attack1" and dPin:GetSprite():GetFrame() == 47 then
            sfx:Play(mod.Sounds.TwistedCuteGrunt, 0.8, 2, false, 1, 0)
            return false
        end
	end
end, SoundEffect.SOUND_CUTE_GRUNT)