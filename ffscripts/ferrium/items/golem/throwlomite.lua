local mod = FiendFolio

function mod:throwlomiteUpdate(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.THROWLOMITE) then
        local data = mod:GetEntityData(player)
        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.THROWLOMITE)

        if not data.throwlomiteTimer then
            data.throwlomiteTimer = 50
        end

        if mod.IsActiveRoom() then
            if data.throwlomiteTimer > 0 then
                data.throwlomiteTimer = data.throwlomiteTimer-mult
            else
                data.throwlomiteTimer = 50
                local target = mod.FindClosestEnemy(player.Position,300)
                if target then
                    local targPos = target.Position+target.Velocity*6
                    local rock = Isaac.Spawn(2, 42, 0, player.Position, (targPos-player.Position)*0.042, player):ToTear()
                    rock.FallingSpeed = -20
                    rock.FallingAcceleration = 1.1
                    mod:GetEntityData(rock).dontHitAbove = true
                    rock.CollisionDamage = player.Damage*mult
                end
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.THROWLOMITE, mod.throwlomiteUpdate)