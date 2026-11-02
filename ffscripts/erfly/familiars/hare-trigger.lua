local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local animDirs = {
    [0] = {0, "Up"},
    [1] = {1, "Side"},
    [2] = {2, "Down"},
    [3] = {3, "Side", true}
}

local function unbunchAggressives(familiar)
    for _, othergressive in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.HARE_TRIGGER, -1, false, false)) do
        local dist = othergressive.Position:Distance(familiar.Position)
        if dist < 20 and dist > 1 then
            local vec = (othergressive.Position - familiar.Position):Resized(20 - dist)
            familiar.Velocity = mod:Lerp(familiar.Velocity, familiar.Velocity - vec, 0.3)
            othergressive.Velocity = mod:Lerp(othergressive.Velocity, othergressive.Velocity + vec, 0.3)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar.IsFollower = true
end, mod.ITEM.FAMILIAR.HARE_TRIGGER)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local player = familiar.Player
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
	local isSuperpositioned = mod:isSuperpositionedPlayer(familiar.Player)
	local isSirenCharmed = mod:isSirenCharmed(familiar)

	if not data.state then
		familiar:AddToFollowers()
		familiar.FireCooldown = 5
		data.state = "Float"
		data.stateframe = 0
	else
		familiar.FireCooldown = familiar.FireCooldown - ((player and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2) or 1)
		familiar.FireCooldown = math.max(0, familiar.FireCooldown)

		data.stateframe = data.stateframe + 1
	end

    local aim = FiendFolio.GetCorrectedFiringInput(player)
    local playerWantsAttack
    if aim:Length() > 0.5 or isSirenCharmed then
        playerWantsAttack = true
    end

    if sprite:IsEventTriggered("drip") then
        local effect = Isaac.Spawn(1000, 7, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
        effect.Scale = 0.4
    end

    if data.Target then
        local playerDist = player.Position:Distance(familiar.Position)
        if data.Target:IsDead() or not playerWantsAttack or playerDist > 200 then
            data.Target = nil
        else
            local targdistance = data.Target.Position - familiar.Position
            local targrel
            if data.dir then
                targrel = animDirs[data.dir[1]][1]
            else
                if math.abs(targdistance.X) > math.abs(targdistance.Y) then
                    if targdistance.X < 0 then
                        targrel = 3 -- Left
                    else
                        targrel = 1 -- Right
                    end
                else
                    if targdistance.Y < 0 then
                        targrel = 0 -- Up
                    else
                        targrel = 2 -- Down
                    end
                end
            end
            local rangeval = targdistance:Length()
            if rangeval > 125 then
                rangeval = 125
            end
            local targpos = data.Target.Position + Vector(0, rangeval):Rotated(targrel * 90)
            local targvel = targpos - familiar.Position
            if targvel:Length() > 20 then
                targvel = targvel:Resized(20)
            end
            familiar.Velocity = mod:Lerp(familiar.Velocity, targvel, 0.2)
            if familiar.FireCooldown == 0 then
                local tearVec = (data.Target.Position - targpos):Resized(12):Rotated(-20 + math.random(40))
                tearVec = tearVec + (familiar.Velocity * 0.5)
                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 1, 0, familiar.Position, tearVec, familiar):ToTear()
                tear.Height = -23
                tear.FallingSpeed = 0
                tear.FallingAcceleration = 0.15
                tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                local mult = familiar:GetMultiplier()
                tear.CollisionDamage = 0.66 * mult
                tear.Scale = 0.4 + 0.2 * math.max(1, mult)
                if isSuperpositioned then
                    tear.CollisionDamage = tear.CollisionDamage / 4
                    local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                    tearcolor.A = tearcolor.A / 4
                    tear.Color = tearcolor
                end
                familiar.FireCooldown = 3

                familiar.Velocity = mod:Lerp(familiar.Velocity, tearVec * -1, 0.1)
            end
            if familiar.FireCooldown > 1 then
                local frame = sprite:GetFrame()
                mod:spritePlay(sprite, "FloatShoot" .. animDirs[targrel][2])
                sprite:SetFrame(frame)
            else
                local frame = sprite:GetFrame()
                mod:spritePlay(sprite, "Float" .. animDirs[targrel][2])
                sprite:SetFrame(frame)
            end
            sprite.FlipX = animDirs[targrel][3]

            unbunchAggressives(familiar)
        end
    else
        if playerWantsAttack then
            familiar:RemoveFromFollowers()
            local targpos = player.Position + aim:Resized(100)
            if isSirenCharmed then
                data.Target = mod:getClosestPlayer(familiar.Position, 900)
            else
                data.Target = mod:getClosestEnemyFlyingMinion(familiar.Position, 150)
            end
            local targvel = targpos - familiar.Position
            if targvel:Length() > 20 then
                targvel = targvel:Resized(20)
            end
            familiar.Velocity = mod:Lerp(familiar.Velocity, targvel, 0.2)

            local playerdistance = familiar.Position - player.Position
            if math.abs(playerdistance.X) > math.abs(playerdistance.Y) then
                if playerdistance.X < 0 then
                    targrel = 3 -- Left
                else
                    targrel = 1 -- Right
                end
            else
                if playerdistance.Y < 0 then
                    targrel = 0 -- Up
                else
                    targrel = 2 -- Down
                end
            end
            mod:spritePlay(sprite, "Float" .. animDirs[targrel][2])
            sprite.FlipX = animDirs[targrel][3]

            unbunchAggressives(familiar)
        else
            mod:spritePlay(sprite, "FloatDown")
            if not familiar.IsFollower then
                familiar:AddToFollowers()
            end
            familiar:FollowParent()
        end
    end


end, mod.ITEM.FAMILIAR.HARE_TRIGGER)