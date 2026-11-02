local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

local debugFunny = false

function mod:TrihorfAI(npc, sprite, data)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position)
    if sprite:IsEventTriggered("TriShoot") then
        if debugFunny then
            
        else
            local vel = 8
            if game.Difficulty % 2 == 1 then
                vel = 10
            end
            mod:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR, npc)
            local params = ProjectileParams()
            --params.Variant = mod.FF.FrogProjectileBlood.Var
            npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(vel), 2, params)
            local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
            effect.SpriteOffset = Vector(0,-6)
            effect.DepthOffset = npc.Position.Y * 1.25
            effect.Color = Color(1,1,1,0.8,0.1,0.1,0.1)
        end
    end
end

function mod:ThumbsUpFlyColl(npc, collider)
    if collider:ToPlayer() ~= nil then
        collider:ToPlayer():AnimateHappy()
    end
end

function mod:ThumbsUpFlyDeath(npc)
    for i = 0, game:GetNumPlayers() - 1 do
        local player = game:GetPlayer(i)
        player:AnimateSad()
    end
end

function mod:GoldenSpiderAI(npc, sprite, data)
    if npc.FrameCount % 3 == 0 then
        local sparkle = Isaac.Spawn(1000, 7003, 0, npc.Position, Vector.Zero, npc):ToEffect()
        sparkle.RenderZOffset = -5
        sparkle.SpriteOffset = Vector(-10 + math.random(20), -10 + math.random(20))
    end
    if npc:IsDead() and rng:RandomFloat() <= 0.5 then
        Isaac.Spawn(mod.FF.GoldenSpider.ID, mod.FF.GoldenSpider.Var, 0, game:GetRoom():GetRandomPosition(0), Vector.Zero, npc)
    end
end

function mod:SlothsHeadAI(npc, sprite, data)
    if not data.Init then
		mod:lastJudgementAutoResprite(npc, data, sprite)
        npc.SplatColor = mod.ColorGurgleGibs
        data.Init = true
    end
end

function mod:TaintedSpitAI(npc, sprite, data)
    if not data.Init then
        npc.SplatColor = mod.ColorGurgleGibs
        data.Init = true
    end

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        mod.scheduleForUpdate(function()
            for _, proj in pairs(Isaac.FindInRadius(npc.Position, 10, EntityPartition.BULLET)) do
                if proj.FrameCount <= 1 then
                    proj = proj:ToProjectile()
                    proj.Color = mod.ColorIpecacProper
                    proj:AddProjectileFlags(ProjectileFlags.EXPLODE)
                    mod:GetEntityData(proj).projType = "taintedSpit"
                end
            end
        end, 0)
    end
end

function mod:TaintedSpitProjDeath(proj, data)
    mod.scheduleForUpdate(function()
        for _, proj in pairs(Isaac.FindInRadius(proj.Position, 10, EntityPartition.BULLET)) do
            if proj.FrameCount <= 1 then
                proj = proj:ToProjectile()
                proj.Color = mod.ColorIpecacProper
                proj:AddProjectileFlags(ProjectileFlags.EXPLODE)
            end
        end
    end, 0)
end

function mod:TheTerribleOni(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    if not data.Init then
        data.State = "TheHiddenOni"
        data.Init = true
    end

    if data.State == "TheHiddenOni" then
        mod:spriteOverlayPlay(sprite, "Head")
        mod:AnimWalkFrame(npc, sprite, "WalkHori", "WalkVert", true)
        mod:ChasePlayer(npc, 3.5, targetpos)

        if npc.FrameCount % 45 == 30 then
            mod:PlaySound(SoundEffect.SOUND_ZOMBIE_WALKER_KID,npc)
        end

        if npc.HitPoints <= npc.MaxHitPoints * 0.8 then
            sprite:RemoveOverlay()
            data.State = "TheEmergingOni"
        end
    
    elseif data.State == "TheEmergingOni" then
        npc.Velocity = npc.Velocity * 0.7
        if sprite:IsFinished("transform") then
            data.State = "TheTerribleOni"
        elseif sprite:IsEventTriggered("transform") then
            npc.SplatColor = mod.ColorTelePurple
            npc:PlaySound(SoundEffect.SOUND_SKIN_PULL, 1, 0, false, 1)
			npc:PlaySound(mod.Sounds.MeatyBurst, 0.6, 0, false, 1)
			npc:PlaySound(mod.Sounds.StretchEye, 1, 0, false, 1.5)
            npc:PlaySound(SoundEffect.SOUND_DEATH_REVERSE, 1, 0, false, 1.5)
        else
            mod:spritePlay(sprite, "transform")
        end

    elseif data.State == "TheTerribleOni" then
        mod:AnimWalkFrame(npc, sprite, "onihori", {"onidown", "oniup"}, true)
        mod:ChasePlayer(npc, 5, targetpos)

        if npc.FrameCount % 60 == 30 then
            mod:PlaySound(SoundEffect.SOUND_HUSH_GROWL,npc,1.5)
        end

    elseif data.State == "TheDyingOni" then
        npc.Velocity = Vector.Zero
        if sprite:IsFinished("onideath") then
            npc:Kill()
        elseif sprite:IsEventTriggered("transform") then
            mod:PlaySound(SoundEffect.SOUND_HUSH_ROAR,npc,1.5)
        else
            mod:spritePlay(sprite, "onideath")
        end
    end
end

function FiendFolio.TheDyingOni(npc)
	local onCustomDeath = function(npc, deathAnim)
        mod:GetEntityData(deathAnim).State = "TheDyingOni"
        mod:GetEntityData(deathAnim).Init = true
    end
    FiendFolio.genericCustomDeathAnim(npc, "Death", true, onCustomDeath, false, false, true, true)
end

function mod:HomonculusLoxodontusAI(npc, sprite, data)
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    npc.SplatColor = Color(0.5,0.5,0.5)
    npc.Velocity = npc.Velocity * 0.9

    if sprite:IsEventTriggered("Jump") then
        mod:PlaySound(SoundEffect.SOUND_BOSS_LITE_ROAR, npc, 0.75, 0.25)
        Isaac.Spawn(1000,16,2,npc.Position,Vector.Zero,npc).Color = Color(1,1,1,0.5)
    elseif sprite:IsEventTriggered("Land") then
        mod:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, npc)
        game:ShakeScreen(10)
        game:MakeShockwave(npc.Position, 0.035, 0.025, 10)
        mod:DestroyNearbyGrid(npc, 120)
        Isaac.Spawn(1000,16,1,npc.Position,Vector.Zero,npc)
    else
        mod:SpritePlay(sprite, "Hop")
    end
end