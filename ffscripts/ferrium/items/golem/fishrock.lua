local mod = FiendFolio
local game = Game()

function mod:FishRockBreakRock(player, grid)
    if player:HasTrinket(mod.ITEM.ROCK.FISH_ROCK) then
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.FISH_ROCK)
        local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.FISH_ROCK)
        local chance = 20+15*mult
        if rng:RandomInt(100) < chance then
            local fly = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, 0, grid.Position, Vector.Zero, player):ToFamiliar()
            fly.Player = player
        end
    end
end

mod.FishRockFlySpawn = true

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    if fam.Player and fam.Player:ToPlayer() then
        local player = fam.Player:ToPlayer()
        if player:HasTrinket(mod.ITEM.ROCK.FISH_ROCK) then
            local rng = player:GetTrinketRNG(mod.ITEM.ROCK.FISH_ROCK)
            local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.FISH_ROCK)
            local chance = 20+15*mult
            if rng:RandomInt(100) < chance and mod.FishRockFlySpawn then
                mod.FishRockFlySpawn = false
                local fly = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, 0, fam.Position, Vector.Zero, player):ToFamiliar()
                fly.Player = player
                mod.FishRockFlySpawn = true
            end
        end
    end
end, FamiliarVariant.BLUE_FLY)