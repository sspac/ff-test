local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.FROND, {
        Name = "gfx/ui/boss/playername_frond.png",
        Portrait = "gfx/ui/stage/playerportrait_frond.png",
        NoShake = false
    })
end

function mod:frondPlayerUpdate(player)
    local room = game:GetRoom()
    if not room:IsClear() then
        local data = mod:GetEntityData(player)
        local hasBirthright = player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        data.FrondDelay = data.FrondDelay or player.MaxFireDelay / 2
        local delayFall = 1
        if hasBirthright then
            delayFall = 2
        end
        data.FrondDelay = data.FrondDelay - delayFall
        if data.FrondDelay <= 0 then
            data.FrondDelay = player.MaxFireDelay / 2
            local frondVec = RandomVector()
            if mod:RandomInt(1,3) == 1 or hasBirthright then
                local enemy = mod:getClosestEnemyFlyingMinion(player.Position, 150)
                if enemy then
                    frondVec = enemy.Position - player.Position
                end
            end
            local frondVel = frondVec:Resized(player.ShotSpeed * mod:RandomInt(10,150)/10)
            local fromdDamg = mod:RandomInt(50,250)/100
            local frondTear = player:FireTear(player.Position, frondVel, false, true, false, player, frondDamg)
            frondTear.FallingAcceleration = frondTear.FallingAcceleration + 0.5
            frondTear.FallingSpeed = frondTear.FallingSpeed - 10
            frondTear:AddTearFlags(TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP)
            frondTear:Update()
            for i = 1, mod:RandomInt(1,5) do
                local rng = player:GetDropRNG()
                local targetposition = frondTear.Position + frondVel + mod:TrueRandomVector(rng):Resized(mod:RandomInt(10,30))
                local effect = Isaac.Spawn(1000, EffectVariant.BLOOD_DROP, 0, frondTear.Position, (targetposition-player.Position):Resized(10*0.2+mod:getRoll(30,55,rng)/10):Rotated(mod:getRoll(-30,30,rng)), player):ToEffect()
                effect.Color = FiendFolio.ColorIpecacProper
                effect.Scale = 0.5
                effect.PositionOffset = Vector(0, -20-mod:RandomInt(1, 10))
                effect:Update()
                effect.FallingSpeed = -mod:getRoll(6,10,rng)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.frondPlayerUpdate, mod.PLAYER.FROND)

function mod:frondBirthrightTakeDamage(player)
    if player:GetPlayerType() == mod.PLAYER.FROND
    and mod:playerHasBirthcake(player)
    then
        Isaac.Explode(player.Position, player, 180)
    end
end

mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, function(_, player)
	mod:AddMorbidHearts(player, 6)
end, mod.PLAYER.FROND)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FROND then
		--player.MaxFireDelay = player.MaxFireDelay * 3 -- direct maxfiredelay multipliers break at negative firedelay values
		player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(1.9))
	end
end, CacheFlag.CACHE_FIREDELAY)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FROND then
		player.Damage = player.Damage * 0.5
	end
end, CacheFlag.CACHE_DAMAGE)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FROND then
		player.TearColor = player.TearColor * FiendFolio.ColorPiss2
	end
end, CacheFlag.CACHE_TEARCOLOR)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FROND then
		player.MoveSpeed = player.MoveSpeed + 0.2
	end
end, CacheFlag.CACHE_SPEED)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FROND then
		player.ShotSpeed = player.ShotSpeed * 0.5
	end
end, CacheFlag.CACHE_SHOTSPEED)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FROND then
		local basemulti = player:GetD8RangeModifier()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
			basemulti = basemulti * 0.8
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
		   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
		   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
		then
			basemulti = basemulti * 0.8
		end

		player.TearRange = player.TearRange - 100 * basemulti
	end
end, CacheFlag.CACHE_RANGE)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FROND then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_POISON | TearFlags.TEAR_GROW
	end
end, CacheFlag.CACHE_TEARFLAG)

local FrondHurts = {
    mod.Sounds.Caca1, mod.Sounds.Caca2, mod.Sounds.Caca6,
}

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(FrondHurts[mod:RandomInt(1, #FrondHurts)], 1, 0, false, mod:RandomInt(180,230)/100)
    return true
end, mod.PLAYER.FROND)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.CacaIDKLOL, 1, 0, false, 2)
    --sfx:Play(mod.Sounds.Caca7, 1, 0, false, mod:RandomInt(230,280)/100)
    return true
end, mod.PLAYER.FROND)