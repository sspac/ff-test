local mod = FiendFolio
local game = Game()

function mod:LooseFilamentCache(player)
    player:CheckFamiliar(mod.ITEM.FAMILIAR.FILAMENT_FLY, (player:HasTrinket(mod.ITEM.TRINKET.LOOSE_FILAMENT) and 1) or 0,
        player:GetTrinketRNG(mod.ITEM.TRINKET.LOOSE_FILAMENT), Isaac:GetItemConfig():GetTrinket(mod.ITEM.TRINKET.LOOSE_FILAMENT), 0)
end

function mod:LooseFilamentUseActive(item, rng, player, slot)
    if player:HasTrinket(mod.ITEM.TRINKET.LOOSE_FILAMENT) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.LOOSE_FILAMENT)
        for _,f in ipairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.FILAMENT_FLY, 0, false, false)) do
            local fam = f:ToFamiliar()
            if fam.Player and GetPtrHash(player) == GetPtrHash(fam.Player) then
                local config = Isaac.GetItemConfig():GetCollectible(item)
                local charge = player:GetActiveMaxCharge(slot)
                local d = mod:GetEntityData(fam)
                d.CurrentCharge = d.CurrentCharge or {0, 0}
                if config.ChargeType == 0 and charge > 0 then
                    d.CurrentCharge[1] = d.CurrentCharge[1]+charge
                elseif config.ChargeType == 1 then
                    d.CurrentCharge[2] = d.CurrentCharge[2]+charge
                end

                local angle = (fam.Position-player.Position):GetAngleDegrees()
				local laser = EntityLaser.ShootAngle(2, player.Position+Vector(0,-20), angle, 1, Vector.Zero, player)
				laser.CollisionDamage = player.Damage*mult
				laser.MaxDistance = fam.Position:Distance(player.Position)-25
				laser.DisableFollowParent = true
				laser.Color = mod.ColorElectricYellow
            end
        end
    end
end

function mod:LooseFilamentRoomClear()
    for _,fam in ipairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.FILAMENT_FLY, 0, false, false)) do
        local d = mod:GetEntityData(fam)
        d.CurrentCharge = d.CurrentCharge or {0, 0}
        if d.CurrentCharge[1] > 0 then
            d.CurrentCharge[1] = d.CurrentCharge[1]-1
        end
    end
end
mod:AddTrinketCallback("FF_ROOM_CLEAR_FERRIUM", mod.ITEM.TRINKET.LOOSE_FILAMENT, mod.LooseFilamentRoomClear)

--YAAaayyyyy bulbs don't pathfind I can use that as an excuse not to make complicated pathfinding for this familiar
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local d = mod:GetEntityData(fam)
    local sprite = fam:GetSprite()
    local rng = fam:GetDropRNG()

    local genericMove
    if not d.init then
        d.StateFrame = 0
        d.State = "Idle"
        fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        d.init = true
    else
        d.StateFrame = d.StateFrame+1
    end
    d.CurrentCharge = d.CurrentCharge or {0,0}

    if d.CurrentCharge[1] > 0 or d.CurrentCharge[2] > 0 then
        if d.CurrentCharge[1] > 0 then
        elseif d.CurrentCharge[2] > 0 then
            d.CurrentCharge[2] = d.CurrentCharge[2]-1
        end
        if not d.Target or not mod:superExists(d.Target) or d.Target.EntityCollisionClass <= EntityCollisionClass.ENTCOLL_PLAYERONLY then
            d.Target = mod.FindRandomEnemy(fam.Position, nil, true)
        end
        if d.Target then
            local level = math.ceil(game:GetLevel():GetAbsoluteStage()/2)
            local dam = 1*level
            if fam.Player and fam.Player:Exists() then
                local mult = fam.Player:GetTrinketMultiplier(mod.ITEM.TRINKET.LOOSE_FILAMENT)
                dam = (dam+fam.Player.Damage*0.5)*mult
            else
                dam = dam+3
            end

            if fam.CollisionDamage == 0 then
                fam.CollisionDamage = dam
            end
            if not d.BulbTargetPosition or not d.Aggressive then
                if not d.Aggressive then
                    d.RandomJerking = nil
                end
                if not d.RandomJerking then
                    d.RandomJerks = rng:RandomInt(2)
                end
                d.Aggressive = true
                d.OriginalSpeed = mod:RandomInt(12,15,rng)
                if d.Target.Position:Distance(fam.Position) < 80 then
                    d.BulbTargetPosition = d.Target.Position+d.Target.Velocity*3
                else
                    d.BulbTargetPosition = fam.Position+(d.Target.Position-fam.Position):Rotated(mod:RandomInt(-40,40,rng)):Resized(mod:RandomInt(65,135,rng))
                end
                d.StateFrame = 0
            end
    
            if d.RandomJerking then
                if not d.JerkMove then
                    if d.RandomJerks > 0 then
                        d.JerkDir = Vector(mod:RandomInt(40,75,rng)/10, 0):Rotated(rng:RandomInt(360))
                        d.JerkMove = true
                        d.RandomJerks = d.RandomJerks-1
                        fam.Velocity = d.JerkDir
                        d.StateFrame = 0
                    else
                        if d.StateFrame > 6 then
                            d.BulbTargetPosition = nil
                            d.RandomJerking = nil
                        else
                            d.StateFrame = d.StateFrame+1
                        end
                        fam.Velocity = Vector(1, 0):Rotated(rng:RandomInt(360))
                    end
                else
                    fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
                    if fam.Velocity:Length() <= 3 then
                        d.JerkMove = nil
                    end
                end
            elseif d.StateFrame > 15 or fam.Position:Distance(d.BulbTargetPosition) < 15 then
                if d.RandomJerks > 0 then
                    d.RandomJerking = true
                    d.JerkMove = nil
                else
                    d.BulbTargetPosition = nil
                end
            else
                fam.Velocity = mod:Lerp(fam.Velocity, (d.BulbTargetPosition-fam.Position):Resized(d.OriginalSpeed), 0.3)
                if d.OriginalSpeed > 9 then
                    d.OriginalSpeed = d.OriginalSpeed-0.5
                end
                sprite.FlipX = fam.Velocity.X < 0
            end

            mod:spritePlay(sprite, "Dash")
        else
            genericMove = true
            mod:spritePlay(sprite, "FlyLit")
        end
    else
        genericMove = true
        mod:spritePlay(sprite, "Fly")
    end
    if genericMove then
        fam.CollisionDamage = 0
        if not d.BulbTargetPosition or d.Aggressive then
            if d.Aggressive then
                d.RandomJerking = nil
            end
            if not d.RandomJerking then
                d.RandomJerks = rng:RandomInt(3)+1
            end
            d.Aggressive = nil
            d.OriginalSpeed = mod:RandomInt(9,12,rng)
            d.BulbTargetPosition = mod:FindRandomFreePosAir(fam.Position, nil, 100)+mod:shuntedPosition(25, rng)
            d.StateFrame = 0
        end

        if d.RandomJerking then
            if not d.JerkMove then
                if d.RandomJerks > 0 then
                    d.JerkDir = Vector(mod:RandomInt(40,75,rng)/10, 0):Rotated(rng:RandomInt(360))
                    d.JerkMove = true
                    d.RandomJerks = d.RandomJerks-1
                    fam.Velocity = d.JerkDir
                    d.StateFrame = 0
                else
                    if d.StateFrame > 8 then
                        d.BulbTargetPosition = nil
                        d.RandomJerking = nil
                    else
                        d.StateFrame = d.StateFrame+1
                    end
                    fam.Velocity = Vector(1, 0):Rotated(rng:RandomInt(360))
                end
            else
                fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.25)
                if fam.Velocity:Length() <= 2.5 then
                    d.JerkMove = nil
                end
            end
        elseif d.StateFrame > 30 or fam.Position:Distance(d.BulbTargetPosition) < 25 then
            d.RandomJerking = true
            d.JerkMove = nil
        else
            fam.Velocity = mod:Lerp(fam.Velocity, (d.BulbTargetPosition-fam.Position):Resized(d.OriginalSpeed), 0.3)
            if d.OriginalSpeed > 6.5 then
                d.OriginalSpeed = d.OriginalSpeed-0.65
            end
            sprite.FlipX = fam.Velocity.X < 0
        end
    end
end, mod.ITEM.FAMILIAR.FILAMENT_FLY)