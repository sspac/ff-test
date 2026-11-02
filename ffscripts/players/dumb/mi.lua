local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.MI, {
        Name = "gfx/ui/boss/playername_mi.png",
        Portrait = "gfx/ui/stage/playerportrait_mi.png",
        NoShake = false
    })
end

mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, function(_, player)
	player:AddCard(mod.ITEM.CARD.THIRTEEN_OF_STARS)
	mod.scheduleForUpdate(function()
		mod:AddFractionalCoins(0.1)
	end, 0, nil, true)
end, mod.PLAYER.MI)

function mod:miPostFireTear(player, tear, rng, pdata, tdata, ignorePlayerEffects, isLudo)
    if player:GetPlayerType() == FiendFolio.PLAYER.MI then
        tdata.isMiFlatTear = true
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            tdata.MiBirthrightTear = true
            tear.Color = FiendFolio.ColorDankBlack
        end
        local vec = tear.Velocity:Normalized()
        tear.SpriteScale = Vector(1 - (0.6 * math.abs(vec.X)), 1)
    end
end

function mod:miTearUpdate(tear, tdata)
    if tdata.isMiFlatTear then
        local vec = tear.Velocity:Normalized()
        tear.SpriteScale = Vector(1 - (0.6 * math.abs(vec.X)), 1)
        if tear.FrameCount == 20 then
            --Yes it's intentional they look like that
            if tdata.MiBirthrightTear then
                local minion = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 10, tear.Position, Vector.Zero, tear.SpawnerEntity)
                minion.EntityCollisionClass = 4
                minion.Parent = player

                local data = mod:GetEntityData(minion)
                data.hollow = true
                data.canreroll = false
                data.fiendsLostFriend = true
                minion:Update()
            else
                local minion = Isaac.Spawn(1000, 1736, 10, tear.Position, Vector.Zero, tear.SpawnerEntity)
                minion:Update()
            end

            tear:Die()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.MI then
		player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.8))
	end
end, CacheFlag.CACHE_FIREDELAY)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.MI then
		player.Damage = player.Damage * 0.8
	end
end, CacheFlag.CACHE_DAMAGE)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.MI then
		player.TearColor = player.TearColor * FiendFolio.ColorFiendGuts
	end
end, CacheFlag.CACHE_TEARCOLOR)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.MI then
		player.ShotSpeed = player.ShotSpeed * 0.6
	end
end, CacheFlag.CACHE_SHOTSPEED)

--[[mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    local rand = math.random(3)
    if rand == 1 then
        sfx:Play(SoundEffect.SOUND_PAPER_IN, 2, 0, false, math.random(60,100)/100)
    elseif rand == 2 then
        sfx:Play(SoundEffect.SOUND_PAPER_OUT, 2, 0, false, math.random(60,100)/100)
    else
        sfx:Play(mod.Sounds.PaperDeath, 2, 0, false, math.random(60,100)/100)
    end
    return true
end, mod.PLAYER.MI)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.PaperDeath, 2, 0, false, 0.5)
    sfx:Play(SoundEffect.SOUND_HEARTIN, 1, 0, false, 0.25)
    return true
end, mod.PLAYER.MI)]]