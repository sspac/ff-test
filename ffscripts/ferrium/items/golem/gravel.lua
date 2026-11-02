local mod = FiendFolio

function mod:gravelNewLevel(player, data)
    if data.ffsavedata.RunEffects.gravelCount then
        data.ffsavedata.RunEffects.gravelCount = 0
    end
end
mod:AddTrinketCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.ROCK.GRAVEL, mod.gravelNewLevel)

function mod:gravelOnGrind(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.GRAVEL) then
		local playersavedata = mod:GetEntityData(player).ffsavedata.RunEffects
		local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.GRAVEL)
		playersavedata.gravelCount = (playersavedata.gravelCount or 0)+0.3*mult
	end
end

function mod:gravelUpdate(player)
    if player:HasTrinket(mod.ITEM.ROCK.GRAVEL) then
        local d = mod:GetEntityData(player)
        if d.gravelFireCooldown then
            if d.gravelFireCooldown > 0 then
                d.gravelFireCooldown = d.gravelFireCooldown-1
            else
                d.gravelFireCooldown = nil
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.GRAVEL, mod.gravelUpdate)

function mod:fireGravel(player, fireDir, d)
    local count = math.min(4, d.ffsavedata.RunEffects.gravelCount or 0) --okay it's getting a bit too crazy
    if count and not d.gravelFireCooldown then
        count = math.min(4, count)
        local mult = player:GetTrinketMultiplier(mod.ITEM.ROCK.GRAVEL)
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.GRAVEL)

        local loops = math.floor(count)
        local remainder = math.ceil((count % 1)*6)
        local vel = fireDir:Resized(10) + player:GetTearMovementInheritance(fireDir)
        for i=1,loops do
            for j=1,6 do
                mod.scheduleForUpdate(function()
                    local pebble = Isaac.Spawn(2, 42, 0, player.Position, vel:Rotated(mod:getRoll(-30,30,rng)), player):ToTear()
                    pebble.CollisionDamage = math.max(1.5, player.Damage/4)*mult
                    pebble.Scale = mod:getRoll(50,65,rng)/100
                    pebble:Update()
                end, j)
            end
        end
        for i=1,remainder do
            mod.scheduleForUpdate(function()
                local pebble = Isaac.Spawn(2, 42, 0, player.Position, vel:Rotated(mod:getRoll(-30,30,rng)), player):ToTear()
                pebble.CollisionDamage = math.max(1.5, player.Damage/4)*mult
                pebble.Scale = mod:getRoll(50,65,rng)/100
                pebble:Update()
            end, i)
        end

        d.gravelFireCooldown = 40
    end
end

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, FiendFolio.ITEM.ROCK.GRAVEL, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.ROCK.GRAVEL) then
		mod:fireGravel(player, dir, mod:GetEntityData(player))
	end
end)