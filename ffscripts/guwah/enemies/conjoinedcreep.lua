local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    projSpeed = 8,
    angleMax = 60,
    deathSpawnChance = 0.33,
}

local params = ProjectileParams()

function mod:ConjoinedCreepAI(npc, sprite, data)
    mod:lastJudgementAutoResprite(npc, data, sprite)
    if npc.State == 4 then
        data.ShootAngle = nil
    elseif sprite:IsEventTriggered("ConjoinedShoot") then
        if not data.ShootAngle then
            mod:PlaySound(SoundEffect.SOUND_SPIDER_SPIT_ROAR,npc)
            local aimangle = npc.SpriteRotation + 90
            local playerangle = (mod:confusePos(npc,npc:GetPlayerTarget().Position) - npc.Position):GetAngleDegrees()
            local anglediff = mod:GetAngleDifferenceDead(aimangle, playerangle)
            if anglediff > bal.angleMax then
                data.ShootAngle = aimangle - bal.angleMax
            elseif anglediff < -bal.angleMax then
                data.ShootAngle = aimangle + bal.angleMax
            else
                data.ShootAngle = playerangle
            end
        end
        npc:FireProjectiles(npc.Position+Vector(12,0):Rotated(npc.SpriteRotation), Vector(bal.projSpeed,0):Rotated(data.ShootAngle), 0, params)
        npc:FireProjectiles(npc.Position+Vector(12,0):Rotated(npc.SpriteRotation+180), Vector(bal.projSpeed,0):Rotated(npc.SpriteRotation + 90), 0, params)
    end
end

function mod:ConjoinedCreepHurt(npc, amount, damageFlags, source)
    if npc.HitPoints - amount <= 0 and npc:GetDropRNG():RandomFloat() <= bal.deathSpawnChance then
        npc:Morph(EntityType.ENTITY_WALL_CREEP, 0, 0, npc:GetChampionColorIdx())
        npc.HitPoints = npc.MaxHitPoints
        npc.GridCollisionClass = GridCollisionClass.COLLISION_PIT
        npc:BloodExplode()
        mod:GetEntityData(npc).GuwahFunctions = nil

        return false
    end
end
