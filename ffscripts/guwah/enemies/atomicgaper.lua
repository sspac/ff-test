local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 5,
    dmgPerHit = 2,
    teleportRadius = 400,
    avoidPlayerTeleportRadius = 160,
    explosionDmg = 20, --Intentionally low so they can be used as support fodder easier
    explosionRadius = 1.5,
}

function mod:AtomicGaperAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()

    if not data.Init then
        npc.SplatColor = mod.ColorCyanGuts
        mod:PlayInitSound(SoundEffect.SOUND_HELL_PORTAL1, npc, mod:RandomInt(18,22,rng) * 0.05, 0.5)
        data.State = "Idle"
        data.Init = true
    end

    if data.State == "Idle" then
        mod:ChasePlayer(npc, bal.moveSpeed, targetpos)
        mod:AnimWalkFrame(npc, sprite, "WalkHori", "WalkVert", true)
        sprite:PlayOverlay("Head")
            
    elseif data.State == "TeleportUp" then
        npc.Velocity = npc.Velocity * 0.2

        if sprite:IsFinished("TeleportUp") then
            npc.Position = mod:FindSafeSpawnSpot(targetpos, bal.teleportRadius, 999, true, bal.avoidPlayerTeleportRadius, true)
            mod:PlaySound(SoundEffect.SOUND_HELL_PORTAL1, npc, mod:RandomInt(18,22,rng) * 0.05, 0.5)
            data.State = "TeleportDown"
        else
            sprite:RemoveOverlay()
            mod:SpritePlay(sprite, "TeleportUp")
        end

    elseif data.State == "TeleportDown" then
        npc.Velocity = npc.Velocity * 0.2

        if sprite:IsFinished("TeleportDown") then
            data.State = "Idle"
        elseif sprite:IsEventTriggered("Shoot") then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
        else
            mod:SpritePlay(sprite, "TeleportDown")
        end

    elseif data.State == "Death" then
        npc.Velocity = Vector.Zero

        if sprite:IsFinished("Death") then
            FiendFolio.AtomicGaperDeathEffect(npc)
            npc:Kill()
        else
            mod:SpritePlay(sprite, "Death")
        end
    end
end

function mod:AtomicGaperHurt(npc, amount, damageFlags, source)
    if not mod:IsDarkRedChampionGoo(npc) then
        local data = mod:GetEntityData(npc)
        if data.State == "Idle" and npc.HitPoints - bal.dmgPerHit > 0 then
            data.State = "TeleportUp"
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
            mod:PlaySound(SoundEffect.SOUND_HELL_PORTAL2, npc, mod:RandomInt(18,22,rng) * 0.05, 0.75)
        end
        return {Damage = bal.dmgPerHit}
    end
end

function FiendFolio.AtomicGaperDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
        mod:PlaySound(SoundEffect.SOUND_THUMBS_DOWN, npc)
        mod:GetEntityData(npc).State = "Death"
        mod:GetEntityData(deathAnim).State = "Death"
        mod:GetEntityData(deathAnim).Init = true
    end
    FiendFolio.genericCustomDeathAnim(npc, "Death", true, onCustomDeath, false, false, true, false)
end

function FiendFolio.AtomicGaperDeathEffect(npc)
	game:BombExplosionEffects(npc.Position, bal.explosionDmg, 0, mod.ColorCyanGuts, npc, bal.explosionRadius)
    game:ShakeScreen(10)
end