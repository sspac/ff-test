local mod = FiendFolio

function mod:shroomiteUpdate(player)
    if player:HasTrinket(mod.ITEM.ROCK.SHROOMITE) then
        local val = math.ceil(player.MaxFireDelay*6)
        if mod.IsActiveRoom() and player.FrameCount % val == 0 then
            local rng = player:GetTrinketRNG(mod.ITEM.ROCK.SHROOMITE)
            local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.SHROOMITE)
            local target = mod.FindRandomEnemy(player.Position, nil, true)
            local dir = nil
            if target then
                dir = (target.Position-player.Position):Resized(mod:getRoll(25,50,rng)/10):Rotated(-70)
            else
                dir = Vector(0, mod:getRoll(25,50,rng)/10):Rotated(rng:RandomInt(360))
            end

			mod.IgnoreSecondaryFireEffects = true
            local tear = player:FireTear(player.Position, dir, false, true, false, player, 1*mult)
			mod.IgnoreSecondaryFireEffects = false
            tear.FallingSpeed = 0
            tear.FallingAcceleration = -0.13
            local chance = rng:RandomInt(100)
            local flags = TearFlags.TEAR_SPECTRAL
            if chance < 20*mult then
                flags = TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_CONFUSION
            end
            tear:AddTearFlags(flags)
            mod:GetEntityData(tear).shroomiteTear = true
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.SHROOMITE, mod.shroomiteUpdate)

function mod:shroomiteTearUpdate(v, d)
    if d.shroomiteTear then
        local rng = v:GetDropRNG()
        mod:RainbowProjectile(v, d)
        
        local thingy = 12*math.sin(math.rad(v.FrameCount*10))
        v.Velocity = v.Velocity:Rotated(thingy + rng:RandomInt(3)-1)
    end
end