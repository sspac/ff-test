local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
    local player = familiar.Player
    local isSuperpositioned = mod:isSuperpositionedPlayer(familiar.Player)
    local isSirenCharmed = mod:isSirenCharmed(familiar)

	if sprite:IsFinished("Hit") then
		sprite:Play("Idle", false)
	end

    data.speed = data.speed or 1
    familiar.CollisionDamage = 1

    local maxSpeed = 1
    local pspeed = player:GetMovementVector():Length()
    if isSirenCharmed then
        --Dude, man, gosh
        pspeed = player.Velocity:Length() * 0.25
        for _, entity in pairs(Isaac.FindInRadius(familiar.Position, 50, EntityPartition.TEAR)) do
            sprite:Play("Hit", true)
        end
    end
    if pspeed > 0.05 then
        data.speed = math.min(pspeed, data.speed + 0.1) 
    else
        data.moveTimer = 0
        data.speed = data.speed * 0.9
    end

	if sprite:IsEventTriggered("Spawn") then
        local mult = familiar:GetMultiplier()
        local isBabyBender = player:HasTrinket(TrinketType.TRINKET_BABY_BENDER)
        for i = 45, 360, 45 do
            local laser = EntityLaser.ShootAngle(2, familiar.Position, i, 3, Vector(0, -20), familiar)
            laser.Parent = familiar
            laser.CollisionDamage = 3.5 * mult

            if isBabyBender then
                laser:AddTearFlags(TearFlags.TEAR_HOMING)
                laser.Color = Color(1,1,1,1,0,0,1)
            else
                laser.Color = Color(1.5,2.5,2.5,1,-0.8,0.8,1)
            end

            if isSuperpositioned then
                local laserCol = laser.Color
                laserCol.A = laserCol.A / 4
                laser.Color = laserCol
            end
            laser:Update()
        end
	end
    --movement
    data.moveTimer = data.moveTimer or 0
    local timeOff = 5
    if data.moveTimer >= timeOff or data.moveTimer == 0 then
	    familiar:MoveDiagonally(data.speed)
    else
        familiar:MoveDiagonally(data.speed * data.moveTimer / timeOff)
        familiar.Velocity = mod:Lerp(familiar.Velocity, player:GetMovementVector() * 3, 1 - (data.moveTimer / timeOff))
    end
    data.moveTimer = data.moveTimer + 1
end, mod.ITEM.FAMILIAR.ROBOBABY3)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, f, c)
    if ((not mod:isSirenCharmed(f)) and (c:ToProjectile() or (c:IsEnemy() and not c:HasEntityFlags(EntityFlag.FLAG_NO_TARGET))))
    or (mod:isSirenCharmed(f) and (c.Type == 1 or c.Type == 2)) then
        if c:ToProjectile() then
            c:Die()
        end

        local s = f:GetSprite()
        if s:IsPlaying("Idle") then
            s:Play("Hit", false)
        end
    end
end, mod.ITEM.FAMILIAR.ROBOBABY3)