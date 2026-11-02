local mod = FiendFolio
local game = Game()

local orbdis = 70
local function FamiliarInit(_, familiar)
    familiar:AddToOrbit(60)
    familiar.OrbitDistance = Vector(orbdis, orbdis)
	familiar.OrbitSpeed = 0.02
end
local function UpdateFamiliar(_, familiar)
    local player = familiar.Player
    familiar.OrbitDistance = Vector(orbdis, orbdis)
	familiar.OrbitSpeed = 0.02

    local position = (familiar:GetOrbitPosition(player.Position + player.Velocity))
    local sin = math.sin(0.1 * familiar.FrameCount)--+1.1
    position = player.Position + player.Velocity + ((player.Position + player.Velocity) - position) * sin
    if game:GetRoom():GetFrameCount() == 0 then
        familiar.Velocity = Vector.Zero
        familiar.Position = position
        --weird visual glitch otherwise
    else
        local velocity = (position) - familiar.Position
        familiar.Velocity = velocity
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, UpdateFamiliar, mod.ITEM.FAMILIAR.DEVILSKNIFE)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, FamiliarInit, mod.ITEM.FAMILIAR.DEVILSKNIFE)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function (_, knife, proj)
    if proj:ToProjectile() then
        proj:Die()
    end
end, mod.ITEM.FAMILIAR.DEVILSKNIFE)