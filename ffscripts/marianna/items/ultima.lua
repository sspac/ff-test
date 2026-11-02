local mod = FiendFolio
local game = Game()
local hud = game:GetHUD()

--======--
--Ultima--
--======--

--ITEM

--oh boy
function mod:ultimaUsed(item, rng, player, flags, slot, varData)
    mod.scheduleForUpdate(function()
        local room = Game():GetRoom()
        local spawnpos = room:FindFreePickupSpawnPosition(room:GetGridPosition(room:GetGridIndex(player.Position)), 20)
        Isaac.Spawn(3, mod.ITEM.FAMILIAR.ULTIMA_UPGRADE, 0, spawnpos + RandomVector()*math.random(20), Vector.Zero, nil)
    end, 3, nil, true)
    ultimaLevel = math.min(5,ultimaLevel+1)
    print("technology ultima ",tostring(ultimaLevel))
end

--item activation
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ultimaUsed, mod.ITEM.COLLECTIBLE.TECH_ULTIMA)

--FAMILIAR
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar.OrbitDistance = Vector(50,50)
    familiar.OrbitSpeed = 1
    familiar.OrbitLayer = 1
    familiar:RecalculateOrbitOffset(familiar.OrbitLayer, true)
end, mod.ITEM.FAMILIAR.ULTIMA_UPGRADE)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
    local player = familiar.Player
    local isSuperpositioned = mod:isSuperpositionedPlayer(familiar.Player)
    local isSirenCharmed = mod:isSirenCharmed(familiar)
    local laservar = LaserVariant.THIN_RED

    local targetPosition = familiar:GetOrbitPosition(player.Position + player.Velocity)
    familiar.Velocity = targetPosition - familiar.Position

    --I DONT KNOW
    if not data.state then
		familiar:AddToOrbit(0)
		familiar.FireCooldown = 0
		data.state = "Float"
		data.stateframe = 0
		data.UltimaNo = ultimaLevel
	end

	--HELP
	local direction = player:GetFireDirection()
    --stole from taiga. helped by erfly
    local firevel = mod.GetFamiliarShootingDirection(familiar):Resized(10)
    --THIS MAKES IT SHOOT
    if familiar.FireCooldown == 0 and direction ~= Direction.NO_DIRECTION then
        if data.UltimaNo == 1 or data.UltimaNo == 2 then
            local laser = EntityLaser.ShootAngle(laservar, familiar.Position, firevel:GetAngleDegrees(), 3, Vector(0, -20), familiar)
            laser:SetMaxDistance(player.TearRange/1.5)
            laser.Parent = familiar
            laser.CollisionDamage = 1.5 + (player.Damage/3)
            laser:Update()
            familiar.FireCooldown = math.ceil(player.MaxFireDelay*3)
        end
    end

    familiar.FireCooldown = math.max(0, familiar.FireCooldown - 1)
end, mod.ITEM.FAMILIAR.ULTIMA_UPGRADE)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for _, ent in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.ULTIMA_UPGRADE, -1, false, false)) do
        ent:Remove()
        ultimaLevel = 0
        print("technology ultima ",tostring(ultimaLevel))
    end
end, mod.ITEM.FAMILIAR.ULTIMA_UPGRADE)
