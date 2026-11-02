local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    speedMult = 0.975,
    roomStartShootDelay = 45,
    projSpeed = 7,
    deathProjSpeed = 8,
    drownSpawnHPMult = 0.75,
}

local params = ProjectileParams()

function mod:DrownedSpittyAI(npc, sprite, data)
    local isConjoined = (npc.Type == mod.FF.DrownedConjoinedSpitty.ID)

    if not data.Init then
        --Drowned Spitties spawned by Drowned Hives/Boom Flies have 50% HP which is a bit low, so bump it up
        mod.scheduleForUpdate(function()
            if npc:Exists() then
                --print(npc.SpawnerType.." "..npc.SpawnerVariant)
                if (npc.SpawnerType == EntityType.ENTITY_HIVE and npc.SpawnerVariant == 1) 
                or (npc.SpawnerType == EntityType.ENTITY_BOOMFLY and npc.SpawnerVariant == 2) then 
                    local targetHP = npc:GetEntityConfigEntity():GetBaseHP() * bal.drownSpawnHPMult
                    --print(targetHP.." "..npc.HitPoints.." "..npc.MaxHitPoints)
                    if npc.HitPoints < targetHP then
                        if npc.MaxHitPoints < targetHP then
                            npc.MaxHitPoints = targetHP
                        end
                        npc.HitPoints = targetHP
                    end
                    --print(npc.HitPoints.." "..npc.MaxHitPoints)
                end
            end
        end, 0)
        data.Init = true
    end
    mod:lastJudgementAutoResprite(npc, data, sprite)

    npc.Velocity = npc.Velocity * bal.speedMult

    if npc.State == 9 then
        if game:GetRoom():GetFrameCount() < bal.roomStartShootDelay then
            npc.State = 4
        elseif sprite:IsEventTriggered("DrownedShoot") then
            mod:PlaySound(SoundEffect.SOUND_LITTLE_SPIT, npc)
            local projs = {}
            if isConjoined then
                projs = npc:FireProjectilesEx(npc.Position, Vector(bal.projSpeed, 0), ProjectileMode.CROSS, params)
            else
                local angle = 0
                if npc.I1 == 1 then
                    angle = -90
                elseif npc.I1 == 2 then
                    angle = 90
                else
                    angle = sprite.FlipX and 180 or 0
                end
                for i = -45, 45, 90 do
                    table.insert(projs, npc:FireProjectilesEx(npc.Position, Vector(bal.projSpeed, 0):Rotated(angle + i), ProjectileMode.SINGLE, params)[1])
                end
            end
            for _, proj in pairs(projs) do
                proj.Height = -9
                proj.FallingSpeed = -3
                proj.FallingAccel = -0.001
            end
        end
    end

    if npc:IsDead() then
        for _, proj in pairs(npc:FireProjectilesEx(npc.Position, Vector(bal.deathProjSpeed, 0), ProjectileMode.PLUS, params)) do
            proj.Height = -22
        end
    end
end