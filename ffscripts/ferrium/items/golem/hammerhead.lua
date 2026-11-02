local mod = FiendFolio

local bal = {
    Damage = 0.15,
    FallVel = {5,20},
    Vel = {1,6},
    FallAccel = 1.5,
}

local lastTimeHammerHeaded = 0
function mod:HammerHeadBreakRock(player, grid, d)
    if player:HasTrinket(mod.ITEM.ROCK.HAMMER_HEAD) then
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.HAMMER_HEAD)
        local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.HAMMER_HEAD)

        d.HammerHeadDamageBuff = (d.HammerHeadDamageBuff or 0)+bal.Damage*mult
        
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()

        local count = 3
        if player.FrameCount-lastTimeHammerHeaded < 10 then
            count = 1
        end
        for i=1,count do
            local rock = Isaac.Spawn(2, 40, 0, grid.Position, Vector(0,mod:RandomInt(bal.Vel[1], bal.Vel[2], rng)):Rotated(rng:RandomInt(360)), player):ToTear()
			rock.FallingSpeed = -mod:RandomInt(bal.FallVel[1], bal.FallVel[2], rng)
			rock.FallingAcceleration = bal.FallAccel
            rock.Scale = 1
			local pSprite = rock:GetSprite()
			mod:GetEntityData(rock).makeSplat = 145
			mod:GetEntityData(rock).customTearSound = {SoundEffect.SOUND_STONE_IMPACT, 0.6, mod:RandomInt(8,12,rng)/10}
			mod:GetEntityData(rock).toothParticles = mod.ColorRockGibs
			rock.CollisionDamage = player.Damage
            pSprite:Load("gfx/009.009_rock projectile.anm2", true)
			pSprite:Play("Rotate2", true)
			pSprite:LoadGraphics()
        end

        lastTimeHammerHeaded = player.FrameCount
    end
end

function mod:HammerHeadNewRoom(player, d)
    d.HammerHeadDamageBuff = nil
    lastTimeHammerHeaded = 0
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.ROCK.HAMMER_HEAD, mod.HammerHeadNewRoom)