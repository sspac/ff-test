local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.FIENT, {
        Name = "gfx/ui/boss/playername_fient.png",
        Portrait = "gfx/ui/stage/playerportrait_fient.png",
        NoShake = false
    })
end

function mod:fientPlayerUpdate(player, data)
	local data = mod:GetEntityData(player)
	local sprite = player:GetSprite()
	if sprite:IsPlaying("Happy") and sprite:GetFrame() == 5 then
		if not data.fientWhipcracked then
			sfx:Play(mod.Sounds.WhipCrack, 1, 0, false, 1)
			data.fientWhipcracked = true
		end
	else
		data.fientWhipcracked = false
	end
	if mod:playerHasBirthcake(player) then
		if player.FrameCount % 180 == 0 then
			game:SetDizzyAmount(math.max(0,game:GetDizzyAmount() - 0.1))
		end
	end
end
mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_UPDATE, mod.fientPlayerUpdate, mod.PLAYER.FIENT)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_DEATH, CollectibleType.COLLECTIBLE_BIRTHRIGHT, function(_, npc)
    mod.AnyPlayerDo(function(player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		and player:GetPlayerType() == mod.PLAYER.FIENT
		then
			Isaac.Spawn(5, mod.PICKUP.VARIANT.FFSACK, mod.PICKUP.SACK.DRUG_BAGGIE, npc.Position, Vector.Zero, nil)
		end
	end)
end)

mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, function(_, player)
	mod:AddMorbidHearts(player, 3)
end, mod.PLAYER.FIENT)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FIENT then
		--player.MaxFireDelay = player.MaxFireDelay * 3 -- direct maxfiredelay multipliers break at negative firedelay values
		player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(3))
	end
end, CacheFlag.CACHE_FIREDELAY)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FIENT then
		player.Damage = player.Damage * 4.057
	end
end, CacheFlag.CACHE_DAMAGE)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FIENT then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_CONFUSION
	end
end, CacheFlag.CACHE_TEARFLAG)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FIENT then
		player.TearColor = player.TearColor * FiendFolio.ColorGreyscale
	end
end, CacheFlag.CACHE_TEARCOLOR)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FIENT then
		player.ShotSpeed = player.ShotSpeed * 0.420
	end
end, CacheFlag.CACHE_SHOTSPEED)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.FIENT then
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

		player.TearRange = player.TearRange - 92 * basemulti
	end
end, CacheFlag.CACHE_RANGE)

function mod:fientPostFire(player, tear, rng, pdata, tdata)
	if player:GetPlayerType() == mod.PLAYER.FIENT then
		sfx:Play(mod.Sounds.AGWheeze, 1, 0, false, 1)
		for i = -30, 30, 30 do
			local smoke = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, tear.Position, tear.Velocity:Resized(3):Rotated(i), npc)
			--smoke.SpriteScale = Vector(1,1)
			smoke.SpriteOffset = Vector(0, -10)
			smoke.Color = Color(1,1,1,0.2)
			mod:GetEntityData(smoke).longonly = true
			smoke:Update()
		end
	end
end

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.AGJump, 1, 0, false, 1)
    return true
end, mod.PLAYER.FIENT)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.AGWheeze, 1, 0, false, 0.75)
    return true
end, mod.PLAYER.FIENT)