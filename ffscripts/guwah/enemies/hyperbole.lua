local mod = FiendFolio
local game = Game()

function mod:HyperboleAI(npc, sprite, data)
    if not data.Init then
        for i = 1, 4 do
            mod:AddSoundmakerFly(npc)
        end
        data.Init = true
    end

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        local params = ProjectileParams()
        params.Scale = 2
        npc:FireProjectiles(npc.Position, Vector(10, 0), 6, params)
    end
end