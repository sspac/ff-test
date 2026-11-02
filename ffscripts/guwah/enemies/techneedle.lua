local mod = FiendFolio
local game = Game()

function mod:TechneedleAI(npc, sprite, data)
    if sprite:IsFinished("DigOut") then
        for i = -45, 45, 90 do
            local laser = Isaac.Spawn(1000, 1737, 0, npc.Position, npc.Velocity:Rotated(i):Resized(7), npc):ToEffect()
            mod:GetEntityData(laser).delay = 20
            mod:GetEntityData(laser).timeout = 8
            mod:GetEntityData(laser).DoesntPush = true
            laser:Update()
            mod:GetEntityData(laser).offSetSpawn = Vector(0,-25)
            laser.Parent = npc
            laser:Update()
        end
    end

    if npc.State == 3 and data.CheckForLava then
        local room = game:GetRoom()
        local grid = room:GetGridEntityFromPos(npc.Position)
        if room:HasLava() and grid and grid:GetType() == GridEntityType.GRID_PIT then
            npc:TakeDamage(80, DamageFlag.DAMAGE_FIRE, EntityRef(nil), 0)
        end
        data.CheckForLava = false
    elseif npc.State == 6 then
        data.CheckForLava = true
    end
end