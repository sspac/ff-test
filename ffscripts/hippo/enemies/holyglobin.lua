local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    speedSlow = 4,
    speedFast = 6,

    pauseAfterBeam = 6,

    beamSpeedMult = 0.9,
    beamFlankDistance = 26,
    meatMaxHitPoints = EntityConfig.GetEntity(mod.FF.HolyGlobin.ID, mod.FF.HolyGlobin.Var):GetBaseHP(),
    regenHPMult = 0.75,
}

function mod:holyGlobinAI(npc, sprite, d)
    local room = game:GetRoom()
    local target = npc:GetPlayerTarget()
    npc.SplatColor = mod.HC.Colors.Sickly
    d.lightpos = d.lightpos or target.Position

    if not d.init then
        d.state = -1
        d.beamCount = 0
        d.headSprite = "Head1"
        d.walkSprite = {"WalkHori","WalkVert"}
        if npc.SubType == 1 or (npc.SubType == 0 and math.random(2) == 1) then
            npc.SubType = 1
            d.headSprite = "Head3"
        end
        d.init = true
    end

    if d.state == -1 then
        if d.headSprite == "Head3" then
            mod:SpritePlay(sprite, "Appear2")
        else
            mod:SpritePlay(sprite, "Appear1")
        end
        if sprite:IsFinished("Appear1") or sprite:IsFinished("Appear2") then
            d.state = 0
        end
        npc.Velocity = Vector.Zero

    elseif d.state == 0 then
        npc:AnimWalkFrame(d.walkSprite[1], d.walkSprite[2], 0)
        if npc.Velocity:Length() < 0.1 then
            sprite:SetFrame(0)
        end
        mod:spriteOverlayPlay(sprite, d.headSprite)

        if game:GetFrameCount() % 45 == 30 then
            mod:PlaySound(SoundEffect.SOUND_ZOMBIE_WALKER_KID, npc, 0.95)
        end

        if d.stopCount and d.stopCount > 0 then
            npc.Velocity = npc.Velocity * 0.2
            sprite:SetFrame(0)
            d.stopCount = d.stopCount - 1
        else
            if d.beamCount > 0 then
                mod:ChasePlayerLerp(npc, bal.speedFast, 0.3)
            else
                mod:ChasePlayerLerp(npc, bal.speedSlow, 0.5)
            end
        end

    elseif d.state == 1 then
        if d.beamCount <= 0 then
            mod:SpritePlay(sprite,"ReGen1")
        else
            mod:SpritePlay(sprite,"ReGen2")
        end
        if sprite:IsEventTriggered("Shoot") then
            d.lightpos = room:FindFreeTilePosition(target.Position+(target.Velocity*bal.beamFlankDistance), 20)
            d.beam = Isaac.Spawn(1000, EffectVariant.CRACK_THE_SKY, 2, d.lightpos, Vector.Zero, npc)
            d.beam:GetSprite().PlaybackSpeed = bal.beamSpeedMult
            d.beam.Parent = npc
        end
        if sprite:IsEventTriggered("Sound") then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
        if sprite:WasEventTriggered("Shoot") then
            npc.Velocity = npc.Velocity * 0.2
        else
            npc.Velocity = npc.Velocity * 0.6
        end
        if sprite:IsFinished("ReGen1") or sprite:IsFinished("ReGen2") then
            npc.Visible = false
        end
    end

    if d.beam and d.beam:GetSprite():IsEventTriggered("Hit") then
        d.headSprite = "Head2"
        d.walkSprite = {"WalkHori2","WalkVert2"}
        npc.Visible = true
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL

        sprite.PlaybackSpeed = 1.0
        d.state = 0
        npc.HitPoints = npc.MaxHitPoints * bal.regenHPMult
        npc.Position = d.lightpos
        d.beamCount = d.beamCount + 1
        d.stopCount = bal.pauseAfterBeam
        npc:SetColor(Color(3,3,3,1,3,3,3), 9, 10, true, true)
    end
end

function mod:holyGlobinHurt(npc, sprite, d, amount, flags, source, cooldown)
    if d and d.state then
        if d.state == 1 and d.beam and d.beam:Exists() and d.beamCount < 1 then
            return false
        end
        if d.state <= 0 then
            if npc.HitPoints - amount <= 0 and d.beamCount < 6 then
                if d.beamCount <= 0 then
                    npc.HitPoints = bal.meatMaxHitPoints --* 0.6
                else
                    npc.HitPoints = math.max(0.1, bal.meatMaxHitPoints * (0.35 - d.beamCount*0.05))
                end
                sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL)
                npc:BloodExplode()
                npc.Velocity = -npc.Velocity*2
                sprite.PlaybackSpeed = 1.0 + mod:RandomInt(-10,10)*0.01
                d.state = 1
                sprite:RemoveOverlay()
                return false
            end
        end
    end
end